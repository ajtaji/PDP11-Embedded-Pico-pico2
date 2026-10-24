#!/usr/bin/env python3
"""uf2_firmware.py - put new firmware into a combined UF2 and leave its disk packs alone.

    python tools/uf2_firmware.py IMAGE.uf2 FIRMWARE.bin -o NEW.uf2

A combined image (rk_image.py pack ... --combined) is the firmware at the start
of the flash and the packs from J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2's
FL_PACKS up. This writes NEW.uf2 with every block of IMAGE.uf2 from the radio's
region up copied unchanged, and the blocks below it made from FIRMWARE.bin (a
flat image from the start of the flash, as the compiler writes diag.bin). The
packs keep their bytes, and so their nonce: on the PSRAM boards the store of
saved changes (pico2/store.pico2) belongs to the packs by that nonce, so a board
flashed with NEW.uf2 keeps what Unix saved, where a new rk_image.py run would
start the store empty.

It refuses a firmware that reaches the radio's region, an image with blocks of
more than one UF2 family, and writes nothing unless the packs come out
byte-identical (checked after writing, by reading NEW.uf2 back).
"""
import argparse
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import flash_layout as FL  # noqa: E402
import rk_image  # noqa: E402

XIP = FL.XIP


def read_uf2(path):
    """{flash offset: 256 bytes}, and the one family the blocks carry."""
    d = open(path, "rb").read()
    if len(d) % 512:
        sys.exit("uf2_firmware: %s is not whole 512-byte UF2 blocks" % path)
    pages, fams = {}, set()
    for i in range(0, len(d), 512):
        m0, m1, flags, addr, size, bno, nb, fam = struct.unpack_from("<8I", d, i)
        if m0 != rk_image.UF2_MAGIC0 or m1 != rk_image.UF2_MAGIC1:
            sys.exit("uf2_firmware: %s block %d is not a UF2 block" % (path, i // 512))
        if size != 256:
            sys.exit("uf2_firmware: %s block %d carries %d bytes; this tool expects 256" % (path, i // 512, size))
        fams.add(fam)
        pages[addr - XIP] = d[i + 32:i + 32 + 256]
    if len(fams) != 1:
        sys.exit("uf2_firmware: %s has blocks of %d UF2 families; expected one" % (path, len(fams)))
    return pages, fams.pop()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("image")
    ap.add_argument("firmware")
    ap.add_argument("-o", required=True)
    a = ap.parse_args()

    pages, fam = read_uf2(a.image)
    chip = [k for k, v in rk_image.FAMILY.items() if v == fam]
    if not chip:
        sys.exit("uf2_firmware: %s's UF2 family 0x%08X is not one rk_image.py writes" % (a.image, fam))
    fw = open(a.firmware, "rb").read()
    if len(fw) > FL.RADIO_LO:
        sys.exit("uf2_firmware: %s is %d bytes and would reach the radio's region at 0x%08X"
                 % (a.firmware, len(fw), XIP + FL.RADIO_LO))
    packs = {o: p for o, p in pages.items() if o >= FL.RADIO_LO}
    old_fw = sum(1 for o in pages if o < FL.RADIO_LO)
    parts = {0: fw}
    for o, p in packs.items():
        parts[o] = p
    open(a.o, "wb").write(rk_image.uf2(parts, chip[0]))

    back, fam2 = read_uf2(a.o)
    if fam2 != fam or {o: p for o, p in back.items() if o >= FL.RADIO_LO} != packs:
        os.remove(a.o)
        sys.exit("uf2_firmware: the packs did not come out byte-identical; nothing written")
    if bytes(b"".join(back[o] for o in sorted(back) if o < FL.RADIO_LO))[:len(fw)] != fw:
        os.remove(a.o)
        sys.exit("uf2_firmware: the firmware did not come out as given; nothing written")
    print("uf2_firmware: %s - firmware %d blocks (was %d), packs %d blocks unchanged, family 0x%08X"
          % (a.o, (len(fw) + 255) // 256, old_fw, len(packs), fam))


if __name__ == "__main__":
    main()
