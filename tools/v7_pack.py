#!/usr/bin/env python3
"""v7_pack.py - the Seventh Edition RK05 pack, built on the host from the
distribution tape.

    python tools/v7_pack.py -o v7root.rk [--add LOCALDIR:/usr/name ...]

then, for a PSRAM board (the only boards with memory enough for V7):

    python tools/rk_image.py pack v7root.rk --chip picoplus2 --blocks 4872
           --swap 4000,872 --name v7root -o v7root.uf2

and at the firmware's prompt: MEM 1024, BOOT RK0, then at /boot's ':'
    rk(0,0)rkunix
which comes up single-user ('#'; type stty -lcase first - the console
starts in upper-case mode).

THE STEPS, each one a tool of this directory:
  1. v7tape.py restore: tape file 5 (the root dump) into a new 4000-block
     file system, 512 inodes, without the RP/HP kernels (there is no room
     and no such disk); then /include out of tape file 6 (the /usr dump)
     at /usr/include, so cc finds its headers.
  2. the kernel: v7ld.py links /usr/sys's own objects (conf/l.o mch.o c.o,
     sys/LIB1, dev/LIB2 - the tape's RK configuration) into rkunix with
     separate I and D, as /usr/sys/conf/makefile does, and two patches
     follow (below).
  3. the pack: padded to the RK05's 4872 blocks (blocks 4000-4871 are V7's
     swap area, swplo 4000 nswap 872 in c.c); /rkunix; /dev/rk0 rk1 rrk0
     rrk1 swap; /etc/rc without its mount of /dev/rp3 (there is no RP);
     block 0 the boot block (rkuboot.py).
  4. --add: each LOCALDIR's files into a new directory of the pack.

THE TWO PATCHES - both about the Unibus map, which the RK11 (an 18-bit
Unibus controller) reaches memory through on a 22-bit machine:
  /boot  (M.s) sets MMR3 to 065, the map switched on, and never loads the
         map's registers; its own RK reads then go nowhere (/boot reports
         "not a directory"). Patched to 025: 22-bit and the D spaces, map
         off - a bus address is the physical address, and /boot lives in
         the low 248 KB.
  rkunix (mch.s start:) when it is started with the MMU already on - by
         /boot - it does not set MMR3 itself; it only tests MMR3 bit 4
         (22-bit) and, seeing it, takes the machine for an 11/70
         (_cputype 70). From then on mapalloc points map registers at every
         swap and raw transfer and gives the controller a MAPPED bus
         address - with the map still off as /boot left it, the transfer
         lands on the wrong memory. (It showed as sticky-text programs - cc's
         c0 - dying with an illegal instruction on their second run, once
         their text came back from the swap area.) The patch turns that
         'bit $20,SSR3' into 'bis $60,SSR3': the map goes on as the kernel
         starts, the condition codes still say 11/70, and startup() loads
         the registers one to one before the first transfer.
"""
import argparse
import gzip
import os
import struct
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
TAPE = os.path.join(HERE, "..", "media", "unix", "v7.tap.gz")
sys.path.insert(0, HERE)
import v7tape  # noqa: E402

BLOCKS, FS_BLOCKS, INODES = 4872, 4000, 512
KERNEL_OBJECTS = ["/sys/conf/l.o", "/sys/conf/mch.o", "/sys/conf/c.o", "/sys/sys/LIB1", "/sys/dev/LIB2"]
DEVICES = [("rk0", "b", 0, 0), ("rk1", "b", 0, 1), ("rrk0", "c", 9, 0), ("rrk1", "c", 9, 1), ("swap", "b", 0, 0)]
RC_MOUNT = "/etc/mount /dev/rp3 /usr"


def fail(msg):
    sys.exit("v7_pack: " + msg)


def run(*args):
    r = subprocess.run([sys.executable] + [str(a) for a in args], capture_output=True, text=True)
    if r.returncode:
        fail("%s failed:\n%s%s" % (" ".join(str(a) for a in args[:2]), r.stdout, r.stderr))
    return r.stdout


def main():
    ap = argparse.ArgumentParser(description="The V7 RK05 pack from the distribution tape.")
    ap.add_argument("-o", required=True, help="the pack image to write")
    ap.add_argument("--tape", default=TAPE)
    ap.add_argument("--add", action="append", default=[], metavar="LOCALDIR:/PATH")
    a = ap.parse_args()
    out = os.path.abspath(a.o)
    v7fs, v7ld = os.path.join(HERE, "v7fs.py"), os.path.join(HERE, "v7ld.py")
    with tempfile.TemporaryDirectory() as tmp:
        tape = os.path.join(tmp, "v7.tap")
        with gzip.open(a.tape) as f, open(tape, "wb") as g:
            g.write(f.read())
        # 1. the root, then /usr/include
        run(os.path.join(HERE, "v7tape.py"), "restore", tape, 5, "-o", out, "--blocks", FS_BLOCKS,
            "--inodes", INODES, "--name", "root", "--skip", "/hphtunix", "/hptmunix", "/rphtunix", "/rptmunix")
        run(os.path.join(HERE, "v7tape.py"), "restore", tape, 6, "--into", out, "-o", out, "--at", "/usr",
            "--only", "/include")
        # 2. the kernel
        usr = v7tape.dump_inodes(v7tape.tapefiles(tape)[6])
        where = dict(v7tape.paths(usr))
        objs = []
        for p in KERNEL_OBJECTS:
            objs.append(os.path.join(tmp, p.split("/")[-1]))
            open(objs[-1], "wb").write(usr[where[p]]["data"])
        kern = os.path.join(tmp, "rkunix")
        run(v7ld, "-i", "-o", kern, *objs)
        k = bytearray(open(kern, "rb").read())
        # mch.s start: the first 'bit $20,SSR3' (relative: 032767 000020 offset) is the
        # MMU-already-on path's; make it 'bis $60,SSR3' (052767 000060, the same offset)
        text = k[16:16 + struct.unpack_from("<H", k, 2)[0]]
        for o in range(0, len(text) - 6, 2):
            w0, w1, w2 = struct.unpack_from("<3H", text, o)
            if w0 == 0o032767 and w1 == 0o20 and (o + 6 + w2) & 0xFFFF == 0o172516:
                struct.pack_into("<2H", k, 16 + o, 0o052767, 0o60)
                break
        else:
            fail("rkunix: no 'bit $20,SSR3' in its text")
        open(kern, "wb").write(k)
        # 3. the pack
        d = open(out, "rb").read()
        open(out, "wb").write(d + bytes(BLOCKS * 512 - len(d)))
        run(v7fs, "put", out, kern, "/rkunix", "--mode", "0644", "-o", out)
        for name, kind, major, minor in DEVICES:
            run(v7fs, "mknod", out, "/dev/" + name, kind, major, minor, "--mode", "0640", "-o", out)
        rc = run(v7fs, "cat", out, "/etc/rc")
        if RC_MOUNT not in rc.splitlines():
            fail("/etc/rc has no '%s' line" % RC_MOUNT)
        rc = "\n".join(": " + RC_MOUNT + " (no RP disk here; /usr/include is in the root file system)"
                       if line == RC_MOUNT else line for line in rc.split("\n"))
        open(os.path.join(tmp, "rc"), "w", newline="\n").write(rc)
        run(v7fs, "put", out, os.path.join(tmp, "rc"), "/etc/rc", "--mode", "0644", "-o", out)
        boot = os.path.join(tmp, "boot")
        run(v7fs, "get", out, "/boot", boot)
        b = bytearray(open(boot, "rb").read())
        hit = False
        for o in range(16, len(b) - 6, 2):               # 'mov $65,SSR3', absolute or relative
            w0, w1, w2 = struct.unpack_from("<3H", b, o)
            if w1 == 0o65 and ((w0 == 0o012737 and w2 == 0o172516) or
                               (w0 == 0o012767 and (o - 16 + 6 + w2) & 0xFFFF == 0o172516)):
                struct.pack_into("<H", b, o + 2, 0o25)
                hit = True
        if not hit:
            fail("/boot: no 'mov $65,SSR3'")
        open(boot, "wb").write(b)
        run(v7fs, "put", out, boot, "/boot", "-o", out)
        run(os.path.join(HERE, "rkuboot.py"), "--into", out)
        # 4. the caller's own files
        for spec in a.add:
            local, _, path = spec.rpartition(":")
            if not os.path.isdir(local) or not path.startswith("/"):
                fail("--add wants LOCALDIR:/path, not %s" % spec)
            run(v7fs, "mkdir", out, path, "-o", out)
            for f in sorted(os.listdir(local)):
                if os.path.isfile(os.path.join(local, f)):
                    run(v7fs, "put", out, os.path.join(local, f), path + "/" + f, "--mode", "0644", "-o", out)
        print(run(v7fs, "check", out).strip().splitlines()[-1])
    print("v7_pack: %s - %d blocks; RK0 for MEM 1024, BOOT RK0, then rk(0,0)rkunix" % (a.o, BLOCKS))


if __name__ == "__main__":
    main()
