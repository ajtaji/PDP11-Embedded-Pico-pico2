# PSRAM board images - UNTESTED ON HARDWARE

**None of these files has run on a real board.** They have run only on the
desk, in the PureMetal ARM emulator with its model of the boards' QSPI PSRAM.
Do not treat them as ready to flash until one has run on the board it names.

| Board | File | Size | SHA-256 |
|---|---|---|---|
| Adafruit Feather RP2350 with HSTX port and 8 MB PSRAM ([6130](https://www.adafruit.com/product/6130)) | `feather/combined.uf2` | 9,381,376 | `96bc062b94eb5f2607238672f324d76ab36b1d12285df0b4e14127decf115981` |
| Pimoroni Pico Plus 2 ([PIM724](https://shop.pimoroni.com/products/pimoroni-pico-plus-2)) and Pico Plus 2 W ([PIM726](https://shop.pimoroni.com/products/pimoroni-pico-plus-2-w), Adafruit [6243](https://www.adafruit.com/product/6243)) | `picoplus2/combined.uf2` | 9,381,376 | `658904fae1445e2052c9ca434d15ef95b3d5a918a663ce83bdee6340b5e54b58` |

| | Feather RP2350 | Pico Plus 2 / Plus 2 W |
|---|---|---|
| chip | RP2350A | RP2350B |
| PSRAM | 8 MB APS6404L, QMI chip select 1 on GPIO8 | 8 MB APS6404L, QMI chip select 1 on GPIO47 |
| flash | 8 MB | 16 MB |

The pins and flash sizes are the pico-sdk board files'
(`adafruit_feather_rp2350.h`, `pimoroni_pico_plus2_rp2350.h`,
`pimoroni_pico_plus2_w_rp2350.h`). The Plus 2 W's radio is not used.

## What they do

Each is one UF2 with the firmware, RK0 (the V6 root pack, as in
`../pico2w-v6/`) and RK1 (V6's source pack, `../../media/unix/v6src.gz`).
At power-up the firmware looks for the PSRAM on the board's chip select:

- **PSRAM found and tested**: both packs are copied from the flash into the
  PSRAM and checked, and run from there - every block writable, every write
  lost at power-off, and the flash never written. V6 gets its whole swap
  area (blocks 4000-4871) and 248 KB of memory: it reports `mem = 1036`
  instead of 76, so the C compiler runs. `/etc/mount /dev/rk1 /usr/source`
  mounts the source pack.
- **Anything wrong** (no ID, the wrong ID, a failed write test, a pack that
  does not copy back exactly): the CS pin is given back and the board runs as
  the Pico 2 W build does - 56 KB, RK0 read-only from the flash, the 112-block
  swap RAM disk. The one difference is a 36-block file-write overlay instead
  of the Pico 2 W's 38, because the PSRAM bring-up code needs that SRAM.

The banner says which, and always says `UNTESTED ON HARDWARE`.

## Desk proof (tools/psram_desk_check.py)

On the emulator, both images boot to `#` with nothing typed with the board's
chip fitted (`mem = 1036`), with the chip left in QPI mode by the last
firmware, and they fall back to `mem = 76` with no chip, no PSRAM model at all,
a 4 MB chip and the chip on the other board's pin. On the Feather image V6
compiled and ran C programs with `cc`, mounted RK1, and kept twelve 32 KB
processes alive with seven of them swapped out (448 swap blocks, past the 112
the fallback has).

What the desk cannot show, and a board run must: the QMI timing at 150 MHz,
the chip's power-on state, the XIP cache's behaviour on the PSRAM window, the
time of the boot copy (646 ms on the desk), and the real speed of memory that
lives in PSRAM.

## Rebuilding

```
python tools/tape2pico.py --empty
python tools/psram_build.py --board feather   --compiler PureMetalForge.exe --desk
python tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe --desk
python tools/psram_desk_check.py --arm-run arm_run.exe --image build_feather/desk.bin --board feather
python tools/psram_desk_check.py --arm-run arm_run.exe --image build_picoplus2/desk.bin --board picoplus2
```

Each build writes `build_<board>/combined.uf2` (and the firmware and the desk
image beside it). With PureMetal Forge main `b9b70ed1` this reproduces both
files here byte for byte. The desk check needs an `arm_run` with the PSRAM
model (`psram=`, `flash=`).

Both files were rebuilt on 2026-10-04 with PureMetal Forge main `b9b70ed1`,
with the Pico 2's dispatch tails in assembly and the paste fix (the README's
Pasting text section), and pass the desk check again, 6 of 6 cases each.

## Pico 2 W with the paste fix - RUN ONLY IN THE EMULATOR

| File | Size | SHA-256 |
|---|---|---|
| `pico2w-v6-paste/combined.uf2` | 5,267,456 | `4d50e25227baa32e39bd5e26a2f25c33f9f92d2fe61acfd56c66035ef3c06f6a` |

**This file has not run on a Pico 2 W.** It is the Pico 2 W firmware built
from the current source (the console's receive pace and USB receive flow
control) with PureMetal Forge main `b9b70ed1`. The same change on the
Pico W has run on its board and is in `../picow-mini-unix/`.

In the PureMetal ARM emulator: the 620-character test program pasted into
`cat >pn.c` in one write is byte for byte identical (the board image in
`../pico2w-v6/` keeps 4 of 620 bytes in the same test); V6 `time od
/rkunix` real 30.0 s, user 28.7 s (29.0 and 28.5 before the fix); bench loop 1,044,093 instructions/s; no clock ticks dropped. (The
emulator adds both cores' cycles into one clock: compare its figures with
each other, not with a board.)

A board run still has to show: the paste from a real terminal at full
speed, `time od` three times with no ticks dropped, the bench loop, the
longest USB gap, and the diagnostic ladder.
