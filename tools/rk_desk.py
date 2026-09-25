#!/usr/bin/env python3
"""rk_desk.py - the desk harness's feed for booting a disk in arm_run.

arm_run's USB host sends nothing to the board, so the diagnostic firmware's
desk probe (#DESK_PROBE = 1) takes its "typed" bytes from the ProbeFeed in
tape_image.pico(2) and hands them to the same routine the port's bytes go
through. This writes an EMPTY tape image whose feed types what a person at
the terminal would, with pauses:

    python rk_desk.py "BOOT RK0 173030\\r" 30 "rkmx\\r" 300 "ls\\r" 50 -o tape_image.pico

Each quoted argument is typed (\\r and \\n understood); each number is a
pause in tenths of a second of emulated time before the next (the feed's
257 marker). Then build diag.pico(2) with #DESK_PROBE = 1 and the disk
backend wanted, and run it in arm_run (with host=open, so the port opens).
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tape2pico  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description="The desk feed that types at a booted system.")
    ap.add_argument("steps", nargs="+")
    ap.add_argument("-o", required=True)
    a = ap.parse_args()
    feed = []
    for s in a.steps:
        if s.isdigit():
            n = int(s)
            while n > 0:
                feed += [257, min(n, 65535)]
                n -= min(n, 65535)
        else:
            feed += list(s.encode("ascii").decode("unicode_escape").encode("latin-1"))
    ext = os.path.splitext(a.o)[1] or ".pico"
    text = tape2pico.render("desk", "(none: the desk feed " + " ".join(a.steps) + ")", 1, 0, [], ext, (), feed)
    open(a.o, "w", newline="\n").write(text)
    print("rk_desk: %d feed entries -> %s" % (len(feed), a.o))


if __name__ == "__main__":
    main()
