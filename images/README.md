# Ready-to-flash Unix images

**Read this first (2026-10-22).** The Pico 2 W and both Pico Plus 2 W files carry firmware built on
2026-10-22 from a clean `git archive` of the current source (`ce1436f` and its successors, the same
firmware bytes): the RP03 and the store of saved changes on the PSRAM boards, and the floating point
fixes DEC's KDJ11 FPA diagnostics found. The DEC diagnostic ladder gives 19 of 21 on the Pico 2 W
(the two J-11 HALTs; `../media/diagnostics/ladder.txt`). The Pico W files are from `658cc72`; the
RP2040 source (`../J11_18MHz_KDJ11_BF/pico/`) has not changed since. Each file was run on its board
as described below. The RP2350 files keep their packs at 0x10240000 and up, clear of the region a
radio's firmware is kept in (`J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2`), and the PSRAM files their
store in the top 1 MB of the flash. The Feather file was rebuilt the same day from the same source and run on a Feather RP2350 HSTX. Built with PureMetal Forge's release binaries of 2026-10-19
(compiler `37314eeb8`).

Each board **powers up into Unix**: the firmware boots the disk pack by
itself and Unix's `#` prompt appears with no typing. Press **Esc** within
2 s of the `auto-boot:` line to stay in the diagnostic console instead.
How to flash, connect and use them, and how to rebuild them from
`../media/unix/` with the tools, is in **[../README.md](../README.md)**.

They run the emulated processor alone on core 0, with its run loop in
SRAM, and USB, the console and the disk's storage on core 1. The Pico 2 W and Pico W
files are **read-only**: the emulator never writes the flash. Swap
and every disk write go to RAM and are lost at power-off, so a board can be
unplugged at any time and always starts again from the pack as flashed. The
PSRAM boards' files (both Pico Plus 2 W files and the Feather's) save what Unix writes into the flash
(their sections below).

The UNIX files inside the disk packs are covered by the Caldera licence in
`../Caldera-license.pdf`.

## Pico 2 W (RP2350): Sixth Edition Unix, memory management on

| File | Size | SHA-256 |
|---|---|---|
| `pico2w-v6/combined.uf2` | 3,246,080 | `5a12af8bf7ad7fdc4835863f6631254266083f8885ef3d318b6635255f67ee1a` |

Firmware and disk pack in one UF2: hold BOOTSEL, plug in, copy the file to
the `RP2350` drive. At the serial console:

```
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 556
#
```

Its firmware was rebuilt on 2026-10-22 from a clean `git archive` of `ce1436f` (SHA-256 `101e0eab...003a`: the
floating point fixes that DEC's KDJ11 FPA diagnostics found, and the RP11 and store code, which this board
does not use); the pack is the one below, unchanged. With it, on a Pico 2 W: `mem = 556`, `time od /rkunix
>/dev/null` 9.0 s by V6's `time` (whole seconds), and the ladder 19 of 21 (`../media/diagnostics/ladder.txt`,
the two J-11 HALTs). `time od /rkunix >/dev/null` takes 9.45 s timed from the host on a Pico 2 W with the file
of 2026-10-21 ( 10.46 s with the file built from `658cc72`, 10.36 s timed from the host with the file of 2026-10-20; 13.24 s before the hot paths in assembly of 2026-10-19, 13.86 s before
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
| Pimoroni Pico Plus 2 W ([PIM726](https://shop.pimoroni.com/products/pimoroni-pico-plus-2-w)): RP2350B, PSRAM chip select GPIO47, 16 MB flash | `picoplus2/combined.uf2` | 9,464,832 | `fba2c760935eb13f44dfba18ba8baefab8e90f591d1b7929ce5f63a33f4d34f3` |
| Adafruit Feather RP2350 with HSTX port and 8 MB PSRAM ([6130](https://www.adafruit.com/product/6130)): RP2350A, GPIO8, 8 MB flash | `feather/combined.uf2` | 9,464,832 | `ab796eb1df80fad7de80dea234310ebabc0ea437aeed822deddc4b0b6e6e784d` |

Each is one UF2 with the firmware, RK0 (the V6 root pack, as in `pico2w-v6/`,
plus `/dev/rk1`) and RK1 (V6's source pack, `../media/unix/v6src.gz`).

`picoplus2/combined.uf2` was rebuilt on 2026-10-22 from a clean `git archive` (firmware SHA-256
`abccd1ee...9526`, the same bytes as the V7 file's) and copied to a Pico Plus 2 W's boot drive: `mem =
1036`, `/etc/mount /dev/rk1 /usr/source`, the C compiler builds and runs a program, `time od /rkunix
>/dev/null` takes 9.0 s by V6's `time` (whole seconds; 9.32 s timed from the host with the file of
2026-10-21, 13.37 s before the hot paths in assembly), and a file written and synced was saved by
itself and was there after the same file was flashed again. The pack regions have the checksums the
board prints at start-up (`RK0 F83C278F 752B2FB0 RK1 E88F7498 87385286`). V7 is in `picoplus2-v7/` (below; rebuilt on 2026-10-22: the whole `/usr`, saves to flash by itself). It is for the Pico Plus 2 and the Pico Plus
2 W (same chip, pin and flash by the makers' board files); the radio is not used.

`feather/combined.uf2` was rebuilt on 2026-10-22 from a clean `git archive` (firmware SHA-256
`5a2ccc1c...7e5d`) and copied to an Adafruit Feather RP2350 HSTX's boot drive: `PSRAM: 8 MB on GPIO8`,
`mem = 1036`, `/etc/mount /dev/rk1 /usr/source`, the C compiler builds and runs a program, `time od
/rkunix >/dev/null` takes 9.0 s by V6's `time`, and a file written and synced was saved by itself (its
store is the top 1 MB of the Feather's 8 MB, 0x10700000 up) and was there after the same file was
flashed again. Pack checksums at start-up: `RK0 132574A5 10266B90 RK1 0378C1AE CAEA1666`. The
2026-10-07 build of the earlier layout ran DFKAA, DFKAB and DFKAC and a swap test there; its
transcripts are in `../docs/psram/`.

```
python tools/tape2pico.py --empty
python tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe
python tools/psram_build.py --board feather   --compiler PureMetalForge.exe
```

## Pimoroni Pico Plus 2 W: Seventh Edition Unix (V7), 2 MB, floating point, the whole /usr, saved to flash

| File | Size | SHA-256 |
|---|---|---|
| `picoplus2-v7/combined.uf2` | 22,850,560 | `eb4b4809c4ccc6842d23b7059b6d6b53e0d41fc95b015663d4521cc0e0cafef0` |

Rebuilt on 2026-10-22 from a clean `git archive` of commit `ce1436f` (the same as `0fd25ce`'s file but for the
floating point fixes DEC's KDJ11 FPA diagnostics found; booted on a Pico Plus 2 W: an empty store, `df`, `od /unix`
in 14.0 s): the PSRAM firmware (SHA-256 `abccd1ee...9526`, with the J-11's floating point unit, the RP11 controller, `../J11_18MHz_KDJ11_BF/pico2/rp11.pico2`,
and the store of saved changes, `store.pico2`) and V7's two disks: RK0 the root file system and kernel
(`tools/v7_pack.py`), and an RP03 holding the distribution's whole `/usr` - sources, documents, dictionary,
games - on `/dev/rp3`, 20,800 blocks, stored mapped where RK1 would go (`tools/rk_image.py --rp`). This
build is **not read-only**: what Unix writes is saved into the top 1 MB of the flash by itself a few seconds
after the disks go quiet, or at once with `sync` and Ctrl-] `w`, and comes back at the next power-up
(HOWTO section 12, Saving). Copied to a Pico Plus 2 W's boot drive, it boots by itself:

```
auto-boot: RK0, switches 000000, then "boot" at the @ prompt, then "rk(0,0)rkunix" at the : prompt. Press Esc within 2 s for the diagnostic console.
memory 2040 KB, as the pack asks
booting RK0, switches 000000
@boot
Boot
: rk(0,0)rkunix
mem = 2012672
#
```

Tried on the board with this file (2026-10-22): it boots by itself as above, its banner saying `the store: 0
saved blocks copied over the packs (generation 0, 256 of 256 sectors free)`; `df` lists `/dev/rk0` and
`/dev/rp3`; a file written and synced was saved by itself (4 saves, 35 blocks); `time od /unix >/dev/null`
takes 15.0 s (V7's `time` counts whole seconds: 14.0 to 15.0 s in runs of the earlier builds; 15.03 s with
the file of 2026-10-21, 17.00 s with the one built from `658cc72`); Ctrl-D to multi-user, where `/etc/rc`
mounts `/dev/rp3` on `/usr` and root logs in with no password. With firmware and packs built the same way
from the working tree that became `0fd25ce`:
- a save by itself, then a restart: the files and the date came back;
- 25 saves of 400 blocks each (1,477 sector writes, 1,367 erases): the newest version came back;
- a fold of more than the store holds, then a save into the store, then a restart: everything intact, and
  `icheck` is clean on `/dev/rp3` and `/dev/rk0`;
- raw reads of `/dev/rrp3` equal block reads.
The pack checksum the board prints: `RK0 76789AFF 4F8A12D0` (the RP disk is not summed). HOWTO section 12
has the use and the build.

## Adafruit Feather RP2350 HSTX: Seventh Edition Unix (V7), 2 MB, floating point, saved to flash

| File | Size | SHA-256 |
|---|---|---|
| `feather-v7/combined.uf2` | 9,464,832 | `d922da3c7cf466d08ed6156d9feb0191120aadd36f019e5fdd9f1536ab08a3ba` |

Built on 2026-10-22 from a clean `git archive` of the current source with the same firmware as
`feather/combined.uf2` (SHA-256 `5a2ccc1c...7e5d`), and V7's packs: RK0 the root file system and kernel,
RK1 a 4,000-block `/usr` - the libraries and nroff's macros, the manual, the headers (`tools/v7_pack.py
--usr`). The Feather's 8 MB of flash cannot hold the whole `/usr` the Pico Plus 2 W's RP03 has. What Unix
writes is saved into the top 1 MB of the flash by itself, or at once with `sync` and Ctrl-] `w`.

Copied to a Feather RP2350 HSTX's boot drive on 2026-10-22, it boots by itself (`mem = 2012672`, as on
the Pico Plus 2 W); `df` lists `/dev/rk0` and `/dev/rk1`, a C program with `double` arithmetic compiles
and prints 3.142857, `time od /unix >/dev/null` takes 14.0 s, Ctrl-D goes multi-user (`/etc/rc` mounts RK1
on `/usr`, root logs in with no password), and a file written to `/usr` and synced was saved by itself
(12 saves, 53 blocks) and was there after the same file was flashed again. Pack checksums at start-up:
`RK0 0A8F9683 5201E310 RK1 68FF2FAA B29A1646`. HOWTO section 12 has the use.

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

