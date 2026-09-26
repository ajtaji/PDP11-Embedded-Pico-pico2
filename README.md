# PDP-11 (J-11) emulator for the Pico W and Pico 2 W

A DEC J-11 (KDJ11-BF) PDP-11 emulated on a Raspberry Pi Pico W (RP2040) or
Pico 2 W (RP2350), with a console on the USB serial port, an RK11 disk
controller with an RK05 pack held in the board's flash, a KW11-L line clock
and, on the J-11, memory management. The emulated processor runs alone on
the chip's first core, with its hot run loop in SRAM; the second core does
USB, the console, the disk's storage and the line clock's 60 Hz. It boots
Unix: **Sixth Edition (V6) on
the Pico 2 W and Mini-Unix on the Pico W.** Seventh Edition (V7) is not
supported (see **Known limits**).

- `images/` - ready-to-flash UF2 files (this page, **Quick start**).
- `media/` - the Unix distributions and DEC diagnostics the images and tests
  are built from.
- `tools/` - the host tools (this page, **Tools**).
- `J11_18MHz_KDJ11_BF/pico` and `pico2` - the firmware source for each chip
  (PureMetal, built with the PureMetal compiler, which is not in this
  repository).

## Quick start

| Board | Flash | Runs |
|---|---|---|
| Pico 2 W (RP2350) | `images/pico2w-v6/combined.uf2` | Sixth Edition Unix (V6), memory management on |
| Pico W (RP2040) | `images/picow-mini-unix/firmware.uf2`, then `images/picow-mini-unix/minix.uf2` | Mini-Unix |

**Flashing.** Hold the board's BOOTSEL button while plugging it into USB. A
drive appears (`RP2350` on the Pico 2 W, `RPI-RP2` on the Pico W). Copy the
UF2 file onto it; the board writes it and restarts by itself.

- **Pico 2 W:** one file, `combined.uf2` (firmware and disk pack together).
- **Pico W:** two files, in two separate BOOTSEL sessions: first
  `firmware.uf2`, then BOOTSEL again and `minix.uf2`. On the RP2040 a single
  combined file leaves the disk area unwritten (the start-up line then says
  `RK0: no pack`), so the two parts are flashed separately.

A board already running this firmware also enters BOOTSEL when it receives
the text `ResetPicoToBootSel1254` on its serial port, so it can be
re-flashed without touching the button.

**Connecting.** The board is a USB serial device (a COM port on Windows,
`/dev/ttyACM0` or similar on Linux). The baud rate does not matter (it is
USB); 115200 8N1 in any terminal program works. Open the port within 30 s
of power-up to see the start-up lines; the firmware waits up to 30 s for the
port to open before it starts.

**What you see.** The board powers up into Unix with no typing:

```
PDP-11 J-11 on Pico 2: serial tape reader ready
RK0: v6root, 4872 blocks, swap 4000-4871 in RAM, READ-ONLY: the flash is never written
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 76
#
```

At `#` you are root in Unix. Type in lower case (both systems print in
capitals: their terminal setting assumes an upper-case-only terminal).
Line endings CR, LF and CR LF are all accepted, and pasted text is fine.
The Pico W prints the same, with `mini-unix` and `rkmx` and Western
Electric's "RESTRICTED RIGHTS" notice before the `#`.

**The diagnostic console.** Press Esc within 2 s of the `auto-boot:` line
and the board stays in the firmware's own console instead of booting. There
`BOOT RK0 173030` boots by hand (then type `rkunix` or `rkmx` at the `@`),
and the diagnostic tools (`tools/tape_ladder.py`) can load paper tapes.

**Live statistics.** Type Ctrl-] then `s` at any time: the firmware prints a
block with the clock (measured at start-up), the emulated instructions per
second, memory in use, disk reads and writes, RAM overlay use, the line
clock, uptime, what each core does, and the longest gap between two USB
services since the banner (and what core 1 was doing then).
These two keys never reach Unix (Ctrl-] twice sends one Ctrl-] through).

**Shutting down.** Unplug at any time. The emulator never writes the flash:
every disk write, the swap area included, goes to RAM and is lost at
power-off, and the next power-up starts from the pack as flashed. `sync`
does no harm but saves nothing across a power cycle.

## Known limits

- **56 KB of PDP-11 memory** (000000-157777) plus the I/O page. V6 reports
  `mem = 76` at boot; about 15 KB is left for user programs once its kernel
  is in.
- **Writes live in RAM, in a fixed number of 512-byte blocks** (104 on the
  Pico 2 W, 124 on the Pico W), shared by the swap area and every file-system
  write. When they are used up, a write is refused: Unix sees a disk error
  and the statistics block shows `REFUSED: block N (RAM overlay full)`.
- **Pico W swap.** Mini-Unix has no memory management and swaps whole
  processes (about 37 KB each), so it fills the 124 blocks after a few
  commands; a refused swap write can restart the shell (the "RESTRICTED
  RIGHTS" notice appears again and the date jumps back). Keep Pico W
  sessions short for now.
- **V6 on the Pico 2 W:** `ps` says "no swap device" and `df` cannot open
  its disks, because the pack's `/dev` holds only `kmem`, `mem`, `null` and
  `tty8`. `dc` is too large for the 56 KB machine.
- **Speed** (measured on the boards, 2026-09-26): about 460,000 PDP-11
  instructions per second under V6 on the Pico 2 W (`od /rkunix` in 21 s),
  and about 800,000 under Mini-Unix on the Pico W. The run loop each Unix
  lives in executes from SRAM; code left in flash runs through a 16 KB
  cache the two cores share.
- **Seventh Edition (V7) is not supported.** Its kernel alone needs about
  74 KB of memory (text 32,704 + data 1,854 + bss 39,812 bytes) and the
  emulated machine has 56 KB. The V7 tape (`media/unix/v7.tap.gz`),
  `tools/v7ld.py` and `tools/rkuboot.py` are kept as archive and reference
  only.

**Licence.** The UNIX files in `media/unix/`, in the disk packs and in
`images/` are covered by the Caldera licence in `../UNIX-LICENSE.txt` (also
`Caldera-license.pdf`). `tools/rkuboot.py` reproduces V7's `/mdec/rpuboot.s`
and is covered by the same licence.

## Tools

All tools are Python 3 scripts in `tools/`, run from the `PureMetal`
folder as shown. Under Git Bash on Windows, put `MSYS_NO_PATHCONV=1` in front
of any command with an argument that starts with `@/` (Git Bash would turn
`@/usr/...` into a Windows path).

### `rk_image.py` - an RK05 pack into the board's flash

Turns an RK05 disk image into a UF2 that writes the flash's disk region
(0x10040000 up), leaving the firmware alone.

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
- Limits: RK05 packs only (up to 4872 blocks); drive 0 only; the firmware
  must be under 256 KB.

### `tape2pico.py` - a paper tape built into the firmware

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

### `tape_ladder.py` - the diagnostic ladder over the serial port

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
into a tape image instead, for the desk emulator (see **Diagnostic
ladder**). The whole port session is one open of the port.

### `rk_desk.py` - typing for the desk emulator

The desk emulator cannot type at the board. This writes an empty tape image
whose built-in feed types what a person would, with pauses in tenths of a
second:

```
python tools/rk_desk.py "BOOT RK0 173030\r" 30 "rkmx\r" 300 "ls\r" 50 -o J11_18MHz_KDJ11_BF/pico/tape_image.pico
```

Build `diag.pico(2)` with `#DESK_PROBE = 1` for the feed to be used.

### `rk11_model.py` - the RK11 and KW11-L reference model

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

### `pdp11asm.py` - a small PDP-11 assembler

A two-pass assembler used by `rk11_model.py` and `rkuboot.py` (a library,
no command line of its own). Octal numbers, one statement per line,
`.word`, `.blkw`, `.ascii`, `.even`, EIS and MFPI/MTPI/MFPD/MTPD. Not
MACRO-11.

### `mmu_gen.py` - the mapped run loop, generated

Writes `instructions_mmu.pico(2)` (the run loop used while memory management
is on) from `pico/instructions.pico`, so the two loops cannot drift.

```
python tools/mmu_gen.py
python tools/mmu_gen.py --check
```

Run it after any change to `instructions.pico`; `--check` fails if the
generated files are out of date.

### `v7ld.py` - a V7 link editor (archive and reference only)

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

### `rkuboot.py` - the RK05 boot block for V7 (archive and reference only)

V7's `/mdec/rpuboot.s` with its disk routine rewritten for the RK11, kept
for reference; V7 is not supported. (The V6 image uses V6's own
`/usr/mdec/rkuboot`, taken from its pack by `rk_image.py --boot-block`.)

```
python tools/rkuboot.py -o rkuboot.bin
python tools/rkuboot.py --into PACK
python tools/rkuboot.py --test-pack OUT NAME=FILE ...
```

### Not in the repository yet

These exist outside the repository and would be worth adding:

- a board session script: flashes a board through BOOTSEL (the reboot text,
  then the copy), opens the port once, boots Unix, runs commands and takes
  statistics, and saves the transcript;
- a screenshot renderer: turns a transcript into 80-column terminal images;

(A UF2 merge script used before is replaced by `rk_image.py --combined`.)

## Rebuilding the images

You need Python 3 and the PureMetal compiler (`PureMetalForge.exe`).
**The images use a compiler with r4-r7 and r12 reservation** (compiler
branch `regres-more`, until it is merged): the firmware keeps the lazy N/Z
flags in r4 (`#RESERVE_MORE = 1` in `cpu.pico(2)`). With a compiler that
refuses it, set `#RESERVE_MORE = 0`; that builds and runs, but not
byte-for-byte the committed images. From the `PureMetal` folder:

**Pico 2 W, V6** (`images/pico2w-v6/combined.uf2`):

```
python tools/tape2pico.py --empty
cd J11_18MHz_KDJ11_BF/pico2
PureMetalForge.exe --compile diag.pico2 -t rp2350 -o diag.bin
python -c "import gzip,shutil; shutil.copyfileobj(gzip.open('../../media/unix/v6root.gz'), open('v6root.rk','wb'))"
python ../../tools/rk_image.py pack v6root.rk --chip pico2 --blocks 4872 --boot-block @/usr/mdec/rkuboot --name v6root --autoboot rkunix --firmware diag.bin --combined combined.uf2 -o v6root.uf2
```

**Pico W, Mini-Unix** (`images/picow-mini-unix/firmware.uf2`, `minix.uf2`):

```
python tools/tape2pico.py --empty
cd J11_18MHz_KDJ11_BF/pico
PureMetalForge.exe --compile diag.pico -t rp2040 -o diag.bin
python ../../tools/rk_image.py pack ../../mini-unix.rk05 --chip pico --name mini-unix --autoboot rkmx --firmware diag.bin --firmware-uf2 firmware.uf2 -o minix.uf2
```

The compiler's output is the same byte for byte from the same source, so
these reproduce the committed files; compare with the SHA-256 values in
`images/README.md`. The firmware's defaults (`#DISK_BACKEND = 2`,
`#DISK_READ_ONLY = 1`, `#DESK_PROBE = 0` at the top of `diag.pico(2)`) are
the ones the images use.

To try an image on the desk emulator instead of a board, add
`--desk desk.bin` to the `rk_image.py` line and run `desk.bin` in the
PureMetal ARM emulator (`arm_run.exe desk.bin rp2350 1500000000 host=open`).

## Diagnostic ladder

The DEC diagnostics in `media/diagnostics/` run through the firmware's
serial tape reader. `media/diagnostics/ladder.txt` lists the 19 tapes, the
options each needs and the expected result: **17 PASS, and two HALTs that
are correct for a J-11** (DZQKC refuses a large CPU; DEQKC reads a register
a KDJ11 does not have).

On a board:

```
python tools/tape2pico.py --empty
(build diag.pico2 or diag.pico as above, and flash its firmware UF2)
python tools/tape_ladder.py --port COM18 --plan media/diagnostics/ladder.txt
```

Esc is not needed: the ladder's first command reaches the console during the
2 s wait, and a firmware with no auto-boot pack never waits.

On the desk: the whole ladder's bytes are too big for one desk build, so
dump a plan of one or a few tapes, build with `#DESK_PROBE = 1`, and run:

```
python tools/tape_ladder.py --dump J11_18MHz_KDJ11_BF/pico2/tape_image.pico2 --plan two.txt --tapes media/diagnostics
cd J11_18MHz_KDJ11_BF/pico2
(set #DESK_PROBE = 1 at the top of diag.pico2)
PureMetalForge.exe --compile diag.pico2 -t rp2350 -o diag.bin
arm_run.exe diag.bin rp2350 6000000000 host=open
```

where `two.txt` holds lines copied from `ladder.txt`. On the desk each tape
runs until it halts or rings a bell, or for 3 s of emulated time, whichever
is first, then the next starts: DFKAB prints `END OF DFKAB` well inside
that; the long T-series tapes need a board (or a longer desk run) for their
first bell.
