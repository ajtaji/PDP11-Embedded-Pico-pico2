#!/usr/bin/env python3
"""flash_layout.py - where the PDP-11 keeps things in an RP2350 board's flash.

The addresses are NOT written here. They are read from
J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2, the file the firmware and the
pack installer are compiled with, so the tools and the boards cannot
disagree. That file's header states the rule and why.

    python tools/flash_layout.py          prints the layout

Used by rk_image.py, pack_install.py and psram_build.py:
    RADIO_LO, RADIO_HI   the region a radio's firmware is kept in: never used
    PACKS                no pack region starts below this
    RK0, RK1             the two pack regions
    touches_radio(off, n)   True when [off, off + n) overlaps the radio's region
    check_region(off, n, what)   None, or the sentence saying why it is refused
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SOURCE = os.path.join(HERE, "..", "J11_18MHz_KDJ11_BF", "pico2", "flash_layout.pico2")
XIP = 0x10000000
WANTED = ("FL_RADIO_LO", "FL_RADIO_HI", "FL_PACKS", "FL_RK0", "FL_RK1")


def _read():
    try:
        text = open(SOURCE, "rb").read().decode("ascii")
    except OSError as e:
        sys.stderr.write("flash_layout: cannot read %s (%s). The tools take the flash addresses "
                         "from that file.\n" % (SOURCE, e))
        sys.exit(1)
    found = {}
    for name, value in re.findall(r"(?m)^#(FL_\w+)\s*=\s*\$([0-9A-Fa-f]+)", text):
        if name in found:
            sys.stderr.write("flash_layout: %s is set twice in flash_layout.pico2.\n" % name)
            sys.exit(1)
        found[name] = int(value, 16)
    missing = [n for n in WANTED if n not in found]
    if missing:
        sys.stderr.write("flash_layout: flash_layout.pico2 does not set %s as '#NAME = $hex'.\n"
                         % ", ".join(missing))
        sys.exit(1)
    return found


_v = _read()
RADIO_LO = _v["FL_RADIO_LO"]
RADIO_HI = _v["FL_RADIO_HI"]
PACKS = _v["FL_PACKS"]
RK0 = _v["FL_RK0"]
RK1 = _v["FL_RK1"]
if not (RADIO_LO < RADIO_HI <= PACKS <= RK0 < RK1) or any(v % 4096 for v in _v.values()):
    sys.stderr.write("flash_layout: flash_layout.pico2's values are not in order (radio region, then "
                     "the packs, RK0 before RK1) or not on 4096-byte sectors.\n")
    sys.exit(1)


def touches_radio(off, n):
    return off < RADIO_HI and off + n > RADIO_LO


def check_region(off, n, what):
    """None when [off, off + n) may hold a pack; otherwise the sentence that refuses it."""
    if touches_radio(off, n):
        return ("%s at 0x%08X-0x%08X touches 0x%08X-0x%08X, where a board with a radio keeps the radio "
                "chip's firmware. The PDP-11 never uses that part of the flash on any board; packs go "
                "at 0x%08X or above (J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2)."
                % (what, XIP + off, XIP + off + n - 1, XIP + RADIO_LO, XIP + RADIO_HI - 1, XIP + PACKS))
    if off < PACKS:
        return ("%s starts at 0x%08X, below 0x%08X: that part of the flash is the program's. Packs go "
                "at 0x%08X or above (J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2)."
                % (what, XIP + off, XIP + PACKS, XIP + PACKS))
    return None


if __name__ == "__main__":
    print("flash_layout: from %s" % os.path.normpath(SOURCE))
    print("  program              0x%08X - 0x%08X" % (XIP, XIP + RADIO_LO - 1))
    print("  never used (radio)   0x%08X - 0x%08X" % (XIP + RADIO_LO, XIP + RADIO_HI - 1))
    print("  RK0                  0x%08X" % (XIP + RK0))
    print("  RK1                  0x%08X" % (XIP + RK1))
