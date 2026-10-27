# V7 on PSRAM boards: kernel and memory support

The PSRAM images use 2040 KB of PDP-11 memory, the complete 872-block RK0
swap area, and writable disk blocks in PSRAM. The Pico Plus 2 W image has
the complete distribution `/usr` on RP03 partition 3. The 8-MB-flash Feather
image has the documented smaller RK1 `/usr` selection; it cannot hold the
whole distribution. Standard Pico W and Pico 2 W images do not provide
this V7 configuration.

The October 27 kernel fixes three floating-point context problems found
with ordinary guest programs:

- `newproc` saves the live FPS and six accumulators before copying the
  parent's user area, so a newly forked child inherits the actual state.
- `setregs` marks the cleared FP state for restoration after exec, including
  when no intervening process switch occurs.
- `savfp` and `restfp` use `ldfps $200` while copying raw double-precision
  state. This masks exceptions during the copy and restores the original
  FPS afterwards, preserving reserved operands and enabled trap modes.

Precision remains the full PDP-11 D format. No guest instruction or math
routine is replaced with a benchmark-specific result. The RP03 raw-transfer
Unibus-map fix from the preceding release remains included.

The distribution's 29 disk buffers and its process, inode and open-file
limits are retained. A 40-buffer trial gave no full-workload improvement
and was rejected. The separate data/BSS area ends at 41766, below the user
area at 49152.

The Feather's 4000-block `/usr` selection has only 24 free blocks (12 KB)
in the factory filesystem. Use the root filesystem for larger working
files. It cannot provide the whole distribution or a large `/usr/tmp`;
the Pico Plus 2 W RP03 image provides the full `/usr`. Guest memory stays
at 2040 KB because this V7 kernel's signed memory accounting and allocation
map cannot safely represent a single free extent beyond 2 MB. Remaining
PSRAM holds writable disk blocks and swap rather than being left unused.

## Rebuilding and verifying

[`build-psram-kernel.sh`](../../media/unix/v7/build-psram-kernel.sh) records
the source edits and native V7 compiler/assembler/linker commands. Start
with an unmodified distribution source tree on a Pico Plus 2 W, mount
`/dev/rp3` on `/usr`, then run the script under V7. Do not apply its edits
twice. The source files are on the supplied distribution tape.

The board-built `/rkfinal29` is 39702 bytes. V7 `sum` reports `04333 78`;
`size` reports text 33472, data 1906 and BSS 39860.
The exported, unpatched artifact is
[`media/unix/v7/rkunix-psram`](../../media/unix/v7/rkunix-psram), verified by
[`SHA256SUMS`](../../media/unix/v7/SHA256SUMS).
`tools/v7_pack.py` verifies that hash, then applies the existing startup
Unibus-map and console-flag adjustments. The installed kernel SHA-256 is
`024d224bab2c81315971dfd751bd2e38d27ffb9729bbd0c30228bed77f46ce55`.
`/unix` and `/rkunix` name the same inode so the namelist matches the running
kernel. External symbols are retained.

## Updating

A firmware-only upload preserves the installed guest kernel and saved
files. Obtain the FP fixes by installing the matching new V7 combined
image, or updating the kernel in a backed-up V7 filesystem with the tools.
Back up saved files first: the new factory RK0 nonce intentionally prevents
old saved blocks from being replayed onto the changed filesystem. RK1/RP03
distribution data is preserved. Never flash a Feather image on a Pico Plus
2 W or vice versa; their PSRAM wiring differs.

This release tests a substantial V7 environment; it does not establish
compatibility with every historical peripheral or every V7 application.
Host elapsed times include flash save pauses. Clock-drop telemetry is
reported alongside PSRAM workloads rather than hidden by guest CPU times.
