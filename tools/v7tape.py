#!/usr/bin/env python3
"""v7tape.py - the Seventh Edition Unix distribution tape, read on the host.

    python tools/v7tape.py files   TAPE OUTDIR          each tape file as OUTDIR/file0 ...
    python tools/v7tape.py ls      TAPE N               the paths in the dump that is tape file N
    python tools/v7tape.py restore TAPE N -o IMAGE --blocks B --inodes I
                                   [--skip PATH ...] [--only PATH ...] [--into IMAGE] [--at DIR]

THE TAPE (media/unix/v7.tap.gz, gunzipped; SIMH format: each record is a
4-byte little-endian length, the data, the length again; a 0 length is a
tape mark). Files 0-4 are the boot programs, the instructions, mkfs and
restor; file 5 is a dump of the root file system and file 6 one of /usr.

THE DUMP (the tape's /usr/include/dumprestor.h): 512-byte blocks in 10 KB
records. A header block has c_magic 60011 at byte 18; c_type 1 is the tape
label, 2 an inode (c_inumber, then the 64-byte disk inode at byte 22, then
c_count at 86 and c_addr[] at 88: for each of the next c_count block
addresses a non-zero byte means its 512 bytes follow, 0 a hole), 3 the
bitmap of dumped inodes, 4 more addresses of the inode before, 5 the end,
6 the bitmap of inodes in use.

RESTORE builds a new file system (tools/v7fs.py, mkfs) and adds the dump's
files from its root directory down, each under the same name, with its
mode, owner, times and contents; a hard link stays a link; a special file
keeps its device number. Inode numbers are new (as restor would give into
a file system that is not empty). --skip leaves a path (and what is under
it) out; --only takes just those paths and the directories leading to them.
--into adds to an existing image instead of a new one (a path already
there is left as it is), and --at puts the dump's root at that directory
of the image (the /usr dump at /usr, say).
"""
import argparse
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import v7fs  # noqa: E402

TS_TAPE, TS_INODE, TS_BITS, TS_ADDR, TS_END, TS_CLRI = 1, 2, 3, 4, 5, 6
MAGIC = 60011
IFMT, IFDIR, IFCHR, IFBLK = v7fs.IFMT, v7fs.IFDIR, v7fs.IFCHR, v7fs.IFBLK


def fail(msg):
    sys.stderr.write("v7tape: " + msg + "\n")
    sys.exit(1)


def tapefiles(path):
    d = open(path, "rb").read()
    i, files = 0, [[]]
    while i + 4 <= len(d):
        n = struct.unpack_from("<I", d, i)[0]
        i += 4
        if n == 0:
            files.append([])
            continue
        if n == 0xFFFFFFFF:
            break
        files[-1].append(d[i:i + n])
        i += n + (n & 1)
        if struct.unpack_from("<I", d, i)[0] != n:
            fail("record at byte %d: the trailing length is not the leading one" % (i - n - 4))
        i += 4
    return [b"".join(f) for f in files if f]


def dump_inodes(data):
    """{inumber: dict(mode, nlink, uid, gid, size, addr, times, data)}"""
    blocks = [data[o:o + 512] for o in range(0, len(data), 512)]
    out, cur, k = {}, None, 0
    while k < len(blocks):
        b = blocks[k]
        k += 1
        if len(b) < 512 or struct.unpack_from("<H", b, 18)[0] != MAGIC:
            continue
        if sum(struct.unpack_from("<256H", b)) & 0xFFFF != 84446 & 0xFFFF:
            fail("a dump header at block %d has a bad checksum" % (k - 1))
        typ = struct.unpack_from("<h", b, 0)[0]
        if typ == TS_INODE:
            cur = struct.unpack_from("<H", b, 16)[0]
            di = b[22:86]
            mode, nlink, uid, gid = struct.unpack_from("<HhhH", di, 0)
            out[cur] = dict(mode=mode, nlink=nlink, uid=uid, gid=gid, size=v7fs.glong(di, 8), addr=bytes(di[12:52]),
                            times=(v7fs.glong(di, 52), v7fs.glong(di, 56), v7fs.glong(di, 60)), parts=[])
        if typ in (TS_INODE, TS_ADDR):
            count = struct.unpack_from("<h", b, 86)[0]
            for j in range(count):
                if b[88 + j]:
                    out[cur]["parts"].append(blocks[k])
                    k += 1
                else:
                    out[cur]["parts"].append(bytes(512))
        if typ == TS_END:
            break
    for i in out.values():
        i["data"] = b"".join(i.pop("parts"))[:i["size"]] if i["mode"] & IFMT not in (IFCHR, IFBLK) else b""
    return out


def entries(ino, inodes):
    d = inodes[ino]["data"]
    for o in range(0, len(d) - 15, 16):
        n = struct.unpack_from("<H", d, o)[0]
        name = d[o + 2:o + 16].rstrip(b"\0").decode("latin1")
        if n and name not in (".", ".."):
            yield name, n


def paths(inodes, ino=2, base=""):
    for name, n in entries(ino, inodes):
        p = base + "/" + name
        yield p, n
        if n in inodes and inodes[n]["mode"] & IFMT == IFDIR:
            yield from paths(inodes, n, p)


def wanted(p, only, skip):
    if any(p == s or p.startswith(s + "/") for s in skip):
        return False
    if not only:
        return True
    return any(p == o or p.startswith(o + "/") or o.startswith(p + "/") for o in only)


def restore(fs, inodes, only=(), skip=(), at=2):
    """add the dump's tree under directory inode at (fs's root by default); returns (files, links)"""
    made = {}                       # dump inumber -> fs inumber
    nfiles = nlinks = 0
    nextino = [3]

    def newino():
        while fs.inode(nextino[0])["mode"]:
            nextino[0] += 1
        n = nextino[0]
        nextino[0] += 1
        if n > fs.ninodes:
            v7fs.fail("no free inode: give restore more --inodes")
        return n

    def walk(dino, fino, base):
        nonlocal nfiles, nlinks
        dirdata = bytearray(fs.read(fino))
        have = {name: n for _, n, name in fs.entries(fino) if n}
        sub = 0
        for name, n in entries(dino, inodes):
            p = base + "/" + name
            if n not in inodes or not wanted(p, only, skip):
                continue
            i = inodes[n]
            if name in have:
                if i["mode"] & IFMT == IFDIR:
                    walk(n, have[name], p)
                continue
            if n in made and i["mode"] & IFMT != IFDIR:
                ino = made[n]
                j = fs.inode(ino); j["nlink"] += 1; fs.setinode(ino, j)
                nlinks += 1
            else:
                ino = newino()
                if i["mode"] & IFMT == IFDIR:
                    v7fs.add_inode(fs, ino, i["mode"], 2, i["uid"], i["gid"],
                                   struct.pack("<H", ino) + b".".ljust(14, b"\0") + struct.pack("<H", fino) + b"..".ljust(14, b"\0"),
                                   times=i["times"])
                    sub += 1
                else:
                    v7fs.add_inode(fs, ino, i["mode"], 1, i["uid"], i["gid"], i["data"], raw_addr=i["addr"], times=i["times"])
                made[n] = ino
                nfiles += 1
            dirdata += struct.pack("<H", ino) + name.encode("latin1")[:14].ljust(14, b"\0")
            if i["mode"] & IFMT == IFDIR:
                fs.rewrite(fino, bytes(dirdata))
                walk(n, ino, p)
                dirdata = bytearray(fs.read(fino))
        fs.rewrite(fino, bytes(dirdata))
        if sub:
            j = fs.inode(fino); j["nlink"] += sub; fs.setinode(fino, j)
    walk(2, at, "")
    return nfiles, nlinks


def main():
    ap = argparse.ArgumentParser(description="Read the V7 distribution tape.")
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("files"); p.add_argument("tape"); p.add_argument("outdir")
    p = sub.add_parser("ls"); p.add_argument("tape"); p.add_argument("n", type=int)
    p = sub.add_parser("restore"); p.add_argument("tape"); p.add_argument("n", type=int)
    p.add_argument("-o", required=True); p.add_argument("--blocks", type=int, default=4000)
    p.add_argument("--inodes", type=int, default=1024); p.add_argument("--skip", nargs="*", default=[])
    p.add_argument("--only", nargs="*", default=[]); p.add_argument("--into")
    p.add_argument("--name", default="")
    p.add_argument("--at", default="/")
    a = ap.parse_args()
    files = tapefiles(a.tape)
    if a.cmd == "files":
        os.makedirs(a.outdir, exist_ok=True)
        for k, f in enumerate(files):
            open(os.path.join(a.outdir, "file%d" % k), "wb").write(f)
            print("v7tape: file%d, %d bytes" % (k, len(f)))
        return
    inodes = dump_inodes(files[a.n])
    if a.cmd == "ls":
        for path, n in paths(inodes):
            i = inodes[n]
            print("%s %2d %5d %8d %s" % (v7fs.modestr(i["mode"]), i["nlink"], n, i["size"], path))
        return
    if a.into:
        fs = v7fs.FS(open(a.into, "rb").read())
    else:
        fs = v7fs.mkfs(a.blocks, a.inodes, a.name.encode(), a.name.encode())
    at = fs.namei(a.at)
    if at is None:
        fail("%s is not a directory in the image" % a.at)
    nf, nl = restore(fs, inodes, [s.rstrip("/") for s in a.only], [s.rstrip("/") for s in a.skip], at)
    fs.recount()
    open(a.o, "wb").write(fs.img)
    print("v7tape: %d files and %d more links into %s (%d blocks, %d inodes)" % (nf, nl, a.o, fs.fsize, fs.ninodes))


if __name__ == "__main__":
    main()
