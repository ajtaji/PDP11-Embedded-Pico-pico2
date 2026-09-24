#!/usr/bin/env python3
"""tape2pico.py - turn a PDP-11 absolute-format paper tape into a PureMetal
include that the J-11 emulator's diagnostic firmware copies into memory at
boot. No tape reader is emulated: this does, on the host, the job DEC's
Absolute Loader does on the machine.

USE
    python tape2pico.py <tape> [--start OCTAL] [--switches OCTAL]
                               [--name TEXT] [-o FILE ...]

    <tape>       a raw tape image (.bin / .ptap: the punched bytes), or a
                 PCjs tape (.json: {"exec": ..., "words": [...]}, the same
                 bytes packed two to a word, low byte first).
    --start      the address to start at, in octal. Default: the tape's own
                 transfer address (its last block); when that is odd (the
                 "halt, do not start" marker every MAINDEC tape ends with),
                 a PCjs file's "exec"; otherwise it must be given. The
                 start is in the diagnostic's listing: usually 000200, and
                 000214 for T14 on 28K words.
    --switches   the value the console switch register (177570) reads, in
                 octal. Default 0: run everything, no halts on error.
    --name       the name printed by the firmware. Default: the file name.
    --patch      ADDR=WORD[,ADDR=WORD...], octal: words to change after the
                 tape is loaded. Only for a subtest written for another
                 PDP-11 model, where the J-11 is right and the listing
                 expects that model (MFPT trapping on an 11/34, say). Each
                 patch is listed in the include's header, so a build says
                 what it changed.
    -o           where to write the include. Default: both
                 ../J11_18MHz_KDJ11_BF/pico/tape_image.pico and
                 ../J11_18MHz_KDJ11_BF/pico2/tape_image.pico2, beside this
                 tool. Then build diag.pico / diag.pico2 in those folders.

THE TAPE FORMAT (DEC-11-UABLB-A-LA, the Absolute Loader listing)
    Any number of zero bytes, then blocks:
        001 000            signature (a 1 byte, then a 0 byte)
        lo hi              byte count N + 6 (the header is counted)
        lo hi              load address
        N data bytes
        1 checksum byte    the 8-bit sum of every byte of the block,
                           checksum included, is zero
    A block with N = 0 ends the tape; its address is the transfer address
    (odd = do not start). A bad checksum is an error here: the real loader
    halts on one too.

THE OUTPUT
    #TAPE_START      the start address
    #TAPE_SWITCHES   the switch register value
    DataSection
      TapeName:      the name, one character per Data.u, 0 at the end
      TapeRuns:      address, word count, the words; ... ; then $FFFF
    EndDataSection
    Bytes are gathered into words first, so a block with an odd address or
    an odd length loads exactly as the real loader would: the byte it does
    not name keeps the value it had, and memory is zero at boot.
"""
import argparse
import json
import os
import re
import sys

RAM_BYTES = 0o160000   # the emulator's RAM: 000000-157777


def fail(msg):
    sys.stderr.write("tape2pico: " + msg + "\n")
    sys.exit(1)


def read_tape_bytes(path):
    """Return (the tape's bytes, PCjs's exec address or None)."""
    raw = open(path, "rb").read()
    if path.lower().endswith(".json"):
        text = raw.decode("ascii", "replace")
        # PCjs writes hex literals (0x1234), which JSON does not allow.
        text = re.sub(r"0x([0-9A-Fa-f]+)", lambda m: str(int(m.group(1), 16)), text)
        try:
            obj = json.loads(text)
        except ValueError as e:
            fail("%s is not a PCjs tape the tool can read (%s). Check that it is "
                 "a {\"exec\": ..., \"words\": [...]} file." % (path, e))
        words = obj.get("words")
        if not isinstance(words, list):
            fail("%s has no \"words\" list, so it is not a PCjs tape. Check the file." % path)
        data = bytearray()
        for w in words:
            data.append(w & 0xFF)
            data.append((w >> 8) & 0xFF)
        return bytes(data), obj.get("exec")
    return raw, None


def parse_absolute(data, path):
    """Return (dict byte address -> value, transfer address, block count)."""
    mem = {}
    pos = 0
    blocks = 0
    n = len(data)
    while True:
        while pos < n and data[pos] == 0:
            pos += 1
        if pos >= n:
            if blocks == 0:
                fail("%s holds no absolute-format block at all. Check that it is "
                     "an absolute-format tape (it must start with zeros, then 001 000)." % path)
            fail("%s ended after %d blocks without the end block (a block with no "
                 "data bytes). The tape image is cut short; check the download." % (path, blocks))
        if pos + 6 > n or data[pos] != 1 or data[pos + 1] != 0:
            fail("%s: byte %d should start a block (001 000) but holds %03o %03o, after "
                 "%d good blocks. The image is damaged or not an absolute-format tape."
                 % (path, pos, data[pos], data[pos + 1] if pos + 1 < n else 0, blocks))
        count = data[pos + 2] | (data[pos + 3] << 8)
        addr = data[pos + 4] | (data[pos + 5] << 8)
        if count < 6 or pos + count + 1 > n:
            fail("%s: block %d at byte %d claims %d bytes, which does not fit the "
                 "tape. The image is damaged." % (path, blocks + 1, pos, count))
        block = data[pos:pos + count + 1]
        if sum(block) & 0xFF:
            fail("%s: block %d at byte %d (load address %06o) has a bad checksum "
                 "(sum %03o, should be 0). The real loader halts here too; the "
                 "image is damaged." % (path, blocks + 1, pos, addr, sum(block) & 0xFF))
        blocks += 1
        if count == 6:
            return mem, addr, blocks
        for i in range(count - 6):
            a = (addr + i) & 0xFFFF
            if a >= RAM_BYTES:
                fail("%s: block %d loads byte %06o, outside the emulator's RAM "
                     "(000000-157777). This tape needs more memory than the "
                     "emulator models." % (path, blocks, a))
            mem[a] = block[6 + i]
        pos += count + 1


def word_runs(mem):
    """Group the loaded bytes into runs of consecutive words."""
    words = {}
    for a, v in mem.items():
        w = words.get(a & ~1, 0)
        if a & 1:
            w = (w & 0x00FF) | (v << 8)
        else:
            w = (w & 0xFF00) | v
        words[a & ~1] = w
    runs = []
    for a in sorted(words):
        if runs and runs[-1][0] + 2 * len(runs[-1][1]) == a:
            runs[-1][1].append(words[a])
        else:
            runs.append((a, [words[a]]))
    return runs


def render(name, source, start, switches, runs, ext, patches=()):
    total = sum(len(r[1]) for r in runs)
    out = []
    out.append("; " + "=" * 70)
    out.append(";  tape_image%s - GENERATED by PureMetal/tools/tape2pico.py. Do not edit;" % ext)
    out.append(";  run the tool again. Not committed: it holds the diagnostic itself.")
    out.append(";  Tape:   %s" % os.path.basename(source))
    out.append(";  Loads:  %d words in %d runs; starts at %06o; switches %06o"
               % (total, len(runs), start, switches))
    for pa, pw in patches:
        out.append(";  PATCHED: %06o = %06o" % (pa, pw))
    out.append("; " + "=" * 70)
    out.append("#TAPE_START = $%04X          ; %06o" % (start, start))
    out.append("#TAPE_SWITCHES = $%04X       ; %06o" % (switches, switches))
    out.append("")
    out.append("DataSection")
    out.append("TapeName:")
    chars = [ord(c) for c in name if 32 <= ord(c) < 127] + [0]
    for i in range(0, len(chars), 16):
        out.append("  Data.u " + ", ".join(str(c) for c in chars[i:i + 16]))
    out.append("TapeRuns:")
    for a, ws in runs:
        out.append("  Data.u $%04X, %d            ; %06o" % (a, len(ws), a))
        for i in range(0, len(ws), 8):
            out.append("  Data.u " + ", ".join("$%04X" % w for w in ws[i:i + 8]))
    out.append("  Data.u $FFFF                ; end (an odd run address)")
    out.append("EndDataSection")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description="Absolute-format PDP-11 tape to a PureMetal include.")
    ap.add_argument("tape")
    ap.add_argument("--start", help="start address, octal (default: the tape's transfer address)")
    ap.add_argument("--switches", default="0", help="switch register 177570, octal (default 0)")
    ap.add_argument("--name", help="name the firmware prints (default: the file name)")
    ap.add_argument("--patch", default="", help="ADDR=WORD[,ADDR=WORD...] octal words to change after loading")
    ap.add_argument("-o", action="append", dest="outs", help="output file (repeatable)")
    a = ap.parse_args()

    data, pcjs_exec = read_tape_bytes(a.tape)
    mem, transfer, blocks = parse_absolute(data, a.tape)
    if a.start is not None:
        start = int(a.start, 8)
    elif transfer & 1 and pcjs_exec is not None and not pcjs_exec & 1:
        # Every MAINDEC tape here ends "do not start" (000001); PCjs records
        # the documented start beside the words, so that is used.
        start = pcjs_exec
        sys.stderr.write("tape2pico: note: the tape says do not start (%06o); using the "
                         "PCjs start address %06o. Pass --start to choose another.\n"
                         % (transfer, pcjs_exec))
    else:
        start = transfer
    if start & 1:
        fail("the tape's transfer address is %06o, odd: the tape says do not start. "
             "Pass --start with the start address from the diagnostic's listing." % start)
    if start >= RAM_BYTES:
        fail("start address %06o is outside RAM (000000-157777). Check --start." % start)
    switches = int(a.switches, 8) & 0xFFFF
    name = a.name or os.path.splitext(os.path.basename(a.tape))[0]
    patches = []
    for item in [x for x in a.patch.split(",") if x.strip()]:
        try:
            pa, pw = [int(v, 8) for v in item.split("=")]
        except ValueError:
            fail("--patch %r is not ADDR=WORD in octal. Write it like 2236=210." % item)
        if pa & 1 or pa >= RAM_BYTES:
            fail("--patch address %06o is odd or outside RAM. Check the listing address." % pa)
        mem[pa] = pw & 0xFF
        mem[pa + 1] = (pw >> 8) & 0xFF
        patches.append((pa, pw & 0xFFFF))
    runs = word_runs(mem)

    outs = a.outs
    if not outs:
        here = os.path.dirname(os.path.abspath(__file__))
        base = os.path.join(here, "..", "J11_18MHz_KDJ11_BF")
        outs = [os.path.join(base, "pico", "tape_image.pico"),
                os.path.join(base, "pico2", "tape_image.pico2")]
    for o in outs:
        ext = os.path.splitext(o)[1] or ".pico"
        with open(o, "w", newline="\n") as f:
            f.write(render(name, a.tape, start, switches, runs, ext, patches))
    print("tape2pico: %s: %d blocks, %d bytes in %d word runs, start %06o, switches %06o -> %s"
          % (name, blocks, len(mem), len(runs), start, switches, ", ".join(outs)))


if __name__ == "__main__":
    main()
