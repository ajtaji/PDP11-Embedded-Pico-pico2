#!/usr/bin/env python3
"""
pack_install.py - put the RK05 disk packs of an image into a board's flash
over USB serial, with no boot drive and no button.

    python tools/pack_install.py --board feather|picoplus2 --image combined.uf2
                                 (--hub-port N | --usb-serial TEXT)
                                 [--compiler PureMetalForge.exe [--board-file FILE]]
                                 [--region all|rk0|rk1] [--max-seconds 240]
                                 [--status] [--sums] [--probe]

WHY. The compiler's uploader writes the firmware; the packs live in the
flash at the places J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2 gives (RK0
from 0x10240000, RK1 from 0x104C0000; this tool reads that file through
tools/flash_layout.py, and the installer is compiled with it) and
a firmware upload leaves them alone. This tool gets them there:

  1. with --compiler it builds the installer program
     (J11_18MHz_KDJ11_BF/pico2/packinstall.pico2, with the board's flash
     size) and uploads it to the board through the compiler's own uploader;
     without --compiler the installer must be running on the board already;
  2. it sends each pack region of the image, one 4096-byte sector at a
     time. The board answers every sector with the checksum of what it
     received; the tool compares it with its own. A sector the flash
     already holds is not sent again, so a run that was stopped is short
     the second time;
  3. the region's first sector - the pack's header - goes LAST. Until then
     the board holds a "transfer started" mark there, and both this tool
     and the installer say so plainly if a transfer stopped part way;
  4. at the end the board reads the whole region back from the flash and
     prints its checksum; the tool compares it with the image file's.

Then upload the PDP-11 firmware with the compiler. Its start-up line prints
the same checksums ("pack checksums: RK0 ... RK1 ..."): --sums prints the
image file's, in the same form, to compare.

THE BOARD IS FOUND BY WHERE IT IS, never by a COM number: --hub-port N is
the number of the USB hub port it is plugged into (Windows: the last
"#USB(N)" of the device's location path; Linux: the last number of its
sysfs USB path), --usb-serial TEXT its USB serial number. The tool refuses
if that does not name exactly one board.

THE CHECKSUM: over the bytes as 32-bit words, low byte first,
a = a + word, b = b + a, both modulo 2^32, from 0; written "aaaaaaaa bbbbbbbb".

--probe       the first write to a board: test ONE sector (the last sector of
              the image's highest region) - programmed with a pattern, read
              back, compared, erased again - and stop. Do this once per
              board before the first install.
--status      only ask the installer what each region holds, change nothing
--sums        only print the image's region checksums, open nothing
--max-seconds stop cleanly at a sector boundary after this long (default
              240) and say how far it got; run again to go on

Exit 0: every region asked for is in the flash and its checksum matches.
Exit 2: stopped at --max-seconds, run again. Exit 1: anything else.
"""
import argparse
import os
import re
import struct
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
XIP = 0x10000000
sys.path.insert(0, HERE)
import flash_layout
KEEP = flash_layout.PACKS    # below it: the programs, and the region kept for a radio's firmware
SECTOR = 4096
BOARDS = {"feather": 0x800000, "picoplus2": 0x1000000}     # the flash chip's size
NAMES = {flash_layout.RK0: "rk0", flash_layout.RK1: "rk1"}
PHRASE = b"ResetPicoToBootSel1254"
USB_IDS = ("VID_2E8A", "VID_239A")
FLASH_LINE = "#PI_FLASH_CHIP = $400000 "


def fail(msg):
    sys.stderr.write("pack_install: " + msg + "\n")
    sys.exit(1)


def say(msg):
    print("pack_install: " + msg, flush=True)


def fsum(data):
    """The checksum (see the header) of a whole number of 32-bit words."""
    a = b = 0
    for (w,) in struct.iter_unpack("<I", data):
        a = (a + w) & 0xFFFFFFFF
        b = (b + a) & 0xFFFFFFFF
    return a, b


def sum_text(ab):
    return "%08X %08X" % ab


def regions_of(path, flash):
    """{offset: bytes} for every pack region of the UF2 (flash_layout.PACKS and above).
    An image with a pack anywhere else, or with anything in the region kept for a
    radio's firmware, is refused whole."""
    raw = open(path, "rb").read()
    if len(raw) % 512 or not raw:
        fail("%s is %d bytes, not a whole number of 512-byte UF2 blocks. Give the combined.uf2 "
             "that tools/psram_build.py or tools/rk_image.py --combined wrote." % (path, len(raw)))
    pages = {}
    for i in range(0, len(raw), 512):
        m0, m1, _flags, addr, n, _k, _total, _fam = struct.unpack_from("<IIIIIIII", raw, i)
        if m0 != 0x0A324655 or m1 != 0x9E5D5157 or n != 256 or addr % 256:
            fail("%s: block %d is not a 256-byte UF2 page. Check the file." % (path, i // 512))
        pages[addr - XIP] = raw[i + 32:i + 32 + 256]
    for off in sorted(pages):
        if flash_layout.touches_radio(off, 256):
            fail("%s: %s Nothing was sent." % (path, flash_layout.check_region(off, 256, "the image's data")))
        if off < KEEP and off % SECTOR == 0 and pages[off][:8] == b"PDP11RK1":
            fail("%s: %s This is an image of the old layout (packs from 0x10040000); build it again with "
                 "tools/psram_build.py. Nothing was sent."
                 % (path, flash_layout.check_region(off, SECTOR, "a pack")))
    out = {}
    start = None
    for off in sorted(pages):
        if off < KEEP:
            continue
        if start is None or off != start + len(out[start]):
            start = off
            out[start] = bytearray()
        out[start] += pages[off]
    for off in list(out):
        data = bytes(out[off])
        if off % SECTOR:
            fail("%s: the data at 0x%X does not start on a 4096-byte sector. Check the file." % (path, off))
        data += b"\xFF" * (-len(data) % SECTOR)
        if off + len(data) > flash:
            fail("%s: the region at 0x%X (%d bytes) runs past this board's %d MB flash."
                 % (path, off, len(data), flash >> 20))
        if PHRASE in data:
            fail("the pack at 0x%X contains the text the board takes as its reboot request (%s); "
                 "it cannot be sent over this port. Change the pack." % (off, PHRASE.decode()))
        if data[:8] != b"PDP11RK1":
            fail("%s: the region at 0x%X does not start with a pack header. Check the file." % (path, off))
        out[off] = data
    if not out:
        fail("%s holds nothing at 0x%08X or above: there is no pack in it." % (path, XIP + KEEP))
    return out


def boards_windows():
    ps = ("Get-PnpDevice -PresentOnly -Class Ports | ForEach-Object { "
          "$l = (Get-PnpDeviceProperty -InstanceId $_.InstanceId -KeyName DEVPKEY_Device_LocationPaths).Data | Select-Object -First 1; "
          "\"$($_.InstanceId)|$($_.FriendlyName)|$l\" }")
    r = subprocess.run(["powershell", "-NoProfile", "-Command", ps], capture_output=True, text=True, timeout=60)
    found = []
    for line in r.stdout.splitlines():
        parts = line.strip().split("|")
        if len(parts) != 3 or not any(v in parts[0].upper() for v in USB_IDS):
            continue
        com = re.search(r"\((COM\d+)\)", parts[1])
        hub = re.search(r"#USB\((\d+)\)$", parts[2])
        if com:
            found.append({"port": com.group(1), "hub": int(hub.group(1)) if hub else None,
                          "serial": parts[0].rsplit("\\", 1)[-1], "id": parts[0]})
    return found


def boards_linux():
    found = []
    base = "/sys/class/tty"
    for name in sorted(os.listdir(base)) if os.path.isdir(base) else []:
        if not name.startswith("ttyACM"):
            continue
        dev = os.path.realpath(os.path.join(base, name, "device", ".."))
        try:
            vid = open(os.path.join(dev, "idVendor")).read().strip().upper()
        except OSError:
            continue
        if ("VID_" + vid) not in USB_IDS:
            continue
        try:
            serial = open(os.path.join(dev, "serial")).read().strip()
        except OSError:
            serial = ""
        hub = re.search(r"(\d+)$", os.path.basename(dev))
        found.append({"port": "/dev/" + name, "hub": int(hub.group(1)) if hub else None,
                      "serial": serial, "id": dev})
    return found


def find_port(a):
    found = boards_windows() if os.name == "nt" else boards_linux()
    if a.hub_port is not None:
        hit = [b for b in found if b["hub"] == a.hub_port]
        what = "on hub port %d" % a.hub_port
    else:
        hit = [b for b in found if b["serial"].upper() == a.usb_serial.upper()]
        what = "with USB serial number %s" % a.usb_serial
    if len(hit) != 1:
        seen = ", ".join("%s (hub port %s, %s)" % (b["port"], b["hub"], b["serial"]) for b in found) or "none"
        fail("%d running boards %s; exactly one is needed. Boards seen: %s. A board in boot mode has "
             "no serial port: it must be running a program." % (len(hit), what, seen))
    return hit[0]["port"]


def upload_installer(a, flash, port):
    text = open(os.path.join(SRC, "packinstall.pico2"), "rb").read().decode("utf-8")
    if text.count(FLASH_LINE) != 1:
        fail("packinstall.pico2 does not hold exactly one '%s' line; update FLASH_LINE here to match."
             % FLASH_LINE.strip())
    text = text.replace(FLASH_LINE, "#PI_FLASH_CHIP = $%X " % flash)
    tmp = os.path.join(SRC, "packinstall_%s.pico2" % a.board)
    out = os.path.join(a.out, "packinstall.bin")
    os.makedirs(a.out, exist_ok=True)
    open(tmp, "wb").write(text.encode("utf-8"))
    cmd = [a.compiler, "--compile", tmp, "-o", out, "--port", port]
    cmd += ["--board", a.board_file] if a.board_file else ["-t", "rp2350"]
    say(" ".join(cmd))
    try:
        r = subprocess.run(cmd, cwd=SRC, capture_output=True, text=True, timeout=240)
    finally:
        os.remove(tmp)
    tail = [l for l in (r.stdout + r.stderr).splitlines() if l.strip()][-6:]
    if r.returncode != 0:
        fail("the compiler did not build and upload the installer (exit %d):\n  %s"
             % (r.returncode, "\n  ".join(tail)))
    size = os.path.getsize(out)
    if size >= flash_layout.RADIO_LO:
        fail("the installer image is %d bytes; it must stay below 0x%08X, where the region kept for a "
             "radio's firmware begins." % (size, XIP + flash_layout.RADIO_LO))
    say("installer built (%d bytes) and uploaded through the compiler" % size)


class Board:
    def __init__(self, port):
        import serial
        self.s = serial.Serial(port, 115200, timeout=0.05, write_timeout=10)
        self.buf = b""

    def line(self, seconds):
        """The next whole line from the board, or None after `seconds`."""
        end = time.time() + seconds
        while True:
            i = self.buf.find(b"\n")
            if i >= 0:
                out, self.buf = self.buf[:i], self.buf[i + 1:]
                return out.decode("ascii", "replace").strip()
            if time.time() > end:
                return None
            self.buf += self.s.read(self.s.in_waiting or 1)   # what has arrived, or wait for one byte

    def hello(self):
        """The installer's answer to "?". A port just opened can lose what is written to it in its
        first moments, so the question is asked again every 2 s, for 20 s."""
        for _ in range(10):
            time.sleep(0.5)
            self.s.write(b"?" + b"\x0a")
            end = time.time() + 1.5
            while time.time() < end:
                l = self.line(max(0.1, end - time.time()))
                if l and l.startswith("PACKINSTALL "):
                    return l
        fail("the board did not answer '?' in 20 s. Is the installer running on it? "
             "(Give --compiler to build and upload it.)")

    def ask(self, text, want, seconds=10.0, payload=b""):
        """Send a line (and a sector); the first answer line that starts OK <want> or NO."""
        self.s.write(text.encode("ascii") + b"\n" + payload)
        end = time.time() + seconds
        while time.time() < end:
            l = self.line(max(0.1, end - time.time()))
            if l is None:
                break
            if l.startswith("NO "):
                fail("the board refused '%s': %s" % (text.split()[0], l[3:]))
            if l.startswith("OK " + want):
                return l
        fail("no answer to '%s' within %d s. Is the installer running on this board? "
             "(Give --compiler to build and upload it.)" % (text.split()[0], seconds))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--board", required=True, choices=sorted(BOARDS))
    ap.add_argument("--image", required=True)
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--hub-port", type=int)
    g.add_argument("--usb-serial")
    ap.add_argument("--compiler")
    ap.add_argument("--board-file")
    ap.add_argument("--out", default=os.path.join(REPO, "build_packinstall"))
    ap.add_argument("--region", default="all", choices=["all", "rk0", "rk1"])
    ap.add_argument("--max-seconds", type=float, default=240.0)
    ap.add_argument("--status", action="store_true")
    ap.add_argument("--sums", action="store_true")
    ap.add_argument("--probe", action="store_true")
    a = ap.parse_args()
    flash = BOARDS[a.board]
    t_start = time.time()

    regions = regions_of(a.image, flash)
    sums = {off: fsum(data) for off, data in regions.items()}
    for off in sorted(regions):
        say("image: %s at 0x%06X, %d bytes, checksum %s"
            % (NAMES.get(off, "region"), off, len(regions[off]), sum_text(sums[off])))
    if a.sums:
        return 0
    if a.hub_port is None and a.usb_serial is None:
        fail("say which board: --hub-port N or --usb-serial TEXT.")
    todo = [off for off in sorted(regions) if a.region == "all" or NAMES.get(off) == a.region]
    if not todo:
        fail("the image has no %s region." % a.region)

    port = find_port(a)
    if a.compiler:
        upload_installer(a, flash, port)
        time.sleep(1.0)
        end = time.time() + 30
        while True:                       # the board comes back as a new port
            try:
                port = find_port_quiet(a)
                if port:
                    break
            except Exception:
                pass
            if time.time() > end:
                fail("the board did not come back with a serial port within 30 s of the upload. "
                     "Stop: do not wait for it; look at the board.")
            time.sleep(1.0)
    say("board: %s" % port)
    b = Board(port)
    hello = b.hello()
    say("board says: " + hello)
    m = re.match(r"PACKINSTALL (\d+) flash ([0-9A-F]{8}) jedec ([0-9A-F]{8}) built-for ([0-9A-F]{8}) keep ([0-9A-F]{8})", hello)
    if not m:
        fail("that is not this installer's answer (an older installer?). Give --compiler to build and upload it.")
    found, jedec, built = int(m.group(2), 16), int(m.group(3), 16), int(m.group(4), 16)
    if jedec == 0xFFFFFFFF:
        fail("the installer could not read the flash chip's JEDEC ID. Nothing was written.")
    say("flash chip: JEDEC ID %02X %02X %02X (maker, type, capacity code: 2^%d bytes = %d MB); "
        "size measured by address wrap: %d MB"
        % (jedec >> 16, (jedec >> 8) & 255, jedec & 255, jedec & 255, (1 << (jedec & 255)) >> 20, found >> 20))
    if (1 << (jedec & 255)) != flash:
        fail("the chip's capacity code says %d MB, but --board %s has %d MB. Wrong board or wrong --board: "
             "nothing was written." % ((1 << (jedec & 255)) >> 20, a.board, flash >> 20))
    if found != flash or built != flash:
        fail("the board's flash is %d MB as measured and the installer was built for %d MB, but --board %s "
             "has %d MB. Wrong board or wrong --board: nothing was written."
             % (found >> 20, built >> 20, a.board, flash >> 20))

    for off in sorted(regions):
        say("flash now: " + b.ask("S %X" % off, "S")[5:])
    if a.status:
        return 0
    if a.probe:
        top = max(regions)
        off = top + len(regions[top]) - SECTOR
        if " PACK " in b.ask("S %X" % top, "S"):
            say("the highest region already holds a pack: the first-write test is for a board with "
                "nothing installed, and was not run. Nothing was changed.")
            return 0
        say("test sector at 0x%06X: %s" % (off, b.ask("T %X" % off, "T", 30)[5:]))
        return 0

    for off in todo:
        data = regions[off]
        name = NAMES.get(off, "region")
        n = len(data) // SECTOR
        if " PACK " in b.ask("S %X" % off, "S"):
            v = b.ask("V %X %X" % (off, len(data)), "V", 60).split()
            if "%s %s" % (v[4], v[5]) == sum_text(sums[off]):
                say("%s: already in the flash, checksum %s = the file's; nothing written"
                    % (name, sum_text(sums[off])))
                continue
        b.ask("B %X %X %X %X" % ((off, len(data)) + sums[off]), "B", 15)
        sent = same = 0
        t0 = time.time()
        for idx in list(range(1, n)) + [0]:           # the header sector last
            if idx and time.time() - t_start > a.max_seconds:
                say("%s: stopped at --max-seconds with %d of %d sectors done (%d sent, %d already right). "
                    "The region is marked UNFINISHED. Run again to go on." % (name, sent + same, n, sent, same))
                return 2
            sec = data[idx * SECTOR:(idx + 1) * SECTOR]
            mine = sum_text(fsum(sec))
            if idx:
                have = b.ask("C %X" % idx, "C").split()
                if "%s %s" % (have[3], have[4]) == mine:
                    same += 1
                    continue
            ans = b.ask("W %X" % idx, "W", 20, sec).split()
            if int(ans[2], 16) != idx or "%s %s" % (ans[3], ans[4]) != mine:
                fail("%s sector %d: the board received %s %s, the file has %s. Nothing more was sent; "
                     "the region is marked UNFINISHED. Run again." % (name, idx, ans[3], ans[4], mine))
            sent += 1
        dt = time.time() - t0
        v = b.ask("V %X %X" % (off, len(data)), "V", 60).split()
        got = "%s %s" % (v[4], v[5])
        if got != sum_text(sums[off]):
            fail("%s: the flash reads back with checksum %s, the file has %s. The region is NOT right."
                 % (name, got, sum_text(sums[off])))
        say("%s: %d sectors (%d sent, %d already right) in %.1f s, %.0f KB/s sent; flash checksum %s = the file's"
            % (name, n, sent, same, dt, sent * 4.096 / dt if dt > 0 else 0, got))
    for off in sorted(regions):
        say("flash now: " + b.ask("S %X" % off, "S")[5:])
    say("done. Now upload the PDP-11 firmware with the compiler; its start-up line prints these checksums.")
    return 0


def find_port_quiet(a):
    found = boards_windows() if os.name == "nt" else boards_linux()
    if a.hub_port is not None:
        hit = [x for x in found if x["hub"] == a.hub_port]
    else:
        hit = [x for x in found if x["serial"].upper() == a.usb_serial.upper()]
    return hit[0]["port"] if len(hit) == 1 else None


if __name__ == "__main__":
    sys.exit(main())
