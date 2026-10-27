# CPU optimization validation, later 2026-10-27

Runtime source: `eacaa8c94b0a5ba955370caaf7f8bce527c72864`.
All six programs were rebuilt with the manifest's canonical compiler.
The manifest checker verifies all 28 release files, settings and preserved
V6/V7/Mini-Unix disk bytes and nonces. The RP2040 Unix and demo program
payloads are byte-identical to the previous release.

Both PSRAM boards run the complete original V7 Unix suite and corrected V2
suite against previous and new firmware, with identical factory disks and
29-buffer FP-fixed kernel per board. V2 traverses the real `/usr` tree;
the original `/usr/bin` path is absent in the V7 distribution. Sources,
exact checks and final fresh results are in the [CPU profile report](../docs/bench/psram-profile-2026-10-27.md).

Native default randomized integer/MMU assembly comparisons pass, including
80,000 byte cases and 32,000 MMU cases. Guest FP state, fork, exec, math and
signal tests, native C/F77, process memory stress, historical programs and
independent byte/count/final-state checks are recorded in the new data.
The native-PC profiles have zero rejected frames; their CPU category includes
memory-load stalls and does not separately quantify PSRAM/cache latency.
Instrumented timings are excluded from performance comparisons.

Standard RP2350 firmware and its demo were rebuilt; their physical timing,
display and speaker tests were not repeated in this CPU pass. Earlier
standard-board figures below belong to their recorded earlier runtime.
Fresh full-flash readbacks verify both original images with only accepted
program pages overlaid: all 8 MB on Feather and 16 MB on Pico Plus 2 W,
zero mismatches. The entire original saved-change store was restored;
Unix disks, settings and radio bytes remain exact. Standard boards were
untouched during this CPU pass. Proof fields are in the new report data.

---

# Earlier firmware validation, 2026-10-27

Runtime source: `d2a84159b8c116bdbdd961b1da770c703fa462a2`.
All six programs were rebuilt using the compiler recorded in
[manifest-2026-10-27.json](manifest-2026-10-27.json). The release checker
verifies 28 files, UF2 structure/families, settings, program payloads,
accepted disk bytes/nonces, and both V6 and V7 FP kernels.

| Hardware | Fresh physical checks |
|---|---|
| Pico W, 200 MHz | Historical Dhrystone algorithm ports, 25,000 system calls, million-long loop, function-call pair, 512-KiB pipe, file write/random reads and shell workloads; independent byte/count/final-state controls |
| Pico 2 W, 150 MHz | Same CPU/pipe/function/shell tests; disk-write overlay exhaustion and swap limits reported as failures, with no accepted failed timings |
| Feather RP2350 HSTX, 150 MHz | Complete V7 four-phase Unix workload, Sieve/Whetstone and additional historical programs; native C/F77, FP fork/exec/math/signal checks, 38 checked 48-KB children, raw RK1 reads, six checked shell jobs, persistent data recovery and multi-user login |
| Pico Plus 2 W, 150 MHz | Same V7 checks with the complete distribution /usr on RP03; raw RP03 read checksum, persistent files on both disks and automatic /usr mount after multi-user startup |

The aligned-copy fixture checks guard words and mapped DMA spans against
the word path. A deliberate short-copy mutant fails. The additional SRAM
transfer unit checks 1,024 copies in each direction, mapped and unmapped;
all final values agree. Its speed ratio excludes PSRAM/controller waits.
[Full results, samples and limits](../docs/bench/psram-2026-10-27.md).

The final V7 kernel retains the original 29 buffers, process/file/inode
limits, 2040 KB guest memory and 872 swap blocks. The 40-buffer trial was
rejected for lack of a whole-workload improvement. All four FP-state
fork/mode cases, both exec chains, the math program and signal 8 pass on
both PSRAM boards. The native kernel is checked against the board's BSD
sum and SHA-256; its installed form is verified in both factory images.

Both PSRAM boards preserve patterned files on RK0 and /usr over an explicit
save and program-only reboot with the same pack nonces: 4 KB per file on
Feather, 32 KB per file on Pico Plus 2 W, zero errors. Feather's supplied
/usr has only 24 free blocks; an oversized trial failed and was excluded.
The complete /usr requires Pico Plus 2 W. Clock coalescence from flash
saves is recorded: up to 28 ticks in benchmark phases and 30 in the saved
file test; host timings include the pauses. Accepted captures lose no input.

All standard and demo program payloads reproduce the preceding accepted
bytes exactly. CPU diagnostic tapes and speaker playback were not repeated
for this PSRAM storage/kernel update; preceding coverage is in
[the October 26 notes](VALIDATION-2026-10-26.md).

After tests, fresh full-flash readbacks prove restoration of all original
board data. Pico W's complete 2 MB and Pico 2 W's complete 4 MB match their
original snapshots. Feather's 8 MB and Pico Plus 2 W's 16 MB match the exact
original images with only the accepted new program pages overlaid. Original
Unix packs, saved files, settings and radio bytes are preserved. Firmware-only
updates preserve the old guest kernel; install the backed-up new V7 system
image to obtain its FP fixes.

The V7 factory images intentionally replace the active /rkunix and /unix
kernel inode and refresh both pack-header nonces. All other 247 root regular
file paths retain their bytes; all RK1/RP03 distribution data remains exact.
V6 and Mini-Unix disks remain unchanged. [Kernel rebuild and update](../docs/v7/PSRAM-KERNEL.md).
