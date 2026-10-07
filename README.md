# PDP-11 (J-11) emulator for the Pico W and Pico 2 W

A DEC J-11 (KDJ11-BF) PDP-11 emulated on a Raspberry Pi Pico W (RP2040) or Pico 2 W (RP2350), written in PureMetal and built with PureMetal Forge. It boots Unix straight from the board's flash and talks to you over the USB serial port: **Sixth Edition (V6) on the Pico 2 W and Mini-Unix on the Pico W.**

The emulated machine has a console on the USB serial port, an RK11 disk controller with an RK05 pack held in the board's flash, a KW11-L line clock and, on the J-11, memory management. The emulated processor runs alone on the chip's first core, with its hot run loop in SRAM; the second core does USB, the console, the disk's storage and the line clock's 60 Hz.

![Mini-Unix booting on a Pico W](boot-mini-unix.png)

*Mini-Unix on a Pico W, seen in a terminal on Linux: the `@rkmx` boot, the licence notice, then a directory listing at the `#` prompt.*

- **How-to:** [docs/HOWTO.md](docs/HOWTO.md) (flashing, serial settings, booting, building)
- **Host tools:** [docs/TOOLS.md](docs/TOOLS.md)
- **Forum:** <https://forum.ajtaji.com>

## Status per board

| | Pico 2 W (RP2350) | Pico W (RP2040) |
|---|---|---|
| Unix | Sixth Edition (V6) | Mini-Unix |
| Kernel booted | `rkunix` | `rkmx` |
| Memory management | on | off (Mini-Unix does not use it; the stats block says `MMU off (16-bit)`) |
| PDP-11 memory | 56 KB (000000-157777) plus the I/O page | 56 KB (000000-157777) plus the I/O page |
| Speed, measured on the boards (Pico 2 W 2026-10-04, Pico W 2026-10-04) | about 674,000 PDP-11 instructions per second under V6 (`od /rkunix` in 13.9 s); about 2,440,000 with memory management off | about 1,020,000 under Mini-Unix (`od /rkmx` in 5.9 s); about 2,550,000 on the bench loop |
| Console ready after port open | `#` after 3.4 s | `#` after 3.2 s |
| RAM for writes | 112-block swap RAM disk plus 38 blocks for file-system writes | 124 blocks shared by swap and file writes |
| Flash images | `combined.uf2` (one file) | `firmware.uf2` then `minix.uf2` (two files) |
| Disk | RK05 pack in flash, read-only | RK05 pack in flash, read-only |
| DEC diagnostic ladder | 17 of 19 pass (the other two halt by design for a J-11) | 17 of 19 pass (the same two) |
| Seventh Edition (V7) | not supported | not supported |

## Features

| Feature | Notes |
|---|---|
| J-11 (KDJ11-BF) processor | Run loop in SRAM on core 0; code left in flash runs through a 16 KB cache the two cores share |
| RK11 controller, RK05 pack | Pack held in the board's flash; **the emulator never writes the flash** |
| KW11-L line clock | 60 Hz, kept by core 1 |
| Console | USB serial, no baud rate to set |
| Auto-boot | Powers up into Unix with no typing; Esc within 2 s for the diagnostic console |
| Live statistics | Ctrl-] then `s` |
| Serial tape reader | Loads DEC diagnostic paper tapes over the serial port |
| Reflash without the button | Send `ResetPicoToBootSel1254` to the serial port |
| Host tools | Build your own disk image, patch V6 file systems, load tapes (see [docs/TOOLS.md](docs/TOOLS.md)) |

## Quick start

| Board | Flash | Runs |
|---|---|---|
| Pico 2 W (RP2350) | `images/pico2w-v6/combined.uf2` | Sixth Edition Unix (V6), memory management on |
| Pico W (RP2040) | `images/picow-mini-unix/firmware.uf2`, then `images/picow-mini-unix/minix.uf2` | Mini-Unix |

1. Hold the board's **BOOTSEL** button while plugging it into USB. A drive appears (`RP2350` on the Pico 2 W, `RPI-RP2` on the Pico W).
2. Copy the UF2 file onto it. The board writes it and restarts by itself.
   - **Pico 2 W:** one file, `combined.uf2` (firmware and disk pack together).
   - **Pico W:** two files in two separate BOOTSEL sessions, firmware first, then `minix.uf2`. On the RP2040 a single combined file leaves the disk area unwritten (the start-up line then says `RK0: no pack`).
3. Open the board's serial port at 115200 8N1 **within 30 s of power-up** (a COM port on Windows, `/dev/ttyACM0` or similar on Linux). The baud rate does not matter: it is USB.
4. The board boots Unix by itself. At `#` you are root; there is no login. Type in lower case (both systems print in capitals).

```
PDP-11 J-11 on Pico 2: serial tape reader ready
RK0: v6root, 4872 blocks, swap 4000-4871 in RAM, READ-ONLY: the flash is never written
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 76
#
```

The full walk-through, with the console boot commands, setting the date and re-flashing without the button, is in [docs/HOWTO.md](docs/HOWTO.md).

![Setting the date in Mini-Unix](mini-unix-set-date.png)

*`date 0922100098` sets Tue Sep 22 10:00:00 1998 (month, day, hour, minute, two-digit year).*

## Pasting text

Text pasted into the terminal arrives all at once, far faster than any
terminal of the time could send. With the firmware before 2026-10-04 a
35-line, 620-character C program pasted into `cat >pn.c` lost most of its
text (measured in the emulator on the Pico 2 W build, V6), in two places:

- **In the USB serial library.** It keeps 256 characters and the console
  queue another 256. A paste longer than that overflowed the library's ring:
  128 of the 656 characters sent never reached the emulated machine.
- **Inside Unix.** Every character that did reach the PDP-11 was read by it
  (528 of 528; and 656 of 656 when the same text was sent a line every
  20 ms). But the console handed Unix the next character 100 instructions
  after the last, and V6 takes each one at interrupt level whether or not
  `cat` has had time to run. When its input queue reaches 256 characters it
  throws the whole queue away (`/usr/sys/dmr/tty.c`, `ttyinput`: `if
  (tp->t_rawq.c_cc>=TTYHOG) { flushtty(tp); return; }`). The file ended up
  with 4 bytes of 620 (131 at a line every 20 ms). At a line every 50 ms or
  slower the file was complete.

Both are fixed in the source:

- **The receiver has a pace.** The next character is given to the PDP-11
  2000 instructions after the last one was read, or at once when the
  processor is in a WAIT (Unix has nothing left to do). The rest waits.
- **The host is held back.** While the queues are full the firmware stops
  accepting USB packets, the host waits and sends again. This is USB's own
  flow control: nothing to set in the terminal.

**Measured on a Pico W** (Mini-Unix, `images/picow-mini-unix/firmware.uf2`,
2026-10-04): the same program sent in one write, and at 1000, 300, 100, 30
and 10 characters a second, read back with `od -c`: the file is byte for
byte identical every time (620 of 620). In the one-write case the host was
held back 3 times; every character sent was read by the PDP-11 and none was
lost. The stats block (Ctrl-] then `s`) has a `typed` line with these
counts.

**Measured on a Pico 2 W** (V6, `images/pico2w-v6/combined.uf2`,
2026-10-04): the same test, the same result - identical in one write and at
1000, 300, 100, 30 and 10 characters a second; the host was held back 4
times in the one-write case, and nothing was lost.

What remains is Unix's own, on any PDP-11:

- A single line longer than 255 characters is thrown away (the same
  `TTYHOG` test: Unix only hands a line to the program at its end).
- `#` erases the character before it and `@` erases the line, as on every
  V6 terminal. Type `\#` and `\@` to enter them, or change them with
  `stty`.
- While the terminal is in upper-case mode (the images' default) capitals
  are stored as lower case. `stty -lcase` first.
- On the Pico W the RAM for disk writes is small (Known limits, below): a
  session of about ten commands fills it, whatever was pasted.

## PSRAM boards

**State of the source now (2026-10-07).** The PSRAM boards' firmware has **22-bit memory management and 3812 KB of PDP-11 memory** (00000000-16707777: 56 KB in SRAM, 3756 KB in PSRAM), the Unibus map of a PDP-11/84 and the RK11 through it. V6's own 11/70 kernel, built on a board from the distribution's sources (`docs/psram/build-rk70unix.txt`), boots there and prints `mem = 18857`. **V6 prints that figure in tenths of 1024 words: 18857 is 3771 KB free of the 3812 KB** (the 18-bit kernel's `mem = 1036` is 207 KB free of 248 KB). That kernel lives in PSRAM only: a reset puts the pack back as the flash holds it, and putting the kernel into the pack image is not done yet (the tools for it are in [docs/TOOLS.md](docs/TOOLS.md), not yet run on a board). RK1 is stored as 4000 blocks, the size of the V6 source pack's file system; blocks 4000 to 4871 of RK1 answer with a drive error.

Two things changed after the runs recorded below, both run on the Feather on 2026-10-07:

- **The packs moved in the flash** to keep clear of the region a board with a radio keeps its radio firmware in: the program is below 0x10200000, 0x10200000 to 0x1023FFFF is never used, RK0 is at 0x10240000 and RK1 at 0x104C0000 (one file, `J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2`). Installed on the Feather with `tools/pack_install.py`: the file, the installer and the firmware's start-up line all give `RK0 21C285A3 5CA82BF0 RK1 1215D2AC 967B3EC6`. **The Pimoroni has not been moved yet, and the image files in `images/` are builds of the earlier layout** (packs from 0x10040000): the current tools refuse them by name; build an image for the current source with `tools/psram_build.py`.
- **The PDP-11's memory is first in the PSRAM**, before the two packs. With it behind the packs the 22-bit firmware took 13.35 s for `time od /rkunix >/dev/null` where the 248 KB firmware took 13.08 s; with the memory first it takes 13.08 s (Feather, the 18-bit kernel, timed from the host, two runs each, one compiler build). The reason is in `pico2/psram_pdp11.pico2`.

The table and the lines below are the record of the 248 KB firmware of the same day (the boards' transcripts are in [docs/psram/](docs/psram/), the 22-bit ones included).

Two boards with 8 MB of QSPI PSRAM run V6 with **248 KB of PDP-11 memory** (V6 prints `mem = 1036`, against 76 on the Pico 2 W), both RK05 packs writable in PSRAM with the whole swap area, and the flash never written. Both ran on 2026-10-07; the images are in [images/](images/README.md) and the transcripts in [docs/psram/](docs/psram/).

| | Pimoroni Pico Plus 2 W | Adafruit Feather RP2350 HSTX |
|---|---|---|
| Chip, PSRAM chip select | RP2350B, GPIO47 | RP2350A, GPIO8 |
| Flash (JEDEC ID read on the board) | Winbond W25Q128JV, 16 MB (EF 40 18) | Winbond W25Q64JV, 8 MB (EF 40 17) |
| Image | `images/picoplus2/combined.uf2` | `images/feather/combined.uf2` |
| V6 start-up | `mem = 1036` | `mem = 1036` |
| `time od /rkunix >/dev/null`, timed from the host | 13.08 s | 13.08 s |
| `cc` of a small C file | 3.5 s | 3.5 s |
| Packs copied from flash into PSRAM at start-up | 1258 ms | 1258 ms |
| DEC diagnostics DFKAA, DFKAB, DFKAC | 3 of 3 pass | 3 of 3 pass |

What a board prints at start-up:

```
PSRAM: 8 MB on GPIO47, ID 0D 5D 53, clock 75000 kHz; packs copied and checked in 1258 ms (copy 903, check 330); memory 248 KB; RK0 and RK1 (4000 blocks) writable in PSRAM, never written to flash; the PSRAM copy's kernel patch applied (block 1517 +90)
PSRAM windows: packs uncached, memory cached
pack checksums: RK0 21C285A3 5CA82BF0 RK1 1215D2AC 967B3EC6
RK0: v6root, 4872 blocks, running from its PSRAM copy: writable, every write lost at power-off, the whole swap area (4000-4871); the flash is never written
```

- **What V6 gains:** the C compiler runs (`cc`), `/etc/mount /dev/rk1 /usr/source` mounts V6's source pack, and twelve 30 KB processes stayed alive at once with seven swapped out. Every write is lost at power-off, as on the other boards.
- **The chip is set up by the compiler's own library** (`RP2350/Lib/psram.pico2`); `pico2/psram_pdp11.pico2` holds what the PDP-11 does with the memory.
- **A program in PSRAM runs as fast as one in SRAM.** The memory management unit's fast windows hold a host address for each page, in SRAM or in PSRAM alike. Before that change the same `od` job took 46.2 s with the program in PSRAM.
- **Which window, measured on V6 itself:** the PDP-11's memory goes through the XIP cache (13.08 s for the `od` job; 18.56 s through the uncached window); the packs go through the uncached window, so a block transfer evicts nothing.
- **If the PSRAM is not found**, or is not a working 8 MB chip, the pin is given back and the board runs as the Pico 2 W build does (56 KB, the pack read-only in flash, `mem = 76`), and the first line says why. Shown on a board by building the Pimoroni image with the Feather's pin: `PSRAM: not in use - the PSRAM library found none (its error 5: no chip answered the ID read on this pin). Running as the Pico 2 build: 56 KB, the pack read-only in flash.` A 4 MB chip and a chip that fails its test could not be shown on these boards; `tools/psram_desk_check.py` covers them on the emulator and has not been run again since the firmware moved to the library.
- **Getting it onto a board:** copy `combined.uf2` to the board's boot drive (hold BOOT while plugging in), or, with no button and no drive, send the packs over USB serial with `tools/pack_install.py` and upload the firmware with the compiler: [docs/HOWTO.md, section 10](docs/HOWTO.md#10-the-psram-boards). The boards here were loaded the second way; the firmware and pack bytes on them are the ones in the image files (the firmware's SHA-256 and the pack checksums were compared), but the files themselves were not copied to a boot drive.

## Known limits

- **56 KB of PDP-11 memory** (000000-157777) plus the I/O page. V6 reports `mem = 76` at boot; about 15 KB is left for user programs once its kernel is in.
- **Writes live in RAM (RAM disks), in 512-byte blocks.**
  - Pico 2 W: a **swap RAM disk of 112 blocks** (56 KB, blocks 4000-4111 of the pack) and **38 blocks for file-system writes**. The V6 kernel in the image is patched to swap only there (`_nswap` = 112), so swap can never be refused. 112 blocks hold about three of V6's largest processes (about 33 blocks each) or many small ones; if a session ever needs more, V6 stops with its own "panic: out of swap space".
  - Pico W: **124 blocks shared** by swap and file writes. Mini-Unix gives each of its 13 process slots a fixed 66-block swap area (858 blocks by design) and has no swap size to patch, so this cannot be bounded in the Pico W's SRAM. Mini-Unix swaps whole processes, and after enough commands the blocks run out; keep Pico W sessions short.
  - When the file-write blocks are used up, a write to a new block fails: Unix sees a disk error, the console prints once `[RK0: the RAM overlay for file writes is full ...]`, and the statistics block shows `FULL: n writes refused`. Nothing already written changes and nothing reaches the flash; power off to start clean.
- **Nothing is saved across a power cycle.** Every disk write, the swap area included, goes to RAM; the next power-up starts from the pack as flashed. `sync` does no harm but saves nothing. (The flash-wear warnings in [disk_boot_readme.md](disk_boot_readme.md) concern emulators that write the flash; this firmware never does.)
- **V6 on the Pico 2 W:** `ps` works; `df` with no argument looks for V6's built-in `/dev/rk2` and `/dev/rp0`, which this machine does not have, so type **`df /dev/rk0`**. `dc` is too large for the 56 KB machine.
- **Seventh Edition (V7) is not supported.** Its kernel alone needs about 74 KB of memory (text 32,704 + data 1,854 + bss 39,812 bytes) and the emulated machine has 56 KB. The V7 tape (`media/unix/v7.tap.gz`), `tools/v7ld.py` and `tools/rkuboot.py` are kept as archive and reference only.
- **Packs:** RK05 only (up to 4872 blocks), drive 0 only (RK1 as well on the PSRAM boards). On the RP2350 boards the pack starts at 0x10240000, so the Pico 2 W's 4 MB hold 1.75 MB of pack: the V6 root pack is stored mapped (2,891 blocks in use). That build has not run on a board yet; `images/pico2w-v6/combined.uf2` is the earlier layout.
- **The Pico W image uses the flash where the radio's firmware would go; a Pico W running it cannot use its radio.** Its 2 MB cannot hold Mini-Unix (3,061 blocks in use) clear of that region; the firmware says so at start-up and `tools/rk_image.py` when it packs. The RP2040 source of this commit compiles and has not run on a Pico W.
- **Mini-Unix:** a refused swap write can restart the shell.
- **Year 2000:** the `date` command takes a two-digit year.

## The emulated processor, and where it is known to differ from a real J-11

The processor is a J-11 as far as the software run on it needs: the instruction set without floating point, the three modes, memory management with 18-bit and 22-bit mapping, the CPU error and maintenance registers, and on the PSRAM boards the Unibus map of a PDP-11/84. It boots the Unix systems named above and passes the diagnostic ladder as [media/diagnostics/ladder.txt](media/diagnostics/ladder.txt) states it. **It is not claimed to be an exact KDJ11.** No diagnostic written for the KDJ11 has been run on it (none is in the diagnostic image here); the diagnostics that have been run are for other processors (the 11/20 family, the 11/34, the 11/44, the F-11 of the 11/23), judged against the published manuals.

One behaviour was corrected from those runs: with a register as the source and memory as the destination, the register is read after the destination's address has been worked out, so `MOV R0,(R0)+` stores R0 already stepped and `MOV PC,X(R)` stores the address of the instruction plus 4 (KDJ11-A CPU Module User's Guide, EK-KDJ1A-UG-002, appendix B, table B-1, items 1 to 3). The F-11 CPU diagnostic CJKDBD0 halted at its test 264 before the change and runs to its test 405 after it; the 11/34 diagnostic DFKAA tests the 11/34's opposite behaviour in its test 145 and carries two patches in the ladder for that reason.

Known differences, found by those tapes and left as they are:

- **MMR0 after a reference in the illegal processor mode (10):** the emulator sets bits 15 and 14; a J-11 sets bit 15 (KDJ11-B CPU Module User's Guide, EK-KDJ1B-UG-001, table 1-10, page 1-21). Seen by the 11/44 memory-management diagnostic CKKTB, test 3 (140103 where 100103 is wanted).
- **MMR1 and MMR2 are kept only while relocation is on.** A real J-11 loads MMR2 with the address of every instruction fetched and records register changes in MMR1 whether or not MMR0 bit 0 is set (the same guide, 1.4.7.2 and 1.4.7.3, page 1-20). Seen by CKKTA tests 14 and 16 and CKKTB test 7.
- **MMR0 bits 3 to 1 are written only at an abort.** The 11/44 tape wants them to follow every reference (CKKTB test 12); the J-11's guide gives them a meaning only at an abort, so whether a J-11 differs from the emulator here is not settled by the manual.
- **A memory-management abort and an odd address in one instruction** (CKKTB test 13: the stacked PC is 4 higher than the 11/44 tape wants) and **the address errors of CKKTB test 34:** not settled by the manuals read.
- **PDR bit 15 does not read back** (CKKTA test 31). On the KDJ11 it is the bit that bypasses the cache; the emulated machine has no cache.
- **Tests of the F-11 tape that a J-11 must fail:** test 405 wants no trap from a word reference to an odd address (the F-11 has none; the J-11 traps: table B-1, item 21) and test 410 wants MFPT to answer 3 (the J-11 answers 5). The emulator behaves as the J-11 there; the tape was not run further.
- **Not modelled at all:** floating point (the kernel for the PSRAM boards is built with the distribution's switch for a machine without it), the cache and its registers beyond what Unix reads, memory on the Unibus itself, the red stack trap, and the registers the KDJ11-B's boot ROM uses.

## Repository layout

| Path | What it is |
|---|---|
| `images/` | Ready-to-flash UF2 files: `pico2w-v6/combined.uf2`, `picow-mini-unix/firmware.uf2` and `minix.uf2`, `picoplus2/combined.uf2`, `feather/combined.uf2`, with sizes and SHA-256 values in [images/README.md](images/README.md) |
| `media/unix/` | Unix distributions from the Unix Heritage Society archive: V6 root and source packs, the V7 tape (archive only), Mini-Unix tapes, 1BSD and 2BSD |
| `media/diagnostics/` | DEC MAINDEC and XXDP diagnostics, the ladder plan `ladder.txt` and `INDEX.md` |
| `media/papertape/` | DEC Absolute Loader and Single-User BASIC paper tape images, with a SIM-H configuration file |
| `media/README.md` | Sources and descriptions of everything in `media/` |
| `mini-unix.rk05` | The Mini-Unix RK05 disk image the Pico W pack is built from |
| `tools/` | Python host tools: `rk_image.py`, `tape2pico.py`, `tape_ladder.py`, `v6fs.py`, `rk_desk.py`, `rk11_model.py`, `pdp11asm.py`, `mmu_gen.py`, `psram_build.py`, `pack_install.py`, `board_session.py`, `psram_desk_check.py`, `v7ld.py`, `rkuboot.py` ([docs/TOOLS.md](docs/TOOLS.md)) |
| `J11_18MHz_KDJ11_BF/pico/`, `pico2/` | The firmware source for the RP2040 and the RP2350 (PureMetal; build with PureMetal Forge, which is not in this repository) |
| `docs/HOWTO.md`, `docs/TOOLS.md` | The how-to and the tool reference |
| `disk_boot_readme.md` | Notes on RK05 disk storage and starting Unix, from the original emulator |
| `boot-mini-unix.png`, `mini-unix-set-date.png` | Screenshots used on this page |
| `EK-RK11D-OP-001.pdf`, `KL11_TeletypeControlManual.pdf`, `KW11-K_UsersMan.pdf` | DEC manuals for the RK11 disk controller, the KL11 teletype interface and the KW11-K clock |
| `Caldera-license.pdf` | The Caldera licence that covers the UNIX files |

## Building

- Flashing, terminal and Unix: [docs/HOWTO.md](docs/HOWTO.md).
- Your own disk image: [docs/HOWTO.md, section 7](docs/HOWTO.md#7-build-your-own-disk-image).
- The firmware and the shipped images, from source with PureMetal Forge: [docs/HOWTO.md, section 8](docs/HOWTO.md#8-build-the-firmware-and-images-with-puremetal-forge). The compiler's output is the same byte for byte from the same source, so the build reproduces the committed UF2 files; compare with the SHA-256 values in [images/README.md](images/README.md).
- The DEC diagnostics: [docs/HOWTO.md, section 9](docs/HOWTO.md#9-run-the-diagnostic-ladder).

## Credits and licences

- **This repository's own work is under the [MIT licence](LICENSE):** the PureMetal firmware source, the tools and the docs. **Third-party material keeps its own terms and is not covered by it:** the Unix distributions and the disk images and UF2 files built from them (Caldera licence, [Caldera-license.pdf](Caldera-license.pdf), which also covers `tools/rkuboot.py`); the DEC manuals and diagnostics; and the files serialcomms contributed (the Mini-Unix pack `mini-unix.rk05`, `disk_boot_readme.md`, the two screenshots, the manuals and the paper tape files in `media/papertape/`; `git log --author=serialcomms` lists them).
- The original C emulator is by **serialcomms**: [Serialcomms/Pico-PDP11-Pimoroni-RISCV-Staging](https://github.com/Serialcomms/Pico-PDP11-Pimoroni-RISCV-Staging). This repository holds the PureMetal work split out of that repository, with its history.
- **UNIX:** the UNIX files in `media/unix/`, in the disk packs and in `images/` are covered by the Caldera licence ([Caldera-license.pdf](Caldera-license.pdf)). They come from the Unix Heritage Society archive (tuhs.org). The two Berkeley archives (1BSD, 2BSD) predate the BSD licence text and carry no separate licence file; they are kept as TUHS distributes them, with the University of California, Berkeley credits in their own READ_ME files. `tools/rkuboot.py` reproduces V7's `/mdec/rpuboot.s` and is covered by the same licence.
- **DEC material:** the diagnostics in `media/diagnostics/` are Digital Equipment Corporation diagnostics, from bitsavers.org and pcjs.org, kept here for testing the emulator. The paper tape images in `media/papertape/` come from <http://iamvirtual.ca/PDP-11/Basic-11/>. See [media/README.md](media/README.md).
- **Questions and news:** <https://forum.ajtaji.com>
