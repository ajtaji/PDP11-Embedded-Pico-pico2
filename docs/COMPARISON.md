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

[Serialcomms/Pico-PDP11-Pimoroni-RISCV-Staging](https://github.com/Serialcomms/Pico-PDP11-Pimoroni-RISCV-Staging)
(commit `7c096d7`, 2026-10-01), the C emulator this repository's PureMetal
work started from. **Not measured yet:** its CMakeLists names three sources
that are not in the repository (`opcodes_option_eis.c`,
`destination_address_byte.c`, `destination_address_word.c`) and four headers
(`destination_address_byte.h`, `destination_address_word.h`,
`opcode_specifiers_byte.h`, `opcode_specifiers_word.h`), and none of its 74
commits has them. A build for the comparison is ready for when they are
published: the Arm cores at 150 MHz, the console (KL11) on USB serial in
place of its UART (each character handed to its own DMA-complete handler, so
its character-time pacing stays), the processor emulation untouched.
