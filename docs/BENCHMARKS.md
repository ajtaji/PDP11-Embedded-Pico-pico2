# Benchmarks

Part of the [PDP-11 emulator for the Pico W and Pico 2 W](../README.md).
Classic benchmarks run under Unix on the emulator, on a Pimoroni Pico Plus 2 W
(RP2350B at 150 MHz, the PSRAM firmware of `images/picoplus2/`, which has the
J-11's floating point unit), on 2026-10-21. Times are V7's or V6's own `time`
(the 60 Hz line clock) unless marked as timed from the host. The transcripts
are in [bench/](bench/).

## Results

| Benchmark | Unix | Result | For comparison |
|---|---|---|---|
| Dhrystone 2.1 (Weicker; netlib's C source unchanged, `cc -O -DHZ=60`, 20,000 runs) | V7 | **1,125.7 Dhrystones/s** (888 us a run), 0.64 DMIPS (VAX-11/780 = 1757); every "should be" in its self-check right | - |
| Whetstone, double precision (netlib's C Whetstone, Painter 1998; [V7 port](bench/v7/whet.c): K&R declarations only) | V7 | 30 loops (3,000 KWhetstones) in 16.4 s CPU: **about 183 KWIPS** | PDP-11/70 with FPP, RSTS/E FORTRAN-IV-PLUS, double precision: 479 (the DECUS RSX80A Whetstone listing, `whet.ftn`); single precision 632 |
| Whetstone, double precision ([V6 port](bench/v6/whet.c): the same arithmetic in 1975 C, int loop counts) | V6 | 1,000 KWhetstones in 4.4 s CPU (4.78 s from the host): **about 227 KWIPS** | the same |
| Sieve of Eratosthenes (Gilbreath, BYTE September 1981: 8190 flags, 10 iterations, 1899 primes) | V7 | **2.5 s CPU** (2.9 s from the host) | C/Unix V6 on a PDP-11/70: **1.52 s** (BYTE January 1983, table 1 continued, printed page 298; [original scan](https://calentamientoglobalacelerado.net/benchmarkzone/download/criba_sieve_byte_1983.pdf)) |
| the same ([V6 port](bench/v6/sieve.c): `=+`) | V6 | **2.5 s CPU** (2.83 s from the host) | the same |
| givens (E. J. Olson's pichart PDP-11 version: Givens-rotation least squares in double precision, golden run and consistency check at every size; unchanged, `cc -O -DKANDR -DASCII`) | V7 | **85,175 FLOPS at 4x4 to 103,697 at 42x42**; 63x63 ends "Error allocating" (64 KB of data per process) | - |

V6's Whetstone beats V7's because its loop counters are 16-bit `int`s
where the C Whetstone counts in `long`s, and V6's `cc -f` and V7's `cc`
compile the floating point differently; the arithmetic done is the same.
Dhrystone 2.1 needs `typedef` and `enum`, which V6's C compiler does not
have, so it runs on V7 only.

These are historical measurements of the 2026-10-21 firmware. They do not describe the newer CPU optimizations or the 2026-10-26 panel/font builds. The earlier 1.12 s attribution for the real PDP-11/70 was incorrect; the scanned BYTE table gives 1.52 s for C under Unix V6. No matched real-machine full-Unix timing is claimed.

## How to repeat them

V7 (HOWTO section 12):

```
python tools/v7_pack.py -o v7root.rk --usr v7usr.rk --add docs/bench/v7:/bench --add DIR_WITH_DHRYSTONE:/dhry
...
# cd /bench
# cc -O -o sieve sieve.c
# cc -O -o whet whet.c -lm
# time ./sieve
# time ./whet 30
# cd /dhry
# cc -O -DHZ=60 -o dhry dhry_1.c dhry_2.c
# echo 20000 | time ./dhry
```

Dhrystone's `dhry.h`, `dhry_1.c` and `dhry_2.c` are netlib's
(<https://www.netlib.org/benchmark/dhry-c>, a shell archive) and are not
copied here.

V6 (a Pico 2 W, or a PSRAM board): put the two files of `docs/bench/v6/` on
the pack with `tools/v6fs.py put`, then

```
# stty -lcase
# cc -O sieve.c; mv a.out sieve
# cc -f -O whet.c; mv a.out whet
# time sieve
# time whet
```

(`-f`: V6's C compiler refuses floating point without it - "No floating
point!" - and links its floating point interpreter, which on this machine
never runs: the instructions go to the FPU.)

## The Pico 2 W

With 152 KB of memory since 2026-10-21 the Pico 2 W runs V6's compiler too, and
the same V6 benchmarks give the PSRAM board's times: the Sieve 2.5 s CPU (2.83 s
from the host), the Whetstone 4.3 s CPU (4.67 s), `od /rkunix` 10.44 s.

## The speed pass of 2026-10-21

Four changes, each measured on the boards at 150 MHz, timed from the host
(the same script each time; the runs repeat within 0.05 s):

1. With PSRAM, the first 224 KB of the PDP-11's memory is in SRAM (it was
   56 KB; `#PSRAM_SRAM_KB` in `diag.pico2`), so the kernel and the first
   processes run from SRAM; the rest stays in the PSRAM.
2. PushM and PopM in assembly (`__pushm`, `__popm`), JSR, RTS and DIV in
   assembly (DIV with the M33's SDIV), and `@(R)+`, `@X(R)` - V7's
   absolute and deferred operands - added to `__eaw` (JMP calls it too).
   `asm_check.pico2` holds each to its plain version on random machine
   states (`ASMCHECK ops`, `ASMCHECK ea`); a deliberately broken version of
   each failed it within the first round.
3. The fetch window is kept per mode: a trap or an interrupt and its RTI
   find the window they left instead of building it again, a PSW write that
   does not change the mode keeps it, and a map write empties only the
   window of the mode whose I space it changed.
4. With PSRAM, the unmapped run loop (CpuRun, used while memory management
   is off: Mini-Unix) runs from SRAM, not flash (`tools/psram_build.py`; the
   Pico 2 W has no room for its 36 KB).

V7 on the Pico Plus 2 W (`images/picoplus2-v7/`):

| Step | before | after | |
|---|---|---|---|
| `cc -O loop.c` | 4.62 s | 4.03 s | 1.15x |
| `cc pi.c` (floating point) | 3.95 s | 3.46 s | 1.14x |
| `time loop` (`%` in a loop: DIV) | 5.24 s | 4.77 s | 1.10x |
| `time pi` | 1.83 s | 1.73 s | 1.06x |
| `time od /unix >/dev/null` | 17.00 s | 15.03 s | 1.13x |
| `ls -l /bin \| wc` | 4.25 s | 3.86 s | 1.10x |

Mini-Unix on the Pico Plus 2 W (the pack and script of
[COMPARISON.md](COMPARISON.md#all-three-on-mini-unix)):

| Step | before | after | |
|---|---|---|---|
| `cc -O sieve.c` | 4.50 s | 2.86 s | 1.57x |
| `time sieve` | 3.04 s | 2.56 s | 1.19x |
| `time od /rkmx >/dev/null` | 10.53 s | 7.17 s | 1.47x |

V6 on the Pico 2 W (`images/pico2w-v6/`; changes 2 and 3): `time od /rkunix
>/dev/null` 10.46 s before, 9.43 s after (1.11x).

The DEC diagnostics of `media/diagnostics/ladder.txt` give the same results
as before on both boards.

## Against another emulator

[COMPARISON.md](COMPARISON.md): Pico_1140 on the same board, at the same clock,
running the same V6 and the same benchmarks.

## What changed V7's times

The console's carriage-return delay. V7 opens the console with a model 33
Teletype's flags, among them a pause of 10 clock ticks after every newline;
Dhrystone's 60-line report then took 13 s of a 31 s run. `tools/v7_pack.py`
patches the kernel's constant (TOOLS.md); with it the same run takes 20.8 s
from the host, its computing 18 s as before.
