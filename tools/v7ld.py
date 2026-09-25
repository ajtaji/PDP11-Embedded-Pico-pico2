#!/usr/bin/env python3
"""v7ld.py - a PDP-11 Seventh Edition Unix link editor, enough to link a
V7 kernel from the objects and libraries on the V7 distribution tape
(/usr/sys/conf/*.o, /usr/sys/sys/LIB1, /usr/sys/dev/LIB2), as the tape's
own /usr/sys/conf/makefile does:

    ld -o unix -X -i l.o mch.o c.o ../sys/LIB1 ../dev/LIB2

USE
    python v7ld.py [-i] [-s] -o OUT file.o ... LIB ...
        -i   separate instruction and data space: magic 0411, data
             starts at 0 in its own space (what a V7 kernel is)
        -s   leave the symbol table out (the default keeps it: ps and
             friends read /unix's namelist)
    python v7ld.py --check OUT REF
        compares a link with a reference image built from the same
        library members (a kernel on the tape): every word of a library
        routine present in both must agree, allowing only for where each
        routine landed.

THE FORMATS (V7 a.out(5), ar(5), the tape's /usr/include/a.out.h and
ar.h; long = two 16-bit words, high word first):
    a.out header  8 words: magic (0407; 0410 read-only text; 0411
                  separate I/D), text, data, bss, syms, entry, unused,
                  flag (1 = no relocation)
    then          text, data, relocation for text, for data (one word per
                  word: bit 0 PC-relative, bits 3-1 00 absolute, 02 text,
                  04 data, 06 bss, 10 external with the symbol number in
                  bits 15-4), symbols (12 bytes: name[8], type, value;
                  type 0 undefined, 1 absolute, 2 text, 3 data, 4 bss,
                  037 file name, +040 external). An undefined external
                  with a value is a COMMON block of that many bytes.
    ar            magic 0177545, then members: name[14], date (long),
                  uid, gid (bytes), mode (word), size (long), contents
                  padded to an even length.

In an 0407 object, data sits after text and bss after data, and symbol
values count from the start of text; the relocation moves each segment to
where the output puts it. Libraries are searched the way V7 ld does it -
a member is loaded if it defines a symbol still undefined, and the
library is scanned again until a pass loads nothing. _etext, _edata and
_end are defined by the linker.
"""
import argparse
import struct
import sys

N_UNDF, N_ABS, N_TEXT, N_DATA, N_BSS, N_FN, N_EXT = 0, 1, 2, 3, 4, 0o37, 0o40


def fail(msg):
    sys.stderr.write("v7ld: " + msg + "\n")
    sys.exit(1)


def plong(b, o):
    hi, lo = struct.unpack_from("<HH", b, o)
    return (hi << 16) | lo


class Obj:
    def __init__(self, name, b):
        self.name = name
        (self.magic, self.tsize, self.dsize, self.bsize, ssize, self.entry,
         _u, self.flag) = struct.unpack_from("<8H", b, 0)
        if self.magic != 0o407:
            fail("%s is not a relocatable object (magic %o)." % (name, self.magic))
        if self.flag:
            fail("%s has no relocation information; it cannot be linked." % name)
        o = 16
        self.text = bytearray(b[o:o + self.tsize]); o += self.tsize
        self.data = bytearray(b[o:o + self.dsize]); o += self.dsize
        self.trel = b[o:o + self.tsize]; o += self.tsize
        self.drel = b[o:o + self.dsize]; o += self.dsize
        self.syms = []
        for k in range(ssize // 12):
            n, ty, v = struct.unpack_from("<8sHH", b, o + 12 * k)
            self.syms.append((n.split(b"\0")[0].decode("latin-1"), ty, v))

    def defines(self):
        return {n for n, ty, v in self.syms if ty & N_EXT and (ty & 0o37) != N_UNDF}

    def undefs(self):
        return {n for n, ty, v in self.syms if ty == N_EXT | N_UNDF and v == 0}


def archive(name, b):
    if struct.unpack_from("<H", b, 0)[0] != 0o177545:
        fail("%s is not a V7 archive." % name)
    o = 2
    out = []
    while o + 26 <= len(b):
        mname = b[o:o + 14].split(b"\0")[0].decode("latin-1")
        size = plong(b, o + 22)
        out.append(Obj("%s(%s)" % (name, mname), b[o + 26:o + 26 + size]))
        o += 26 + size + (size & 1)
    return out


def link(files, sep):
    loaded = []
    defined = set()
    undef = set()

    def load(ob):
        loaded.append(ob)
        defined.update(ob.defines())
        undef.update(ob.undefs())
        undef.difference_update(defined)

    for name, b in files:
        if struct.unpack_from("<H", b, 0)[0] == 0o177545:
            members = archive(name, b)
            while True:
                n = 0
                for m in members:
                    if m in loaded:
                        continue
                    if m.defines() & undef:
                        load(m)
                        n += 1
                if n == 0:
                    break
        else:
            load(Obj(name, b))
    # the layout: all text, then all data, then all bss, then commons
    tpos = dpos = 0
    for ob in loaded:
        ob.tbase = tpos
        tpos += ob.tsize
    tsize = tpos
    dbase0 = 0 if sep else tsize
    for ob in loaded:
        ob.dbase = dbase0 + dpos
        dpos += ob.dsize
    dsize = dpos
    bpos = dbase0 + dsize
    for ob in loaded:
        ob.bbase = bpos
        bpos += ob.bsize
    # global symbols
    gsym = {}
    commons = {}
    for ob in loaded:
        for n, ty, v in ob.syms:
            if not ty & N_EXT:
                continue
            t = ty & 0o37
            if t == N_UNDF:
                if v:
                    commons[n] = max(commons.get(n, 0), v)
                continue
            if n in gsym:
                fail("%s is defined twice (%s and an earlier file)." % (n, ob.name))
            gsym[n] = (t, reloc_value(ob, t, v))
    for n in sorted(commons):
        if n in gsym:
            continue
        sz = (commons[n] + 1) & ~1
        gsym[n] = (N_BSS, bpos)
        bpos += sz
    bsize = bpos - dbase0 - dsize
    gsym.setdefault("_etext", (N_TEXT, tsize))
    gsym.setdefault("_edata", (N_DATA, dbase0 + dsize))
    gsym.setdefault("_end", (N_BSS, bpos))
    missing = sorted(n for ob in loaded for n in ob.undefs() if n not in gsym)
    if missing:
        fail("undefined: " + ", ".join(sorted(set(missing))))
    text = bytearray()
    data = bytearray()
    for ob in loaded:
        text += relocate(ob, ob.text, ob.trel, ob.tbase, gsym, 0)
    for ob in loaded:
        data += relocate(ob, ob.data, ob.drel, ob.dbase, gsym, ob.tsize)
    return loaded, gsym, text, data, bsize


def reloc_value(ob, t, v):
    if t == N_TEXT:
        return v + ob.tbase
    if t == N_DATA:
        return v - ob.tsize + ob.dbase
    if t == N_BSS:
        return v - ob.tsize - ob.dsize + ob.bbase
    return v


def relocate(ob, seg, rel, newbase, gsym, oldbase):
    out = bytearray(seg)
    names = [n for n, ty, v in ob.syms]
    for k in range(0, len(seg), 2):
        r, = struct.unpack_from("<H", rel, k)
        if r == 0:
            continue
        w, = struct.unpack_from("<H", seg, k)
        kind = r & 0o16
        if kind == 0o02:
            w += ob.tbase
        elif kind == 0o04:
            w += ob.dbase - ob.tsize
        elif kind == 0o06:
            w += ob.bbase - ob.tsize - ob.dsize
        elif kind == 0o10:
            n = names[r >> 4]
            w += gsym[n][1]
        elif kind != 0:
            fail("%s: relocation word %o at %o is not one V7 writes." % (ob.name, r, k))
        if r & 1:                             # PC-relative: the word itself moved
            w -= newbase - oldbase
        struct.pack_into("<H", out, k, w & 0xFFFF)
    return out


def write(path, sep, loaded, gsym, text, data, bsize, keepsyms, entry=0):
    syms = bytearray()
    if keepsyms:
        for n in sorted(gsym, key=lambda n: (gsym[n][1], n)):
            t, v = gsym[n]
            syms += struct.pack("<8sHH", n.encode("latin-1")[:8], N_EXT | t, v & 0xFFFF)
    hdr = struct.pack("<8H", 0o411 if sep else 0o407, len(text), len(data), bsize, len(syms), entry, 0, 1)
    open(path, "wb").write(hdr + text + data + syms)


def read_aout(b):
    magic, t, d, bss, ns, entry, u, flag = struct.unpack_from("<8H", b, 0)
    o = 16 + t + d + (0 if flag else t + d)
    syms = {}
    for k in range(ns // 12):
        n, ty, v = struct.unpack_from("<8sHH", b, o + 12 * k)
        syms[n.split(b"\0")[0].decode("latin-1")] = (ty, v)
    return magic, b[16:16 + t], b[16 + t:16 + t + d], syms


def check(out, ref, files):
    """Compare every library routine's text present in both images."""
    m1, t1, d1, s1 = read_aout(open(out, "rb").read())
    m2, t2, d2, s2 = read_aout(open(ref, "rb").read())
    loaded, gsym, text, data, bsize = link(files, True)
    same = diff = 0
    for ob in loaded:
        if "(" not in ob.name:
            continue                       # l.o, mch.o, c.o differ by configuration
        tsyms = [(v, n) for n, ty, v in ob.syms if ty == N_EXT | N_TEXT]
        if not tsyms:
            continue
        v0, n0 = min(tsyms)
        if n0 not in s2 or (s2[n0][0] & 0o37) != N_TEXT:
            continue
        a1 = ob.tbase
        a2 = s2[n0][1] - v0
        for k in range(0, ob.tsize, 2):
            r, = struct.unpack_from("<H", ob.trel, k)
            w1, = struct.unpack_from("<H", t1, a1 + k)
            w2, = struct.unpack_from("<H", t2, a2 + k)
            kind = r & 0o16
            if kind == 0:
                ok = (w1 == w2) if not r & 1 else True
            elif kind == 0o10:
                n = [x for x, ty, v in ob.syms][r >> 4]
                if n not in s2:
                    continue
                if r & 1:
                    ok = (w1 + a1 + k - gsym[n][1]) & 0xFFFF == (w2 + a2 + k - s2[n][1]) & 0xFFFF
                else:
                    ok = (w1 - gsym[n][1]) & 0xFFFF == (w2 - s2[n][1]) & 0xFFFF
            elif kind == 0o02:                 # PC-relative within its own text: unchanged
                ok = (w1 == w2) if r & 1 else (w1 - a1) & 0xFFFF == (w2 - a2) & 0xFFFF
            else:
                continue                   # data/bss offsets depend on the whole layout
            same += ok
            diff += not ok
            if not ok and diff <= 10:
                print("  %s +%o: link %06o, reference %06o (reloc %o)" % (ob.name, k, w1, w2, r))
    print("v7ld --check: %d words agree, %d differ" % (same, diff))
    return diff == 0


def main():
    ap = argparse.ArgumentParser(description="A V7 PDP-11 link editor.")
    ap.add_argument("files", nargs="*")
    ap.add_argument("-o")
    ap.add_argument("-i", action="store_true")
    ap.add_argument("-s", action="store_true")
    ap.add_argument("--check", nargs=2, metavar=("OUT", "REF"))
    a = ap.parse_args()
    files = [(f, open(f, "rb").read()) for f in a.files]
    if a.check:
        sys.exit(0 if check(a.check[0], a.check[1], files) else 1)
    if not a.o:
        fail("give -o OUT.")
    loaded, gsym, text, data, bsize = link(files, a.i)
    write(a.o, a.i, loaded, gsym, text, data, bsize, not a.s)
    print("v7ld: %s: %s, text %d, data %d, bss %d, %d modules" % (
        a.o, "0411" if a.i else "0407", len(text), len(data), bsize, len(loaded)))


if __name__ == "__main__":
    main()
