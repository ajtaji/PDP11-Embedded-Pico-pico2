# Speed against other PDP-11 emulators on the RP2350

Part of the [PDP-11 emulator for the Pico W and Pico 2 W](../README.md). Each
emulator runs the same Sixth Edition Unix programs, typed by the same script,
on the same board at the same clock, and each step is timed from the host:
from the return that starts a command to the `#` after it.

## Pico_1140

[Isysxp/Pico_1140](https://github.com/Isysxp/Pico_1140) (commit `fd906ff`,
2025-08-24; GPL-3.0): a PDP-11/40, an updated version of Dave Cheney's CPP11
in C++, with an FP11 taken from SIMH. It is written for a SparkFun Thing Plus
(an RP2040 at 200 MHz, its disk images on an SD card).

**What was changed to run it here, and nothing else.** No SD card: the RK05
image is linked into the flash and its writes go to a RAM overlay of 256
blocks (a new `flashdisk.cxx` in place of the FatFs calls in `rk11.cxx`), and
`main()` boots RK0 at once instead of listing the card. FatFs is left out of
the build (a stub `ff.h` for the types the RK and RL classes name; the RL11 is
not attached). The second terminal (DL11) used USB serial port 1, which a
standard Pico SDK build does not have; it is its UART alone. The clock is
150 MHz, the RP2350's rated speed, in place of the 200 MHz its `main()` sets.
The processor emulation is not touched. Built with the Pico SDK 2.1.1 and Arm
GCC 14.2.1, `-O3` as its CMakeLists has it, for the Pico 2 (Arm cores).

**Board:** a Pimoroni Pico Plus 2 W (RP2350B), 150 MHz, for both. This
emulator ran its PSRAM build there: the firmware of commit `5064ad4` but for
that commit's last change, which touched only the run loop used with memory
management off (V6 runs in the other one).

**Disk:** Pico_1140's own `Unix_V6.RK05`, booted with its kernel `unix`; this
emulator's V6 root pack (the TUHS distribution's), kernel `rkunix`. Both have
the same `/bin/cc` (7,186 bytes), `/bin/od` (4,476) and C compiler passes.
The two sources of `docs/bench/v6/` were put on both packs with
`tools/v6fs.py`. `od` reads `/rkunix`, 28,836 bytes on Pico_1140's pack and
28,636 on this one: its times are compared per byte.

**Script** ([comparison/script.txt](comparison/script.txt)): `stty -lcase cr0`
(no carriage-return delay on either), then compile the Sieve and the
Whetstone, run each twice, `od /rkunix` twice. Transcripts:
[Pico_1140](comparison/transcript-pico_1140-picoplus2w-150mhz.txt),
[this emulator](comparison/transcript-this-emulator-picoplus2w-150mhz.txt).

| Step, timed from the host (the two runs agree within 0.1 s) | Pico_1140 | this emulator | this one faster by |
|---|---|---|---|
| `cc -O sieve.c` | 7.01 s | 3.77 s | 1.86x |
| `cc -f -O whet.c` (the floating point build) | 22.15 s | 10.03 s | 2.21x |
| `time sieve` (BYTE Sieve, 10 iterations, 1899 primes) | 6.26 s (user 5.7) | 2.86 s (user 2.5) | 2.19x |
| `time whet` (1,000 KWhetstones, double precision; both print X = 18178/10000) | 5.99 s (user 5.2) | 4.81 s (user 4.4) | 1.25x |
| `time od /rkunix >/dev/null` | 28.70 s (user 27.3) | 10.57 s (user 9.8) | 2.70x per byte |

The Whetstone is the closest: Pico_1140's floating point is SIMH's C code
compiled for the M33, this one a port of the same SIMH code in PureMetal Basic
with its fraction multiply and divide in Arm assembly. Integer work - the
compiler, the Sieve, `od` - is two to nearly three times as fast here.

Measured 2026-10-21.

## serialcomms' C emulator

[Serialcomms/Pimoroni-PDP11-SDK231](https://github.com/Serialcomms/Pimoroni-PDP11-SDK231)
(2026-10-21; it replaces the earlier staging repository), the C emulator this
repository's PureMetal work started from: a PDP-11/40 for the Pimoroni Pico Plus
2, its RK05 pack copied from flash (at 0x10100000) into the PSRAM. It builds
(Pico SDK 2.3.1, the Arm cores, 150 MHz) and runs on the same Pico Plus 2 W:
the pack is copied in 196 ms, V6's boot block prints its `@` and loads the
kernel. **It cannot run the V6 comparison yet:** its memory management unit
(KT11) is a placeholder - the kernel's page registers at 772300-772356 are not
decoded - and V6's kernel stops at its first write to them (`no decode for
address=0772340`). It runs systems that keep memory management off, such as
Mini-Unix.

To run it here, the console (KL11) goes to USB serial in place of its UART
(each character handed to its own DMA-complete handler, so its character-time
pacing stays), its diagnostic printing is copied to the console, and the USB
port waits up to 10 s for the host at start-up; the processor emulation is not
touched.

## All three on Mini-Unix

serialcomms' emulator runs systems with memory management off, so the three
were also compared on Mini-Unix (V6 for machines without memory management):
the same Pico Plus 2 W at 150 MHz, the same pack - this repository's
Mini-Unix pack as the Pico W image builds it (the kernel `/rkmx` with swap by
process slot, `media/unix/rkmx-slotswap`) plus `/usr/sieve.c` - and the same
script ([comparison/script-mini-unix.txt](comparison/script-mini-unix.txt)),
each step timed from the host.

| Step, timed from the host | this emulator | Pico_1140 | serialcomms' C emulator |
|---|---|---|---|
| `cc -O sieve.c` | **4.50 s** | 5.36 s | 9.68 s |
| `time sieve` (BYTE Sieve, 10 iterations, 1899 primes) | **3.04 s** (user 2.5) | 4.68 s (user 3.9) | 4.19 s |
| `time od /rkmx >/dev/null` (the same 19,036-byte kernel) | **10.53 s** (user 9.7) | 13.57 s (user 12.4) | 10.74 s |

Transcripts: [this emulator](comparison/transcript-mini-unix-this-emulator.txt),
[Pico_1140](comparison/transcript-mini-unix-pico_1140.txt),
[serialcomms'](comparison/transcript-mini-unix-serialcomms.txt) (its boot:
[here](comparison/transcript-mini-unix-serialcomms-boot.txt)). The runs repeat
within 0.05 s.

How each was run, and what was different:

- **This emulator** booted single-user by itself (its pack header asks for
  `rkmx`). Mini-Unix keeps memory management off, so it runs in this
  emulator's unmapped loop, which runs from flash (V6 and V7 use the mapped
  loop, in SRAM): per byte of `od` that loop is about 1.5 times slower than the
  one V6 runs in.
- **Pico_1140** (the flash-disk build, 150 MHz) came up multi-user, its switch
  register not asking for single-user; root logged in, and its `update` daemon
  was stopped (`kill 5`) because its sync every 30 s put 2 s into every other
  `od`. Its compile was timed again with `update` stopped: 5.36 s both times.
- **serialcomms' emulator** (Pimoroni-PDP11-SDK231 built for the Arm cores, 150
  MHz, console on USB as above) booted single-user. Its first load of the
  kernel after power-up fails at the boot block (the `@` comes back) and the
  second loads it - the same on V6; with Mini-Unix's own boot block its first
  `@` was not followed by a load either way, so its pack carries V6's boot
  block in block 0 (the kernel, the programs and the files are the same
  pack). It stops itself if no interrupt comes within 5 s of a WAIT. Its
  `time` shows real time running slower than user time (`real 1.0`, `user
  3.1`): its line clock does not keep time, so only the host's figures count.

Measured 2026-10-21.

## SIM-H on the RP2350 (serialcomms' figures)

[Serialcomms/Raspberry_Pico_SIMH](https://github.com/Serialcomms/Raspberry_Pico_SIMH):
an early version of SIMH's PDP-11 for RP2350 boards, its packs kept in the
flash with SPIFFS. Not run here: these are the figures serialcomms posted
(2026-10-23), by Unix's own `time` (whole seconds), after two runs of each
program to warm it, on the same board and clock as this emulator's figures:
a Pimoroni Pico Plus 2 W at 150 MHz, booted into Mini-Unix (serialcomms,
2026-10-24). The programs are the same two (the Sieve prints 1899 primes,
the Whetstone X = 18178/10000). Beside them, this emulator's `time` figures
for the same programs from the tables above, at 150 MHz:

| Program | SIM-H (serialcomms) | this emulator |
|---|---|---|
| `time sieve` (BYTE Sieve, 10 iterations) | real 8.0, user 6.5, sys 1.3 | user 2.5 (Mini-Unix, Pico Plus 2 W) |
| `time whet` (1,000 KWhetstones, double precision) | real 7.0, user 7.2, sys 0.5 | user 4.4 (V6, Pico Plus 2 W) |

By user time this emulator is about 2.6 times as fast on the Sieve and 1.6
times on the Whetstone. The board, the clock and the Sieve's system are the
same; this emulator's Whetstone figure is from V6, not Mini-Unix. None of
SIM-H's figures was taken by this repository's script or timed from the host.
