#!/usr/bin/env python3
"""xxdp_extract.py - list an XXDP+ disk image's directory and take files out
of it, so that a diagnostic kept on the XXDP pack can be sent to the J-11
emulator as a tape (tools/tape_ladder.py reads the absolute-loader format,
which is what an XXDP .BIN or .BIC file holds).

USE
    python xxdp_extract.py IMAGE                     the directory
    python xxdp_extract.py IMAGE NAME.EXT [...] -o DIR
                 writes each named file into DIR (lower-case names), checks
                 that it parses as an absolute-loader tape, and prints its
                 blocks, bytes, load range, transfer address and SHA-256

  IMAGE may be gzipped (media/diagnostics/xxdp-plus-du.dsk.gz).

THE FORMAT (read from the image itself, and it agrees with the XXDP+ file
structure as the DOS-11 family uses it; 512-byte blocks, 16-bit words low
byte first):
    block 1      the master directory: word 0 = its second block
    second block word 2 = the first block of the user file directory
    a directory block: word 0 = the next directory block (0 = the last),
                 then 28 entries of 9 words:
                    0-1  the name, RADIX-50, six characters
                    2    the extension, RADIX-50
                    3    the date
                    4    (not used here)
                    5    the file's first block
                    6    its length in blocks
                    7    its last block
                    8    (not used here)
                 an entry whose first word is 0 is empty
    a file block: word 0 = the file's next block (0 = the last), then 510
                 bytes of the file
The tool follows the links, and refuses a file whose chain does not have
the directory's length or does not end at the directory's last block.
"""
import argparse
import gzip
import hashlib
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tape2pico  # noqa: E402

R50 = " ABCDEFGHIJKLMNOPQRSTUVWXYZ$.%0123456789"
BLOCK = 512


def fail(msg):
    sys.stderr.write("xxdp_extract: " + msg + "\n")
    sys.exit(1)


def r50(w):
    return R50[(w // 1600) % 40] + R50[(w // 40) % 40] + R50[w % 40]


class Image:
    def __init__(self, path):
        raw = open(path, "rb").read()
        self.data = gzip.decompress(raw) if raw[:2] == b"\x1f\x8b" else raw
        self.blocks = len(self.data) // BLOCK
        if self.blocks < 8:
            fail("%s is too small to be an XXDP+ disk image." % path)

    def words(self, n):
        if not 0 <= n < self.blocks:
            fail("block %d is outside the image (%d blocks): this is not an XXDP+ image, or it is damaged." % (n, self.blocks))
        return struct.unpack("<256H", self.data[n * BLOCK:(n + 1) * BLOCK])

    def directory(self):
        """[(name, first block, length, last block)] in directory order."""
        mfd2 = self.words(1)[0]
        ufd = self.words(mfd2)[2]
        out, seen = [], set()
        while ufd:
            if ufd in seen:
                fail("the directory's block chain loops at block %d." % ufd)
            seen.add(ufd)
            w = self.words(ufd)
            for i in range(1, 1 + 28 * 9, 9):
                e = w[i:i + 9]
                if e[0] == 0:
                    continue
                name = (r50(e[0]) + r50(e[1])).strip() + "." + r50(e[2]).strip()
                out.append((name, e[5], e[6], e[7]))
            ufd = w[0]
        if not out:
            fail("no directory entries found: this is not an XXDP+ image.")
        return out

    def file(self, entry):
        name, first, length, last = entry
        out, b, n, prev = bytearray(), first, 0, 0
        while b:
            n += 1
            if n > length:
                fail("%s: its block chain is longer than the directory's %d blocks." % (name, length))
            out += self.data[b * BLOCK + 2:(b + 1) * BLOCK]
            prev, b = b, self.words(b)[0]
        if n != length or prev != last:
            fail("%s: chain of %d blocks ending at %d; the directory says %d blocks ending at %d." % (name, n, prev, length, last))
        return bytes(out)


def main():
    ap = argparse.ArgumentParser(description="List or extract files of an XXDP+ disk image.")
    ap.add_argument("image")
    ap.add_argument("names", nargs="*")
    ap.add_argument("-o", "--out", default=".")
    a = ap.parse_args()
    img = Image(a.image)
    d = img.directory()
    if not a.names:
        for name, first, length, last in d:
            print("%-12s %4d blocks at %d" % (name, length, first))
        print("%d files" % len(d))
        return
    by = {e[0]: e for e in d}
    os.makedirs(a.out, exist_ok=True)
    for want in a.names:
        e = by.get(want.upper())
        if e is None:
            fail("%s is not in the directory (names are NAME.EXT as the listing prints them)." % want)
        data = img.file(e)
        path = os.path.join(a.out, e[0].lower())
        open(path, "wb").write(data)
        line = "%-12s %3d blocks, %6d bytes, sha256 %s" % (e[0], e[2], len(data), hashlib.sha256(data).hexdigest())
        ext = e[0].split(".")[1]
        if ext in ("BIN", "BIC"):
            mem, transfer, blocks = tape2pico.parse_absolute(data, path)
            lo, hi = min(mem), max(mem)
            line += "; tape: %d blocks, loads %06o-%06o, transfer %s" % (
                blocks, lo, hi, "none" if transfer is None else "%06o" % transfer)
        print(line)


if __name__ == "__main__":
    main()
