# Firmware validation, 2026-10-26

The current assembly and V6 FP-context refresh uses runtime source `338b5a5`. All six programs were rebuilt. The newest checks are recorded at the end; earlier text/CPU measurements below remain historical.
[manifest-2026-10-26.json](manifest-2026-10-26.json) records every program/file
hash, board profile and compiler hash. All ready builds start silent.

The following CPU/Unix checks precede the text-only refresh. New panel checks
are recorded at the end of this document.

| Image | Physical hardware | Checks |
| --- | --- | --- |
| Pico W standard firmware | Pico W, RP2040, 200 MHz, LAFVIN ST7796 | All four Mini-Unix phases passed again in 48.29 s; 63 KB lossless overlay, real guest-kernel pipes, 56 KB guest memory; no dropped clock ticks/lost console input |
| Pico 2 W standard firmware | Pico 2 W, RP2350, 150 MHz, LAFVIN ST7796 | All four V6 build/process/file/text/read phases passed; 152 KB guest and 248 write blocks retained; no dropped ticks/lost input |
| Pico Plus 2 W V6 | GPIO47 PSRAM, 16 MB flash | Boot, filesystem listing, C compilation and result `42`; 18-bit MMU, 3812 KB guest memory with 224 KB SRAM window; fonts ready; no dropped ticks/lost input |
| Feather V6 | Feather RP2350 HSTX, GPIO8 PSRAM, 8 MB flash | Same V6 checks and result `42`; correct flash/store profile; no dropped ticks/lost input |
| Pico Plus 2 W V7 | Pico Plus 2 W | Boot, RP03 `/usr` mount, C compilation in `/usr` and result `42`; 22-bit MMU, 2040 KB guest; fonts ready; no dropped ticks/lost input |
| Feather V7 | Feather RP2350 HSTX | Boot, RK1 `/usr` mount, C compilation and result `42`; 22-bit MMU, 2040 KB guest; fonts ready; no dropped ticks/lost input |

Both clean rebuilt demos passed on LAFVIN panels. In roughly 22-second
observation windows, RP2040 advanced 1,320 panel frames and vertical blanks,
and RP2350 advanced 1,322: about 60 frames/s each, with zero panel errors,
dropped ticks or HALTs. A private RP2040 diagnostic seeded the animation
counter at 0, 32760, 32767 and 65520, and exercised all ten highlight phases:
all plasma colors remained valid and white visited all six logo levels.
The old program reproduced invalid colors at signed-word overflow.
Both clean tests used silent settings. RP2040 links Bluetooth but does not
start its radio with those settings. Its full 2 MB readback matched every
public demo program page; all original bytes from settings offset 0x3f000
through the end of flash matched the fresh pre-test snapshot exactly.
Pico W was left on the fixed silent demo; Pico 2 W was returned to Unix.

The standard UF2s match the programs used for the fresh Unix phases.
Both boards passed all four phases with zero lost input and dropped ticks:
RP2040 48.15 s, RP2350 55.44 s. [Fresh timing samples and benchmark
methodology](../docs/bench/fresh-2026-10-26.md) include Sieve and Whetstone.
The RP2040 overlay passed 6,451 native checks. Its new guest kernel passed
three 8,208-byte pipe-stream tests, including EOF, broken pipes, descriptor
sharing and allocation-failure recovery.

The following processor checks come from the preceding assembly pass; CPU
instruction implementations are unchanged by this storage/demo refresh.

Both chips passed 4,000 native/plain comparisons of the twelve complete
unmapped word/byte operand handlers. RP2350 also passed 512 multi-instruction
fetch sequences, exercising warm/cold windows, kernel/user modes, physical
aliases, page boundaries and 16-bit PC wrap. Mapped operand/addressing groups
passed separately. Deliberate word-store, mode-dispatch and indexed-PC-wrap
mutants were rejected. Generated code freshness checks passed. The desktop
CLI compiled with its C backend; it was not executed for this hardware pass.

Both RP2040 and RP2350 passed all 17 integer diagnostic tapes in
`media/diagnostics/ladder.txt`.
RP2350 also passed both KDJ11 floating-point diagnostics, JFPAA1 and JFPBA0,
with zero reported errors. The two documented model-rejection tapes were
not repeated. Tapes that exceeded the initial shortened timeout were rerun with their
original single-tape limits; a timeout was not counted as a pass.

The PSRAM tests used fresh complete flash snapshots. V6 images were uploaded
whole. V7 installation transferred changed sectors from the complete image,
retaining all supplied image bytes at their original addresses. The original
contents were restored after testing, including the complete saved-change
store; full 16 MB and 8 MB readbacks matched the pre-test snapshots
byte-for-byte. One initial restoration exceeded the helper's transfer limit;
it was completed before V7 testing, and the final full readbacks verified
restoration. No board snapshots or personal settings are published.

The Pico Plus 2 W's existing saved V7 root was full. Its V7 check used an
empty temporary store and a workspace under `/usr`; the previous saved
filesystem was restored afterward. V6 compiler checks use `cc file.c` and
`a.out`, matching the installed compiler.

Firmware-only downloads contain the same program bytes as their combined
images. The release checker validates every hash, UF2 family, block count,
address and settings checksum, and compares every Unix payload address and
byte against the immutable pack-base revision. RP2350 disk payloads and pack
nonces are unchanged. RP2040 deliberately ships the new Mini-Unix kernel and
its patched sources; the pack is committed in the recorded base revision. LF checkout rules keep the hashed metadata stable on Windows.

LAFVIN glass was checked on Pico W and Pico 2 W. The other three resident
screen drivers were compiled but not physically checked. PSRAM boards were
checked over USB serial with the shared glyph generator active. Earlier
runtime-font checks covered Lato-derived and monospace faces at 14, 15 and
16 pixels on both chips, identical glyph bytes, live resize and rejection
of oversized requests while restoring the previous cache.

## Earlier sound validation

The preceding RP2040 demo publication passed live Bluetooth playback, and
the user confirmed the sound. It sustained 57.51 panel frames/s, A2DP packets
848 to 1,603, and zero underruns, overruns, audio errors or synthesis delays.
Its PCM-meter build also produced increasing nonzero sample counts, peak
9,072, with zero lost/late samples. The shared sound producer/transport is
unchanged by this storage/demo refresh. Those audio results apply to the
preceding firmware; live speaker playback has not been repeated for the
new binary. RP2350 speaker playback was not checked. See [OUTPUTS.md](../OUTPUTS.md).

## RP2040 direct FP11 refresh

The final 197,528-byte normal program was tested on the physical Pico W at
200 MHz. It keeps the full 56 KB guest, 63 KB compressed overlay, panels and
live fonts. Code SRAM is 49,136 bytes; 248 bytes remain beyond reserved
stacks/windows. The demo is 249,572 bytes, below the 0x3f000 settings sector.

- 22,528 native arithmetic checks cover full unsigned products, fraction
  products, scaled quotient/remainder and all 64-bit shift counts. A private
  deliberately incorrect quotient produced 989 failures.
- DEC JFPAA1 and JFPBA0 both complete with zero errors using the final program.
- General Unix tests pass for precision, integer conversion, matrices,
  sqrt, sin/cos, atan, exp/log, all six accumulators/FPS across fork and
  blocking pipes, live state reset on exec, and signal 8 on divide by zero.
  The previous kernel fails the state check; the new kernel passes.
- The Mini-Unix kernel was compiled/assembled/linked on the physical Pico W.
  Its nine patched source files match the packaged filesystem. Kernel end
  is 22,700, leaving 852 bytes below the swap stack. All three swap users
  retain consistent process-slot addressing.
- The complete Unix workload passes in 48.286163 s; three Sieve runs return
  1,899 primes, median 0.840355 s normalized to ten passes. Three 3,000-KWhetstone
  runs take 12.443447, 12.438980 and 12.441653 s, all X=9311/10000:
  241.1255 KWIPS, about 41.6 times the earlier guest interpreter result.

These are general FP11 and guest kernel changes, with no benchmark matching.
Full results and methodology: [floating point and Unix rerun](../docs/bench/fp-2026-10-26.md).
The old same-day benchmark page is retained as historical evidence.

The final RP2040 demo was installed after restoring the pre-test whole-flash
snapshot. A full 2 MB native flash readback matches every published demo
program page; every byte from 0x3f000 to the end matches the original
snapshot, preserving settings, Unix pack and radio data. The panel and guest
frame/vertical-blank counters advanced by 1,322 over roughly 22 seconds,
with zero panel errors, dropped ticks or audio transport errors in silent
mode. Speaker playback was not repeated for this FP-only update.

## Gamma and 16-pixel text refresh

- Both standard programs boot at 16 pixels on the physical Pico W and Pico 2 W
  LAFVIN panels. Four cached coverage levels now use nominal brightness
  0/156/213/255 instead of 0/85/170/255, encoded by a flash lookup table.
  The glyph cache remains 4 KB; 16-pixel Terminal Sans uses 3,581 bytes.
- Both boards generated identical 14- and 16-pixel glyphs, metrics and actual
  RGB565 palette exports. Fourteen uses a 19-pixel line (16 screen rows),
  sixteen a 22-pixel line (14 rows). Sixteen was selected from the captured
  rendering for clearer lowercase letters and punctuation. This is an export
  of board-rendered data, not optical calibration or a photograph of the LCD.
- Final standard programs pass Unix text output, file creation/readback and
  clean statistics: zero panel errors, dropped clock ticks or lost input.
  Live-font tests cover both faces, 14/15/16 pixels, cache-limit rejection and
  return to the original glyph data. One initial extended Pico 2 stress run
  recorded one dropped tick; the complete clean-boot repeat passed with zero.
- Both rebuilt demos boot with the same 16-pixel font/palette; guest/panel
  frame and vertical-blank counters advance with zero panel errors and
  dropped ticks. Silent audio was used; speaker playback was not repeated.
- A fresh whole-flash backup preceded testing. Final 2 MB Pico W and 4 MB
  Pico 2 W readbacks match every page of their final program images. Every
  byte from 0x3f000/0x4f000 respectively to flash end matches its original
  snapshot, preserving settings, Unix packs and radio data. Pico W is left
  on the rebuilt silent demo; Pico 2 W is left on updated normal Unix.
- The Mini-Unix pack is unchanged from the accepted FP release. All RP2350
  combined-image disk bytes and nonces are unchanged. Existing settings UF2s
  keep their stable font IDs; readable now selects 16, compact remains 11.
- RP2040 normal program: 197,620 bytes, unchanged 49,136-byte SRAM code and
  248 free SRAM bytes beyond reserved stacks/windows. RP2040 demo: 249,660
  bytes, below its 0x3f000 settings sector. RP2350 normal: 199,992 bytes;
  RP2350 demo: 218,692 bytes. No guest memory or overlay budgets changed.

[Comparison, exports and reproduction](../docs/FONT-READABILITY.md).

## Further assembly and V6 FP context refresh

- RP2040 exact arithmetic: 22,528 checks pass; RP2350 shifts: 8,192 checks
  pass. A deliberately wrong logical shift is rejected with 518 failures.
  Both DEC FPA diagnostics pass zero errors on both processors.
- Full native Unix build/assemble/archive/link, processes/pipes/files,
  text/sort/edit and repeated reads pass on both standard boards. Three
  long Whetstone runs and three Sieve100 runs have checked numerical outputs.
  General precision/conversion/matrix/math-function tests pass; all six
  accumulators/FPS survive fork and blocking pipes, exec resets the state,
  and divide-by-zero signals 8. All final measured sessions have zero
  dropped ticks and lost input.
- Fresh matched results: Pico W Unix48.37->48.45 s, Whet242.9->257.1 KWIPS;
  Pico2 W with the same FP-enabled kernel on both sides Unix55.57->55.59 s,
  Whet489.3->491.8 KWIPS. Small Unix differences are not treated as a speedup.
  [Samples and methodology](../docs/bench/assembly-2026-10-26.md).
- Program/code-SRAM/free-SRAM bytes: Pico W196980/49016/504 versus
  197620/49136/248; Pico2 W199768/92840/1628 versus199992/93004/1344.
  Free counts exclude reserved stacks/windows. No guest, overlay, font or
  audio budgets were reduced.
- The stock FP-disabled V6 kernel also fails state checks with unchanged
  public firmware. The new native-built FP-enabled m45 kernel fixes this
  independently of the emulator optimization. It passes full state/math,
  maintenance-bit, exec and signal tests on Pico2 W and Feather. Its 0407
  data-first sysfix layout and swap metadata are verified by release tools.
- V6 RK0 images deliberately gain `/rkfp` and sources, retaining every
  existing regular file and recovery kernel. RK1 and V7 packs/nonces are
  unchanged. New RK0 nonces prevent incompatible saved-store replay.
  The Pico Plus2 kernel is identical and compiled/repackaged; its physical
  checks were not repeated this turn. [Kernel guide](../docs/v6/FP-KERNEL.md).
- Both final demos boot at16 pixels with advancing guest/panel counters,
  zero panel errors and dropped ticks. Silent settings were used; live
  speaker playback was not repeated. Pico W is left on the rebuilt demo,
  Pico2 W on updated normal firmware and the new FP-enabled V6 kernel.
- Pico W full2MB readback matches the new demo program and all original
  bytes from0x3f000 onward, preserving settings/pack/radio. Pico2 W full4MB
  readback matches its new normal program and accepted new RK0 pages, while
  all bytes from0x4f000 to0x240000 match the original snapshot. Its original
  root matches the image whose288 regular files were preserved by the tool.
- Feather full8MB flash, including its original saved filesystem, was
  restored exactly after kernel building/testing: SHA256
  286063eaf84234d0833399fd3ec0fed119e10b155bd7f24ccb3d74f7fc006d24.
  Pico Plus2 physical flash was untouched.
