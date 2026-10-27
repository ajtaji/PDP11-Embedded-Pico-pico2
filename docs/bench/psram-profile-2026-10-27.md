# PSRAM CPU profiling and Unix optimization, 27 October 2026

The previous aligned sector-copy change left the Unix workload essentially unchanged because emulated CPU execution dominates the measured read phase. Its 44,902 valid native PC samples included 44,837 samples with the guest not in WAIT, 62 waiting with a disk controller busy, zero waiting for console transmission, and 3 other WAIT samples. MOV, effective-address handling, JSR and RTS dominate the hottest 64-byte code buckets. These samples include memory-load stalls and do not isolate PSRAM/cache latency. This profile covers the read phase, which accounts for over half of the original four-phase suite; it is not a whole-system cycle counter.

The accepted M33 assembly caches the current data-space map-row base, extracts JSR/RTS opcode fields directly, and combines dispatch indexing with its indirect jump. Map permissions, alignment, boundaries, traps, instruction budgets and the slow paths remain checked. There are no guest-program names, benchmark recognition, clock changes, timing reductions, buffer-count changes or FP precision cuts.

| Physical board, 150 MHz | Previous firmware | Optimized firmware | Elapsed-time reduction |
|---|---:|---:|---:|
| Feather RP2350 HSTX | 84.707s | 81.107s | 4.25% |
| Pico Plus 2 W | 106.645s | 102.443s | 3.94% |

These are fresh physical-board host elapsed times for the complete V2 Unix suite: native compilation, assembly, archive/link/run, pipes/processes, text tools, kernel reads and traversal of the installed `/usr` tree. Both firmware versions use identical clean FP-fixed V7 disks, the original 29 buffers, 2040 KB guest memory and 872 swap blocks. Source entry, flashing and boot are excluded; all measured command work and flash-save pauses are included. Full-suite totals are sums of four independently booted phases, one paired run per board. V2 walks different amounts of data: Feather has a selected `/usr`, while Pico Plus 2 W holds the full distribution. Compare firmware versions within each board.

The original V1 read script names `/usr/bin`, which does not exist in the V7 distribution, producing three `du` warnings. The distribution keeps its commands in `/bin`. V2 lists `/usr/lib` and traverses all installed `/usr` instead. This adds real work. Compare firmware within the same suite version; do not compare a V1 score directly with V2. All V2 commands pass their output checks without the missing-directory warning.

| Original V1 suite, retained comparison | Previous | Optimized |
|---|---:|---:|
| Feather | 76.461s | 73.230s |
| Pico Plus 2 W | 76.684s | 73.468s |

| V2 phase | Feather before/after | Pico Plus 2 before/after |
|---|---:|---:|
| build | 13.628/13.147s | 13.628/13.159s |
| ipc | 8.067/7.797s | 8.059/7.815s |
| text | 10.110/9.799s | 10.358/10.033s |
| readfull | 52.901/50.364s | 74.600/71.435s |

SRAM code decreases from 123,476 to 123,068 bytes. After the new 4-byte cached pointer, net free SRAM increases 404 bytes, to 4,608 on Feather and 4,604 on Pico Plus 2 W. Guest RAM and disk capacities are unchanged.


| Test | Feather | Pico Plus 2 W | Recorded PDP-11/70 |
|---|---:|---:|---|
| V7 complete Unix suite V2 | 81.107s | 102.443s | No matched real-machine run |
| BYTE Sieve, normalized 10 passes | 0.960s | 0.961s | 1.52s, C/Unix V6 (1983) |
| Double-precision Whetstone | 417.7KWIPS | 417.6KWIPS | 515KWIPS, WHET2A/FP11-C (1976) |
| Dhrystone C1.1 whole-process, no registers | 1,418/s | 1,417/s | 1,162/s, older version/Unix 5.2 (1985) |
| Dhrystone C1.1 whole-process, registers | 1,495/s | 1,495/s | 1,250/s, older version/Unix 5.2 (1985) |
| 25,000 getpid calls | 4.191s | 4.190s | 8.0s, 2.8BSD (1984) |
| 512 KiB through a pipe | 2.983s | 2.985s | 8.1s, 2.8BSD (1984) |
| 1,000,000 long increments | 3.499s | 3.491s | 7.9s, 2.8BSD (1984) |
| 128 KiB file write | 0.864s | 0.863s | 4.0s, 2.8BSD (1984) |
| 256 random file reads | 1.404s | 1.406s | 9.5s, 2.8BSD (1984) |
| Single shell workload | 1.083s | 1.084s | 4.0s, 2.8BSD (1984) |
| 50,000 function calls, user-time delta | 0.5s | 0.5s | 1.0s, historical call-overhead figure |
| Concurrent shell jobs: 1 | 1.229s | 1.224s | 5.0s |
| Concurrent shell jobs: 2 | 2.212s | 2.188s | 7.8s |
| Concurrent shell jobs: 3 | 3.256s | 3.261s | 9.3s |
| Concurrent shell jobs: 4 | 4.227s | 4.319s | 11.8s |
| Concurrent shell jobs: 5 | 5.257s | 5.269s | 14.3s |
| Concurrent shell jobs: 6 | 6.412s | 6.470s | 16.7s |

Historical comparisons are approximate: Unix releases, compilers, storage and benchmark versions differ. Dhrystone is a checked C1.1 algorithm port timed as a whole process, including setup/output, with no original empty-loop correction; the 1985 rating is an older version with its own timing method. It is not a standard Dhrystone/DMIPS rating. Disk tests compare RAM-backed storage with period disks. No real PDP-11/70 time has been invented for either full Unix suite. [Original historical references and method](historical-2026-10-27.md).

Sieve and Whetstone retain three samples each, 100 sieve passes/sample (1899 primes) and 3000 KWhetstones/sample (expected X=9311/10000). Other historical samples and final states are recorded in the data. Fresh paired baseline/candidate runs show Sieve improving about 5.4-5.5% and Whetstone about 0.5%; arithmetic precision is unchanged. Both boards pass native C and F77, FP state/fork/exec/math/signal checks, 38 children checking 48 KB each, raw `/usr` checksums, a byte-checked 512 KiB pipe and six independently checked concurrent shell jobs. The final combined integer/MMU assembly comparison passes the default randomized groups, including 32,000 MMU and 80,000 byte cases. All accepted captures lose zero input.

Feather retains a selected `/usr` with 24 free blocks; the full distribution requires Pico Plus 2 W. Stock V7 signed memory accounting still limits this configuration to 2040 KB. Previous release persistence and multi-user tests remain documented separately; this CPU optimization does not alter disk payloads, save logic, panel settings or sound. Instrumented profile timings are excluded from speed claims; 64-byte symbol attribution is approximate.

[Exact samples, checks, telemetry, program and source hashes](psram-profile-2026-10-27.json). [V2 read input](v7/read-full/session.txt). [Other unchanged measured sources](v7/README.md). [Earlier sector-copy/kernel results](psram-2026-10-27.md).

After testing, full 8 MB and 16 MB flash readbacks prove restoration of each board's original image with only the accepted firmware program replaced. Original disks, saved files, settings and radio data are preserved byte for byte.
