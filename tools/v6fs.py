#!/usr/bin/env python3
"""v6fs.py - read and change a Sixth Edition (V6) Unix file system inside an
RK05 disk image, on the host: list and copy out files, make device nodes,
link and remove files, and patch a word of a kernel by its symbol.

USE
    python v6fs.py ls    IMAGE PATH
    python v6fs.py cat   IMAGE PATH
    python v6fs.py mknod IMAGE PATH b|c MAJOR MINOR [--mode OCTAL] -o OUT
    python v6fs.py ln    IMAGE EXISTING NEW -o OUT
    python v6fs.py rm    IMAGE PATH -o OUT
    python v6fs.py patch IMAGE FILE SYMBOL VALUE -o OUT
    python v6fs.py check IMAGE

    patch   writes VALUE (decimal, or 0o.. octal) into the data word of
            the a.out FILE named by SYMBOL (a V6 kernel's _nswap, say).
    check   walks the file system the way icheck does: every block is
            either free or in exactly one file, and every inode's link
            count matches the directory entries naming it.

    Each changing command reads IMAGE and writes the whole image to OUT
    (OUT may be IMAGE itself). Nothing is changed in place otherwise.

THE FORMAT (V6 /usr/sys/filsys.h, ino.h, param.h)
    block 1       the superblock: s_isize, s_fsize, s_nfree, s_free[100],
                  s_ninode, s_inode[100], locks, s_fmod, s_ronly, s_time
    block 2 on    the i-list, 16 inodes of 32 bytes a block, inode 1 first:
                  i_mode, i_nlink, i_uid, i_gid, i_size0, i_size1,
                  i_addr[8], i_atime[2], i_mtime[2]
    i_mode        0100000 allocated, 060000 file type (040000 directory,
                  020000 character device, 060000 block device), 010000
                  large file (i_addr are indirect blocks), then set-uid,
                  set-gid, sticky and the rwx bits
    device node   i_addr[0] = major << 8 | minor
    directory     16-byte entries: inode number, 14-byte name
    free blocks   s_free[0 .. s_nfree-1]; when the superblock's list is
                  used up, s_free[0] names a block holding the next 100
                  (its first word is their count)

LIMITS
    Plain V6 only (not V7, whose superblock and addresses differ); files of
    up to 8 indirect blocks (1 MB), which is every file on an RK05; a
    directory grows by a block when it has no empty entry.
"""
import argparse
import struct
import sys

BS = 512
IALLOC, IFMT, IFDIR, IFCHR, IFBLK, ILARG = 0o100000, 0o60000, 0o40000, 0o20000, 0o60000, 0o10000


def fail(msg):
    sys.exit("v6fs: " + msg)


class Fs:
    def __init__(self, path):
        self.d = bytearray(open(path, "rb").read())
        sb = self.blk(1)
        self.isize, self.fsize, self.nfree = struct.unpack_from("<HHH", sb, 0)
        self.free = list(struct.unpack_from("<100H", sb, 6))
        self.ninode = struct.unpack_from("<H", sb, 206)[0]
        self.inodes = list(struct.unpack_from("<100H", sb, 208))
        self.time = sb[412:416]
        if not (2 < self.isize < self.fsize <= len(self.d) // BS and self.nfree <= 100 and self.ninode <= 100):
            fail("%s does not hold a V6 file system (superblock isize %d fsize %d)" % (path, self.isize, self.fsize))

    # ---- blocks and the superblock ----
    def blk(self, b):
        return self.d[b * BS:(b + 1) * BS]

    def put(self, b, data):
        self.d[b * BS:(b + 1) * BS] = bytes(data).ljust(BS, b"\0")

    def save_sb(self):
        sb = bytearray(self.blk(1))
        struct.pack_into("<HHH", sb, 0, self.isize, self.fsize, self.nfree)
        struct.pack_into("<100H", sb, 6, *self.free)
        struct.pack_into("<H", sb, 206, self.ninode)
        struct.pack_into("<100H", sb, 208, *self.inodes)
        sb[410] = 1                                   # s_fmod
        self.put(1, sb)

    def balloc(self):
        """V6 alloc(): the superblock's list, refilled from the block it names."""
        if self.nfree == 0:
            fail("the file system is full")
        self.nfree -= 1
        b = self.free[self.nfree]
        if b == 0:
            fail("the file system is full")
        if self.nfree == 0:
            nb = self.blk(b)
            self.nfree = struct.unpack_from("<H", nb, 0)[0]
            self.free = list(struct.unpack_from("<100H", nb, 2))
        self.put(b, b"")
        return b

    def bfree(self, b):
        """V6 free(): a full superblock list goes into the freed block."""
        if self.nfree >= 100:
            nb = bytearray(BS)
            struct.pack_into("<H", nb, 0, self.nfree)
            struct.pack_into("<100H", nb, 2, *self.free)
            self.put(b, nb)
            self.nfree = 0
            self.free = [0] * 100
        self.free[self.nfree] = b
        self.nfree += 1

    # ---- inodes ----
    def ioff(self, n):
        return (2 + (n - 1) // 16) * BS + ((n - 1) % 16) * 32

    def inode(self, n):
        o = self.ioff(n)
        mode, nlink, uid, gid, s0, s1 = struct.unpack_from("<HBBBBH", self.d, o)
        addr = list(struct.unpack_from("<8H", self.d, o + 8))
        return {"mode": mode, "nlink": nlink, "uid": uid, "gid": gid, "size": (s0 << 16) | s1, "addr": addr}

    def put_inode(self, n, ino):
        o = self.ioff(n)
        struct.pack_into("<HBBBBH", self.d, o, ino["mode"], ino["nlink"], ino["uid"], ino["gid"],
                         (ino["size"] >> 16) & 0xFF, ino["size"] & 0xFFFF)
        struct.pack_into("<8H", self.d, o + 8, *ino["addr"])

    def ialloc(self):
        for n in range(1, self.isize * 16 + 1):
            if not self.inode(n)["mode"] & IALLOC:
                if n in self.inodes[:self.ninode]:        # keep the free-inode cache true
                    k = self.inodes[:self.ninode].index(n)
                    del self.inodes[k]
                    self.inodes.append(0)
                    self.ninode -= 1
                self.d[self.ioff(n):self.ioff(n) + 32] = bytes(32)
                self.d[self.ioff(n) + 24:self.ioff(n) + 32] = self.time + self.time   # atime, mtime
                return n
        fail("no free inode")

    def blocks(self, n):
        """The data blocks of inode n, in order (0 for a hole), and its indirect blocks."""
        ino = self.inode(n)
        if ino["mode"] & IFMT in (IFCHR, IFBLK):
            return [], []
        nb = (ino["size"] + BS - 1) // BS
        if not ino["mode"] & ILARG:
            return list(ino["addr"][:nb]), []
        data, ind = [], []
        for ib in ino["addr"]:
            if ib:
                ind.append(ib)
                data += list(struct.unpack_from("<256H", self.blk(ib)))
        return data[:nb], ind

    def read(self, n):
        ino = self.inode(n)
        bl, _ = self.blocks(n)
        return b"".join(self.blk(b) if b else bytes(BS) for b in bl)[:ino["size"]]

    # ---- names ----
    def entries(self, n):
        data = self.read(n)
        for i in range(0, len(data), 16):
            yield i, struct.unpack_from("<H", data, i)[0], data[i + 2:i + 16].split(b"\0")[0].decode("latin-1")

    def lookup(self, path):
        n = 1
        for part in [p for p in path.split("/") if p]:
            if self.inode(n)["mode"] & IFMT != IFDIR:
                fail("%s: not a directory on the way" % path)
            for _, ino, name in self.entries(n):
                if ino and name == part:
                    n = ino
                    break
            else:
                return 0
        return n

    def split(self, path):
        parts = [p for p in path.split("/") if p]
        if not parts:
            fail("%s: no name" % path)
        name = parts[-1]
        if len(name.encode()) > 14:
            fail("%s: a V6 name is at most 14 characters" % name)
        dn = self.lookup("/" + "/".join(parts[:-1]))
        if not dn or self.inode(dn)["mode"] & IFMT != IFDIR:
            fail("%s: the directory is not there" % path)
        return dn, name

    def dir_set(self, dn, offset, ino, name):
        """Write entry at byte offset of directory dn."""
        bl, _ = self.blocks(dn)
        b = bl[offset // BS]
        blk = bytearray(self.blk(b))
        e = struct.pack("<H", ino) + name.encode("latin-1").ljust(14, b"\0")
        blk[offset % BS:offset % BS + 16] = e
        self.put(b, blk)

    def link(self, dn, name, ino):
        for off, i, nm in self.entries(dn):
            if i and nm == name:
                fail("%s already exists" % name)
        for off, i, nm in self.entries(dn):
            if i == 0:
                self.dir_set(dn, off, ino, name)
                return
        d = self.inode(dn)                          # no empty entry: grow by one
        off = d["size"]
        if off % BS == 0:
            if d["mode"] & ILARG or off // BS >= 8:
                fail("the directory would need an indirect block")
            d["addr"][off // BS] = self.balloc()
        d["size"] = off + 16
        self.put_inode(dn, d)
        self.dir_set(dn, off, ino, name)


def cmd_mknod(fs, a):
    dn, name = fs.split(a.path)
    n = fs.ialloc()
    kind = IFBLK if a.kind == "b" else IFCHR
    fs.put_inode(n, {"mode": IALLOC | kind | int(a.mode, 8), "nlink": 1, "uid": 0, "gid": 0, "size": 0,
                     "addr": [(a.major << 8) | a.minor, 0, 0, 0, 0, 0, 0, 0]})
    fs.link(dn, name, n)
    print("v6fs: %s = inode %d, %s %d,%d mode %o" % (a.path, n, a.kind, a.major, a.minor, int(a.mode, 8)))


def cmd_ln(fs, a):
    n = fs.lookup(a.existing)
    if not n:
        fail("%s is not there" % a.existing)
    ino = fs.inode(n)
    if ino["mode"] & IFMT == IFDIR:
        fail("V6 links only files, not directories")
    dn, name = fs.split(a.new)
    fs.link(dn, name, n)
    ino["nlink"] += 1
    fs.put_inode(n, ino)
    print("v6fs: %s -> inode %d, now %d links" % (a.new, n, ino["nlink"]))


def cmd_rm(fs, a):
    dn, name = fs.split(a.path)
    for off, n, nm in fs.entries(dn):
        if n and nm == name:
            break
    else:
        fail("%s is not there" % a.path)
    ino = fs.inode(n)
    if ino["mode"] & IFMT == IFDIR:
        fail("rm removes files, not directories")
    fs.dir_set(dn, off, 0, name)
    ino["nlink"] -= 1
    if ino["nlink"] > 0:
        fs.put_inode(n, ino)
        print("v6fs: %s unlinked, inode %d keeps %d links" % (a.path, n, ino["nlink"]))
        return
    data, ind = fs.blocks(n)
    for b in [b for b in data if b] + ind:
        fs.bfree(b)
    fs.d[fs.ioff(n):fs.ioff(n) + 32] = bytes(32)
    if fs.ninode < 100:
        fs.inodes[fs.ninode] = n
        fs.ninode += 1
    print("v6fs: %s removed, inode %d and %d blocks freed" % (a.path, n, len([b for b in data if b]) + len(ind)))


def locate(fs, path, symbol):
    """Where the data word of a.out PATH's SYMBOL is: (image byte offset,
    the symbol's value, the word there now). rk_image.py --psram-patch
    uses this too."""
    n = fs.lookup(path)
    if not n:
        fail("%s is not there" % path)
    img = fs.read(n)
    magic, tsz, dsz, bsz, ssz, entry, unused, flag = struct.unpack_from("<8H", img, 0)
    if magic not in (0o407, 0o410, 0o411):
        fail("%s is not an a.out (magic %o)" % (path, magic))
    if ssz == 0:
        fail("%s has no symbol table" % path)
    so = 16 + tsz + dsz + (0 if flag else tsz + dsz)      # flag 1: no relocation bits
    val = None
    for i in range(so, so + ssz, 12):
        if img[i:i + 8].rstrip(b"\0").decode("latin-1") == symbol:
            typ, val = struct.unpack_from("<HH", img, i + 8)
            break
    if val is None:
        fail("%s has no symbol %s" % (path, symbol))
    if typ & 0o37 != 3:
        fail("%s is not a data symbol (type %o)" % (symbol, typ))
    if magic == 0o407:
        off = 16 + val
    elif magic == 0o410:
        off = 16 + tsz + val - ((tsz + 0o17777) & ~0o17777)
    else:
        off = 16 + tsz + val
    old = struct.unpack_from("<H", img, off)[0]
    bl, _ = fs.blocks(n)
    if off & 1:
        fail("%s %s is at an odd offset" % (path, symbol))
    return bl[off // BS] * BS + off % BS, val, old


def cmd_patch(fs, a):
    where, val, old = locate(fs, a.file, a.symbol)
    new = int(a.value, 0) & 0xFFFF
    b = where // BS
    blk = bytearray(fs.blk(b))
    struct.pack_into("<H", blk, where % BS, new)
    fs.put(b, blk)
    print("v6fs: %s %s at %06o: %d -> %d" % (a.file, a.symbol, val, old, new))


def cmd_check(fs):
    owner = {}
    problems = []
    links = {}
    stack = [1]
    seen = set()
    while stack:
        n = stack.pop()
        if n in seen:
            continue
        seen.add(n)
        for _, ino, name in fs.entries(n):
            if not ino:
                continue
            links[ino] = links.get(ino, 0) + 1
            if name not in (".", "..") and fs.inode(ino)["mode"] & IFMT == IFDIR:
                stack.append(ino)
    for n in range(1, fs.isize * 16 + 1):
        ino = fs.inode(n)
        if not ino["mode"] & IALLOC:
            continue
        data, ind = fs.blocks(n)
        for b in [b for b in data if b] + ind:
            if not fs.isize + 2 <= b < fs.fsize:
                problems.append("inode %d: block %d out of range" % (n, b))
            elif b in owner:
                problems.append("block %d in inodes %d and %d" % (b, owner[b], n))
            owner[b] = n
        if links.get(n, 0) != ino["nlink"]:
            problems.append("inode %d: %d links recorded, %d directory entries" % (n, ino["nlink"], links.get(n, 0)))
    free = set()
    lst, nfree = fs.free, fs.nfree
    while True:
        for b in lst[1:nfree]:
            free.add(b)
        nxt = lst[0] if nfree else 0
        if not nxt:
            break
        free.add(nxt)
        blk = fs.blk(nxt)
        nfree = struct.unpack_from("<H", blk, 0)[0]
        lst = list(struct.unpack_from("<100H", blk, 2))
    both = free & set(owner)
    missing = set(range(fs.isize + 2, fs.fsize)) - free - set(owner)
    if both:
        problems.append("%d blocks both free and in use, e.g. %s" % (len(both), sorted(both)[:5]))
    if missing:
        problems.append("%d blocks neither free nor in use, e.g. %s" % (len(missing), sorted(missing)[:5]))
    print("v6fs check: %d inodes in use, %d blocks in files, %d free, %d problems"
          % (len([1 for n in range(1, fs.isize * 16 + 1) if fs.inode(n)["mode"] & IALLOC]), len(owner), len(free), len(problems)))
    for p in problems[:20]:
        print("  " + p)
    return 1 if problems else 0


def main():
    ap = argparse.ArgumentParser(description="Read and change a V6 file system in an RK05 image.")
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("ls"); p.add_argument("image"); p.add_argument("path")
    p = sub.add_parser("cat"); p.add_argument("image"); p.add_argument("path")
    p = sub.add_parser("check"); p.add_argument("image")
    p = sub.add_parser("mknod"); p.add_argument("image"); p.add_argument("path"); p.add_argument("kind", choices=["b", "c"])
    p.add_argument("major", type=int); p.add_argument("minor", type=int); p.add_argument("--mode", default="640"); p.add_argument("-o", required=True)
    p = sub.add_parser("ln"); p.add_argument("image"); p.add_argument("existing"); p.add_argument("new"); p.add_argument("-o", required=True)
    p = sub.add_parser("rm"); p.add_argument("image"); p.add_argument("path"); p.add_argument("-o", required=True)
    p = sub.add_parser("patch"); p.add_argument("image"); p.add_argument("file"); p.add_argument("symbol")
    p.add_argument("value"); p.add_argument("-o", required=True)
    a = ap.parse_args()
    fs = Fs(a.image)
    if a.cmd == "ls":
        n = fs.lookup(a.path)
        if not n:
            fail("%s is not there" % a.path)
        names = [(nm, i) for _, i, nm in fs.entries(n) if i] if fs.inode(n)["mode"] & IFMT == IFDIR else [(a.path, n)]
        for nm, i in names:
            ino = fs.inode(i)
            t = {IFDIR: "d", IFCHR: "c", IFBLK: "b"}.get(ino["mode"] & IFMT, "-")
            extra = ("%d,%d" % (ino["addr"][0] >> 8, ino["addr"][0] & 255)) if t in "cb" else str(ino["size"])
            print("%s%04o %2d %5d %8s %s" % (t, ino["mode"] & 0o7777, ino["nlink"], i, extra, nm))
        return
    if a.cmd == "cat":
        n = fs.lookup(a.path)
        if not n:
            fail("%s is not there" % a.path)
        sys.stdout.buffer.write(fs.read(n))
        return
    if a.cmd == "check":
        sys.exit(cmd_check(fs))
    {"mknod": cmd_mknod, "ln": cmd_ln, "rm": cmd_rm, "patch": cmd_patch}[a.cmd](fs, a)
    fs.save_sb()
    open(a.o, "wb").write(fs.d)


if __name__ == "__main__":
    main()
