# Firmware validation, 2026-10-26

The latest assembly refresh is built from runtime source `3f81486`.
[manifest-2026-10-26.json](manifest-2026-10-26.json) records every program/file
hash, board profile and compiler hash. All ready builds start silent.

| Image | Physical hardware | Checks |
| --- | --- | --- |
| Pico W standard firmware | Pico W, RP2040, 200 MHz, LAFVIN ST7796 | Mini-Unix build and read phases passed, compiler/utility results matched, 56 KB guest and 124 write blocks retained, no dropped clock ticks/lost console input |
| Pico 2 W standard firmware | Pico 2 W, RP2350, 150 MHz, LAFVIN ST7796 | All four V6 build/process/file/text/read phases passed; 152 KB guest and 248 write blocks retained; no dropped ticks/lost input |
| Pico Plus 2 W V6 | GPIO47 PSRAM, 16 MB flash | Boot, filesystem listing, C compilation and result `42`; 18-bit MMU, 3812 KB guest memory with 224 KB SRAM window; fonts ready; no dropped ticks/lost input |
| Feather V6 | Feather RP2350 HSTX, GPIO8 PSRAM, 8 MB flash | Same V6 checks and result `42`; correct flash/store profile; no dropped ticks/lost input |
| Pico Plus 2 W V7 | Pico Plus 2 W | Boot, RP03 `/usr` mount, C compilation in `/usr` and result `42`; 22-bit MMU, 2040 KB guest; fonts ready; no dropped ticks/lost input |
| Feather V7 | Feather RP2350 HSTX | Boot, RK1 `/usr` mount, C compilation and result `42`; 22-bit MMU, 2040 KB guest; fonts ready; no dropped ticks/lost input |

Both rebuilt demo firmwares passed on LAFVIN panels: RP2040 advanced 362
panel frames over 362 vertical blanks and RP2350 advanced 365 over 365,
60 frames/s on each. Guest counters advanced, with no panel errors or HALT.
Both tests used silent settings; the RP2040 binary links Bluetooth but does
not start its radio with those settings. Pico W was left on the new silent
demo; Pico 2 W was returned to the new standard Unix firmware.

The standard UF2s are byte-identical to those used for the complete Unix
phases. Timings and the unchanged Mini-Unix overlay capacity limitation are
recorded in [BENCHMARKS](../docs/BENCHMARKS.md#additional-assembly-pass-2026-10-26).

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
byte against the immutable pack-base revision. Disk payloads and pack nonces
are unchanged. LF checkout rules keep the hashed metadata stable on Windows.

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
unchanged by this CPU assembly refresh. Those audio results apply to the
preceding firmware; live speaker playback has not been repeated for the
new binary. RP2350 speaker playback was not checked. See [OUTPUTS.md](../OUTPUTS.md).
