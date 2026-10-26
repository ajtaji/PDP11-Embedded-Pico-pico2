# Mini-Unix J-11 kernel, floating point and RAM overlay

The RP2040 read-only firmware uses a 63 KB lossless block overlay, replacing
the fixed 124-block overlay. Blocks are compressed independently, with a raw
fallback for incompressible data. Identical encoded blocks share a record
only after a byte-for-byte comparison. There are 255 unique records; identical
records can serve all 4,872 logical blocks. An empty pool holds at least 125
raw blocks. Actual capacity depends on the data, and remains finite.

Replacement preserves the old block until the new record fits. A full pool
returns a disk error without corrupting earlier writes. Collection moves at
most one record per disk-service call, allowing USB and the line clock to run
between moves. Reset discards all writes; the firmware never programs the pack.
Statistics report logical blocks, unique records, live bytes and collections.

The original Mini-Unix has no pipe system call. Its shell implements pipelines
using temporary files. The J-11 kernel adds bounded anonymous byte streams to
system call 42, with blocking reads/writes, EOF, descriptor sharing, and
SIGPIPE/EPIPE. It uses unlinked inodes and the existing buffer cache, with no
additional permanent buffers. The existing limits remain: 13 processes,
six disk buffers, 50 inodes, 50 file structures, and 32 KB of user space.

All swap users must use the same addressing scheme: the swap routine, exit's
saved status, and wait's status read select the process **slot**, not its PID.
The J-11 provides EIS integer instructions, so the kernel enables `eis = 1`
and omits the PDP-11/10 software EIS emulator. Floating-point instructions now execute directly in the RP2040 emulator.
Mini-Unix saves FPS and all six D-format accumulators in its existing
50-byte user-area slot before swapping, and restores them after swapping.
Exec resets the live FP state. Vector 244 delivers Unix signal 8. Save and
restore mask FP exceptions temporarily and preserve reserved operand bits.
The kernel checks the J-11 maintenance register's FPA-present bit, so it
also boots with earlier firmware that uses the guest FP interpreter.

## Reproduce on a physical RP2040

`j11-pipes.patch` is against the sources in the repository's `mini-unix.rk05`.
Unix-derived material retains the [Caldera licence](../../Caldera-license.pdf).
The image tool edits a filesystem; it does not run a simulated CPU.

Prepare patched sources in a private image:

```
python tools/minix_pipe_image.py mini-unix.rk05 --source-out build/minix-src -o build/minix-build.rk05
python tools/rk_image.py pack build/minix-build.rk05 --chip pico --name minix-build --autoboot rkmx -o build/minix-build.uf2
```

Install the RP2040 firmware and this temporary disk pack, in separate upload
sessions. At the board's Unix prompt:

```
stty -lcase
chdir /usr/sys/mxsys
cc -c -O pipe.c
cc -c -O sys1.c
cc -c -O sys2.c
cc -c -O fio.c
cc -c -O bio.c
cc -c -O sysent.c
cc -c -O trap.c
as mch.s
mv a.out mch.o
as low.s
mv a.out ../low.o
ld -a -x ../low.o ../conf.o *.o ../lib2
size a.out
nm a.out
od -b a.out
```

Use the individual objects, rather than `../lib1`: that archive contains an
aggregate kernel object and would duplicate the changed routines. The new
link must have no undefined or multiply defined symbols. Export its `od -b`
output with the documented `tools/od2bin.py` workflow.

The user area starts at octal 056000. Mini-Unix's swap stack grows downward
from two bytes below it: checking only that `_end <= _u` is insufficient.
The image tool requires at least 512 bytes between `_end` and `_u`, verifies
the a.out length and symbols, and rejects an EIS emulation entry point.

To assemble an installable image with a board-built kernel:

```
python tools/minix_pipe_image.py mini-unix.rk05 --source-out build/minix-src --kernel media/unix/rkmx-j11-fp --fallback media/unix/rkmx-j11-pipes -o build/minix-j11.rk05
python tools/rk_image.py pack build/minix-j11.rk05 --chip pico --name mini-unix --autoboot rkmx -o build/minix.uf2
```

The pack retains `/rkmx.prev` as the previous working kernel. Type its name
at the boot block's `@` prompt to select it manually.

## Focused validation

`J11_18MHz_KDJ11_BF/pico/overlay_check.pico` runs natively on RP2040. It checks
compression, incompressible fallback, sharing, slot IDs above 127, collection,
repeated replacements, refusal at capacity and preservation of previous data.
The acceptance run passed 6,451 checks, including 4,000 churn writes and six
collections. A deliberately damaged decoder was rejected on its first block.

Compile `pipe-check.c` with the guest compiler on the board. It exercises
zero-length reads, EOF after closing duplicated descriptors, broken pipes,
descriptor exhaustion and recovery, and an 8,208-byte forked stream crossing
the 4 KB pipe buffer repeatedly. Its success line is `PIPE CHECK 0 8208 0`.

The ordinary Unix workload remains `tools/unix_workload.py`; its expected
outputs and measured phases are unchanged. A full overlay, kernel panic,
halt, console loss, dropped tick or incorrect result is a failed run.

The FP-capable board-built kernel ends at decimal 22,700 (octal 054254),
leaving 852 bytes below the user area. Three consecutive pipe-check runs
returned `PIPE CHECK 0 8208 0`. The unchanged four-phase Unix suite passed
on RP2040 at 200 MHz in 48.15 seconds, excluding setup/source transfer,
with zero lost console input and zero dropped line-clock ticks.


## Floating-point validation

The default RP2040 firmware now executes the complete FP11 F/D instruction
set directly. The earlier 5.80-KWIPS result came from Mini-Unix interpreting
floating instructions in guest PDP-11 code; an ARM floating-point library
was not involved. The implementation preserves the PDP-11 formats,
56-bit D significand, rounding modes, condition codes and exceptions.

The native `pico/fp_check.pico` fixture checks exact integer identities for
full 32-bit multiplication, fraction multiplication, restoring division,
and every 64-bit shift count. `tools/fp11_vectors.py --check` verifies its
deterministic reference data. A damaged quotient-bit update was rejected.
Both DEC JFPAA1/JFPBA0 diagnostics passed with zero errors on RP2040.

The guest tests in `docs/bench/v6/` include precision and library math,
all six FP registers across fork and 40 blocking IPC exchanges, exec state
reset, and divide-by-zero signal delivery. Assemble the state-transfer
helper separately; Mini-Unix cc does not assemble `.s` inputs automatically:

```
as fpstate_io.s
mv a.out fpio.o
cc -O fpstate.c fpio.o
mv a.out fpstate
./fpstate
cc -f -O fp_math.c
./a.out
```

Mini-Unix `cc -f` supplies its floating library, including the math routines;
it does not need `-lm`. Install both the current RP2040 firmware and the
current Mini-Unix pack for correct multi-process FP state handling. Bare-metal
FP11 programs use the firmware directly.
