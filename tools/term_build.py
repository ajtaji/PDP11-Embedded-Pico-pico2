#!/usr/bin/env python3
"""
term_build.py - build the Pico 2 W's PDP-11 firmware with the console on the LAFVIN ST7796 panel.

    python tools/term_build.py [--compiler EXE] [--out DIR] [--port COMnn] [--keep]

The firmware is the emulator's own (J11_18MHz_KDJ11_BF/pico2/diag.pico2) with #TERM_PANEL = 1: core 1
also shows the PDP-11's console as an 80 x 24 terminal on the kit's 480 x 320 panel at up to 60 frames a
second (pico2/term_panel.pico2, the glyphs in pico2/term_font.pico2 from tools/term_font.py). Everything
else is the Pico 2 W build as it is - the same packs (V6 from the Pico 2 W image), the keyboard on the USB
port. Like demo_build.py and psram_build.py it writes a copy beside diag.pico2 and removes it afterwards;
the source's #TERM_PANEL = 0 keeps the terminal out of every other build.

OUTPUT (in --out, default build_term/ at the repository root)
    term_firmware.uf2   the firmware (the packs stay on the board: flash the Pico 2 W image first)
    term_firmware.bin   the flat image
"""
import argparse, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
EDITS = [("#TERM_PANEL = 0 ", "#TERM_PANEL = 1 "),
         ('XIncludeFile "rk11.pico2"', 'XIncludeFile "rk11.pico2"\n'
                                      'XIncludeFile "RP2350/Lib/spi.pico2"       ; the terminal build: the panel (term_panel.pico2)\n'
                                      'XIncludeFile "RP2350/Lib/st7796.pico2"\n'
                                      'XIncludeFile "term_panel.pico2"')]


def run(cmd, **kw):
    print("term_build: " + " ".join(cmd))
    r = subprocess.run(cmd, **kw)
    if r.returncode != 0:
        sys.exit("term_build: that step failed (exit %d); nothing past it was built." % r.returncode)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--compiler", default="PureMetalForge.exe")
    ap.add_argument("--out")
    ap.add_argument("--port", help="upload through the compiler's uploader to the board on this port")
    ap.add_argument("--keep", action="store_true", help="leave diag_term.pico2 beside diag.pico2")
    a = ap.parse_args()
    out = os.path.abspath(a.out or os.path.join(REPO, "build_term"))
    os.makedirs(out, exist_ok=True)
    tmp = os.path.join(SRC, "diag_term.pico2")
    try:
        text = open(os.path.join(SRC, "diag.pico2"), "rb").read().decode("utf-8")
        for old, new in EDITS:
            if text.count(old) != 1:
                sys.exit("term_build: diag.pico2 does not hold exactly one '%s' - it has moved; "
                         "update EDITS here to match." % old.strip())
            text = text.replace(old, new)
        text = text.rstrip() + '\nXIncludeFile "term_font.pico2"          ; the glyphs (a DataSection): last\n'
        open(tmp, "wb").write(text.encode("utf-8"))
        uf2 = os.path.join(out, "term_firmware.uf2")
        cmd = [a.compiler, "--compile", tmp, "-t", "rp2350", "-o", uf2]
        if a.port:
            cmd += ["--port", a.port]
        run(cmd, cwd=SRC)
        run([a.compiler, "--compile", tmp, "-t", "rp2350", "-o", os.path.join(out, "term_firmware.bin")], cwd=SRC)
    finally:
        if os.path.exists(tmp) and not a.keep:
            os.remove(tmp)
    print("term_build: done - %s" % os.path.join(out, "term_firmware.uf2"))


if __name__ == "__main__":
    main()
