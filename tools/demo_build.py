#!/usr/bin/env python3
"""
demo_build.py - build the PDP-11 demo firmware for a Pico 2 W in the LAFVIN ST7796 kit.

    python tools/demo_build.py [--compiler EXE] [--lda demo/demo.lda] [--out DIR] [--port COMnn]
                               [--speaker AA:BB:CC:DD:EE:FF]

The firmware is the emulator's own (J11_18MHz_KDJ11_BF/pico2/diag.pico2) with the demo's display
and tone generator in it (pico2/demo_dev.pico2: the registers at 164000, the frame interrupt at
320, the picture on the kit's 320 x 480 panel) and the demo built in as its tape, so the board
starts the demo by itself at power-up. The Unix firmware is not touched: like psram_build.py this
writes copies beside diag.pico2 and removes them afterwards, and the source's #DEMO_DEV = 0 keeps
cpu.pico2's hooks out of every other build.

WHAT IT DOES
    1. tools/tape2pico.py makes a tape image of the .lda (the demo: demo/demo.lda), into a copy
       (tape_image_demo.pico2), not into tape_image.pico2.
    2. A copy of diag.pico2 with #DEMO_DEV = 1, #SRAM_MEM_KB = 64 (the demo runs with memory
       management off in the 56 KB below the I/O page; the rest of the SRAM is free for the panel's
       strips), the SPI and ST7796 libraries and demo_dev.pico2 included, and the demo's tape
       instead of the empty one.
    3. Compiles it for the RP2350 (-t rp2350): DIR/demo_firmware.uf2 and .bin; with --port the
       compiler's own uploader puts it on the board.

SOUND. With --speaker (a Bluetooth speaker's address, as a phone shows it) the build has #DEMO_AUDIO = 1:
the radio and Bluetooth libraries (Shared/Bluetooth/bt_audio.pmi, A2DP + SBC, as Ms. Pac-Man uses them),
and the speaker's address in the build's copy only - never in the repository. Without it the demo plays
silent. The speaker's link key is kept in the flash's last sector (as the other Pico emulators keep it).

OUTPUT (in --out, default build_demo/ at the repository root)
    demo_firmware.uf2   for the board's boot drive (or the IDE)
    demo_firmware.bin   the flat image
"""
import argparse, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
EDITS = [("#DEMO_DEV = 0 ", "#DEMO_DEV = 1 "),
         ("#SRAM_MEM_KB = 152 ", "#SRAM_MEM_KB = 64 "),
         ('XIncludeFile "tape_image.pico2"', 'XIncludeFile "tape_image_demo.pico2"'),
         ('XIncludeFile "rk11.pico2"', 'XIncludeFile "rk11.pico2"\n'
                                      'XIncludeFile "RP2350/Lib/spi.pico2"       ; the demo build: the panel (demo_dev.pico2)\n'
                                      'XIncludeFile "RP2350/Lib/st7796.pico2"\n'
                                      'XIncludeFile "demo_dev.pico2"')]


def run(cmd, **kw):
    print("demo_build: " + " ".join(cmd))
    r = subprocess.run(cmd, **kw)
    if r.returncode != 0:
        sys.exit("demo_build: that step failed (exit %d); nothing past it was built." % r.returncode)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--compiler", default="PureMetalForge.exe")
    ap.add_argument("--lda", default=os.path.join(REPO, "demo", "demo.lda"))
    ap.add_argument("--out")
    ap.add_argument("--port", help="upload through the compiler's uploader to the board on this port")
    ap.add_argument("--keep", action="store_true",
                    help="leave diag_demo.pico2 and its copies beside diag.pico2 (the compiler's message on a failed "
                         "build shows only when it is run by hand on them)")
    ap.add_argument("--speaker", help="a Bluetooth speaker's address, AA:BB:CC:DD:EE:FF: the demo's sound goes there")
    a = ap.parse_args()
    out = os.path.abspath(a.out or os.path.join(REPO, "build_demo"))
    os.makedirs(out, exist_ok=True)

    tape = os.path.join(SRC, "tape_image_demo.pico2")
    tmp = os.path.join(SRC, "diag_demo.pico2")
    tmp_ins = os.path.join(SRC, "instructions_demo.pico2")
    try:
        run([sys.executable, os.path.join(HERE, "tape2pico.py"), a.lda, "--name", "demo", "-o", tape])
        text = open(os.path.join(SRC, "diag.pico2"), "rb").read().decode("utf-8")
        for old, new in EDITS:
            if text.count(old) != 1:
                sys.exit("demo_build: diag.pico2 does not hold exactly one '%s' - it has moved; "
                         "update EDITS here to match." % old.strip())
            text = text.replace(old, new)
        audio = 0
        if a.speaker:
            parts = a.speaker.split(":")
            if len(parts) != 6 or not all(len(x) == 2 for x in parts):
                sys.exit("demo_build: --speaker wants six two-digit hex numbers, AA:BB:CC:DD:EE:FF")
            audio = 1
            text = text.replace('XIncludeFile "demo_dev.pico2"', "\n".join([
                'XIncludeFile "RP2350/Lib/cyw43_nvram.pico2" ; the demo build with sound: the radio and Bluetooth',
                'XIncludeFile "RP2350/Lib/bits.pico2"',
                'XIncludeFile "RP2350/Lib/wiring.pico2"',
                'XIncludeFile "RP2350/Lib/string_out.pico2"',
                'XIncludeFile "RP2350/Lib/cyw43.pico2"',
                'XIncludeFile "RP2350/Lib/cyw43_btfw.pico2"',
                'XIncludeFile "RP2350/Lib/bluetooth.pico2"',
                'XIncludeFile "Shared/Bluetooth/sbc.pmi"',
                'XIncludeFile "Shared/Bluetooth/bt_audio.pmi"',
                'XIncludeFile "demo_dev.pico2"']))
            text += "\n".join(["", "DataSection", "DdSpeaker:",
                               "  Data.a " + ", ".join("$" + x.upper() for x in parts),
                               "EndDataSection", ""])
        text = text.replace("#DEMO_DEV = 1 ", "#DEMO_AUDIO = %d\n#DEMO_DEV = 1 " % audio, 1)
        # The unmapped run loop (CpuRun: the demo runs with memory management off) from SRAM, as
        # psram_build.py does for the PSRAM boards: from flash it shares the 16 KB XIP cache with
        # core 1's panel code, and the two evict each other (420,000 instructions/s, 2026-10-24).
        inc = 'XIncludeFile "instructions.pico2"'
        head = "\nProcedure.i CpuRun(n.i)\n"
        ins = open(os.path.join(SRC, "instructions.pico2"), "rb").read().decode("utf-8").replace("\r\n", "\n")
        if text.count(inc) != 1 or ins.count(head) != 1:
            sys.exit("demo_build: diag.pico2's include of instructions.pico2, or CpuRun's first line, "
                     "has moved; update demo_build.py to match.")
        text = text.replace(inc, 'XIncludeFile "instructions_demo.pico2"')
        open(tmp_ins, "wb").write(ins.replace(head, "\nProcedureRAM.i CpuRun(n.i)\n").encode("utf-8"))
        open(tmp, "wb").write(text.encode("utf-8"))
        uf2 = os.path.join(out, "demo_firmware.uf2")
        cmd = [a.compiler, "--compile", tmp, "-t", "rp2350", "-o", uf2]
        if a.port:
            cmd += ["--port", a.port]
        run(cmd, cwd=SRC)
        run([a.compiler, "--compile", tmp, "-t", "rp2350", "-o", os.path.join(out, "demo_firmware.bin")], cwd=SRC)
    finally:
        for f in (tmp, tape, tmp_ins):
            if os.path.exists(f) and not a.keep:
                os.remove(f)
    print("demo_build: done - %s" % os.path.join(out, "demo_firmware.uf2"))


if __name__ == "__main__":
    main()
