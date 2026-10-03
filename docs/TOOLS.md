# Host tools

Part of the [PDP-11 emulator for the Pico W and Pico 2 W](../README.md). Step-by-step use is in [HOWTO.md](HOWTO.md).

All tools are Python 3 scripts in `tools/`, run from the repository root
as shown. Under Git Bash on Windows, put `MSYS_NO_PATHCONV=1` in front
of any command with an argument that starts with `/` or `@/` (Git Bash would
turn `/dev/rk0` or `@/usr/...` into a Windows path).

## `rk_image.py` - an RK05 pack into the board's flash

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
python tools/v6fs.py patch IMAGE /rkunix _nswap 112 -o OUT
python tools/v6fs.py check IMAGE
```

- `mknod` makes a block (`b`) or character (`c`) device with a major and
  minor number; `ln` adds a name for an existing file; `rm` removes a name
  and, with the last one, frees the inode and its blocks onto the free list
  the way V6 does.
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

- a board session script: flashes a board through BOOTSEL (the reboot text,
  then the copy), opens the port once, boots Unix, runs commands and takes
  statistics, and saves the transcript;
- a screenshot renderer: turns a transcript into 80-column terminal images;

(A UF2 merge script used before is replaced by `rk_image.py --combined`.)
