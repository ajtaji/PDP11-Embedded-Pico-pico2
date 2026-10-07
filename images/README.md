# Ready-to-flash Unix images

**Read this first (2026-10-07).** The files here were built before the packs moved in the flash. They are complete and consistent in themselves (each UF2 carries its own firmware and its own packs, at 0x10040000 and 0x102C0000), and each ran as described below. The source in this repository now puts the packs at 0x10240000 and 0x104C0000, clear of the region a radio's firmware is kept in (`J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2`), and has 22-bit memory on the PSRAM boards; `tools/pack_install.py` of the current source refuses these files and says why. Images of the current source have not been put here yet: the Feather has run that source, the Pimoroni and the Pico 2 W build have not. Build one with `tools/psram_build.py` (PSRAM boards) or the lines of HOWTO section 8.

Each board **powers up into Unix**: the firmware boots the disk pack by
itself and Unix's `#` prompt appears with no typing. Press **Esc** within
2 s of the `auto-boot:` line to stay in the diagnostic console instead.
How to flash, connect and use them, and how to rebuild them from
`../media/unix/` with the tools, is in **[../README.md](../README.md)**.

Both run the emulated processor alone on core 0, with its run loop in
SRAM, and USB, the console and the disk's storage on core 1. Both builds
are **read-only**: the emulator never writes the flash. Swap
and every disk write go to RAM and are lost at power-off, so a board can be
unplugged at any time and always starts again from the pack as flashed.

The UNIX files inside the disk packs are covered by the Caldera licence in
`../Caldera-license.pdf`.

## Pico 2 W (RP2350): Sixth Edition Unix, memory management on

| File | Size | SHA-256 |
|---|---|---|
| `pico2w-v6/combined.uf2` | 5,267,456 | `4d50e25227baa32e39bd5e26a2f25c33f9f92d2fe61acfd56c66035ef3c06f6a` |

Firmware and disk pack in one UF2: hold BOOTSEL, plug in, copy the file to
the `RP2350` drive. At the serial console:

```
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 76
#
```

`#` 3.4 s after the port opened on a Pico 2 W (2 s of the Esc wait, then the
boot). `time od /rkunix >/dev/null` takes real 13-14 s, user 13.0 s, 13.86 s timed
from the host (14.22 s before the dispatch tails in assembly, 17.43 s
before the compiler's code generation pass of 2026-10-03, 19.3 s before the
dispatch pass of 2026-10-03, 21.7 s before the speed pass of 2026-10-02).
The memory-management-off bench loop runs at 2,439,000 instructions/s
(2,482,000 before the paste fix of 2026-10-04, 2,310,000 before the tails,
1,733,000 before the compiler pass). No clock ticks are dropped, the longest
gap between USB services is 338 us, and the DEC diagnostics DFKAA, DFKAB and
DFKAC pass on the board. Built with PureMetal Forge main `b9b70ed1`, with
`#ASM_TAILS = 1` in `pico2/cpu.pico2`. Text pasted into the terminal arrives
whole (the README's Pasting text section): a 620-character program was byte
for byte identical sent in one write and at every rate from 10 to 1000
characters a second. The file-write overlay is 38 blocks (it was 48):
ten went to MOV handlers in SRAM. The pack is the V6 root pack (`../media/unix/v6root.gz`) with V6's
own `rkuboot` installed in block 0.

The pack is changed with `tools/v6fs.py` (see `../README.md`): `/dev/rk0`,
`/dev/rrk0` and `/dev/swap` added, `/unix` linked to the kernel that runs,
and the kernel's swap sized to the firmware's 112-block swap RAM disk. `ps`
works; use `df /dev/rk0` (plain `df` looks for V6's built-in `/dev/rk2` and
`/dev/rp0`). V6's `dc` is too large for the 56 KB machine.

**This file is the build of commit `f358dcd`.** The Pico 2 W source has changed since (the memory
management unit's fast windows hold host addresses; README, PSRAM boards), and that build has not run on a
Pico 2 W, so this file was not replaced. The unchanged source built for a Pico 2 W ran on an Adafruit Feather
RP2350 (the same RP2350A): `mem = 76`, `od /rkunix` in 13.04 s, DFKAA, DFKAB and DFKAC pass, no clock tick
dropped. That is supporting evidence, not a Pico 2 W run. The Pico W image is unaffected: its source did not
change and it still reproduces from HEAD.

## PSRAM boards: Pimoroni Pico Plus 2 W and Adafruit Feather RP2350 HSTX (V6, 248 KB)

| Board | File | Size | SHA-256 |
|---|---|---|---|
| Pimoroni Pico Plus 2 W ([PIM726](https://shop.pimoroni.com/products/pimoroni-pico-plus-2-w)): RP2350B, PSRAM chip select GPIO47, 16 MB flash | `picoplus2/combined.uf2` | 9,378,816 | `62789e35ee5c6c8e54eecee3b8767a62c3ef67646f5e73b0d4e4f55419c5aa27` |
| Adafruit Feather RP2350 with HSTX port and 8 MB PSRAM ([6130](https://www.adafruit.com/product/6130)): RP2350A, GPIO8, 8 MB flash | `feather/combined.uf2` | 9,378,816 | `cebc0629fda95a4975144c330f84a7baf9ac5b1219e5e6392b043d0653a8d722` |

Each is one UF2 with the firmware, RK0 (the V6 root pack, as in `pico2w-v6/`,
plus `/dev/rk1`) and RK1 (V6's source pack, `../media/unix/v6src.gz`). Both
boards ran these bytes on 2026-10-07: `mem = 1036`, the C compiler, the
second drive, a swap test and the DEC diagnostics DFKAA, DFKAB and DFKAC.
What each printed is in [../README.md](../README.md#psram-boards) and the
transcripts are in `../docs/psram/`.

How the bytes reached the boards: the packs over USB serial with
`tools/pack_install.py` and the firmware through the compiler's uploader
(HOWTO section 10), not by copying these files to a boot drive. The
firmware inside each file has the SHA-256 of the firmware the board ran
(`picoplus2` `d2dc4c94...758e5`, `feather` `d651c785...4101`), and the pack
regions have the checksums the boards print at start-up
(`RK0 21C285A3 5CA82BF0 RK1 1215D2AC 967B3EC6`).

The `picoplus2` image is for the Pico Plus 2 and the Pico Plus 2 W (same
chip, pin and flash by the makers' board files); the board that ran it is
the Pico Plus 2 W. The radio is not used.

Built with PureMetal Forge main `681bc04ed` (compiler exes of `a55d11720`):

```
python tools/tape2pico.py --empty
python tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe
python tools/psram_build.py --board feather   --compiler PureMetalForge.exe
```

## Pico W (RP2040): Mini-Unix

| File | Size | SHA-256 |
|---|---|---|
| `picow-mini-unix/firmware.uf2` | 272,384 | `2cb43b80e71222e7bc832495a43db5d92129b3ee1f85a95681c74eb3df1173b7` |
| `picow-mini-unix/minix.uf2` | 3,167,232 | `de8bb8dc541f17e25b38097f7b0063cdb0f11d7ff28a81eb8a1fb0e75460f55a` |

**Flash these as two separate copies**, firmware first, then the pack, each
from a fresh BOOTSEL (the `RPI-RP2` drive). On the RP2040 a single combined
UF2 leaves the pack area unwritten. The pack holds only the used blocks of
the Mini-Unix pack (`../mini-unix.rk05`, 3,061 blocks, mapped) so it fits
the Pico W's flash. It boots `rkmx` by itself; `#` 3.2 s after the port
opened on a Pico W. Mini-Unix runs with memory management off (the stats
block says `MMU off (16-bit)`). `time od /rkmx >/dev/null` takes real 6.0 s,
user 5.4 s on a Pico W, timed from the host 5.90 s a run (7.09 s before the
compiler's code generation pass of 2026-10-03 and the dispatch tails in
assembly, 8.09 s before the MOV handlers by addressing mode, 8.64 s before
the speed pass of 2026-10-03). The memory-management-off bench loop runs at
2,548,000 instructions/s (2,587,000 before the paste fix of 2026-10-04,
2,048,000 before the compiler pass). No clock ticks are dropped and the
longest gap between USB services is 331 us. Built with PureMetal Forge main
`b9b70ed1`, with `#ASM_TAILS = 1` in `pico/instructions.pico`; the DEC
diagnostics DFKAA, DFKAB and DFKAC pass on the board with this file. Text
pasted into the terminal arrives whole (the README's Pasting text section):
a 620-character program was byte for byte identical sent in one write and
at every rate from 10 to 1000 characters a second.

Known: the RAM for disk writes (124 blocks, shared with swap) fills after a
few commands; when it does, the console says so once and Unix sees a disk
error. Mini-Unix swaps whole processes, and a refused swap write can
restart the shell, so keep sessions short for now.
