#!/usr/bin/env python3
"""rk_image.py - put an RK05 disk image into a Pico's flash, where the
J-11 emulator's RK11 (disk.pico / disk.pico2, #DISK_BACKEND = 2) reads it.

USE
    python rk_image.py info IMAGE
        the image's size, its Unix file system (V6 or V7) if it has one,
        and which blocks are in use
    python rk_image.py pack IMAGE --chip pico|pico2 -o OUT.uf2
                       [--layout dense|mapped] [--blocks N] [--name TEXT]
                       [--swap auto|LO,N|none] [--boot-block FILE|@/PATH]
                       [--autoboot KERNEL[,SWITCHES]]
                       [--psram-patch FILE,SYMBOL,VALUE] [--drive1 IMAGE]
                       [--firmware FW.bin [--desk OUT.bin] [--combined OUT.uf2]
                                          [--firmware-uf2 OUT.uf2]]
        a UF2 that the board's BOOTSEL drive writes to the disk region of
        the flash, leaving the firmware alone. Flash the firmware's UF2
        and this one, in either order. --firmware with --desk also writes
        a flat image of the firmware with the disk behind it, for arm_run
        (the desk emulator loads one .bin into the flash). --combined
        writes the firmware and the pack as ONE UF2 (fine on the Pico 2 W;
        on the Pico W flash the two separately - see the README), and
        --firmware-uf2 the firmware alone as a UF2 (for the Pico W).

THE FLASH REGION (disk.pico's header says the same)
    Pico W   (RP2040, 2 MB flash):  0x10040000 - 0x101FFFFF
    Pico 2 W (RP2350, 4 MB flash):  0x10040000 - 0x103FFFFF
    feather    (Adafruit Feather RP2350 with 8 MB PSRAM, 8 MB flash) and
    picoplus2  (Pimoroni Pico Plus 2 and Pico Plus 2 W, 16 MB flash, 8 MB
               PSRAM): the PSRAM builds (both ran on 2026-10-07). RK0 from
               0x10040000, RK1 from 0x102C0000 (--drive1), both dense
    The firmware lives below 0x10040000 (256 KB); this tool refuses a
    firmware bigger than that.
        +0      4 KB header: "PDP11RK1", u32 version 1, u32 layout (0 dense,
                1 mapped), u32 blocks stored, u32 slots used, u32 map
                sectors, u32 flags, 32-byte name, then at +64 u32 swap
                start and u32 swap blocks (the RAM overlay's area, below),
                at +72 u32 auto-boot (bit 16 on, bits 15-0 the switch
                register) and at +80 the kernel's name, NUL-terminated
        +4 KB   mapped layout only: 3 sectors, one u16 per RK05 block,
                0 = not stored (reads as zeros), n = slot n - 1
        then    512-byte slots

LAYOUTS
    dense    block n in slot n, for blocks 0 .. N-1 (N = --blocks, or the
             whole image). Blocks past N read as zeros and refuse writes
             (the firmware says so). For a pack that fits: a full RK05
             pack (4872 blocks, 2,494,464 bytes) fits the Pico 2 W.
    mapped   only the blocks that hold something get a slot; a block
             written later gets the next free slot. For a pack whose
             block numbers run past the room but whose USED blocks fit:
             Mini-Unix on the Pico W. "Used" is read from the image's own
             Unix file system when it has one (V6 or V7 free list; blocks
             past the file system - the swap area - hold nothing worth
             keeping); otherwise every block that is not all zeros.

    The default is dense if the whole image fits, else mapped.

BOOT BLOCK
    --boot-block FILE puts FILE (at most 512 bytes, a.out header and all)
    into block 0, which the RK05 bootstrap reads. --boot-block @/PATH takes
    the file from the image's own V6 file system - the V6 install step
    "dd if=/usr/mdec/rkuboot of=/dev/rk0 count=1". The TUHS Dennis_v6
    v6root image has no boot program in block 0: pack it with
    --boot-block @/usr/mdec/rkuboot.

SWAP
    --swap LO,N names the pack's swap area: the firmware keeps those blocks
    in SRAM and never writes them to flash (disk.pico, THE RAM OVERLAY).
    --swap auto (the default) takes, for a V6 or V7 file system smaller
    than the pack, the rest of the pack after it - the classic layout
    (Mini-Unix: 4000,872, SWPLO and NSWAP in its /usr/sys/param.h). Check
    it against the kernel's own configuration; --swap none turns it off.

THE PSRAM BUILD (--chip feather or picoplus2; pico2/psram_pdp11.pico2)
    The firmware copies the packs into the PSRAM at start-up and runs them
    from there, writable, with the whole swap area - or, if the PSRAM is
    not there or fails its checks, runs RK0 from the flash exactly as the
    Pico 2 build does (read-only, the 112-block swap RAM disk).
    --psram-patch FILE,SYMBOL,VALUE records in the header (+96) one word
    to change in the PSRAM copy only: rkunix,_nswap,872 gives V6 its whole
    swap area there, while the flash - and so the fallback - keeps the
    kernel patched for the RAM disk. The word's present value is recorded
    too, and the firmware changes nothing unless it finds it.
    --drive1 IMAGE packs a second RK05 image for RK1 (dense, whole).

AUTO-BOOT
    --autoboot rkunix (or rkunix,173030) asks the firmware to boot this
    pack at power-up: BOOT RK0 with the switch register at SWITCHES (octal,
    default 173030), then the kernel's name typed at the boot block's '@'.
    Esc within 2 s of the banner leaves the board at the diagnostic
    console instead.
"""
import argparse
import os
import struct
import sys

UF2_MAGIC0, UF2_MAGIC1, UF2_END = 0x0A324655, 0x9E5D5157, 0x0AB16F30
UF2_FLAG_FAMILY = 0x00002000
FAMILY = {"pico": 0xE48BFF56, "pico2": 0xE48BFF59,            # rp2040; rp2350 Arm secure
          "feather": 0xE48BFF59, "picoplus2": 0xE48BFF59}
FLASH = {"pico": 0x200000, "pico2": 0x400000, "feather": 0x800000, "picoplus2": 0x1000000}
PSRAM_CHIPS = ("feather", "picoplus2")   # the boards with PSRAM (psram.pico2)
XIP = 0x10000000
REGION = 0x40000
REGION1 = 0x2C0000       # RK1 on the 8 MB boards (psram.pico2 #DISK_REGION1)
SECTOR = 4096
RK_BLOCKS = 4872
MAP_SECTORS = (RK_BLOCKS * 2 + SECTOR - 1) // SECTOR     # 3


def fail(msg):
    sys.stderr.write("rk_image: " + msg + "\n")
    sys.exit(1)


def capacity(chip, mapped):
    data = REGION + SECTOR + (MAP_SECTORS * SECTOR if mapped else 0)
    return (FLASH[chip] - data) // 512, data


def blocks_of(img):
    n = len(img) // 512
    if len(img) % 512:
        fail("the image is %d bytes, not a whole number of 512-byte blocks. Check the file." % len(img))
    if n > RK_BLOCKS:
        fail("the image has %d blocks; an RK05 pack has %d. Check the file." % (n, RK_BLOCKS))
    return n


def unix_fs(img):
    """(kind, isize, fsize, free-block set) for a V6 or V7 file system, else None."""
    if len(img) < 1024:
        return None
    sb = img[512:1024]
    isize, = struct.unpack_from("<H", sb, 0)
    for kind in ("V6", "V7"):
        if kind == "V6":
            fsize, = struct.unpack_from("<H", sb, 2)
            nfree, = struct.unpack_from("<H", sb, 4)
            free0 = 6
            get = lambda b, o: struct.unpack_from("<H", b, o)[0]
            step = 2
            nic = 100                                      # V6 NICFREE
        else:
            hi, lo = struct.unpack_from("<HH", sb, 2)      # daddr_t: PDP-11 long, high word first
            fsize = (hi << 16) | lo
            nfree, = struct.unpack_from("<H", sb, 6)
            free0 = 8
            get = lambda b, o: (struct.unpack_from("<H", b, o)[0] << 16) | struct.unpack_from("<H", b, o + 2)[0]
            step = 4
            nic = 50                                       # V7 NICFREE
        if not (2 < isize < fsize <= RK_BLOCKS and 0 <= nfree <= nic):
            continue
        free = set()
        lst = [get(sb, free0 + step * i) for i in range(nic)]
        n = nfree
        ok = True
        seen = 0
        while ok:
            for i in range(n - 1, 0, -1):
                if not isize + 2 <= lst[i] < fsize:
                    ok = False
                    break
                free.add(lst[i])
            nxt = lst[0] if n else 0
            if not ok or nxt == 0:
                break
            if not isize + 2 <= nxt < fsize or seen > RK_BLOCKS:
                ok = False
                break
            # nxt is free too, but it HOLDS the next part of the free list:
            # its contents must be kept, or the kernel reads a zero block
            # when the superblock's list runs out (df: "bad free count").
            seen += 1
            blk = img[nxt * 512:(nxt + 1) * 512]
            n = struct.unpack_from("<H", blk, 0)[0]
            if n > nic:
                ok = False
                break
            lst = [get(blk, 2 + step * i) for i in range(nic)]
        if ok:
            return kind, isize, fsize, free
    return None


def v6_file(img, path):
    """A small file (direct blocks only) out of a V6 file system."""
    def inode(n):
        b = 2 + (n - 1) // 16
        o = b * 512 + ((n - 1) % 16) * 32
        mode, = struct.unpack_from("<H", img, o)
        size = (img[o + 5] << 16) | struct.unpack_from("<H", img, o + 6)[0]
        return mode, size, struct.unpack_from("<8H", img, o + 8)

    def data(n):
        mode, size, addr = inode(n)
        if mode & 0o10000:
            fail("%s is a large file; a boot block is at most 512 bytes." % path)
        return b"".join(img[a * 512:(a + 1) * 512] for a in addr if a)[:size]
    n = 1
    for part in [p for p in path.split("/") if p]:
        d = data(n)
        for k in range(0, len(d), 16):
            ino, = struct.unpack_from("<H", d, k)
            if ino and d[k + 2:k + 16].split(b"\0")[0].decode("latin-1") == part:
                n = ino
                break
        else:
            fail("%s is not in the image's V6 file system." % path)
    return data(n)


def used_blocks(img):
    n = blocks_of(img)
    fs = unix_fs(img)
    zero = bytes(512)
    used = []
    for b in range(n):
        if img[b * 512:(b + 1) * 512] == zero:
            continue
        if fs:
            kind, isize, fsize, free = fs
            if b >= fsize or b in free:
                continue
        used.append(b)
    return used, fs


SWAP = (0, 0)


AUTOBOOT = (0, b"")      # (switches | 1 << 16, kernel name) or (0, "") for none
PSPATCH = None           # (block, byte offset, old word, new word) for the PSRAM copy


def header(layout, stored, slots, name):
    h = bytearray(SECTOR)
    struct.pack_into("<8sIIIIII", h, 0, b"PDP11RK1", 1, layout, stored, slots,
                     MAP_SECTORS if layout else 0, 1)
    nb = name.encode("ascii", "replace")[:31]
    h[32:32 + len(nb)] = nb
    struct.pack_into("<II", h, 64, SWAP[0], SWAP[1])
    struct.pack_into("<I", h, 72, AUTOBOOT[0])
    h[80:80 + len(AUTOBOOT[1])] = AUTOBOOT[1]
    if PSPATCH:
        struct.pack_into("<IIIII", h, 96, 1, *PSPATCH)
    return bytes(h)


def build(img, chip, layout, nblocks, name):
    """{flash offset: bytes} for the region, and a summary line."""
    n = blocks_of(img)
    if layout == "auto":
        cap, _ = capacity(chip, False)
        layout = "dense" if (nblocks or n) <= cap else "mapped"
    parts = {}
    if layout == "dense":
        stored = nblocks or n
        cap, data = capacity(chip, False)
        if stored > cap:
            fail("a dense pack of %d blocks does not fit the %s: its region holds %d blocks "
                 "(%d bytes from 0x%08X to 0x%08X). Use --layout mapped, or --blocks N with N "
                 "no more than %d." % (stored, chip, cap, cap * 512, XIP + data, XIP + FLASH[chip] - 1, cap))
        body = img[:stored * 512] + bytes(max(0, stored * 512 - len(img)))
        parts[REGION] = header(0, stored, stored, name)
        parts[data] = body
        return parts, "dense, %d blocks (%d bytes) of %d that fit" % (stored, stored * 512, cap)
    used, fs = used_blocks(img)
    used = [b for b in used if not SWAP[0] <= b < SWAP[0] + SWAP[1]]
    cap, data = capacity(chip, True)
    if len(used) > cap:
        fail("the image uses %d blocks and the %s's mapped region holds %d slots. It does not fit." %
             (len(used), chip, cap))
    m = bytearray(MAP_SECTORS * SECTOR)
    body = bytearray()
    for slot, b in enumerate(used):
        struct.pack_into("<H", m, b * 2, slot + 1)
        body += img[b * 512:(b + 1) * 512]
    parts[REGION] = header(1, len(used), len(used), name)
    parts[REGION + SECTOR] = bytes(m)
    parts[data] = bytes(body)
    return parts, "mapped, %d blocks stored, %d slots left for blocks written later (%d bytes)" % (
        len(used), cap - len(used), (cap - len(used)) * 512)


def uf2(parts, chip):
    pages = {}
    for off, data in parts.items():
        for i in range(0, len(data), 256):
            chunk = data[i:i + 256]
            pages[off + i] = chunk + bytes(256 - len(chunk))
    addrs = sorted(pages)
    out = bytearray()
    for k, a in enumerate(addrs):
        out += struct.pack("<IIIIIIII", UF2_MAGIC0, UF2_MAGIC1, UF2_FLAG_FAMILY, XIP + a, 256, k,
                           len(addrs), FAMILY[chip])
        out += pages[a] + bytes(476 - 256) + struct.pack("<I", UF2_END)
    return bytes(out)


def main():
    ap = argparse.ArgumentParser(description="Put an RK05 image into a Pico's flash.")
    ap.add_argument("cmd", choices=["info", "pack"])
    ap.add_argument("image")
    ap.add_argument("--chip", choices=["pico", "pico2", "feather", "picoplus2"])
    ap.add_argument("--psram-patch")
    ap.add_argument("--drive1")
    ap.add_argument("--layout", choices=["auto", "dense", "mapped"], default="auto")
    ap.add_argument("--blocks", type=int)
    ap.add_argument("--name")
    ap.add_argument("-o")
    ap.add_argument("--firmware")
    ap.add_argument("--desk")
    ap.add_argument("--swap", default="auto")
    ap.add_argument("--boot-block")
    ap.add_argument("--autoboot")
    ap.add_argument("--combined")
    ap.add_argument("--firmware-uf2")
    a = ap.parse_args()
    img = open(a.image, "rb").read()
    if a.boot_block:
        bb = v6_file(img, a.boot_block[1:]) if a.boot_block.startswith("@") else open(a.boot_block, "rb").read()
        if len(bb) > 512:
            fail("the boot block %s is %d bytes; block 0 holds 512." % (a.boot_block, len(bb)))
        img = bb.ljust(512, b"\0") + img[512:]
        print("rk_image: block 0 <- %s (%d bytes)" % (a.boot_block, len(bb)))
    if a.cmd == "info":
        n = blocks_of(img)
        used, fs = used_blocks(img)
        print("%s: %d bytes, %d blocks" % (a.image, len(img), n))
        if fs:
            print("  %s file system: %d blocks, i-list %d blocks, %d free; blocks %d-%d past it (swap)"
                  % (fs[0], fs[2], fs[1], len(fs[3]), fs[2], n - 1))
        print("  blocks in use: %d, the highest %d" % (len(used), used[-1] if used else -1))
        for chip in ("pico", "pico2"):
            cd, _ = capacity(chip, False)
            cm, _ = capacity(chip, True)
            print("  %-5s dense room %d blocks, mapped room %d slots" % (chip, cd, cm))
        return
    if not a.chip or not a.o:
        fail("pack needs --chip pico or pico2, and -o OUT.uf2.")
    if a.blocks is not None and not 0 < a.blocks <= RK_BLOCKS:
        fail("--blocks must be 1 to %d." % RK_BLOCKS)
    global SWAP
    if a.swap == "auto":
        fs = unix_fs(img)
        SWAP = (fs[2], RK_BLOCKS - fs[2]) if fs and fs[2] < RK_BLOCKS else (0, 0)
    elif a.swap != "none":
        try:
            lo, n = [int(x) for x in a.swap.split(",")]
        except ValueError:
            fail("--swap takes LO,N (decimal blocks), auto or none.")
        if not (0 <= lo and 0 < n and lo + n <= RK_BLOCKS):
            fail("--swap %s is not inside the pack's %d blocks." % (a.swap, RK_BLOCKS))
        SWAP = (lo, n)
    if SWAP[1]:
        print("rk_image: swap area blocks %d-%d (%d): kept in the firmware's RAM, never written to flash"
              % (SWAP[0], SWAP[0] + SWAP[1] - 1, SWAP[1]))
    global AUTOBOOT
    if a.autoboot:
        kern, _, sw = a.autoboot.partition(",")
        try:
            sw = int(sw or "173030", 8)
        except ValueError:
            fail("--autoboot takes KERNEL[,SWITCHES] with SWITCHES in octal.")
        if not kern or len(kern) > 15 or not kern.isascii() or not kern.isprintable() or not 0 <= sw <= 0o177777:
            fail("--autoboot: the kernel's name is 1 to 15 printable characters, the switches 0-177777.")
        AUTOBOOT = (sw | 1 << 16, kern.encode("ascii"))
        print("rk_image: auto-boot: RK0, switches %06o, then %s at the @ prompt" % (sw, kern))
    global PSPATCH
    if a.psram_patch or a.drive1:
        if a.chip not in PSRAM_CHIPS:
            fail("--psram-patch and --drive1 are for --chip feather or picoplus2 (the PSRAM builds).")
    if a.psram_patch:
        try:
            pf, psym, pval = a.psram_patch.split(",")
            pval = int(pval, 0)
        except ValueError:
            fail("--psram-patch takes FILE,SYMBOL,VALUE (rkunix,_nswap,872).")
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import tempfile
        import v6fs
        with tempfile.NamedTemporaryFile(delete=False, suffix=".rk") as t:
            t.write(img)
        try:
            where, val, old = v6fs.locate(v6fs.Fs(t.name), pf, psym)
        finally:
            os.unlink(t.name)
        PSPATCH = (where // 512, where % 512, old, pval & 0xFFFF)
        print("rk_image: PSRAM patch: %s %s at block %d +%d, %d -> %d in the PSRAM copy only"
              % (pf, psym, where // 512, where % 512, old, pval & 0xFFFF))
    parts, summary = build(img, a.chip, a.layout, a.blocks, a.name or os.path.basename(a.image))
    if a.drive1:
        img1 = open(a.drive1, "rb").read()
        n1 = blocks_of(img1)
        if REGION1 + SECTOR + RK_BLOCKS * 512 > FLASH[a.chip]:
            fail("RK1 does not fit the %s's flash." % a.chip)
        if REGION + SECTOR + max(len(d) for d in parts.values()) > REGION1:
            fail("RK0 runs into RK1's region at 0x%08X." % (XIP + REGION1))
        keep = (SWAP, AUTOBOOT, PSPATCH)
        SWAP, AUTOBOOT, PSPATCH = (0, 0), (0, b""), None
        parts[REGION1] = header(0, n1, n1, os.path.basename(a.drive1))
        SWAP, AUTOBOOT, PSPATCH = keep
        parts[REGION1 + SECTOR] = img1
        print("rk_image: RK1 <- %s, dense, %d blocks, at 0x%08X" % (a.drive1, n1, XIP + REGION1))
    open(a.o, "wb").write(uf2(parts, a.chip))
    print("rk_image: %s -> %s for the %s at 0x%08X: %s" % (a.image, a.o, a.chip, XIP + REGION, summary))
    if (a.desk or a.combined or a.firmware_uf2) and not a.firmware:
        fail("--desk, --combined and --firmware-uf2 need --firmware FW.bin.")
    if a.firmware:
        fw = open(a.firmware, "rb").read()
        if len(fw) > REGION:
            fail("the firmware is %d bytes and the disk region starts %d bytes in: it would be "
                 "overwritten. Move the region (disk.pico #DISK_REGION and REGION here) first." % (len(fw), REGION))
        if a.desk:
            end = max(off + len(d) for off, d in parts.items())
            flat = bytearray(b"\xff" * end)
            flat[:len(fw)] = fw
            for off, d in parts.items():
                flat[off:off + len(d)] = d
            open(a.desk, "wb").write(flat)
            print("rk_image: firmware (%d bytes) and pack -> %s, %d bytes, for arm_run" % (len(fw), a.desk, len(flat)))
        if a.combined:
            both = dict(parts)
            both[0] = fw
            open(a.combined, "wb").write(uf2(both, a.chip))
            print("rk_image: firmware and pack -> %s, one UF2" % a.combined)
        if a.firmware_uf2:
            open(a.firmware_uf2, "wb").write(uf2({0: fw}, a.chip))
            print("rk_image: firmware -> %s" % a.firmware_uf2)


if __name__ == "__main__":
    main()
