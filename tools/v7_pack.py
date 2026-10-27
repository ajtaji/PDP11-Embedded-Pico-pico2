#!/usr/bin/env python3
"""v7_pack.py - the Seventh Edition RK05 pack, built on the host from the
distribution tape.

    python tools/v7_pack.py -o v7root.rk [--add LOCALDIR:/usr/name ...]

then, for a PSRAM board (the only boards with memory enough for V7):

    python tools/rk_image.py pack v7root.rk --chip picoplus2 --blocks 4872
           --swap 4000,872 --name v7root -o v7root.uf2

and at the firmware's prompt: MEM 1024, BOOT RK0, then at /boot's ':'
    rk(0,0)rkunix
which comes up single-user ('#', in lower case: THE CONSOLE below).

THE STEPS, each one a tool of this directory:
  1. v7tape.py restore: tape file 5 (the root dump) into a new 4000-block
     file system, 512 inodes, without the RP/HP kernels (there is no room
     and no such disk); then /include out of tape file 6 (the /usr dump)
     at /usr/include, so cc finds its headers.
  2. the PSRAM kernel: the checked native board build in media/unix/v7/
     rkunix-psram preserves FP state across fork and exec, retaining the
     distribution's 29 buffers and resource limits. The small --pico2w
     experiment instead uses the original v7ld.py link. Two startup/console
     adjustments follow (below).
  3. the pack: padded to the RK05's 4872 blocks (blocks 4000-4871 are V7's
     swap area, swplo 4000 nswap 872 in c.c); /rkunix; /dev/rk0 rk1 rrk0
     rrk1 swap; /etc/rc without its mount of /dev/rp3 (there is no RP);
     block 0 the boot block (rkuboot.py).
  4. --add: each LOCALDIR's files into a new directory of the pack.

THE CONSOLE. The kernel opens the console with the flags of a model 33
Teletype (kl.c: EVENP|LCASE|ECHO|XTABS|CRMOD|CR2): upper case only, and CR2,
a pause of 10 clock ticks after every newline for the carriage to get back.
On a USB terminal the pause is all there is to it - 60 lines of output took
10 s (Dhrystone's report: real 31 s for 18 s of computing). The kernel's
constant is patched to EVENP|ECHO|XTABS|CRMOD: no pause, lower case.

THE TWO MEMORY PATCHES - both about the Unibus map, which the RK11 (an 18-bit
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
KERNEL_OBJECTS = ["/sys/conf/l.o", "/sys/conf/mch.o", "/sys/conf/c.o", "/sys/dev/rp.o", "/sys/sys/LIB1",
                  "/sys/dev/LIB2"]      # rp.o: board-built (MEDIA_V7), ahead of LIB2 so LIB2's is never loaded
DEVICES = [("rk0", "b", 0, 0), ("rk1", "b", 0, 1), ("rrk0", "c", 9, 0), ("rrk1", "c", 9, 1), ("swap", "b", 0, 0)]
RC_MOUNT = "/etc/mount /dev/rp3 /usr"
# --pico2w: the Pico 2 W has no PSRAM - 152 KB of memory, the pack read-only in 1.75 MB of flash (3,584
# blocks, stored mapped), swap on a 112-block RAM disk at 4000 (pico2/disk.pico2). The root's files are
# 3,509 blocks; these programs, which need what the Pico 2 W has not got anyway (the manual's macros and
# /usr for typesetting, a network for uucp and mail transfer, room for Fortran), are left out. 2026-10-22.
PICO2W_SKIP = ["/lib/f77pass1", "/bin/f77", "/bin/learn", "/bin/uucp", "/bin/uux", "/bin/xsend", "/bin/xget",
               "/bin/enroll", "/bin/troff", "/bin/eqn", "/bin/neqn", "/bin/tbl", "/bin/refer"]
# The swap area: 700 blocks from 4000. V7's fork() (sys/sys1.c) fails with ENOMEM unless the swap map has
# room for a whole MAXMEM process, ctod(64*32) = 256 blocks, though it writes nothing there - with V6's
# 112, init could never fork a shell. Blocks 4000-4111 are the firmware's swap RAM disk; swap that really
# goes past them is held in its 254-block write overlay, with the files written.
PICO2W_NSWAP = 700
PICO2W_RAMDISK = 112
# --usr: what of the /usr dump goes on RK1 - what fits RK1's place on the PSRAM boards,
# 4,000 blocks (pico2/psram_pdp11.pico2, #PS_RK1_BLOCKS): the libraries and nroff's
# macros (2,230 blocks), the manual (1,424), the headers (141). Left out: /src (6,808
# blocks), /doc (3,247), /sys (1,169; the kernel's objects are linked here instead),
# /dict (715), /games (532).
USR_SET = ["/lib", "/man", "/include", "/mdec", "/spool", "/pub", "/tmp", "/dmr"]
USR_BLOCKS, USR_INODES = 4000, 600
# --usr-rp: the WHOLE /usr dump (sources, documents, dictionary, games: 15,218 blocks of data) on the RP03's
# partition 3, /dev/rp3, mounted on /usr by the distribution's own /etc/rc line. rp.c gives rp3 74,000 blocks
# from cylinder 35; the file system is made smaller than the partition, 20,800 blocks, so that every block of
# it can have a slot in the flash: a slot, once a block has one, is never given back (pico2/rp11.pico2, THE
# PACK IN FLASH), and RK1's place in the Pico Plus 2's 16 MB, up to the store of saved changes in its top
# 1 MB (pico2/store.pico2), holds 20,896. rk_image.py --rp refuses a file system with more blocks than
# that. 2026-10-22.
RP_USR_BLOCKS, RP_USR_INODES = 20800, 2400
RP_DEVICES = [("rp3", "b", 1, 3), ("rrp3", "c", 11, 3)]      # the distribution's /dev/makefile, rp03
# media/unix/v7/: built ON A BOARD by V7 itself (build-on-board.txt there): the kernel's configuration (c.o,
# l.o from mkconf: rk, rp, ht), the RP03 driver asking for the Unibus map on raw transfers (rp.o) and date
# (00-69 is 2000-2069). Each is checked against SHA256SUMS.
MEDIA_V7 = os.path.join(HERE, "..", "media", "unix", "v7")


def media_v7(name):
    import hashlib
    p = os.path.join(MEDIA_V7, name)
    sums = {}
    for line in open(os.path.join(MEDIA_V7, "SHA256SUMS")):
        h, f = line.split()
        sums[f.lstrip("*")] = h
    data = open(p, "rb").read()
    if hashlib.sha256(data).hexdigest() != sums.get(name):
        fail("media/unix/v7/%s does not match its SHA256SUMS line" % name)
    return data


def set_data_word(k, name, old, new):
    """Kernel k (a.out, 0411): the initialised data word of symbol name, which must read old, set to new."""
    magic, tsize, dsize, bsize, ssize, entry, _, flag = struct.unpack_from("<8H", k, 0)
    if magic != 0o411:
        fail("rkunix: magic %o, not 0411" % magic)
    syms = 16 + tsize + dsize + (0 if flag else tsize + dsize)
    want = name.encode("ascii")[:8].ljust(8, b"\0")
    for o in range(syms, syms + ssize, 12):
        if k[o:o + 8] == want:
            typ, val = struct.unpack_from("<HH", k, o + 8)
            if typ & 0o37 != 0o3:
                fail("rkunix: %s is not in the data segment (type %o)" % (name, typ))
            at = 16 + tsize + val
            if struct.unpack_from("<H", k, at)[0] != old:
                fail("rkunix: %s reads %d, not %d" % (name, struct.unpack_from("<H", k, at)[0], old))
            struct.pack_into("<H", k, at, new)
            return
    fail("rkunix: no symbol %s" % name)


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
    ap.add_argument("--usr", metavar="IMAGE", help="also write RK1: a /usr file system (USR_SET), mounted by /etc/rc")
    ap.add_argument("--usr-rp", metavar="IMAGE", help="also write the RP03's /usr: the WHOLE /usr dump for /dev/rp3, "
                    "mounted by /etc/rc (rk_image.py --rp)")
    ap.add_argument("--pico2w", action="store_true", help="the Pico 2 W's pack: no PSRAM, so a smaller root "
                    "(PICO2W_SKIP) and the kernel's swap on the 112-block RAM disk")
    a = ap.parse_args()
    if a.pico2w and (a.usr or a.usr_rp):
        fail("--pico2w is a root pack alone: the Pico 2 W has no second drive")
    if a.usr and a.usr_rp:
        fail("--usr (RK1) and --usr-rp (the RP03) both mount on /usr: give one")
    out = os.path.abspath(a.o)
    v7fs, v7ld = os.path.join(HERE, "v7fs.py"), os.path.join(HERE, "v7ld.py")
    with tempfile.TemporaryDirectory() as tmp:
        tape = os.path.join(tmp, "v7.tap")
        with gzip.open(a.tape) as f, open(tape, "wb") as g:
            g.write(f.read())
        # 1. the root, then /usr/include
        run(os.path.join(HERE, "v7tape.py"), "restore", tape, 5, "-o", out, "--blocks", FS_BLOCKS,
            "--inodes", INODES, "--name", "root", "--skip", "/hphtunix", "/hptmunix", "/rphtunix", "/rptmunix",
            *(PICO2W_SKIP if a.pico2w else []))
        run(os.path.join(HERE, "v7tape.py"), "restore", tape, 6, "--into", out, "-o", out, "--at", "/usr",
            "--only", "/include")
        # 2. the kernel
        usr = v7tape.dump_inodes(v7tape.tapefiles(tape)[6])
        where = dict(v7tape.paths(usr))
        objs = []
        for p in KERNEL_OBJECTS:
            objs.append(os.path.join(tmp, p.split("/")[-1]))
            if p in ("/sys/conf/l.o", "/sys/conf/c.o", "/sys/dev/rp.o"):   # board-built (MEDIA_V7)
                data = media_v7(p.split("/")[-1])
            else:
                data = usr[where[p]]["data"]
            open(objs[-1], "wb").write(data)
        kern = os.path.join(tmp, "rkunix")
        run(v7ld, "-i", "-o", kern, *objs)
        # PSRAM kernel compiled by V7 on the physical board. It retains the
        # distribution's process/file/inode limits and adds full FP context
        # preservation across fork/exec, masked raw FP saves and 40 buffers.
        # The small non-PSRAM profile keeps its original kernel configuration.
        k = bytearray(open(kern, "rb").read() if a.pico2w else media_v7("rkunix-psram"))
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
        # kl.c klopen: tp->t_flags = EVENP|LCASE|ECHO|XTABS|CRMOD|CR2 (mov $026234,36(r3));
        # without CR2 and LCASE: 006230
        for o in range(0, len(text) - 6, 2):
            if struct.unpack_from("<3H", text, o) == (0o012763, 0o026234, 0o36):
                struct.pack_into("<H", k, 16 + o + 2, 0o006230)
                break
        else:
            fail("rkunix: no 'mov $026234,36(r3)' (the console's flags) in its text")
        if a.pico2w:                             # nswap 872 (c.o) -> the Pico 2 W's 400 (PICO2W_NSWAP)
            set_data_word(k, "_nswap", 872, PICO2W_NSWAP)
        open(kern, "wb").write(k)
        # 3. the pack
        d = open(out, "rb").read()
        open(out, "wb").write(d + bytes(BLOCKS * 512 - len(d)))
        run(v7fs, "put", out, kern, "/rkunix", "--mode", "0644", "-o", out)
        if "unix" not in run(v7fs, "ls", out, "/").split():  # ps reads its names from /unix: the kernel that runs
            run(v7fs, "ln", out, "/rkunix", "/unix", "-o", out)
        for name, kind, major, minor in DEVICES + ([] if a.pico2w else RP_DEVICES):
            run(v7fs, "mknod", out, "/dev/" + name, kind, major, minor, "--mode", "0640", "-o", out)
        # date: the board-built one (media/unix/v7): a two-digit year under 70 is 20yy
        dp = os.path.join(tmp, "date")
        open(dp, "wb").write(media_v7("date"))
        run(v7fs, "put", out, dp, "/bin/date", "--mode", "0775", "-o", out)
        rc = run(v7fs, "cat", out, "/etc/rc")
        if RC_MOUNT not in rc.splitlines():
            fail("/etc/rc has no '%s' line" % RC_MOUNT)
        if a.usr_rp:                             # the distribution's own line: /usr on the RP03's rp3
            pass
        elif a.usr:                              # multi-user mounts RK1's /usr over the root's
            rc = "\n".join("/etc/mount /dev/rk1 /usr" if line == RC_MOUNT else line for line in rc.split("\n"))
        else:
            rc = "\n".join(": " + RC_MOUNT + " (no RP disk here; /usr/include is in the root file system)"
                           if line == RC_MOUNT else line for line in rc.split("\n"))
        open(os.path.join(tmp, "rc"), "w", newline="\n").write(rc)
        run(v7fs, "put", out, os.path.join(tmp, "rc"), "/etc/rc", "--mode", "0644", "-o", out)
        # root logs in with no password (the distribution's is not known): multi-user is usable
        pw = run(v7fs, "cat", out, "/etc/passwd").split("\n")
        if not pw[0].startswith("root:"):
            fail("/etc/passwd does not start with root")
        f = pw[0].split(":")
        f[1] = ""
        pw[0] = ":".join(f)
        open(os.path.join(tmp, "passwd"), "w", newline="\n").write("\n".join(pw))
        run(v7fs, "put", out, os.path.join(tmp, "passwd"), "/etc/passwd", "-o", out)
        # df with no argument reports the disks compiled into it, /dev/rp0 and /dev/rp3 (the RP
        # pack V7 was set up for): the root is rk0 here, and /usr is rp3 (--usr-rp, as compiled in)
        # or rk1 (--usr); the same lengths, so plain df answers (2026-10-22)
        dfp = os.path.join(tmp, "df")
        run(v7fs, "get", out, "/bin/df", dfp)
        dfb = open(dfp, "rb").read()
        if dfb.count(b"/dev/rp0\0") != 1 or dfb.count(b"/dev/rp3\0") != 1:
            fail("/bin/df: its two disk names (/dev/rp0, /dev/rp3) are not there once each")
        dfb = dfb.replace(b"/dev/rp0\0", b"/dev/rk0\0")
        if not a.usr_rp:
            dfb = dfb.replace(b"/dev/rp3\0", b"/dev/rk1\0")
        open(dfp, "wb").write(dfb)
        run(v7fs, "put", out, dfp, "/bin/df", "--mode", "0775", "-o", out)
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
        # 5. RK1: /usr
        if a.usr:
            usr_out = os.path.abspath(a.usr)
            run(os.path.join(HERE, "v7tape.py"), "restore", tape, 6, "-o", usr_out, "--blocks", USR_BLOCKS,
                "--inodes", USR_INODES, "--name", "usr", "--only", *USR_SET)
            print(run(v7fs, "check", usr_out).strip().splitlines()[-1])
            print("v7_pack: %s - RK1, /usr (%s); multi-user mounts it on /usr, single-user: /etc/mount /dev/rk1 /usr"
                  % (a.usr, " ".join(USR_SET)))
            for spec in a.add:
                if spec.rpartition(":")[2].startswith("/usr/"):
                    print("v7_pack: note: %s is on RK0's /usr, which RK1 covers once mounted (multi-user)" % spec)
        # 5b. the RP03's rp3: the whole /usr dump
        if a.usr_rp:
            rp_out = os.path.abspath(a.usr_rp)
            run(os.path.join(HERE, "v7tape.py"), "restore", tape, 6, "-o", rp_out, "--blocks", RP_USR_BLOCKS,
                "--inodes", RP_USR_INODES, "--name", "usr")
            print(run(v7fs, "check", rp_out).strip().splitlines()[-1])
            print("v7_pack: %s - the RP03's rp3, the whole /usr (%d blocks); multi-user mounts it on /usr, "
                  "single-user: /etc/mount /dev/rp3 /usr" % (a.usr_rp, RP_USR_BLOCKS))
    if a.pico2w:
        print("v7_pack: %s - %d blocks, the Pico 2 W's (swap 4000-%d): rk_image.py pack ... --chip pico2 --swap "
              "4000,%d; BOOT RK0, boot at the @, rk(0,0)rkunix at the :" % (a.o, BLOCKS, 4000 + PICO2W_NSWAP - 1,
              PICO2W_RAMDISK))
    else:
        print("v7_pack: %s - %d blocks; RK0 for MEM 1024, BOOT RK0, boot at the @, rk(0,0)rkunix at the :" % (a.o, BLOCKS))


if __name__ == "__main__":
    main()
