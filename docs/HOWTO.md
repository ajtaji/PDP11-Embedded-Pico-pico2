# How to use the PDP-11 emulator

Step-by-step instructions for the [PDP-11 emulator for the Pico W and Pico 2 W](../README.md): flash a board, select a panel, change fonts live, connect a terminal, boot Unix, set the date, re-flash without the button, build your own disk image and build the firmware.

| Step | Section |
|---|---|
| Put the emulator on a board | [2. Flash the Pico 2 W](#2-flash-the-pico-2-w-rp2350), [3. Flash the Pico W](#3-flash-the-pico-w-rp2040-two-steps) |
| See its console | [4. Panel and USB console](#4-panel-and-usb-console) |
| Choose a screen, font or sound module | [13. Panels, live TrueType fonts and sound](#13-panels-live-truetype-fonts-and-sound) |
| Use Unix | [5. Boot and use Unix](#5-boot-and-use-unix) |
| Re-flash without the button | [6. Re-flash without the BOOTSEL button](#6-re-flash-without-the-bootsel-button) |
| Your own disk | [7. Build your own disk image](#7-build-your-own-disk-image) |
| Your own firmware | [8. Build the firmware and images with PureMetal Forge](#8-build-the-firmware-and-images-with-puremetal-forge) |
| All of it from the IDE, no command line | [11. Flash and build from the PureMetal Forge IDE](#11-flash-and-build-from-the-puremetal-forge-ide) |
| Run the DEC diagnostics | [9. Run the diagnostic ladder](#9-run-the-diagnostic-ladder) |
| A board with PSRAM | [10. The PSRAM boards](#10-the-psram-boards) |
| Seventh Edition Unix, floating point | [12. Seventh Edition (V7) on the Pico Plus 2 W](#12-seventh-edition-v7-on-the-pico-plus-2-w) |

## 1. What you need

| For | You need |
|---|---|
| Running it | A Raspberry Pi Pico 2 W or a Pico W, a USB cable that carries data, and a serial terminal program on the host |
| Building a disk image | Python 3 (the tools are Python scripts in `tools/`; see [TOOLS.md](TOOLS.md)) |
| Building the firmware | Python 3 and PureMetal Forge (`PureMetalForge.exe`), the compiler. It is not in this repository; the forum is at <https://forum.ajtaji.com> |

The ready-to-flash files are in `images/`:

| Board | Files | Runs |
|---|---|---|
| Pico 2 W (RP2350) | `images/pico2w-v6/combined.uf2` | Sixth Edition Unix (V6), memory management on |
| Pico W (RP2040) | `images/picow-mini-unix/firmware.uf2`, then `images/picow-mini-unix/minix.uf2` | Mini-Unix |

Sizes and SHA-256 values are in [images/README.md](../images/README.md).

## 2. Flash the Pico 2 W (RP2350)

One file, one copy.

1. Hold the board's **BOOTSEL** button while plugging it into USB.
2. A drive named `RP2350` appears.
3. Copy `images/pico2w-v6/combined.uf2` onto it.
4. The board writes the file and restarts by itself. `combined.uf2` holds the firmware and the V6 disk pack together.

## 3. Flash the Pico W (RP2040), two steps

The Pico W takes **two files in two separate BOOTSEL sessions**. On the RP2040 a single combined file leaves the disk area unwritten (the start-up line then says `RK0: no pack`), so the firmware and the pack are flashed separately.

1. Hold **BOOTSEL** while plugging the board into USB. A drive named `RPI-RP2` appears.
2. Copy `images/picow-mini-unix/firmware.uf2` onto it. The board restarts.
3. Enter BOOTSEL again (the button, or the phrase in [section 6](#6-re-flash-without-the-bootsel-button)). The `RPI-RP2` drive appears again.
4. Copy `images/picow-mini-unix/minix.uf2` onto it. The board restarts into Mini-Unix.

If the start-up line says `RK0: no pack`, the second file is missing: repeat steps 3 and 4.

<a id="4-connect-a-serial-terminal"></a>

## 4. Panel and USB console

The default LAFVIN ST7796 panel shows the boot messages and Unix console without opening a serial terminal. For the wiring and other panels, see [section 13](#13-panels-live-truetype-fonts-and-sound). USB serial remains available for keyboard input and a second view: a COM port on Windows, `/dev/ttyACM0` or similar on Linux.

| Setting | Value |
|---|---|
| Speed | 115200 (the rate does not matter: it is USB) |
| Data / parity / stop | 8N1 |
| Line endings | CR, LF and CR LF are all accepted; pasted text is fine |

With panel output enabled, boot proceeds without waiting for a USB terminal. If you select the `none` panel profile, the firmware waits up to 30 s for the serial port before starting. Open the port during that interval to capture the first serial lines.

Linux example (minicom, as in the screenshots below):

```
minicom -D /dev/ttyACM0
```

On a Pico 2 W the `#` prompt appears 3.4 s after the port opened (2 s of that is the Esc wait); on a Pico W, 3.2 s.

## 5. Boot and use Unix

### Automatic boot

Each board powers up into Unix with no typing. The Pico 2 W prints:

```
PDP-11 J-11 on Pico 2: serial tape reader ready
RK0: v6root, 4872 blocks, swap 4000-4871 in RAM, READ-ONLY: the flash is never written
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 556
#
```

The Pico W prints the same, with `mini-unix` and `rkmx`, and Western Electric's "RESTRICTED RIGHTS" notice before the `#`.

![Mini-Unix on a Pico W: the @rkmx boot, the RESTRICTED RIGHTS notice, then a directory listing at the # prompt (minicom on Linux)](../boot-mini-unix.png)

### Boot by hand from the console

Press **Esc** within 2 s of the `auto-boot:` line. The board then stays in the firmware's own console instead of booting. There:

| Type | What it does |
|---|---|
| `BOOT RK0 173030` | Boots the disk pack by hand. The switch register value 173030 (octal) selects single-user mode |
| `rkunix` (Pico 2 W, V6) or `rkmx` (Pico W, Mini-Unix), at the `@` prompt | Names the kernel to start, in lower case |

The `@` prompt repeats if the kernel name is not on the disk. Do not boot an unsupported kernel: the system may hang. The diagnostic tools (`tools/tape_ladder.py`) can load paper tapes from this console.

### Logging in

There is no login and no password. Boot is complete at the `#` prompt, where you are root in single-user Unix. Normal Unix commands can be entered from there.

### Upper and lower case

Both systems print in capitals: their terminal setting assumes an upper-case-only terminal. Type in lower case. On Mini-Unix, `stty -lcase` switches the output to mixed case (as the screenshots show).

### Pasting text

A file can be pasted into `cat >name` at any speed: see
[Pasting text](../README.md#pasting-text) in the README for what was
measured on both boards and what Unix itself still limits (`#`, `@`,
capitals, lines over 255 characters). `stty -lcase` first keeps capitals.

### Set the date and time

Optional. The `date` command takes the date as `MMDDhhmmYY`, with a **two-digit year** (it is not Y2K compliant). For 22 September, 10:00, year 98:

```
# date 0922100098
```

The system answers `Tue Sep 22 10:00:00 EDT 1998`, and `date` on its own then shows the clock running.

![Mini-Unix: DATE 0922100098 sets Tue Sep 22 10:00:00 1998, and a later date shows 10:00:08](../mini-unix-set-date.png)

### V6 notes (Pico 2 W)

- `ps` works.
- `df` with no argument looks for V6's built-in `/dev/rk2` and `/dev/rp0`, which this machine does not have: type `df /dev/rk0`.
- `cc` and `dc` run: the machine has 152 KB (`mem = 556`).

### Live statistics

Type **Ctrl-]** then `s` at any time. The firmware prints a block with the clock (measured at start-up), the emulated instructions per second, memory in use, disk reads and writes, RAM overlay use, the line clock, uptime, what each core does, and the longest gap between two USB services since the banner. These two keys never reach Unix (Ctrl-] twice sends one Ctrl-] through).

### Shutting down

Unplug at any time. On these boards the emulator never writes the flash (the PSRAM boards' images save: section 12): every disk write, the swap area included, goes to RAM and is lost at power-off, and the next power-up starts from the pack as flashed. `sync` does no harm but saves nothing across a power cycle.

### If something looks wrong

| You see | Meaning |
|---|---|
| Nothing printed | The port was opened late, or the board is not running the firmware. Reconnect, and open the port within 30 s of power-up |
| `RK0: no pack` (Pico W) | Only `firmware.uf2` was flashed. Flash `minix.uf2` as well ([section 3](#3-flash-the-pico-w-rp2040-two-steps)) |
| `@` repeated | The kernel name typed is not on the disk |
| `[RK0: the RAM overlay for file writes is full ...]` | The RAM for file writes is used up; power off to start clean (see [Known limits](../README.md#known-limits)) |
| `panic: out of swap space` (V6) | A session needed more than the 112-block swap RAM disk; power off to start clean |

## 6. Re-flash without the BOOTSEL button

A board already running this firmware enters BOOTSEL when it receives this text on its serial port:

```
ResetPicoToBootSel1254
```

Send it from any terminal program, or from a script that writes the text to the port. The BOOTSEL drive appears and you can copy a UF2 as in sections 2 and 3. This is also the quick way to reach the second BOOTSEL session on a Pico W.

## 7. Build your own disk image

`tools/rk_image.py` turns an RK05 disk image into a UF2 that writes the board's flash disk region and leaves the firmware alone.

**Where things are in the flash.** On every RP2350 board the program is below 0x10200000, 0x10200000 to 0x1023FFFF is never used by the PDP-11 (a board with a radio keeps the radio chip's firmware there, and it survives a pack being installed), and the packs start at 0x10240000: RK0 there, RK1 at 0x104C0000 on the boards with 8 MB of flash or more. The addresses are in one file, `J11_18MHz_KDJ11_BF/pico2/flash_layout.pico2`, which the firmware and the pack installer are compiled with and the tools read. The Pico 2 W's 4 MB leave 1.75 MB for RK0, so a pack is stored mapped there (only the blocks in use). The Pico W (2 MB) keeps its pack at 0x10040000: the Pico W image uses the flash where the radio's firmware would go; a Pico W running it cannot use its radio.

 All the Python tools are described in [TOOLS.md](TOOLS.md).

1. **Get an RK05 image.** The Unix packs are in `media/unix/` (`v6root.gz` is gzipped; `mini-unix.rk05` is in the repository root). Unzip a `.gz` first.
2. **Look at it.** `info` prints the size, the Unix file system (V6 or V7), the blocks in use and how many fit each chip:

   ```
   python tools/rk_image.py info mini-unix.rk05
   ```

3. **Change it (V6 only).** `tools/v6fs.py` reads and changes a V6 file system inside the image: `ls`, `cat`, `mknod`, `ln`, `rm`, `patch` and `check`. Each changing command writes the whole image to `-o`.

   ```
   python tools/v6fs.py ls    IMAGE /dev
   python tools/v6fs.py check IMAGE
   ```

4. **Pack it.** Choose the chip, the layout and what boots:

   ```
   python tools/rk_image.py pack IMAGE --chip pico|pico2 -o OUT.uf2
          [--layout auto|dense|mapped] [--blocks N] [--name TEXT]
          [--swap auto|LO,N|none] [--boot-block FILE|@/PATH]
          [--autoboot KERNEL[,SWITCHES]]
   ```

   - `--layout dense` stores block n in slot n (a full 4872-block pack fits the Pico 2 W). `mapped` stores only the blocks in use (Mini-Unix on the Pico W). The default picks dense when it fits.
   - `--swap` names the swap area, which the firmware keeps in RAM.
   - `--autoboot rkunix` makes the pack boot at power-up: `BOOT RK0` with the switch register at 173030, then the kernel's name typed at the boot block's `@`.
   - `--boot-block @/usr/mdec/rkuboot` copies that file from the image's own V6 file system into block 0 (the V6 root pack has no boot block of its own).
   - `--firmware diag.bin --combined OUT.uf2` writes firmware and pack as one UF2 (Pico 2 W). `--firmware-uf2 OUT.uf2` writes the firmware alone (the Pico W's first file).

5. **Flash it** as in sections 2 and 3. A pack-only UF2 goes onto a board that already has the firmware.

Limits: RK05 packs only (up to 4872 blocks), drive 0 only (RK1 as well on the PSRAM boards), the firmware below 0x10200000 (under 256 KB on the Pico W), V6 only for `v6fs.py`. A complete worked example is in section 8.

Under Git Bash on Windows, put `MSYS_NO_PATHCONV=1` in front of any command with an argument that starts with `/` or `@/`, or Git Bash will turn it into a Windows path.

## 8. Build the firmware and images with PureMetal Forge

To flash a board and to change and rebuild the firmware **from the IDE alone**, see [section 11](#11-flash-and-build-from-the-puremetal-forge-ide). The command lines below build the disk images too.

You need Python 3 and the PureMetal compiler (`PureMetalForge.exe`), the
release build from compiler main `b9b70ed1` or later: the firmware keeps the
lazy N/Z flags in r4 (`#RESERVE_MORE = 1` in `cpu.pico(2)`), and the
dispatch tails are assembly blocks that name the reserved registers
(`ASM Uses`; `#ASM_TAILS = 1` in `pico/instructions.pico` and in
`pico2/cpu.pico2`) and asks the USB serial library for receive flow control
(`#USB_RX_HOLD = 1` in `diag.pico(2)`), which that release has. From the
repository root:

**Pico 2 W, V6** (`images/pico2w-v6/combined.uf2`):

```
python tools/tape2pico.py --empty
cd J11_18MHz_KDJ11_BF/pico2
PureMetalForge.exe --compile diag.pico2 -t rp2350 -o diag.bin
python -c "import gzip,shutil; shutil.copyfileobj(gzip.open('../../media/unix/v6root.gz'), open('v6root.rk','wb'))"
python ../../tools/v6fs.py mknod v6root.rk /dev/rk0 b 0 0 -o v6root.rk
python ../../tools/v6fs.py mknod v6root.rk /dev/rrk0 c 9 0 -o v6root.rk
python ../../tools/v6fs.py mknod v6root.rk /dev/swap b 0 0 -o v6root.rk
python ../../tools/v6fs.py rm v6root.rk /unix -o v6root.rk
python ../../tools/v6fs.py ln v6root.rk /rkunix /unix -o v6root.rk
python ../../tools/v6fs.py patch v6root.rk /rkunix _nswap 112 -o v6root.rk
python ../../tools/v6fs.py check v6root.rk
python ../../tools/rk_image.py pack v6root.rk --chip pico2 --blocks 4872 --boot-block @/usr/mdec/rkuboot --swap 4000,112 --name v6root --autoboot rkunix --firmware diag.bin --combined combined.uf2 -o v6root.uf2
```

The `v6fs.py` lines give V6 the device nodes `ps` and `df` need, make
`/unix` the kernel that actually runs (`ps` reads its symbols from
`/unix`), and size the kernel's swap to the firmware's swap RAM disk.

**Pico W, Mini-Unix** (`images/picow-mini-unix/firmware.uf2`, `minix.uf2`):

```
python tools/tape2pico.py --empty
cd J11_18MHz_KDJ11_BF/pico
PureMetalForge.exe --compile diag.pico -t rp2040 -o diag.bin
cp ../../mini-unix.rk05 minix.rk05
python ../../tools/v6fs.py ln minix.rk05 /rkmx /rkmx.dist -o minix.rk05
python ../../tools/v6fs.py rm minix.rk05 /rkmx -o minix.rk05
python ../../tools/v6fs.py put minix.rk05 ../../media/unix/rkmx-slotswap /rkmx --mode 0777 -o minix.rk05
python ../../tools/v6fs.py rm minix.rk05 /mx -o minix.rk05
python ../../tools/v6fs.py ln minix.rk05 /rkmx /mx -o minix.rk05
python ../../tools/v6fs.py check minix.rk05
python ../../tools/rk_image.py pack minix.rk05 --chip pico --name mini-unix --autoboot rkmx --firmware diag.bin --firmware-uf2 firmware.uf2 -o minix.uf2
```

The `v6fs.py` lines put in Mini-Unix's kernel with swap by process slot
(`media/unix/rkmx-slotswap`, 2026-10-20). The distribution's kernel swaps
each process to a place chosen by its process number, which moves on with
every new process, so the swap area is walked from end to end; on the Pico W,
whose swap lives in a 124-block RAM overlay that keeps every block once
written, the overlay was full after about three commands and Unix then saw a
disk error. The new kernel is the distribution's own, built on a board from
its own sources with three lines changed (`docs/minix/build-rkmx.txt`; the
same build without the change gives the distribution's `/rkmx` byte for
byte); ten `od` runs and more now leave the overlay at 53 of 124 blocks
(`docs/minix/transcript-picow-swap-proof.txt`). The distribution's kernel
stays on the pack as `/rkmx.dist`; `/mx`, whose symbols `ps` reads, is
linked to the kernel that runs.

The current release extends this earlier setup with a 63 KB compressed overlay
and a J-11 Mini-Unix kernel providing real pipes. For the current kernel,
source patch, on-board build and fallback instructions, use
[the kernel and overlay guide](minix/j11-pipes.md). The 124-block figures above
describe the earlier firmware.

The compiler's output is reproducible with the same source, compiler, board profile and options. The current builds use the runtime source and compiler hash in `images/manifest-2026-10-26.json`; follow `images/README.md` for the current build commands and SHA-256 values. The firmware's
defaults (`#DISK_BACKEND = 2`, `#DISK_READ_ONLY = 1`, `#DESK_PROBE = 0` at
the top of `diag.pico(2)`) are the ones the images use.

To try an image on the desk emulator instead of a board, add
`--desk desk.bin` to the `rk_image.py` line and run `desk.bin` in the
PureMetal ARM emulator (`arm_run.exe desk.bin rp2350 1500000000 host=open`).

## 9. Run the diagnostic ladder

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

## 10. The PSRAM boards

**Current images (2026-10-26).** `images/picoplus2/combined.uf2` and `images/feather/combined.uf2` contain the updated panel/font firmware and unchanged V6 packs, and were run on both boards. Their `firmware.uf2` downloads update an existing V6 or V7 installation without replacing the packs. The packs start at 0x10240000 and 0x104C0000; the saved-change store remains in the top 1 MB of flash.

The supplied V6 kernel on the Pimoroni Pico Plus 2 W and Adafruit Feather RP2350 HSTX uses an 18-bit address space (up to 248 KB); the firmware provides 3812 KB for 22-bit guests. The V7 pack asks for 2040 KB. Their images are `images/picoplus2/combined.uf2` and `images/feather/combined.uf2`.

**With the boot drive.** Hold BOOT while plugging the board in and copy the board's `combined.uf2` to the drive, as in section 2.

**With no button and no drive** (the way the boards here were loaded). The board must be running a program with PureMetal's USB serial (any PureMetal example, or this firmware). The board is named by the USB hub port it is plugged into (`--hub-port N`) or by its USB serial number (`--usb-serial TEXT`), never by a COM number.

1. First time on a board, test one flash sector and read the flash chip's ID:

   ```
   python tools/pack_install.py --board picoplus2 --image images/picoplus2/combined.uf2 --hub-port 9 --compiler PureMetalForge.exe --probe
   ```

   It builds the installer (`pico2/packinstall.pico2`), uploads it through the compiler, and prints the chip (`JEDEC ID EF 40 18 ... 16 MB; size measured by address wrap: 16 MB`) and `test sector at 0x4B4000: programmed, read back the same, erased again, reads blank`. The installer needs PureMetal Forge main `0d2b796dd` or later (`FlashJedecIdRead()` in `RP2350/Lib/flashid.pico2`).
2. Send the packs (the installer is running, so no `--compiler`):

   ```
   python tools/pack_install.py --board picoplus2 --image images/picoplus2/combined.uf2 --hub-port 9
   ```

   About 12 s a pack. Each ends `flash checksum 21C285A3 5CA82BF0 = the file's`. A run that stops part way leaves the region marked; run the line again and only the missing sectors are sent.
3. Build the firmware and upload it through the compiler:

   ```
   python tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe --hub-port 9
   ```

   A firmware upload writes only the firmware's own sectors: the packs stay. The start-up line `pack checksums: RK0 ... RK1 ...` must show the values of step 2 (`pack_install.py --sums` prints the file's).

**The proof session.** `tools/board_session.py` types a script at the Unix prompt on one open of the port and times each step:

```
python tools/board_session.py --hub-port 9 --script docs/psram/proof.txt --out transcript.txt
```

`docs/psram/proof.txt` checks `mem = 1036`, runs `ps`, `df /dev/rk0`, mounts RK1, types and compiles a C program and runs it, times `od /rkunix` twice and takes the statistics block. `docs/psram/swap.txt` keeps twelve 30 KB processes alive at once. The transcripts of both boards are beside them.

**V6 notes for these boards.** `stty -lcase` first if you type C: in upper-case mode `\n` in a string arrives as `N`. `#` and `@` are V6's erase and kill characters. Everything written is lost at power-off unless it is saved: firmware built from the source of 2026-10-22 on - `images/picoplus2/combined.uf2` and `images/feather/combined.uf2` have it - saves both packs' changes into the flash by itself, or at once with `sync`, then Ctrl-] and `w` (section 12, Saving).

## 11. Flash and build from the PureMetal Forge IDE

Everything for the **Pico 2 W** and the **Pico W** can be done in the PureMetal Forge IDE (the OpenGL IDE or the Standard one; the menus are the same), with no command line and no BOOTSEL button once the board runs a PureMetal program. The IDE's upload resets the board, copies the file and waits for it to come back, as for any PureMetal program.

**Flash the ready images** (section 2 and 3 without the button):

1. Plug in the board. If it is new or runs something that is not PureMetal, hold BOOTSEL while plugging it in, this once.
2. **Board** menu: choose **Raspberry Pi Pico 2 W** or **Raspberry Pi Pico W**.
3. **Compiler > Flash Prebuilt File...**, and choose:
   - **Pico 2 W:** `images/pico2w-v6/combined.uf2`. The board restarts into V6.
   - **Pico W:** `images/picow-mini-unix/firmware.uf2`, and when it is done, **Flash Prebuilt File...** again with `images/picow-mini-unix/minix.uf2`. The board restarts into Mini-Unix.
4. Open the board's serial port (section 4). It boots Unix by itself.

A ready UF2 is sent exactly as it is, so the firmware and the disk pack land where the file says.

**Change the firmware and put it on the board:**

1. **File > Open** `J11_18MHz_KDJ11_BF/pico2/diag.pico2` (Pico 2 W) or `J11_18MHz_KDJ11_BF/pico/diag.pico` (Pico W). If the Board menu then shows the board without the W (Raspberry Pi Pico 2, or Pico), that is fine: same chip, same build, same upload.
2. **Compiler > Compile + Upload.** The firmware goes on the board and **the disk pack already there is kept**: the upload writes only the firmware's part of the flash. The board restarts and boots Unix from the pack.

So a board needs the ready image once (above), and after that every change is Compile + Upload. For byte-for-byte reproduction, use the same compiler and build command recorded in [the image documentation](../images/README.md). Board profile, source filename and build options must match; the image manifest records the runtime source and compiler hash.

`tape_image.pico` and `tape_image.pico2` are in the repository as the **empty** tape, which is what Unix and the serial tape reader use, so the firmware compiles as it comes. Building a diagnostic tape in (section 9, `tools/tape2pico.py TAPE`) replaces them; run `python tools/tape2pico.py --empty`, or check the two files out again, before going back to Unix.

**The Pimoroni Pico Plus 2 W** (8 MB PSRAM, section 10) the same way: choose **Pimoroni Pico Plus 2 W** in the Board menu, **Flash Prebuilt File...** with `images/picoplus2/combined.uf2` once, then open `J11_18MHz_KDJ11_BF/pico2/diag.pico2`, **choose Pimoroni Pico Plus 2 W again** (opening the file selects a Pico 2), and **Compile + Upload**. With that board chosen, `diag.pico2` builds the PSRAM firmware by itself (chip select GPIO47, 16 MB of flash; the board's 48 GPIOs pick it); with any other board it builds the Pico 2 W firmware. The firmware built this way is not byte for byte the one in `images/picoplus2/` (that one is built by `tools/psram_build.py`, against the Pico 2's board file), and it ran `docs/psram/proof.txt` on a Pico Plus 2 W with the same results: `mem = 1036`, both drives, the C compiler, `od /rkunix` 10.44 s, no clock tick dropped (`docs/psram/transcript-picoplus2w-ide-build-proof.txt`); and the whole DEC diagnostic ladder of section 9 gives what `ladder.txt` expects, 17 PASS and the two HALTs that are right for a J-11 (`docs/psram/transcript-picoplus2w-ide-build-ladder.txt`).

**What still needs Python:** a disk pack of your own (section 7) and the Adafruit Feather RP2350's firmware (`tools/psram_build.py --board feather`; the IDE has no Feather board).

A Compile in the IDE leaves `diag.bin`, `diag.uf2` and the like beside the source; the repository ignores them.

Checked 2026-10-20 with the release compiler of 2026-10-19, on a Pico 2 W and a Pico W from a fresh clone, and on a Pico Plus 2 W as above: the ready images through the IDE's upload job, then the firmware compiled from the clone and uploaded on top; both boards kept their packs and booted Unix (V6 `mem = 76`; Mini-Unix `#`).

## 12. Seventh Edition (V7) on the Pico Plus 2 W

V7 runs on the PSRAM boards, where it gets 2 MB, with the J-11's floating
point unit (FPJ11, `pico2/fp11.pico2`), which V7's C compiler needs.

**Flash the ready image.** `images/picoplus2-v7/combined.uf2`: hold BOOT,
plug the board in, copy the file to the drive (section 10 has the way with no
button). It is the PSRAM firmware with V7's two disks: RK0, the root file
system and kernel; and an RP03 on an RP11 controller holding the whole `/usr`
of the distribution - sources, documents, the dictionary, games - on
`/dev/rp3`, where V7 shipped it.

**On the Adafruit Feather RP2350 HSTX** flash `images/feather-v7/combined.uf2`
the same way. Everything below holds for it but the RP03: its 8 MB of flash
cannot hold the whole `/usr`, so `/usr` is a 4,000-block RK1 (the libraries,
nroff's macros, the manual, the headers), which `/etc/rc` mounts in
multi-user and `/etc/mount /dev/rk1 /usr` mounts in single-user. It is built
with `v7_pack.py -o v7root.rk --usr v7usr.rk` and `rk_image.py pack v7root.rk
--chip feather ... --drive1 v7usr.rk` (the build lines below, with those
changes).

**It boots by itself.** Open the board's serial port; after the banner:

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

The pack asks for 2040 KB (V7 counts memory in a signed number of 64-byte
clicks, so 2048 KB would read as negative); the firmware types `boot` at the
boot block's `@` and the kernel's name at `/boot`'s `:`. `#` is the
single-user shell, root, in lower case. To boot by hand instead, press Esc,
then `MEM 2040`, `BOOT RK0`, type `boot` at the `@` and `rk(0,0)rkunix` at
the `:`. The banner's `RP03 drive 0 on the RP11` part says the RP disk was
found.

**Single-user.** Mount `/usr` with `/etc/mount /dev/rp3 /usr`. `df` lists
both disks. DEL interrupts a program.

**Multi-user.** Ctrl-D at the single-user `#`: `/etc/rc` mounts `/dev/rp3`
on `/usr` and prints `login:`. Log in as `root` (no password). `/etc/rc`
empties `/tmp` and `/usr/tmp` at each multi-user start, as V7 always did.

**Set the date** with `date yymmddhhmm`: a year from 70 to 99 is 19yy, from
00 to 69 is 20yy (`/bin/date` was rebuilt on the board for that; V7's
library prints years past 1999 correctly).

**Saving.** Everything Unix writes goes to the PSRAM copies of the disks,
and is saved into the flash **by itself**: a few seconds after the disks go
quiet (V7 syncs every 30 s), at most every 20 s, the blocks that changed are
written to the store, the top 1 MB of the flash. The PDP-11 waits a fraction
of a second; nothing is printed unless something goes wrong. To save at once
- before unplugging, say - type `sync`, then Ctrl-] and `w`:

```
# sync
[saving the packs' changes to flash: 2 changed 4 KB sectors and 0 RP blocks; the PDP-11 waits until it is done]
[saved: 5 changed blocks into the store, 1 sectors written, in 70 ms; the store holds 15 of its 1792 slots]
```

The next power-up copies the disks from the flash and then the newest saved
copy of every block over them, and says how many in its banner (`the store:
434 saved blocks copied over the packs`). The store never writes over what it
holds: a save goes into free sectors, a sector's contents are said in its
header, written last, and an old sector is erased only after what is still
live in it has been copied out - so a power cut during a save loses that save,
never one before it. The erases go round all 256 sectors, so a flash sector
(good for about 100,000) lasts many years of saves.

When the store fills (about 1,500 changed blocks, some 750 KB of different
blocks since the disks were flashed), or the RP disk's 3,888 PSRAM slots do,
the save is a **fold**: everything that changed is written into the disks'
own places in the flash, the store starts again empty, and the console says
`folded into the packs` (about 15 s for 1,500 blocks). Ctrl-] then `s` shows
the store's state. Flashing new disk packs starts a new store; the old one's
sectors are erased as they are wanted.

**What works** (each tried on the board): the shell and the root's
commands, `cc` with floating point (constants, `double`, `-lm`), `awk`,
`dc`, `adb`, `ps`, `who`, `man` and `nroff`, raw I/O on `/dev/rrp3`,
`icheck` and `dcheck` of `/dev/rp3`.

**Build it yourself** (from the V7 tape in `media/unix/`; `tools/v7_pack.py`
in [TOOLS.md](TOOLS.md) says what it does and why it patches `/boot` and
the kernel; `media/unix/v7/build-on-board.txt` has the four files V7 built
for it on a board: the kernel's configuration with the RP03, the RP03
driver asking for the Unibus map on raw transfers, and `date`):

```
python tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe --out build_picoplus2
python tools/v7_pack.py -o v7root.rk --usr-rp v7usr-rp.img
python tools/rk_image.py pack v7root.rk --chip picoplus2 --blocks 4872 --swap 4000,872 --name v7root --autoboot boot,0 --autoboot-then "::rk(0,0)rkunix" --autoboot-mem 2040 --rp v7usr-rp.img --firmware build_picoplus2/diag.bin --combined v7-combined.uf2 -o v7root.uf2
```

`--rp` stores the RP file system mapped (only the blocks that hold
something) where RK1 would go; it is 20,800 blocks, so that every block of it
can always have a place in the flash. `v7_pack.py --usr v7usr.rk` with
`--drive1 v7usr.rk` instead gives the older layout, a 4,000-block `/usr` on
RK1. `--add DIR:/path` copies a directory of your files onto the root pack (a
directory under `/usr` there is covered by `/usr` once it is mounted). Send
`v7-combined.uf2` to the board's boot drive, or with no button as in section
10 (`pack_install.py --image v7-combined.uf2`, then the firmware with
`psram_build.py`). A firmware upload alone keeps the disks, and what was saved
on them.

**On the Pico 2 W (no PSRAM): it runs, with a limit.** `python tools/v7_pack.py -o
v7p2w.rk --pico2w` makes a root pack that fits the Pico 2 W's flash (it leaves out
Fortran, the typesetting programs and the uucp and mail-transfer programs) and gives
V7 a 700-block swap area; pack it with `rk_image.py pack v7p2w.rk --chip pico2 --swap
4000,112 --name v7root --autoboot boot,0 --autoboot-then "::rk(0,0)rkunix" --firmware
diag.bin --combined v7p2w.uf2 -o v7p2w-pack.uf2`. Tried on a Pico 2 W (2026-10-22): it
boots by itself to `#` with `mem = 79360` (77 KB for programs), `df`, `dc`, `ps`,
multi-user and `login`, `cc` builds and runs a `double` program (4 s), and `time od
/unix` takes 15.0 s - as on the Pico Plus 2 W. The limit is the RAM for writes: with
77 KB for programs V7 swaps a lot, and its swap and `/tmp` together outgrow the 112-block
swap RAM disk and 254-block write overlay after two or three compiles; from then on
writes are refused (the statistics block says `FULL`). Nothing is saved on this board.
V7's fork() wants swap room for a whole 128 KB process (`ctod(MAXMEM)`, 256 blocks) even
though it writes nothing there, which is why the swap area is 700 blocks and not the
RAM disk's 112: with 112, init can never fork a shell.

**A floating point benchmark.** E. J. Olson's `givens` from the pichart
suite ([givens-pdp.tar](https://fractal.math.unr.edu/~ejolson/pi/pichart/givens-pdp.tar))
builds unchanged:

```
python tools/v7_pack.py -o v7root.rk --usr v7usr.rk --add givens-pdp:/givens
...
# cd /givens
# cc -O -DKANDR -DASCII -c weyl32.c
# cc -O -DKANDR -DASCII -c tictoc.c
# cc -O -DKANDR -DASCII -o givens givens.c weyl32.o tictoc.o -lm
# time ./givens
```

It solves least-squares systems of growing size in double precision, checks
each against a golden run, and prints FLOPS per size; it ends at 63x63 with
`Error allocating 31752 bytes for A!` (a PDP-11 process has 64 KB of data).

Dhrystone, Whetstone and the BYTE Sieve, and how to run them, are in
[BENCHMARKS.md](BENCHMARKS.md).

## 13. Panels, live TrueType fonts and sound

The 2026-10-26 images enable the panel console by default on both Pico W and
Pico 2 W. The PSRAM firmware includes the same output modules. USB serial
continues to accept keyboard input, tape-loader commands and firmware uploads.

**Choose a screen without rebuilding.** Flash the settings UF2 for your chip
and panel from [images/output-settings](../images/output-settings/), using
**Compiler > Flash Prebuilt File...** or BOOTSEL. For example, use
`rp2040-ili9341.uf2` with an ILI9341 on a Pico W. Use `rp2350-none.uf2` on a
headless RP2350 board. Settings survive firmware-only updates; they take effect
after reboot and occupy a dedicated sector outside the Unix pack. To restore
the standard screen, flash the chip's `lafvin` settings file. The resident
profiles and wiring are listed in [OUTPUTS.md](../OUTPUTS.md).

**Change fonts live.** Press Ctrl-], release it, then `f` to switch between
Lato-derived Terminal Sans and the monospace face. Use Ctrl-] then `+` or `-`
to change the pixel size. The screen reflows and Unix keeps running. The Pico
reads actual TrueType outlines and rasterizes glyphs at the selected size.
The 4 KB glyph cache bounds the sizes available; a request that does not fit
is refused and the previous font is regenerated. These live choices reset
to the boot font after a restart. The default is Lato-derived 14 pixels.

To generate a compact boot setting or another configuration:

```text
py -3 tools/output_config.py --target rp2350 --panel lafvin --font compact --out settings.uf2
```

**Sound.** Ready builds are silent. Source builds can link the Bluetooth
backend or a custom signed 16-bit mono PCM sink at 48 kHz. The included custom
sink is a silent meter example. Console BEL and both Pico demo profiles' voices use
the same producer. See [OUTPUTS.md](../OUTPUTS.md) for build flags, runtime
settings, memory costs and the RP2040 pack/radio overlap restriction.

**Graphics demo.** Flash [picow-demo/firmware.uf2](../images/picow-demo/firmware.uf2)
on RP2040 or [pico2w-demo/firmware.uf2](../images/pico2w-demo/firmware.uf2)
on RP2350. Each starts the built-in demo using the selected panel. The RP2040
profile has Bluetooth linked but starts silent; sound needs separate settings
and radio firmware. Its radio data overlaps Mini-Unix, so follow the backup
instructions in [OUTPUTS.md](../OUTPUTS.md) before enabling it. To return to
Unix, restore its pack if radio data replaced it, then flash the normal board
firmware. The demo's bounded animation counter keeps the plasma colors and
white logo sweep valid during long runs.

**V7 build workspace.** On the Pico Plus 2 W, mount `/dev/rp3` on `/usr`
before building programs there; on the Feather use `/dev/rk1`. The root RK05
is small, so keep larger builds under `/usr` and check free space with `df`.
V6's `cc` does not accept the V7 `-o` option: use `cc file.c` and run `a.out`
(or rename it). `cc file.c` also works on V7.


## RP2040 floating point

Install the current `picow-mini-unix/firmware.uf2`, then the current
`picow-mini-unix/minix.uf2` in a second upload. The firmware executes FP11
instructions directly; the new guest kernel saves FP registers across
process switches, resets them on exec and handles floating exceptions.

Compile ordinary Mini-Unix floating-point programs with `cc -f -O file.c`.
Existing FP11 binaries also use the direct implementation. F and D formats,
word/long conversions and the FPS rounding/exception modes are supported.
See [the kernel guide](minix/j11-pipes.md) for reproducible sources and tests.
