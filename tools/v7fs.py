#!/usr/bin/env python3
"""v7fs.py - read and write a Seventh Edition Unix file system in a disk image.

    python tools/v7fs.py ls    IMAGE [PATH]
    python tools/v7fs.py cat   IMAGE PATH                 (the file's bytes to stdout)
    python tools/v7fs.py get   IMAGE PATH HOSTFILE
    python tools/v7fs.py put   IMAGE HOSTFILE PATH [--mode 0644] -o OUT
    python tools/v7fs.py rm    IMAGE PATH -o OUT          (one link; the file goes with its last)
    python tools/v7fs.py ln    IMAGE OLD NEW -o OUT
    python tools/v7fs.py mkdir IMAGE PATH -o OUT
    python tools/v7fs.py mknod IMAGE PATH b|c MAJOR MINOR [--mode 0644] -o OUT
    python tools/v7fs.py check IMAGE

Every changing command writes the whole image to -o (which may be IMAGE).
tools/v7tape.py builds images from the V7 distribution tape with the
functions below (mkfs, add_inode).

THE FORMAT (the tape's /usr/include/sys/filsys.h, ino.h, fblk.h, dir.h and
param.h; PDP-11 order: a word low byte first, a long high WORD first):
  block 0          the boot block
  block 1          the super-block: s_isize (the first block after the
                   i-list), s_fsize (blocks in the volume), s_nfree and
                   s_free[50] (the free list's head; s_free[0] links to the
                   next block of 50, 0 ends it), s_ninode and s_inode[100]
                   (a cache of free i-numbers; 0 makes the kernel search),
                   flags, s_time, s_tfree, s_tinode, s_m, s_n, s_fname[6],
                   s_fpack[6]
  blocks 2..       the i-list, 8 inodes of 64 bytes a block: inode n is in
                   block (n + 15) >> 3 at ((n + 15) & 7) * 64
  inode            di_mode, di_nlink, di_uid, di_gid, di_size (long),
                   di_addr[40] = 13 addresses of 3 bytes (l3tol: byte 0 is
                   bits 16-23, byte 1 bits 0-7, byte 2 bits 8-15), atime,
                   mtime, ctime. Addresses 0-9 are direct, 10 single
                   indirect, 11 double, 12 triple; an indirect block holds
                   128 longs. A special file keeps its device number
                   as its first address (the kernel's i_rdev = i_addr[0]
                   after l3tol): di_addr[1] the minor, di_addr[2] the major.
  directories      16-byte entries: i-number (word), name[14]
"""
import argparse
import struct
import sys

BSIZE = 512
NICFREE = 50
NICINOD = 100
IFMT, IFDIR, IFCHR, IFBLK, IFREG = 0o170000, 0o040000, 0o020000, 0o060000, 0o100000


def fail(msg):
    sys.stderr.write("v7fs: " + msg + "\n")
    sys.exit(1)


def glong(b, o):
    hi, lo = struct.unpack_from("<HH", b, o)
    return (hi << 16) | lo


def plong(b, o, v):
    struct.pack_into("<HH", b, o, (v >> 16) & 0xFFFF, v & 0xFFFF)


def l3tol(a):
    return [(a[3 * i] << 16) | a[3 * i + 1] | (a[3 * i + 2] << 8) for i in range(13)]


def ltol3(addrs):
    out = bytearray(40)
    for i, v in enumerate(addrs):
        out[3 * i] = (v >> 16) & 0xFF
        out[3 * i + 1] = v & 0xFF
        out[3 * i + 2] = (v >> 8) & 0xFF
    return out


class FS:
    def __init__(self, img):
        self.img = bytearray(img)
        sb = self.block(1)
        self.isize = struct.unpack_from("<H", sb, 0)[0]
        self.fsize = glong(sb, 2)
        self.ninodes = (self.isize - 2) * 8

    def block(self, n):
        return self.img[n * BSIZE:(n + 1) * BSIZE]

    def setblock(self, n, data):
        data = bytes(data) + bytes(BSIZE - len(data))
        self.img[n * BSIZE:(n + 1) * BSIZE] = data

    # ---- inodes ----
    def ioff(self, ino):
        return ((ino + 15) >> 3) * BSIZE + ((ino + 15) & 7) * 64

    def inode(self, ino):
        o = self.ioff(ino)
        r = self.img[o:o + 64]
        mode, nlink, uid, gid = struct.unpack_from("<HhhH", r, 0)
        return dict(mode=mode, nlink=nlink, uid=uid, gid=gid, size=glong(r, 8),
                    addr=bytes(r[12:52]), atime=glong(r, 52), mtime=glong(r, 56), ctime=glong(r, 60))

    def setinode(self, ino, i):
        o = self.ioff(ino)
        r = bytearray(64)
        struct.pack_into("<HhhH", r, 0, i["mode"], i["nlink"], i["uid"], i["gid"])
        plong(r, 8, i["size"])
        r[12:52] = i["addr"]
        plong(r, 52, i.get("atime", 0))
        plong(r, 56, i.get("mtime", 0))
        plong(r, 60, i.get("ctime", 0))
        self.img[o:o + 64] = r

    # ---- block lists ----
    def blocklist(self, i, meta=False):
        """the file's data blocks in order (and, with meta, the indirect blocks too)"""
        if i["mode"] & IFMT in (IFCHR, IFBLK):
            return ([], []) if meta else []
        a = l3tol(i["addr"])
        n = (i["size"] + BSIZE - 1) // BSIZE
        out, ind = [], []

        def walk(b, level):
            if b == 0:
                return
            ind.append(b)
            blk = self.block(b)
            for k in range(128):
                if len(out) >= n:
                    return
                c = glong(blk, 4 * k)
                if level == 1:
                    out.append(c)
                else:
                    walk(c, level - 1)
        for k in range(10):
            if len(out) < n:
                out.append(a[k])
        for lvl, k in ((1, 10), (2, 11), (3, 12)):
            if len(out) < n:
                walk(a[k], lvl)
        return (out, ind) if meta else out

    def read(self, ino):
        i = self.inode(ino)
        data = b"".join(self.block(b) if b else bytes(BSIZE) for b in self.blocklist(i))
        return data[:i["size"]]

    # ---- allocation (the free list, as the kernel's alloc/free) ----
    def alloc(self):
        sb = bytearray(self.block(1))
        nfree = struct.unpack_from("<h", sb, 6)[0]
        if nfree <= 0:
            fail("the file system is full")
        nfree -= 1
        b = glong(sb, 8 + 4 * nfree)
        if b == 0:
            fail("the file system is full")
        if nfree == 0:
            fb = self.block(b)
            nfree = struct.unpack_from("<h", fb, 0)[0]
            for k in range(NICFREE):
                plong(sb, 8 + 4 * k, glong(fb, 2 + 4 * k))
        struct.pack_into("<h", sb, 6, nfree)
        plong(sb, 418, glong(sb, 418) - 1)
        self.setblock(1, sb)
        self.setblock(b, b"")
        return b

    def free(self, b):
        sb = bytearray(self.block(1))
        nfree = struct.unpack_from("<h", sb, 6)[0]
        if nfree >= NICFREE:
            fb = bytearray(BSIZE)
            struct.pack_into("<h", fb, 0, nfree)
            for k in range(NICFREE):
                plong(fb, 2 + 4 * k, glong(sb, 8 + 4 * k))
            self.setblock(b, fb)
            nfree = 0
        plong(sb, 8 + 4 * nfree, b)
        struct.pack_into("<h", sb, 6, nfree + 1)
        plong(sb, 418, glong(sb, 418) + 1)
        self.setblock(1, sb)

    def ialloc(self):
        for ino in range(1, self.ninodes + 1):
            i = self.inode(ino)
            if i["mode"] == 0 and ino > 1:
                return ino
        fail("no free inode")

    def writedata(self, data):
        """allocate blocks for data; return the 13 addresses"""
        nb = (len(data) + BSIZE - 1) // BSIZE
        blocks = []
        for k in range(nb):
            b = self.alloc()
            self.setblock(b, data[k * BSIZE:(k + 1) * BSIZE])
            blocks.append(b)
        a = [0] * 13
        for k in range(min(10, nb)):
            a[k] = blocks[k]
        rest = blocks[10:]

        def indirect(lst, level):
            b = self.alloc()
            blk = bytearray(BSIZE)
            per = 128 ** (level - 1)
            for k in range(128):
                chunk = lst[k * per:(k + 1) * per]
                if not chunk:
                    break
                plong(blk, 4 * k, chunk[0] if level == 1 else indirect(chunk, level - 1))
            self.setblock(b, blk)
            return b
        if rest:
            a[10] = indirect(rest[:128], 1)
            rest = rest[128:]
        if rest:
            a[11] = indirect(rest[:128 * 128], 2)
            rest = rest[128 * 128:]
        if rest:
            a[12] = indirect(rest, 3)
        return a

    def release(self, i):
        data, ind = self.blocklist(i, meta=True)
        for b in data + ind:
            if b:
                self.free(b)

    # ---- directories ----
    def entries(self, ino):
        d = self.read(ino)
        for o in range(0, len(d) - 15, 16):
            n = struct.unpack_from("<H", d, o)[0]
            yield o, n, d[o + 2:o + 16].rstrip(b"\0").decode("latin1")

    def namei(self, path):
        ino = 2
        for part in [p for p in path.split("/") if p]:
            if self.inode(ino)["mode"] & IFMT != IFDIR:
                return None
            for _, n, name in self.entries(ino):
                if n and name == part:
                    ino = n
                    break
            else:
                return None
        return ino

    def rewrite(self, ino, data):
        i = self.inode(ino)
        self.release(i)
        i["addr"] = ltol3(self.writedata(data))
        i["size"] = len(data)
        self.setinode(ino, i)

    def link(self, dirino, name, ino):
        d = bytearray(self.read(dirino))
        ent = struct.pack("<H", ino) + name.encode("latin1")[:14].ljust(14, b"\0")
        for o in range(0, len(d), 16):
            if struct.unpack_from("<H", d, o)[0] == 0:
                d[o:o + 16] = ent
                break
        else:
            d += ent
        self.rewrite(dirino, bytes(d))

    def unlink(self, dirino, name):
        d = bytearray(self.read(dirino))
        for o in range(0, len(d), 16):
            n = struct.unpack_from("<H", d, o)[0]
            if n and d[o + 2:o + 16].rstrip(b"\0").decode("latin1") == name:
                d[o:o + 2] = b"\0\0"
                self.rewrite(dirino, bytes(d))
                return n
        return None

    def split(self, path):
        parts = [p for p in path.split("/") if p]
        parent = self.namei("/" + "/".join(parts[:-1]))
        if parent is None:
            fail("%s: the directory is not there" % path)
        return parent, parts[-1]


def mkfs(nblocks, ninodes, fname=b"", fpack=b""):
    """an empty V7 file system with a root directory (inode 2)"""
    isize = 2 + (ninodes + 7) // 8
    img = bytearray(nblocks * BSIZE)
    sb = bytearray(BSIZE)
    struct.pack_into("<H", sb, 0, isize)
    plong(sb, 2, nblocks)
    sb[428:434] = fname[:6].ljust(6, b"\0")
    sb[434:440] = fpack[:6].ljust(6, b"\0")
    img[BSIZE:2 * BSIZE] = sb
    fs = FS(img)
    # the free list, as V7 mkfs builds it: 0 first (the end), then the data
    # blocks from the top down, so the lowest are handed out first
    sb = bytearray(fs.block(1))
    struct.pack_into("<h", sb, 6, 1)
    plong(sb, 8, 0)
    fs.setblock(1, sb)
    for b in range(nblocks - 1, isize - 1, -1):
        fs.free(b)
    root = dict(mode=IFDIR | 0o755, nlink=2, uid=0, gid=0, size=0, addr=bytes(40))
    fs.setinode(2, root)
    d = struct.pack("<H", 2) + b".".ljust(14, b"\0") + struct.pack("<H", 2) + b"..".ljust(14, b"\0")
    fs.rewrite(2, d)
    fs.setinode(1, dict(mode=IFREG, nlink=1, uid=0, gid=0, size=0, addr=bytes(40)))   # V7 mkfs: inode 1 holds bad blocks
    fs.recount()
    return fs


def _recount(self):
    """s_tinode: the free inodes; s_ninode left 0 (the kernel searches)"""
    sb = bytearray(self.block(1))
    free = sum(1 for ino in range(1, self.ninodes + 1) if self.inode(ino)["mode"] == 0)
    struct.pack_into("<H", sb, 422, free)
    struct.pack_into("<h", sb, 208, 0)
    self.setblock(1, sb)


FS.recount = _recount


def add_inode(fs, ino, mode, nlink, uid, gid, data=b"", raw_addr=None, times=(0, 0, 0)):
    """put an inode with a chosen number (a restored file) into fs"""
    i = dict(mode=mode, nlink=nlink, uid=uid, gid=gid, size=0, addr=bytes(40),
             atime=times[0], mtime=times[1], ctime=times[2])
    if mode & IFMT in (IFCHR, IFBLK):
        i["addr"] = raw_addr
    else:
        i["addr"] = ltol3(fs.writedata(data))
        i["size"] = len(data)
    fs.setinode(ino, i)


def check(fs):
    """every block used once, the free list in range and disjoint, link counts"""
    owner = {}
    problems = 0
    links = {}
    for ino in range(1, fs.ninodes + 1):
        i = fs.inode(ino)
        if i["mode"] == 0:
            continue
        data, ind = fs.blocklist(i, meta=True)
        for b in data + ind:
            if b == 0:
                continue
            if not fs.isize <= b < fs.fsize:
                print("v7fs check: inode %d: block %d out of range" % (ino, b)); problems += 1
            elif b in owner:
                print("v7fs check: block %d in inode %d and %s" % (b, ino, owner[b])); problems += 1
            owner[b] = ino
        if i["mode"] & IFMT == IFDIR:
            for _, n, name in fs.entries(ino):
                if n:
                    links[n] = links.get(n, 0) + 1
    sb = fs.block(1)
    nfree = struct.unpack_from("<h", sb, 6)[0]
    lst = [glong(sb, 8 + 4 * k) for k in range(nfree)]
    free = 0
    while lst:
        b = lst.pop()
        if b == 0:
            if lst:
                print("v7fs check: a 0 inside the free list"); problems += 1
            break
        if b in owner:
            print("v7fs check: block %d is free and in inode %s" % (b, owner[b])); problems += 1
        owner[b] = "free"
        free += 1
        if not lst:
            fb = fs.block(b)
            n = struct.unpack_from("<h", fb, 0)[0]
            lst = [glong(fb, 2 + 4 * k) for k in range(n)]
    for ino, n in links.items():
        i = fs.inode(ino)
        if i["mode"] == 0:
            print("v7fs check: a directory names free inode %d" % ino); problems += 1
        elif i["nlink"] != n:
            print("v7fs check: inode %d has nlink %d, %d names" % (ino, i["nlink"], n)); problems += 1
    used = sum(1 for v in owner.values() if v != "free")
    lost = fs.fsize - fs.isize - used - free
    if lost:
        print("v7fs check: %d blocks neither in a file nor free" % lost); problems += 1
    if glong(sb, 418) != free:
        print("v7fs check: s_tfree %d, the free list holds %d" % (glong(sb, 418), free)); problems += 1
    print("v7fs check: %d inodes in use, %d blocks in files, %d free, %d problems"
          % (sum(1 for ino in range(1, fs.ninodes + 1) if fs.inode(ino)["mode"]), used, free, problems))
    return problems


def modestr(m):
    t = {IFDIR: "d", IFCHR: "c", IFBLK: "b", IFREG: "-"}.get(m & IFMT, "?")
    return t + "%04o" % (m & 0o7777)


def main():
    ap = argparse.ArgumentParser(description="Read and write a V7 file system image.")
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name, args in (("ls", ["image", "path?"]), ("cat", ["image", "path"]), ("get", ["image", "path", "hostfile"]),
                       ("put", ["image", "hostfile", "path"]), ("rm", ["image", "path"]), ("ln", ["image", "old", "new"]),
                       ("mkdir", ["image", "path"]), ("mknod", ["image", "path", "kind", "major", "minor"]),
                       ("check", ["image"])):
        p = sub.add_parser(name)
        for a in args:
            if a.endswith("?"):
                p.add_argument(a[:-1], nargs="?", default="/")
            else:
                p.add_argument(a)
        if name in ("put", "mknod", "mkdir"):
            p.add_argument("--mode")
        if name in ("put", "rm", "ln", "mkdir", "mknod"):
            p.add_argument("-o", required=True)
    a = ap.parse_args()
    fs = FS(open(a.image, "rb").read())
    if a.cmd == "check":
        sys.exit(1 if check(fs) else 0)
    if a.cmd in ("ls", "cat", "get"):
        ino = fs.namei(a.path)
        if ino is None:
            fail("%s is not there" % a.path)
        if a.cmd == "cat":
            sys.stdout.buffer.write(fs.read(ino))
        elif a.cmd == "get":
            open(a.hostfile, "wb").write(fs.read(ino))
        else:
            i = fs.inode(ino)
            rows = list(fs.entries(ino)) if i["mode"] & IFMT == IFDIR else [(0, ino, a.path)]
            for _, n, name in rows:
                if n:
                    j = fs.inode(n)
                    print("%s %2d %5d %8d %s" % (modestr(j["mode"]), j["nlink"], n, j["size"], name))
        return
    if a.cmd == "put":
        data = open(a.hostfile, "rb").read()
        parent, name = fs.split(a.path)
        old = fs.namei(a.path)
        if old is not None:
            fs.rewrite(old, data)
            ino = old
        else:
            ino = fs.ialloc()
            add_inode(fs, ino, IFREG | int(a.mode or "0644", 8), 1, 0, 0, data)
            fs.link(parent, name, ino)
        if a.mode:
            i = fs.inode(ino); i["mode"] = IFREG | int(a.mode, 8); fs.setinode(ino, i)
        print("v7fs: %s = inode %d, %d bytes" % (a.path, ino, len(data)))
    elif a.cmd == "rm":
        parent, name = fs.split(a.path)
        ino = fs.unlink(parent, name)
        if ino is None:
            fail("%s is not there" % a.path)
        i = fs.inode(ino)
        i["nlink"] -= 1
        if i["nlink"] <= 0:
            fs.release(i)
            fs.setinode(ino, dict(mode=0, nlink=0, uid=0, gid=0, size=0, addr=bytes(40)))
        else:
            fs.setinode(ino, i)
        print("v7fs: %s removed" % a.path)
    elif a.cmd == "ln":
        ino = fs.namei(a.old)
        if ino is None:
            fail("%s is not there" % a.old)
        parent, name = fs.split(a.new)
        fs.link(parent, name, ino)
        i = fs.inode(ino); i["nlink"] += 1; fs.setinode(ino, i)
        print("v7fs: %s -> inode %d" % (a.new, ino))
    elif a.cmd == "mkdir":
        parent, name = fs.split(a.path)
        ino = fs.ialloc()
        d = struct.pack("<H", ino) + b".".ljust(14, b"\0") + struct.pack("<H", parent) + b"..".ljust(14, b"\0")
        add_inode(fs, ino, IFDIR | int(a.mode or "0755", 8), 2, 0, 0, d)
        fs.link(parent, name, ino)
        p = fs.inode(parent); p["nlink"] += 1; fs.setinode(parent, p)
        print("v7fs: %s = inode %d" % (a.path, ino))
    elif a.cmd == "mknod":
        parent, name = fs.split(a.path)
        if fs.namei(a.path) is not None:
            fail("%s is already there" % a.path)
        ino = fs.ialloc()
        kind = IFBLK if a.kind == "b" else IFCHR
        dev = (int(a.major) << 8) | int(a.minor)
        addr = ltol3([dev] + [0] * 12)
        add_inode(fs, ino, kind | int(a.mode or "0644", 8), 1, 0, 0, raw_addr=bytes(addr))
        fs.link(parent, name, ino)
        print("v7fs: %s = inode %d, %s %d,%d" % (a.path, ino, a.kind, int(a.major), int(a.minor)))
    fs.recount()
    open(a.o, "wb").write(fs.img)


if __name__ == "__main__":
    main()
