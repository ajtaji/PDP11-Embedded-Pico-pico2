# Ready-to-flash Unix images

**Read this first (2026-10-21).** The Pico 2 W and Pico Plus 2 W files were rebuilt on 2026-10-21
from the source of commit `8e7a63f` (the speed pass: the stack, JSR, RTS and DIV in assembly, the
fetch window kept per mode, and on the PSRAM boards 224 KB of the memory and the unmapped run loop in
SRAM - `../docs/BENCHMARKS.md`, "The speed pass"); the Pico W files from `658cc72`, whose RP2040
source the speed pass does not touch (V7's two-step auto-boot; the Pico 2 W's 152 KB of memory
and 254-block write overlay, so V6's cc runs there; the J-11's floating point unit on the RP2350 builds;
the PC's references in I space; on top of the hot paths in assembly and Mini-Unix's swap by process slot
of 2026-10-20), from a clean `git archive`, and each file was run on its board as described
below. The DEC diagnostic ladder gives 17 of 19 (the two J-11 HALTs) on the Pico 2 W, the Pico Plus
2 W and the Pico W with firmware built from the same source. The RP2350 files keep
their packs at 0x10240000 and 0x104C0000, clear of the region a radio's firmware is kept in
(`J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2`). **The Feather file is still the 2026-10-07 build of
the earlier layout** (packs at 0x10040000 and 0x102C0000): no Feather was at hand to run a new one,
and `tools/pack_install.py` of the current source refuses it and says why; build a current one with
`tools/psram_build.py --board feather`. Built with PureMetal Forge's release binaries of 2026-10-19
(compiler `37314eeb8`).

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
| `pico2w-v6/combined.uf2` | 3,236,352 | `13c365ea0640750350075b6531df0a78c413b5c95ddae3472f45327ca33734b4` |

Firmware and disk pack in one UF2: hold BOOTSEL, plug in, copy the file to
the `RP2350` drive. At the serial console:

```
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 556
#
```

`time od /rkunix >/dev/null` takes 9.45 s timed from the host on a Pico 2 W with this file
(2026-10-21; 10.46 s with the file built from `658cc72`, 10.36 s timed from the host with the file of 2026-10-20; 13.24 s before the hot paths in assembly of 2026-10-19, 13.86 s before
the paste fix, 14.22 s before the dispatch tails in assembly, 17.43 s before the compiler's code
generation pass of 2026-10-03, 19.3 s before the dispatch pass of 2026-10-03, 21.7 s before the
speed pass of 2026-10-02). No clock ticks are dropped. The file was copied to the `RP2350`
drive, as above, and booted by itself; the DEC diagnostics pass with firmware built from the
same source (above). Text pasted into
the terminal arrives whole (the README's Pasting text section). The file-write overlay is 254
blocks; the C compiler builds and runs a program, and `dc` runs. The pack is the V6 root pack (`../media/unix/v6root.gz`) with V6's
own `rkuboot` installed in block 0.

The pack is changed with `tools/v6fs.py` (see `../README.md`): `/dev/rk0`,
`/dev/rrk0` and `/dev/swap` added, `/unix` linked to the kernel that runs,
and the kernel's swap sized to the firmware's 112-block swap RAM disk. `ps`
works; use `df /dev/rk0` (plain `df` looks for V6's built-in `/dev/rk2` and
`/dev/rp0`). The machine has 152 KB of memory (V6 says `mem = 556`).

## PSRAM boards: Pimoroni Pico Plus 2 W and Adafruit Feather RP2350 HSTX (V6, 248 KB)

| Board | File | Size | SHA-256 |
|---|---|---|---|
| Pimoroni Pico Plus 2 W ([PIM726](https://shop.pimoroni.com/products/pimoroni-pico-plus-2-w)): RP2350B, PSRAM chip select GPIO47, 16 MB flash | `picoplus2/combined.uf2` | 9,421,312 | `b9af052c15aa49b5d0ad266b3779c9d212741140b30361e1c11defc5f6655d6a` |
| Adafruit Feather RP2350 with HSTX port and 8 MB PSRAM ([6130](https://www.adafruit.com/product/6130)): RP2350A, GPIO8, 8 MB flash | `feather/combined.uf2` | 9,378,816 | `cebc0629fda95a4975144c330f84a7baf9ac5b1219e5e6392b043d0653a8d722` |

Each is one UF2 with the firmware, RK0 (the V6 root pack, as in `pico2w-v6/`,
plus `/dev/rk1`) and RK1 (V6's source pack, `../media/unix/v6src.gz`).

`picoplus2/combined.uf2` was copied to a Pico Plus 2 W's boot drive on 2026-10-21: `mem = 1036`, the
C compiler builds and runs a program, `dc` runs, `time od /rkunix >/dev/null` takes 9.32 s timed from
the host (10.66 s with the file built from `658cc72`, 10.42 s with the one from `dccf68e`; 13.37 s before the hot paths in assembly), and no clock tick is dropped. Its
firmware (SHA-256 `f326ed7d...0bb6`) has the floating point unit, which V7 and the benchmarks of
`../docs/BENCHMARKS.md` use; the pack regions have the checksums the board prints at start-up
(`RK0 21C285A3 5CA82BF0 RK1 1215D2AC 967B3EC6`). V7 is in `picoplus2-v7/` (below). It is for the Pico Plus 2 and the Pico Plus
2 W (same chip, pin and flash by the makers' board files); the radio is not used.

`feather/combined.uf2` is the 2026-10-07 build of the earlier layout (see the top of this file):
on that day it ran `mem = 1036`, the C compiler, the second drive, a swap test and DFKAA,
DFKAB and DFKAC on an Adafruit Feather RP2350 HSTX (firmware `d651c785...4101`, the same pack
checksums). What each board printed then is in [../README.md](../README.md#psram-boards) and
the transcripts are in `../docs/psram/`.

```
python tools/tape2pico.py --empty
python tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe
python tools/psram_build.py --board feather   --compiler PureMetalForge.exe
```

## Pimoroni Pico Plus 2 W: Seventh Edition Unix (V7), 1 MB, floating point

| File | Size | SHA-256 |
|---|---|---|
| `picoplus2-v7/combined.uf2` | 9,421,312 | `ec80b70a3907ca0c66c0f68bb9c2f1af96df662fb532d4c6cf85eeca24a67633` |

The same firmware as `picoplus2/combined.uf2` (SHA-256 `f326ed7d...0bb6`, with the J-11's floating
point unit), with V7's packs: RK0 the root file system and kernel (`tools/v7_pack.py`), RK1 a `/usr`
of 4,000 blocks (the libraries and nroff's macros, the manual, the headers). Copied to a Pico Plus 2 W's
boot drive on 2026-10-21, it boots by itself:

```
auto-boot: RK0, switches 000000, then "boot" at the @ prompt, then "rk(0,0)rkunix" at the : prompt. Press Esc within 2 s for the diagnostic console.
memory 1024 KB, as the pack asks
booting RK0, switches 000000
@boot
: rk(0,0)rkunix
mem = 973120
#
```

Tried on the board with this file (2026-10-21, the speed pass's build): it boots by itself as above,
a C program with `double` arithmetic compiles and prints the right answer, `dc` (2^100), RK1 mounted
on `/usr`, `df /dev/rk0 /dev/rk1`, `ls /usr/man`; `time od /unix >/dev/null` takes 15.03 s timed from
the host (17.00 s with the file built from `658cc72`). With that earlier file, the same packs also ran
`awk`, `man echo`, `ps` and `ps alx`, and Ctrl-D to multi-user, where `/etc/rc` mounts RK1 and root
logs in with no password. The pack checksums the board prints: `RK0 6795FB47 3E7B1015 RK1 CE4E3DF9 8FC9D376`. Memory
1024 KB; 0 flash writes. HOWTO section 12 has the use and the build.

## Pico W (RP2040): Mini-Unix

| File | Size | SHA-256 |
|---|---|---|
| `picow-mini-unix/firmware.uf2` | 294,912 | `210df6b08117180b872b9652ac3e04118609b8d0777cfa9a6e6cc553d2a5814f` |
| `picow-mini-unix/minix.uf2` | 3,167,232 | `0ec2c16c5201f3ed789c785174c7c1480f414197fcda6ce772600585bf0be54c` |

**Flash these as two separate copies**, firmware first, then the pack, each
from a fresh BOOTSEL (the `RPI-RP2` drive). On the RP2040 a single combined
UF2 leaves the pack area unwritten. The pack holds only the used blocks of
the Mini-Unix pack (`../mini-unix.rk05`, mapped) so it fits the Pico W's flash, with
Mini-Unix's kernel with swap by process slot as `/rkmx` (`../media/unix/rkmx-slotswap`; the
distribution's kernel stays as `/rkmx.dist`, and `/mx`, which `ps` reads, is the kernel that
runs; HOWTO section 8). It boots `rkmx` by itself. Mini-Unix runs with memory management off
(the stats block says `MMU off (16-bit)`). `time od /rkmx >/dev/null` takes real 4.0-5.0 s,
user 4.1-4.2 s on a Pico W (4.0 s real with this file on 2026-10-21), timed from the host 4.62 s a run (5.88 s before the hot paths in
assembly of 2026-10-19, 7.09 s before the compiler's code generation pass of 2026-10-03 and
the dispatch tails in assembly, 8.09 s before the MOV handlers by addressing mode, 8.64 s
before the speed pass of 2026-10-03). No clock ticks are dropped, and DFKAA, DFKAB and DFKAC
pass with firmware built from the same source; these two files were copied to a Pico W and
boot Mini-Unix by themselves.

The RAM for disk writes (124 blocks, shared with swap) no longer fills after a few commands:
the distribution's kernel swapped each process to a place set by its process number, which
moves on with every command, and walked the whole swap area; the kernel in this pack swaps by
process slot. Ten `od` runs and `ls -l /bin`, `ps`, `sum` and `df` leave 53 of the 124 blocks
used (`../docs/minix/transcript-picow-swap-proof.txt`). Files written still use the same RAM,
and are lost at power-off.

