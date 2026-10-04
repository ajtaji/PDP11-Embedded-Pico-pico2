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
| Speed, measured on the boards (Pico 2 W 2026-10-04, Pico W 2026-10-03) | about 675,000 PDP-11 instructions per second under V6 (`od /rkunix` in 13.8 s); about 2,480,000 with memory management off | about 1,010,000 under Mini-Unix (`od /rkmx` in 5.9 s); about 2,590,000 on the bench loop |
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
terminal of the time could send. Measured in the emulator with a 35-line,
620-character C program pasted into `cat >pn.c` (2026-10-04), the firmware
in `images/pico2w-v6/` and `images/picow-mini-unix/` loses most of it, in
two places:

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

The source in this repository fixes both, and the builds in
`images/untested/` (see its README) carry the fix:

- **The receiver has a pace.** The next character is given to the PDP-11
  2000 instructions after the last one was read, or at once when the
  processor is in a WAIT (Unix has nothing left to do). The rest waits.
- **The host is held back.** While the queues are full the firmware stops
  accepting USB packets, the host waits and sends again. This is USB's own
  flow control: nothing to set in the terminal.

With both, the same paste is byte for byte identical however fast the host
sends it (emulator, both builds; the stats block, Ctrl-] then `s`, has a
`typed` line with the counts). These builds have not run on a board yet.

What remains is Unix's own, on any PDP-11:

- A single line longer than 255 characters is thrown away (the same
  `TTYHOG` test: Unix only hands a line to the program at its end).
- `#` erases the character before it and `@` erases the line, as on every
  V6 terminal. Type `\#` and `\@` to enter them, or change them with
  `stty`.
- While the terminal is in upper-case mode (the images' default) capitals
  are stored as lower case. `stty -lcase` first.

## PSRAM boards (untested on hardware)

Images for the Adafruit Feather RP2350 (8 MB PSRAM) and the Pimoroni Pico Plus 2 and Pico Plus 2 W are in [images/untested/](images/untested/README.md). They have run only in the PureMetal ARM emulator and are not yet tested on hardware; do not treat them as ready to flash until one has run on the board it names. With the PSRAM found, V6 reports `mem = 1036` instead of 76 and gets its whole swap area. Without it, they run as the Pico 2 W build does.

## Known limits

- **56 KB of PDP-11 memory** (000000-157777) plus the I/O page. V6 reports `mem = 76` at boot; about 15 KB is left for user programs once its kernel is in.
- **Writes live in RAM (RAM disks), in 512-byte blocks.**
  - Pico 2 W: a **swap RAM disk of 112 blocks** (56 KB, blocks 4000-4111 of the pack) and **38 blocks for file-system writes**. The V6 kernel in the image is patched to swap only there (`_nswap` = 112), so swap can never be refused. 112 blocks hold about three of V6's largest processes (about 33 blocks each) or many small ones; if a session ever needs more, V6 stops with its own "panic: out of swap space".
  - Pico W: **124 blocks shared** by swap and file writes. Mini-Unix gives each of its 13 process slots a fixed 66-block swap area (858 blocks by design) and has no swap size to patch, so this cannot be bounded in the Pico W's SRAM. Mini-Unix swaps whole processes, and after enough commands the blocks run out; keep Pico W sessions short.
  - When the file-write blocks are used up, a write to a new block fails: Unix sees a disk error, the console prints once `[RK0: the RAM overlay for file writes is full ...]`, and the statistics block shows `FULL: n writes refused`. Nothing already written changes and nothing reaches the flash; power off to start clean.
- **Nothing is saved across a power cycle.** Every disk write, the swap area included, goes to RAM; the next power-up starts from the pack as flashed. `sync` does no harm but saves nothing. (The flash-wear warnings in [disk_boot_readme.md](disk_boot_readme.md) concern emulators that write the flash; this firmware never does.)
- **V6 on the Pico 2 W:** `ps` works; `df` with no argument looks for V6's built-in `/dev/rk2` and `/dev/rp0`, which this machine does not have, so type **`df /dev/rk0`**. `dc` is too large for the 56 KB machine.
- **Seventh Edition (V7) is not supported.** Its kernel alone needs about 74 KB of memory (text 32,704 + data 1,854 + bss 39,812 bytes) and the emulated machine has 56 KB. The V7 tape (`media/unix/v7.tap.gz`), `tools/v7ld.py` and `tools/rkuboot.py` are kept as archive and reference only.
- **Packs:** RK05 only (up to 4872 blocks), drive 0 only; the firmware must be under 256 KB.
- **Mini-Unix:** a refused swap write can restart the shell.
- **Year 2000:** the `date` command takes a two-digit year.

## Repository layout

| Path | What it is |
|---|---|
| `images/` | Ready-to-flash UF2 files: `pico2w-v6/combined.uf2`, `picow-mini-unix/firmware.uf2` and `minix.uf2`, with sizes and SHA-256 values in [images/README.md](images/README.md) |
| `media/unix/` | Unix distributions from the Unix Heritage Society archive: V6 root and source packs, the V7 tape (archive only), Mini-Unix tapes, 1BSD and 2BSD |
| `media/diagnostics/` | DEC MAINDEC and XXDP diagnostics, the ladder plan `ladder.txt` and `INDEX.md` |
| `media/papertape/` | DEC Absolute Loader and Single-User BASIC paper tape images, with a SIM-H configuration file |
| `media/README.md` | Sources and descriptions of everything in `media/` |
| `mini-unix.rk05` | The Mini-Unix RK05 disk image the Pico W pack is built from |
| `tools/` | Python host tools: `rk_image.py`, `tape2pico.py`, `tape_ladder.py`, `v6fs.py`, `rk_desk.py`, `rk11_model.py`, `pdp11asm.py`, `mmu_gen.py`, `v7ld.py`, `rkuboot.py` ([docs/TOOLS.md](docs/TOOLS.md)) |
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
