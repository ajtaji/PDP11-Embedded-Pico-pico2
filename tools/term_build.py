#!/usr/bin/env python3
"""
Compatibility wrapper for the RP2350 standard panel-enabled Unix build.

    python tools/term_build.py --compiler EXE [--out DIR] [--port COMnn]

Panel output is now standard on both processors. This wrapper retains the
term_firmware.uf2/.bin filenames. Use output_build.py for either processor
and optional audio, and output_config.py to choose a resident screen driver.
The normal 152 KB guest memory and 248-block file overlay are preserved.
"""
import argparse, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
EDITS = []  # Panel output is standard; runtime settings select the controller.


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
