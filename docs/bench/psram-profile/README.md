# Native sampling fixture

This diagnostic fixture is excluded from release firmware. It samples core 0
native PC every 997 us, with 64-byte histogram buckets. The histogram occupies
64 KB at PSRAM guest-window offset 3 MB; use only a working 8 MB PSRAM board
configured for 2040 KB guest memory. This is not safe for larger guest-memory
configurations without selecting another unused region.

Include it in the PSRAM diagnostic build, call ProfInit once on core 0, and
toggle ProfEnabled only around timed guest command execution. Source typing,
flashing and boot are excluded. ProfDump disables sampling and emits counts
and nonzero buckets. Match the exact compiled image's symbols to its PCs;
the SRAM code's symbol addresses are rebased by 0x10000000. 64-byte symbol
attribution is approximate, since buckets can cross handler boundaries.

IMPORTANT: [sp,#64] and [sp,#68] assume the compiler-generated 40-byte ISR
frame before the hardware exception frame. Verify the generated prologue
for every compiler/build. The recorded canonical compiler SHA-256 is
`ea0c04dd97636624cbfd51d4d7fbc2d854ce8548f65ddbb139b2634c99f2c94c`.
The XPSR/PC checks reject malformed samples; both accepted captures had zero.

The CPU counter means the guest is not in WAIT. Native-PC samples include
memory-load stalls and do not distinguish PSRAM/cache latency from instruction
execution. IO counts require guest WAIT and a busy RK/RP controller; they do
not measure every byte-copy cycle. Instrumented elapsed times are excluded
from published speed comparisons. Raw bucket counts and method are in the
[CPU profile data](../psram-profile-2026-10-27.json).
