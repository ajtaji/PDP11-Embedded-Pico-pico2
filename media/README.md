# PDP-11 media: tapes, paper tapes and disk images

How to use these with the tools, rebuild the images and run the diagnostic
ladder: **[../README.md](../README.md)**.

Everything the emulator has been fed, or is meant to be fed, in one place.
Files are stored exactly as downloaded (gzipped where the source gzipped them).

## `unix/`: UNIX distributions

Source: The Unix Heritage Society archive (tuhs.org), downloaded 2026-09-24.
Covered by the Caldera licence in `../../UNIX-LICENSE.txt`. The two Berkeley
archives (1978 and 1979) predate the BSD licence text and carry no separate
licence file; they are kept exactly as TUHS distributes them, with the
University of California, Berkeley credits in their own READ_ME files.

| File | What it is |
|---|---|
| `v6root.gz` | Sixth Edition root RK05 pack (the pack Unix V6 boots from on the Pico 2 W) |
| `v6src.gz` | Sixth Edition source RK05 pack |
| `v7.tap.gz` | Seventh Edition installation tape (archive only: V7 is not supported, its kernel needs about 74 KB and the emulator has 56 KB) |
| `tape0.bin.gz` to `tape3.bin.gz` | Mini-Unix distribution; `tape1` is a 2,048,000-byte RK05 image |
| `1bsd.tar.gz` | First Berkeley Software Distribution |
| `2bsd.tar.gz` | Second Berkeley Software Distribution |

`tools/rk_image.py` turns a pack into a UF2 for the Pico's flash, and
`--boot-block` installs a boot block where a pack has none (V6's root pack
needs `/usr/mdec/rkuboot`).

## `diagnostics/`: DEC MAINDEC and XXDP diagnostics

Source: bitsavers.org and pcjs.org, downloaded 2026-09-23. These are Digital
Equipment Corporation diagnostics, kept here for testing the emulator.
`diagnostics/INDEX.md` describes each file with its size and SHA-256. It was
written before the emulator had a console, clock or disk, so its "runs
today?" column is out of date: the serial tape loader now runs them, and the
diagnostic ladder passes 17 of 19 on both Picos (DZQKC and DEQKC halt by
design). The ladder's plan, with the options each tape needs, is
`diagnostics/ladder.txt`.

| Folder | What it is |
|---|---|
| `papertape/` | Absolute-format paper tape images (`.bin`): the absolute loaders and MAINDEC tests such as DFKAA, DFKAB, DFKAC, DZQKC and DZKMA |
| `pcjs/tapes-diag/` | The MAINDEC D0AA to D0OA series and DEQKC, in pcjs's decoded JSON tape form, with pcjs's README |
| `pcjs/tapes-absloader/` | The DEC-11-L2PC-PO absolute loader in the same form |
| `xxdp-plus-du.dsk.gz` | An XXDP+ disk image holding the KDJ11-B (J-11) CPU diagnostics; not yet extracted |

The DEC listings and manuals that `INDEX.md` mentions are not included; they
are documentation, available from bitsavers.

## `papertape/`: DEC Absolute Loader and BASIC
Source http://iamvirtual.ca/PDP-11/Basic-11/

Both paper tape images validated with SIM-H.

Intended here as an alternative boot and test option for PureMetal Forge's PDP/11 Emulator

Note that BASIC boots and runs directly on the PDP/11, no underlying Unix or RT11 is required
| File | What it is |
|---|---|
| `DEC-11-L2PC-PO.ptap` | DEC Absolute Loader (native/SIM-H papertape format) 183 bytes|
| `DEC-11-AJPB-PB.ptap` | DEC Single User BASIC (native/SIM-H papertape format) 10180 bytes|
| `PDP11_basic_simh.ini` | SIM-H configuration file, used to start SIM-H and test BASIC


