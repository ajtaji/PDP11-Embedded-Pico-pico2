#!/usr/bin/env python3
"""od2bin.py - turn what V6's `od FILE` typed at the console back into the file.

    python tools/od2bin.py TRANSCRIPT [TRANSCRIPT ...] -o FILE [--size BYTES] [--sum "N B"]

WHY. A file made ON a board (a kernel built there from the distribution's
sources, say) lives in the PSRAM copy of the pack and is gone at the next
reset: the PDP-11 never writes the flash. The console is the way out: a
session (tools/board_session.py) runs `od FILE`, this tool rebuilds the
bytes from the transcript, and tools/v6fs.py put writes them into a pack
image on the host.

WHAT IT READS. Lines of an octal offset and up to eight octal words, as V6's
od prints them; a line holding only `*` stands for lines equal to the one
before it, up to the next offset; the last line is the end offset alone.
Everything else in the transcript (prompts, other commands) is skipped. With
several transcripts, or several od commands in one (`od FILE 0 ; od FILE
+100.` and so on), every offset must be given exactly once or with the same
words: a gap or a disagreement is an error, not a guess.

CHECKS. --size is the length `ls -l` gave. --sum is what V6's `sum FILE`
printed on the board: the file's bytes, each sign-extended to 16 bits,
added into a 16-bit sum with the carry added back in, and the number of
512-byte reads (the distribution's /usr/source/s2/sum.s). The tool
prints both for the file it wrote and fails if either differs.
"""
import argparse
import re
import sys


def fail(msg):
    sys.exit("od2bin: " + msg)


def v6sum(data):
    s = 0
    for b in data:                   # /usr/source/s2/sum.s: movb (r2)+,r4 ; add r4,r5 ; adc r5
        s += b | (0xFF00 if b & 0x80 else 0)
        if s > 0xFFFF:
            s = (s + 1) & 0xFFFF
    return s, (len(data) + 511) // 512


def main():
    ap = argparse.ArgumentParser(description="Rebuild a file from V6 od output in a session transcript.")
    ap.add_argument("transcripts", nargs="+")
    ap.add_argument("-o", required=True)
    ap.add_argument("--size", type=int)
    ap.add_argument("--sum")
    a = ap.parse_args()
    words = {}                       # byte offset -> 16-bit word
    end = None
    line_re = re.compile(r"^([0-7]{7})((?: [0-7]{6}){1,8})\s*$")
    end_re = re.compile(r"^([0-7]{7})\s*$")
    for path in a.transcripts:
        last = None                  # (offset, words) of the last data line
        star = False
        for raw in open(path, "r", errors="replace"):
            line = raw.rstrip("\r\n")
            m = line_re.match(line)
            e = end_re.match(line)
            if line.strip() == "*" and last:
                star = True
                continue
            if not m and not e:
                continue
            off = int((m or e).group(1), 8)
            if star and last:
                o = last[0] + 16
                while o < off:
                    for k, w in enumerate(last[1]):
                        if words.setdefault(o + 2 * k, w) != w:
                            fail("%s: offset %o is given twice with different words" % (path, o + 2 * k))
                    o += 16
                star = False
            if e and not m:
                end = max(end or 0, off)
                last = None
                continue
            ws = [int(x, 8) for x in m.group(2).split()]
            for k, w in enumerate(ws):
                if words.setdefault(off + 2 * k, w) != w:
                    fail("%s: offset %o is given twice with different words" % (path, off + 2 * k))
            last = (off, ws) if len(ws) == 8 else None
    if not words:
        fail("no od lines found in %s" % ", ".join(a.transcripts))
    size = a.size if a.size is not None else end
    if size is None:
        fail("no end offset in the transcripts; give --size (the length ls -l printed)")
    out = bytearray()
    for o in range(0, size, 2):
        if o not in words:
            fail("offset %o (byte %d) is not in the transcripts: a part of the od output is missing" % (o, o))
        out += bytes((words[o] & 255, words[o] >> 8))
    out = bytes(out[:size])
    s, b = v6sum(out)
    print("od2bin: %s: %d bytes, sum %d %d" % (a.o, len(out), s, b))
    if a.sum is not None and a.sum.split() != [str(s), str(b)]:
        fail("the board's sum was '%s': the file is NOT the board's. Nothing written." % a.sum)
    open(a.o, "wb").write(out)


if __name__ == "__main__":
    main()
