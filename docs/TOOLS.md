# Host tools

Part of the [PDP-11 emulator for the Pico W and Pico 2 W](../README.md). Step-by-step use is in [HOWTO.md](HOWTO.md).

All tools are Python 3 scripts in `tools/`, run from the repository root
as shown. Under Git Bash on Windows, put `MSYS_NO_PATHCONV=1` in front
of any command with an argument that starts with `/` or `@/` (Git Bash would
turn `/dev/rk0` or `@/usr/...` into a Windows path).

## `rk_image.py` - an RK05 pack into the board's flash

Turns an RK05 disk image into a UF2 that writes the flash's disk region
(0x10240000 up on the RP2350 boards, 0x10040000 up on the Pico W), leaving
the firmware alone. It refuses a pack region that touches 0x10200000 to
0x1023FFFF and a firmware that reaches it (`flash_layout.py`, below).
`--autoboot-psram KERNEL` names the kernel the auto-boot types on a board
whose PSRAM is working (the 22-bit `/rk70unix`); without the PSRAM the
board types `--autoboot`'s.

```
python tools/rk_image.py info mini-unix.rk05
python tools/rk_image.py pack IMAGE --chip pico|pico2 -o OUT.uf2
       [--layout auto|dense|mapped] [--blocks N] [--name TEXT]
       [--swap auto|LO,N|none] [--boot-block FILE|@/PATH]
       [--autoboot KERNEL[,SWITCHES]]
       [--firmware FW.bin [--combined OUT.uf2] [--firmware-uf2 OUT.uf2] [--desk OUT.bin]]
```

- `info` prints the image's size, its Unix file system (V6 or V7) and the
  blocks in use, and how many fit each chip.
- `--layout dense` stores block n in slot n (a full 4872-block pack fits the
  Pico 2 W); `mapped` stores only the blocks in use (Mini-Unix on the Pico
  W). The default picks dense when it fits.
- `--swap` names the swap area, which the firmware keeps in RAM. `auto`
  takes the blocks after the file system (4000-4871 for both packs here).
- `--boot-block @/usr/mdec/rkuboot` copies that file from the image's own V6
  file system into block 0 (the V6 root pack has no boot block of its own).
- `--autoboot rkunix` makes the pack boot at power-up: `BOOT RK0` with the
  switch register at 173030 (or the octal value after a comma), then the
  kernel's name typed at the boot block's `@`.
- `--firmware diag.bin` with `--combined` writes firmware and pack as one
  UF2 (use it on the Pico 2 W); with `--firmware-uf2` the firmware alone as a
  UF2 (the Pico W's first file); with `--desk` a flat flash image for the
  desk emulator.
- Limits: RK05 packs only (up to 4872 blocks); drive 0 only (RK1 as well on
  the PSRAM boards); the firmware must stay below 0x10200000 on the RP2350
  boards and under 256 KB on the Pico W. On the Pico 2 W a whole RK05 no
  longer fits dense: the V6 root pack is stored mapped (2,891 blocks).

## `tape2pico.py` - a paper tape built into the firmware

Turns an absolute-format paper tape (`.bin`) or a PCjs tape (`.json`) into
`tape_image.pico` / `tape_image.pico2` beside the firmware source, so the
firmware starts with that program in memory.

```
python tools/tape2pico.py media/diagnostics/papertape/maindec-11-dfkaa-b1-pb.bin --start 200
python tools/tape2pico.py --empty
```

`--empty` builds the firmware with no tape: the serial tape reader and the
Unix images use that. Options: `--start` and `--switches` (octal), `--name`,
`--patch ADDR=WORD,...` (octal words changed after loading), `-o FILE`.

## `tape_ladder.py` - the diagnostic ladder over the serial port

Sends each tape of a plan to a board running the `--empty` firmware (the
serial tape reader), starts it, and judges it: PASS on a bell or
`END PASS`/`END OF`, FAIL on `HALT at`, otherwise NO VERDICT.

```
python tools/tape_ladder.py --port COM18 --plan media/diagnostics/ladder.txt
python tools/tape_ladder.py --port COM18 media/diagnostics/papertape/maindec-11-dfkaa-b1-pb.bin --start 200
python tools/tape_ladder.py --dump J11_18MHz_KDJ11_BF/pico2/tape_image.pico2 --plan PLAN --tapes media/diagnostics
```

A plan has one tape per line: `name | tape | tape2pico options | seconds`,
tape paths relative to the plan's folder (or `--tapes`). The ladder's plan
is `media/diagnostics/ladder.txt`. `--dump` writes the bytes it would send
into a tape image instead, for the desk emulator (see
[the diagnostic ladder](HOWTO.md#9-run-the-diagnostic-ladder)). The whole port session is one open of the port.

## `flash_layout.py` - the flash addresses, read from the firmware's own file

```
python tools/flash_layout.py
```

Prints the layout. It holds no addresses of its own: it reads
`J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2`, the file the firmware and
the pack installer are compiled with, so the tools and a board cannot
disagree. `rk_image.py` and `pack_install.py` take the pack regions and
the refusals from it.

## `od2bin.py` - a file typed by V6's `od` back into its bytes

```
python tools/od2bin.py TRANSCRIPT [...] -o FILE [--size BYTES] [--sum "N B"]
```

A file made on a board lives in PSRAM and is gone at the next reset. This
rebuilds it from a session transcript holding `od FILE`, and checks it
against what V6's own `sum FILE` printed on the board. It is meant for
the 22-bit kernel built on a board (`docs/psram/build-rk70unix.txt`, then
`docs/psram/get-rk70unix.txt`), to be kept as `media/unix/rk70unix`.
**Not yet run on a board's transcript:** tested on the host only, by a
round trip of a V6 kernel file through od's format.

## `v6fs.py` - read and change a V6 file system in a disk image

Works on the Sixth Edition file system inside an RK05 image, on the host.
Each changing command writes the whole image to `-o` (which may be the
input).

```
python tools/v6fs.py ls    IMAGE /dev
python tools/v6fs.py cat   IMAGE /etc/passwd
python tools/v6fs.py mknod IMAGE /dev/rk0 b 0 0 [--mode 640] -o OUT
python tools/v6fs.py ln    IMAGE /rkunix /unix -o OUT
python tools/v6fs.py rm    IMAGE /unix -o OUT
python tools/v6fs.py put   IMAGE HOSTFILE /rk70unix [--mode 755] -o OUT
python tools/v6fs.py patch IMAGE /rkunix _nswap 112 -o OUT
python tools/v6fs.py check IMAGE
```

- `mknod` makes a block (`b`) or character (`c`) device with a major and
  minor number; `ln` adds a name for an existing file; `rm` removes a name
  and, with the last one, frees the inode and its blocks onto the free list
  the way V6 does.
- `put` writes a host file into the file system under a new name; a file
  of more than 8 blocks becomes a V6 large file (indirect blocks), as the
  kernel would write it, and is read back and compared before the image is
  saved.
- `patch` writes a word into the data of an a.out file at the address of a
  symbol from its symbol table (the kernel's `_nswap`, say).
- `check` walks the file system as `icheck` would: every block free or in
  exactly one file, every link count matching the directory entries.
- Limits: V6 only (not V7), files up to 8 indirect blocks, directories grow
  by one block at most.

## `rk_desk.py` - typing for the desk emulator

The desk emulator cannot type at the board. This writes an empty tape image
whose built-in feed types what a person would, with pauses in tenths of a
second:

```
python tools/rk_desk.py "BOOT RK0 173030\r" 30 "rkmx\r" 300 "ls\r" 50 -o J11_18MHz_KDJ11_BF/pico/tape_image.pico
```

Build `diag.pico(2)` with `#DESK_PROBE = 1` for the feed to be used.

## `rk11_model.py` - the RK11 and KW11-L reference model

A Python model of the RK11 disk controller written from DEC's manual
(`EK-RK11D-OP-001.pdf`), a PDP-11 test program that drives the emulated
controller through every access pattern, and the comparison of the two.

```
python tools/rk11_model.py --tape rktest.bin
python tools/rk11_model.py --expect
python tools/rk11_model.py --check LOG
```

Build the test tape into the firmware (`tape2pico.py rktest.bin`) with
`#DISK_BACKEND = 1` (RAM packs), run it on the desk, and `--check` the log:
every line must match.

## `pdp11asm.py` - a small PDP-11 assembler

A two-pass assembler used by `rk11_model.py` and `rkuboot.py` (a library,
no command line of its own). Octal numbers, one statement per line,
`.word`, `.blkw`, `.ascii`, `.even`, EIS and MFPI/MTPI/MFPD/MTPD. Not
MACRO-11.

## `mmu_gen.py` - the mapped run loop, generated

Writes `instructions_mmu.pico(2)` (the run loop used while memory management
is on) from `pico/instructions.pico`, so the two loops cannot drift.

```
python tools/mmu_gen.py
python tools/mmu_gen.py --check
```

Run it after any change to `instructions.pico`; `--check` fails if the
generated files are out of date.

## `psram_build.py` - the PSRAM boards' image

```
python tools/psram_build.py --board feather|picoplus2 --compiler PureMetalForge.exe [--out DIR] [--desk]
```

Compiles `pico2/diag.pico2` with the board's three constants (`#PSRAM = 1`, the chip-select pin, the flash size), makes the V6 root pack with `/dev/rk1`, and packs firmware, RK0 and RK1 into one `combined.uf2` at the addresses of `flash_layout.pico2`. When `media/unix/rk70unix` exists (it does not yet: the 22-bit kernel has so far only been built on a board, where a reset loses it), the tool also writes it into the root pack as `/rk70unix` with `v6fs.py put`, links `/unix` to it and names it as the kernel to boot when the PSRAM is working; that path has not been run.

## `pack_install.py` - the packs into a board's flash over USB serial

```
python tools/pack_install.py --board feather|picoplus2 --image combined.uf2 (--hub-port N | --usb-serial TEXT)
                             [--compiler PureMetalForge.exe [--board-file FILE]] [--region all|rk0|rk1]
                             [--max-seconds 240] [--probe] [--status] [--sums]
```

For a board with no boot drive at hand. With `--compiler` it builds and uploads the installer (`pico2/packinstall.pico2`); then it sends each pack region of the image a sector at a time, every sector answered with a checksum, the header sector last, and the whole region read back and compared at the end. `--probe` tests one sector first; `--status` only asks what the flash holds (`PACK`, `UNFINISHED`, `BLANK`, `OTHER`); `--sums` prints the image's region checksums, the ones the firmware prints at start-up. The installer refuses a region inside the first 256 KB, past the flash size it measured, or past the size it was built for. It runs on Windows (the hub port from the device's location path) and reads the same from sysfs on Linux, where it has not been run.

## `board_session.py` - a scripted session at the Unix prompt

```
python tools/board_session.py (--hub-port N | --usb-serial TEXT) --script FILE [--out TRANSCRIPT] [--max-seconds 240]
```

One open of the port; each line of the script is typed and timed from the Return to the next prompt; `!boot`, `!stats`, `!eof`, `!line`, `!expect`, `!timeout`, `!wait` steps (the file's header lists them). The scripts used on the PSRAM boards are in `docs/psram/`.

## `psram_desk_check.py` - the PSRAM image on the emulator

Six cases per board on the PureMetal ARM emulator's PSRAM model (the chip present, left in QPI mode, absent, no model, a 4 MB chip, the other board's pin). Not run since the firmware moved to the compiler's PSRAM library; see its header.

## `v7ld.py` - a V7 link editor (archive and reference only)

V7 is not supported on this emulator (its kernel needs about 74 KB; the
machine has 56 KB). This tool is kept for reference. It links a Seventh
Edition kernel from the objects and libraries on the V7 tape
(`/usr/sys/conf/l.o mch.o c.o`, `/usr/sys/sys/LIB1`, `/usr/sys/dev/LIB2`),
as the tape's own makefile does:

```
python tools/v7ld.py -i -o rkunix l.o mch.o c.o LIB1 LIB2
python tools/v7ld.py --check rkunix hptmunix
```

The first gives an 0411 kernel (text 32,704, data 1,854, bss 39,812 bytes).
The objects come off `media/unix/v7.tap.gz` (a dump-format tape); the
script that extracts them is not in this repository.

## `rkuboot.py` - the RK05 boot block for V7 (archive and reference only)

V7's `/mdec/rpuboot.s` with its disk routine rewritten for the RK11, kept
for reference; V7 is not supported. (The V6 image uses V6's own
`/usr/mdec/rkuboot`, taken from its pack by `rk_image.py --boot-block`.)

```
python tools/rkuboot.py -o rkuboot.bin
python tools/rkuboot.py --into PACK
python tools/rkuboot.py --test-pack OUT NAME=FILE ...
```

## Not in the repository yet

These exist outside the repository and would be worth adding:

- a screenshot renderer: turns a transcript into 80-column terminal images;

(A UF2 merge script used before is replaced by `rk_image.py --combined`.)
