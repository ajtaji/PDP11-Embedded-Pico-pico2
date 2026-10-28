# Fixed-compiler rebuild, latest 2026-10-27

All six production programs were freshly rebuilt with the fixed, signed
compiler, SHA-256 `9a582ee9c05acb1d386ffbd4082d178bf81fc3359ddaddb5211783b3671bba8e`,
from PDP-11 source `f4cc314478eee76f256fbaf687b722b43db3158a`.

The rebuild covers Pico W Unix, Pico 2 W Unix, Feather and Pico Plus 2
PSRAM firmware, and both Pico W/Pico 2 W display-and-sound demos. Their
complete UF2 bytes match the accepted release. The refreshed manifest and
all 28 release files pass hash, sector-padding/E10, metadata, output-settings,
unchanged Unix pack/nonce and native V6/V7 kernel checks. V6 and V7 combined
images retain their existing filesystem payloads and nonces.

No board was flashed during this rebuild. Saved Unix data remains untouched.
The earlier physical compiler/uploader and full-flash preservation tests
remain recorded separately; this is a build/publication verification pass.
[Fresh build record](FIXED-9a582ee9c05acb1d386ffbd4082d178bf81fc3359ddaddb5211783b3671bba8e-REBUILD-2026-10-27.json).

---

# UF2 BOOTSEL validation, latest 2026-10-27

Packaging source: `1124d1c54c7b8e89657162c20c4b58006fc07683`. All six programs rebuilt with the canonical
compiler; executable payloads match the previously measured release.
All 28 supplied files pass the release checker and 11 UF2 safety tests pass.
The published Feather/Plus2 firmware and V7 files exactly match the prepared
physical test files. [Machine-readable proof](UF2-VALIDATION-2026-10-27.json).

| Board | Actual Windows Explorer test | Full-flash verification |
|---|---|---|
| Feather RP2350 HSTX, 8 MB | Firmware-only and V7 combined dragged onto BOOTSEL; USB serial returned | All V7 data pages match; saved 1 MB store unchanged; final complete readback matches original data plus new firmware |
| Pico Plus 2 W, 16 MB | V7 combined dragged onto BOOTSEL; USB serial returned | All V7 data pages match; saved 1 MB store unchanged; final complete readback matches original data plus new firmware |

Boards entered BOOTSEL before each Explorer copy. Guests were halted on USB
return before test workloads. Original disk packs were restored after the
factory V7 transfer; only changed sectors were written, excluding the saved
store entirely. Final readbacks preserve every original byte from output
settings (`0x4F000`) to flash end, including radio, pack nonces and user data.
Standard Pico W/Pico 2 W boards were not reflashed in this packaging pass.

Each touched flash sector now contains all sixteen payload pages. Only
missing pages inside touched sectors gain FF padding: no inter-region gaps
are filled. Existing V6, V7 and Mini-Unix disk bytes, filesystem contents and
pack nonces are preserved. The standard V6 and Mini-Unix pack tail sectors
also receive their missing padding pages.

RP2350 flash UF2s carry the official E10 Absolute-family prefix, with
`RP2_IGNORE_BLOCK`, at `0x1004EF00`. The dedicated `0x4E000..0x4EFFF` sector
is reserved in linker metadata and excluded from ordinary program pages.
It is below settings and far from the saved Unix store. Both attached ROMs
left that sector unchanged, consistent with ignoring the workaround tag.
A physical A2-ROM board was not available for this test; the prefix's bytes
and placement are checked against the official converter and safety mutants.

Older PureMetal Forge prebuilt uploaders reject the prefix before writing.
Use Explorer BOOTSEL or [the unchanged-copy helper](../docs/TOOLS.md#bootsel-uf2-copy).
Do not remove the prefix for an A2 BOOTSEL transfer.

References: [official converter](https://github.com/raspberrypi/picotool/blob/master/elf2uf2/elf2uf2.cpp),
[RP2350 datasheet, E10](https://pip-assets.raspberrypi.com/categories/1214-rp2350/documents/RP-008373-DS-2-rp2350-datasheet.pdf?disposition=inline).

---

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
