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
Unix images use that. The repository holds the empty files, so the firmware
compiles as it comes (in the IDE too); after building a tape in, run
`--empty` again before building Unix images. Options: `--start` and `--switches` (octal), `--name`,
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
First run on a board's transcript on 2026-10-20: Mini-Unix's slot-swap
kernel (`docs/minix/build-rkmx.txt`, `get-rkmx.txt`), three transcripts
giving the same 19,036 bytes and the board's `sum`. That run taught it od's
run form: a line of eight equal words starts a run, which od prints as the
run's offset and the word once (V6's `od.c`, `dupl`), so a one-word line
followed by a gap stands for that word up to the next offset.

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

For the Pico 2 it also writes the mapped loop's assembly: a fast path in
front of each MOV handler by addressing mode, and `__eaw`, the operand
address the handlers reach with `bl` instead of calling `EaWordM`
(`#ASM_MOV` and `#ASM_EA` in `pico2/cpu.pico2`; 0 builds the plain code).

## `asm_mov_gen.py` - the Pico's assembly fast paths

```
python tools/asm_mov_gen.py
python tools/asm_mov_gen.py --check
```

Writes the Pico's Thumb-1 assembly into `pico/instructions.pico`, between
`; ---- ASM (tools/asm_mov_gen.py)` lines: a fast path in front of each of
the unmapped loop's MOV handlers by addressing mode, and `__eaw1`, the
operand address in place of `EaWord` (`#ASM_MOV` and `#ASM_EA` in
`pico/cpu.pico`). Each fast path makes every test the Basic makes before it
changes anything and, if one fails, goes to the Basic body, which stays as
both the slow path and the reference. Run it after changing those handlers'
Basic bodies; `--check` fails if the file is out of date.

## `asm_check.pico` / `asm_check.pico2` - the assembly held to the Basic, on a board

Not a tool but a test firmware, one per chip. It puts the emulated machine
in random states and runs each assembly fast path and its plain Basic
version from the same state, comparing everything they can change
(registers, condition codes, memory against a shadow copy, the memory
management registers, traps), and counts how many runs took the fast path
and how many left it for the Basic. It prints a line per round:

```
ASMCHECK mov checks=17977 fast=6733 slow=11244 failures=0 PASS
ASMCHECK ea checks=80000 fast=60679 slow=19321 failures=0 PASS
ASMCHECK fp checks=20036 failures=0 PASS
```

The `fp` line (Pico 2 only) holds the floating point unit's assembly - the
fraction multiply and divide, `FpFracMulAsm` and `FpDivQAsm` in
`fp11.pico2` - to their Basic, `FpFracMulRef` and `FpDivQRef`, on random
fractions and every pairing of the extremes, in F and D.

```
cd J11_18MHz_KDJ11_BF/pico2
PureMetalForge.exe --compile asm_check.pico2 -t rp2350 -o asm_check.bin --port COMn
cd ../pico
PureMetalForge.exe --compile asm_check.pico -t rp2040 -o asm_check.bin --port COMn
```

Read its serial port for a few minutes; any `FAIL` names the first
instruction and field that differed.

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

## `term_build.py` - the console on the LAFVIN panel (Pico 2 W)

```
python tools/term_build.py [--compiler EXE] [--out DIR] [--port COMnn]
```

The Pico 2 W firmware with `#TERM_PANEL = 1`: core 1 also shows the PDP-11's console as an 80 x 24 terminal
on the kit's 480 x 320 ST7796 (`pico2/term_panel.pico2`: VT52 and the usual ANSI codes, 6 x 13 cells, the
rows that changed sent at each 60 Hz tick, the next band drawn while one goes by DMA). The packs stay on
the board. Measured on COM6, 2026-10-25: 60 frames a second while a frame's changes fit, 27-29 during
full-screen scrolling (`od /rkunix`: the SPI's 75 MHz carries a whole 480 x 312 frame in 32 ms); core 0
99% and core 1 42% busy meanwhile (the stats block's `busy` line). The file-write overlay is 230 blocks
in this build (254 otherwise): the panel's buffers take the rest of the SRAM.

## `term_font.py` - the terminal's glyphs

```
python tools/term_font.py DejaVuSansMono.ttf [--preview glyphs.png]
```

Writes `pico2/term_font.pico2`: ASCII 32-126 in 6 x 13 cells at four grey levels (13 rows of 12 bits a
glyph) from a monospace TTF; the firmware's are DejaVu Sans Mono's (any Linux has the font).

## `demo_build.py` - graphics and sound demo for either Pico family

```
python tools/demo_build.py [--target rp2040|rp2350] [--compiler EXE] [--lda demo/demo.lda] [--out DIR] [--port COMnn]
                           [--speaker AA:BB:CC:DD:EE:FF] [--keep]
```

Builds the emulator with the shared graphics and tone device (`outputs/demo.pmi`),
registers at octal 164000, frame interrupt at 320, and the demo as its boot tape.
Core 1 sends strips through the selected shared panel driver. RP2040 has 56 KB
guest RAM, four-row buffers and disks disabled; RP2350 has 64 KB and eight-row
buffers. CpuRun runs from SRAM. Temporary source copies are removed unless
`--keep` is given. Normal Unix builds omit the device.

`--audio silent|plugin|bluetooth` selects the backend; `--speaker` also selects
Bluetooth. Personal addresses reside only in the separately generated settings.
Bluetooth without `--speaker` produces silent public settings. `--port` uploads
both firmware and settings. Radio firmware is installed separately. On RP2040
it overlaps Mini-Unix: back up first and restore the disk pack when returning
to Unix. See [setup and validation](../OUTPUTS.md#graphics-and-sound-demo).

## `uf2_firmware.py` - new firmware into an image, the packs left alone

```
python tools/uf2_firmware.py IMAGE.uf2 FIRMWARE.bin -o NEW.uf2
```

For a release where only the firmware changed: every block of the image from the radio's region up (the packs) is copied unchanged, the blocks below it are made from the firmware (`diag.bin`, as `psram_build.py` or `--compile ... -o fw.bin` writes it). The packs keep their nonce, so on the PSRAM boards the store of saved changes still belongs to them and survives the reflash (a new `rk_image.py` run would start it empty). It reads the new file back and writes nothing unless the packs came out byte for byte the same. The images of 2026-10-24 were made with it.

## `board_session.py` - a scripted session at the Unix prompt

```
python tools/board_session.py (--hub-port N | --usb-serial TEXT) --script FILE [--out TRANSCRIPT] [--max-seconds 240]
```

One open of the port; each line of the script is typed and timed from the Return to the next prompt; `!boot`, `!stats`, `!save` (Ctrl-] w on a PSRAM board, waiting for its report: blocks, sectors, and the time spent listing, erasing and programming), `!eof`, `!line`, `!expect`, `!timeout`, `!wait` steps (the file's header lists them). The scripts used on the PSRAM boards are in `docs/psram/`.

## `psram_desk_check.py` - the PSRAM image on the emulator

Six cases per board on the PureMetal ARM emulator's PSRAM model (the chip present, left in QPI mode, absent, no model, a 4 MB chip, the other board's pin). Not run since the firmware moved to the compiler's PSRAM library; see its header.

## `v7_pack.py` - the Seventh Edition pack, from the tape

Builds a bootable V7 RK05 pack from `media/unix/v7.tap.gz` with the tools
below, for the PSRAM boards (V7 needs more memory than the others have):

```
python tools/v7_pack.py -o v7root.rk [--usr v7usr.rk | --usr-rp v7usr-rp.img] [--add LOCALDIR:/path ...]
python tools/rk_image.py pack v7root.rk --chip picoplus2 --blocks 4872 --swap 4000,872 --name v7root --autoboot boot,0 --autoboot-then "::rk(0,0)rkunix" --autoboot-mem 2040 --rp v7usr-rp.img -o v7root.uf2
```

`--usr-rp IMAGE` (the ready image's layout, HOWTO section 12) writes the
whole `/usr` dump as a 20,800-block file system for the RP03's `/dev/rp3`,
keeps `/etc/rc`'s own `mount /dev/rp3 /usr`, and makes `/dev/rp3` and
`/dev/rrp3`; `rk_image.py --rp IMAGE[,FIRST]` packs it, mapped, where RK1
would go (blocks FIRST on, default 7000: cylinder 35, where rp.c puts rp3).
The kernel is then linked from the four objects V7 built on a board
(`media/unix/v7/`, checked against `SHA256SUMS`; `build-on-board.txt` has the
sessions): `c.o` and `l.o`, mkconf's configuration with rk, rp and ht; and
`rp.o`, V7's RP03 driver with the two lines rk.c has, `if(bp->b_flags&B_PHYS)
mapalloc(bp);` - written for 18-bit machines, it never asked for the 11/70's
Unibus map, and a raw transfer wrote over another process's memory. `--usr`
(RK1, 4,000 blocks) is the older layout; the two are one or the other.

`rk_image.py` writes a random nonce at +192 of every pack header it makes. The
PSRAM firmware's store of saved changes (`pico2/store.pico2`, the top 1 MB of
the flash, which no pack may reach into) belongs to the packs whose nonces it
was saved with. Packs made by a new run of `rk_image.py` start with the store empty;
flashing the same file again keeps what was saved (a new firmware does too).

It restores the root dump (tape file 5) into a 4000-block file system,
adds `/usr/include` from the /usr dump (file 6), links `rkunix` from the
tape's own kernel objects (`v7ld.py`), pads the pack to 4872 blocks (V7
swaps at blocks 4000-4871), makes `/dev/rk0 rk1 rrk0 rrk1 swap`, takes the
mount of `/dev/rp3` out of `/etc/rc`, writes the boot block
(`rkuboot.py`), and copies each `--add` directory's files into a new
directory, and with `--usr IMAGE` writes RK1 as well: a 4,000-block `/usr` (the
libraries and nroff's macros, the manual, the headers; what fits RK1's place on
the PSRAM boards) that `/etc/rc` mounts. Root logs in with no password (the
distribution's is not known) and `/unix` is a link to `/rkunix` (`ps` reads its
names there). It patches the kernel's console flags (V7 opens the console as a
model 33 Teletype: upper case, and a pause of 10 clock ticks after each
newline - 13 s of a 31 s Dhrystone run went to it), and makes two patches
about the Unibus map (the script's header has the whole story):

- `/boot` switches the map on without loading its registers, so its own
  disk reads go nowhere; patched to leave it off (MMR3 025, not 065).
- `rkunix`, started by `/boot` with memory management already on, takes
  the machine for an 11/70 and sends every swap and raw transfer through
  the map - which `/boot` left off. Patched so that it switches the map on
  itself (`bis $60,SSR3` for `bit $20,SSR3`); `startup()` loads the map one
  to one before the first transfer. Without it, programs whose text comes
  back from the swap area (cc's `c0`, `awk`) die or hang on their second run.

## `v7fs.py` - read and change a V7 file system in a disk image

`v6fs.py`'s commands for the Seventh Edition file system (512-byte blocks,
4-byte block numbers, 3-byte addresses in the inode), plus `mkdir` (its
`mkfs` is a function `v7tape.py` builds new file systems with):

```
python tools/v7fs.py ls    IMAGE /usr
python tools/v7fs.py cat   IMAGE /etc/rc
python tools/v7fs.py get   IMAGE /rkunix HOSTFILE
python tools/v7fs.py put   IMAGE HOSTFILE /usr/x/file [--mode 0644] -o OUT
python tools/v7fs.py rm    IMAGE /usr/x/file -o OUT
python tools/v7fs.py ln    IMAGE /rkunix /unix -o OUT
python tools/v7fs.py mkdir IMAGE /usr/x -o OUT
python tools/v7fs.py mknod IMAGE /dev/rk0 b 0 0 [--mode 0640] -o OUT
python tools/v7fs.py check IMAGE
```

`put` over an existing file rewrites it in place (its inode, links and mode
stay unless `--mode` is given). A special file keeps its device number as
the kernel does: the first address, `di_addr[1]` the minor and
`di_addr[2]` the major.

## `v7tape.py` - the V7 distribution tape, read on the host

```
python tools/v7tape.py files   TAPE OUTDIR
python tools/v7tape.py ls      TAPE N
python tools/v7tape.py restore TAPE N -o IMAGE --blocks B --inodes I [--skip PATH ...] [--only PATH ...] [--into IMAGE] [--at DIR]
```

The tape is `media/unix/v7.tap.gz` gunzipped (SIMH format). Files 0-4 are
the boot programs, file 5 a dump of the root and file 6 of /usr. `restore`
builds a file system (or adds to one, `--into`) from a dump, with modes,
owners, times, hard links and device numbers kept; `--at` puts the dump's
root at a directory of the image.

## `v7ld.py` - a V7 link editor

Links a Seventh Edition kernel from the objects and libraries on the V7
tape (`/usr/sys/conf/l.o mch.o c.o`, `/usr/sys/sys/LIB1`,
`/usr/sys/dev/LIB2`), as the tape's own makefile does; `v7_pack.py` uses
it:

```
python tools/v7ld.py -i -o rkunix l.o mch.o c.o LIB1 LIB2
python tools/v7ld.py --check rkunix hptmunix
```

The first gives an 0411 kernel (text 32,704, data 1,854, bss 39,812 bytes).

## `rkuboot.py` - the RK05 boot block for V7

V7's `/mdec/rpuboot.s` with its disk routine rewritten for the RK11, and one
addition: it prints `@` before reading the name (rpuboot.s prints nothing), so
the firmware's auto-boot can answer it;
`v7_pack.py` writes it to block 0. (The V6 image uses V6's own
`/usr/mdec/rkuboot`, taken from its pack by `rk_image.py --boot-block`.)

```
python tools/rkuboot.py -o rkuboot.bin
python tools/rkuboot.py --into PACK
python tools/rkuboot.py --test-pack OUT NAME=FILE ...
```

## `fp11_model.py` - the floating point unit, in Python

A second port of SIMH's `pdp11_fp.c` (the FP11 / FPJ11), made apart from
the firmware's `pico2/fp11.pico2`, for checking it: every arithmetic and
conversion instruction with register operands, every FPS mode and enable,
FEC and the trap request.

```
python tools/fp11_model.py --selftest
python tools/fp11_model.py --check TRANSCRIPT
```

It also holds the two identities the firmware's assembly is built on (the
shift-and-add fraction multiply is exactly `floor(a * (b << 3) / 2^56)`;
the restoring divide is `floor(a * 2^(n-1) / b)`). Results printed by a
program on V7 can be held to it: on 2026-10-21, 400 random D-format sums,
differences, products and quotients typed out by a C program on a Pico
Plus 2 W were the model's, bit for bit.

## Not in the repository yet

These exist outside the repository and would be worth adding:

- a screenshot renderer: turns a transcript into 80-column terminal images;

(A UF2 merge script used before is replaced by `rk_image.py --combined`.)

## Panel, font and release tools

- `output_build.py --target rp2040|rp2350 --compiler EXE --out firmware.uf2`
  builds the standard emulator; `--audio silent|bluetooth|plugin` selects the
  linked sound transport. The default is silent.
- `output_config.py --target rp2040|rp2350 --panel NAME --font readable|compact
  --out settings.uf2` writes the small persistent output-settings sector.
- `font_pack.py` prepares the bundled ASCII TrueType outline assets.
  `--check` verifies reproducibility. It requires FontTools; rasterization
  itself runs on the Pico. `term_font.py` forwards to this tool.
- `font_capture.py --port COM7 --out work/font --exercise` captures the actual
  glyph cache and checks live font changes on a board. Requires pyserial and
  Pillow; take the board lease before using it.
- `demo_build.py --target rp2040|rp2350 --compiler EXE --out build_demo` builds the graphics
  demo and its settings file. `--panel` and `--font` choose its settings;
  `--speaker` selects the optional Bluetooth backend. Keep personal speaker
  settings private. `--port` also uploads the settings after building.
- `demo_check.py --port COM7 --out work/demo.txt --audio bluetooth` checks
  live graphics/audio counters on a leased board.
- `demo_release.py --target rp2040 --build-dir DIR --manifest images/manifest-2026-10-26.json --audio bluetooth`
  adds a tested demo and its committed source revision to the existing release
  manifest and checksums, leaving Unix packages untouched.
- `firmware_release.py --build-dir DIR --date YYYY-MM-DD --compiler-sha256 HASH` publishes the
  prepared firmware set, checksums and metadata. It uses `uf2_firmware.py` to
  replace code while verifying that every existing Unix pack byte and nonce
  is unchanged. See [images/README.md](../images/README.md) for the directory
  layout and build commands.

Panel wiring, APIs, live-font controls and audio module contracts are in
[OUTPUTS.md](../OUTPUTS.md).

## Operand assembly and fetch regression checks

`asm_full_gen.py --check` checks the twelve generic unmapped word/byte handlers
in the shared instruction source. Regenerate them before `mmu_gen.py`, then
run `unmapped_gen.py` and `unmapped_gen.py --tests` for RP2350 output. The
plain handlers remain available to diskless comparison firmware.

`fetch_check_gen.py` generates `pico2/fetch_check.pico2` and its independent
plain mapped interpreter. Build this fixture with PureMetal Forge and run it
on an RP2350; its serial verdict is `ASMCHECK fetch checks=512 failures=0 PASS`.
It executes instruction sequences with a multi-instruction budget so native
next-fetch tails are exercised. `CpuRunM(1)` alone cannot validate those tails.
`--check` verifies that the generated fixture and reference are current.


## RP2040 FP11 native arithmetic checks

`tools/fp11_vectors.py` generates deterministic, exact integer reference
values for the native `J11_18MHz_KDJ11_BF/pico/fp_check.pico` fixture.
It executes no guest instructions on the host. `--check` verifies the
committed vector data. The physical-board fixture performs 22,528 checks
of full-width multiplication, FP fraction products, division and 64-bit
shifts, including aliasing and all counts from zero through 63.

```
python tools/fp11_vectors.py --check
PureMetalForge.exe --compile J11_18MHz_KDJ11_BF/pico/fp_check.pico -t rp2040 -o fp_check.uf2
```

Flash the fixture to a physical RP2040 and read its USB serial output.
Success ends with `FP CHECK 22528 failures=0 PASS`. The ordinary firmware
also passes DEC JFPAA1/JFPBA0; the Mini-Unix tests in `docs/bench/v6/` cover
precision, library math, process state, executable startup and signal 8.
