# PDP-11 Unix on both Picos: fresh historical benchmark comparisons

Physical-board results from 27 October 2026 for the additional historical tests, alongside the latest accepted Unix/Sieve/Whetstone runs from 26 October. Pico W/RP2040 runs at 200 MHz with Mini-Unix and 56 KB of guest RAM. Pico 2 W/RP2350 runs at 150 MHz with Unix V6 and 152 KB of guest RAM. Both have the panel console and 16-pixel runtime font enabled.

All emulator optimizations are general. There is no guest benchmark recognition, reduced floating-point precision, precomputed output or benchmark-specific instruction path.

| Test | Pico W / RP2040 | Pico 2 W / RP2350 | Recorded real PDP-11/70 |
|---|---:|---:|---|
| Complete current Unix suite [1] | 48.45 s | 55.59 s | No matching measurement |
| BYTE Sieve, 10 passes [1,2] | 0.839 s | 0.997 s | 1.52 s, C/Unix V6 (1983) |
| Double-precision Whetstone [1,3] | 257.1 KWIPS | 491.8 KWIPS | 515 KWIPS, WHET2A/FP11-C (1976) |
| Dhrystone whole-process rate, no registers [4] | 1,316/s | 1,354/s | 1,162/s, older version/Unix 5.2 (1985) |
| Dhrystone whole-process rate, registers [4] | 1,371/s | 1,429/s | 1,250/s, older version/Unix 5.2 (1985) |
| 25,000 getpid calls [5] | 3.344 s | 5.266 s | 8.0 s, 2.8BSD (1984) |
| 512 KiB through a pipe [5] | 29.931 s | 5.443 s | 8.1 s, 2.8BSD (1984) |
| 1,000,000 long increments [5] | 6.661 s | 8.020 s | 7.9 s, 2.8BSD (1984) |
| 50,000 function calls, user-time delta [5] | 0.5 s | 0.5 s | 1.0 s, historical call-overhead figure |
| 128 KiB file write [5] | 0.692 s | Write overlay fills: no accepted score | 4.0 s, 2.8BSD (1984) |
| 256 random file reads [5] | 0.988 s | No accepted score after write failure | 9.5 s, 2.8BSD (1984) |
| Single shell workload [5] | 1.560 s | 1.169 s | 4.0 s, 2.8BSD (1984) |
| Concurrent shell jobs: 1 [5] | 1.864 s | 1.299 s | 5.0 s |
| Concurrent shell jobs: 2 [5] | 3.472 s | 2.299 s | 7.8 s |
| Concurrent shell jobs: 3 [5] | 5.156 s | 3.316 s | 9.3 s |
| Concurrent shell jobs: 4 [5] | 12.499 s | Out of swap | 11.8 s |
| Concurrent shell jobs: 5 [5] | Fork limit | Not continued | 14.3 s |
| Concurrent shell jobs: 6 [5] | Fork limit | Not continued | 16.7 s |

The results vary by workload. Both Picos beat the 1983 Sieve reference (about 1.81x and 1.52x throughput). RP2350 reaches about 95.5% of the 1976 double-precision Whetstone score; RP2040 about 49.9%. Pico W is slower than the recorded 11/70 on the large pipe test. These measurements do not establish that every program is faster than an 11/70.

The current complete Unix suite has no matched real-11/70 measurement. Its two Pico totals also use different Unix implementations and available utilities; they are not a direct comparison of the Arm processors. No real-machine suite time has been invented by scaling another benchmark.

Seconds are host elapsed time unless explicitly marked as the function-call user-time delta. Three runs are summarized by their median; concurrent shell counts were run once each. The Unix suite figures are single complete runs. Lower seconds and higher KWIPS/Dhrystones per second are better.

Compatibility matters: the fresh Dhrystone is a checked C1.1 algorithm port, while the 1985 reference is an earlier version. V6 lacks typedef/enum, unsigned declarations, casts and some library routines. The port retains all timed algorithm operations, uses ordinary C string/record copies, and moves equivalent record initialization into static storage. The unsigned and long-loop ports execute the original iteration counts, verified by final values. Dhrystone is 10,000 iterations per sample and checks its final globals and records; these are not Dhrystone 2.1 or DMIPS scores. The new rate uses total host elapsed time, including process setup and checked output, without the original empty-loop timing correction. The published historical scores use their own loop-timing method, so this is an approximate comparison rather than a standard Dhrystone rating.

The V6 disk-read port preserves 256 random byte positions but uses two seek calls in place of one lseek. The shell's here-document and for loop are expanded before timing for the Thompson shell; the word list, utilities, pipelines, cleanup and job counts remain the same. The reference systems have different compilers, libraries and kernels. File timings additionally compare volatile RAM-backed storage with period disks. The original file-write test repeats an uninitialized stack buffer; the RP2040 result proves that test succeeds, rather than arbitrary 128-KiB data capacity in its compressed overlay.

The Pico W pipe/FP-capable Mini-Unix pack is installed for these runs. An independent 512-KiB patterned-data pipe check passes on each Pico: 1,024 complete blocks, no byte errors and child status zero. Independent checks verify all 16 sorted words, the three grep matches and word counts. Each Dhrystone sample returns the checked final state. Accepted standard-board sessions have zero lost input and dropped clock ticks.

Resource failures are reported, not timed as successes: the standard Pico 2 fills its 248-block write overlay during the 128-KiB file test and runs out of its 112-block swap area at four concurrent shell jobs. Mini-Unix reports refused forks at five and six jobs. Its four-job outputs were independently checked. A three-job rerun retaining the intermediate word-count files also exhausts swap on Pico 2; its successful three-job timing is specific to the original cleanup sequence and scheduling. The PSRAM boards have writable RAM disks and a larger swap area, tested separately.

1. [October 26 Unix/Sieve/Whetstone results and exact samples](https://github.com/ajtaji/PDP11-Embedded-Pico-pico2/blob/5b07729bc1ef3d0cf8065cca4f81ca9c71ad7559/docs/bench/assembly-2026-10-26.md)
2. [BYTE January 1983, printed page 298: original Sieve table](https://calentamientoglobalacelerado.net/benchmarkzone/download/criba_sieve_byte_1983.pdf)
3. [BCS April 1976 record: CCA WHET2A double precision, FP11-C](https://fortran.bcs.org/1976/min760405.html)
4. [1985 Dhrystone reference table](https://groups.google.com/g/net.sources/c/UJPmAnsCu6o)
5. [BYTE August 1984 Unix reference results, archived in 1987](https://www.tuhs.org/Usenet/comp.unix.xenix/1987-March/004999.html)
6. [Original BYTE August 1984 programs, pp.134-135 and400-408](https://www.worldradiohistory.com/Archive-Byte/80s/Byte-1984-08.pdf)
7. [Project, sources, firmware and installation instructions](https://github.com/ajtaji/PDP11-Embedded-Pico-pico2)

Exact samples and checks: [data](historical-2026-10-27.json). The measured compatibility sources are in [historical/](historical/).
