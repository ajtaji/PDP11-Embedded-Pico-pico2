# Firmware validation, 2026-10-26

The program payloads and image hashes are listed in
[manifest-2026-10-26.json](manifest-2026-10-26.json). All ready builds are silent.

| Image | Actual hardware | Checks |
| --- | --- | --- |
| Pico W firmware + Mini-Unix pack | Pico W, RP2040, 200 MHz | Separate firmware/pack uploads; boot with no serial terminal for eight seconds; Unix directory listing; 56 KB guest, 124 write blocks; Lato cache ready; no dropped clock ticks or lost input |
| Pico 2 W V6 combined image | Pico 2 W, RP2350, 150 MHz | Exact combined UF2 uploaded; standalone boot; directory listing; 152 KB guest, 248 file-write blocks; LAFVIN display and Lato ready; no dropped ticks or lost input |
| Pico Plus 2 W V6 combined image | Pico Plus 2 W, GPIO47 PSRAM | Boot, filesystem listing, C compilation and result `42`; MMU 18-bit, 3812 KB physical guest memory, 224 KB SRAM window; live-font cache ready; zero dropped ticks/lost input |
| Feather V6 combined image | Feather RP2350 HSTX, GPIO8 PSRAM | Same V6 checks and result `42`; correct 8 MB flash profile and store region; zero dropped ticks/lost input |
| Pico Plus 2 W V7 combined image | Pico Plus 2 W | Boot, RP03 `/usr` mount, C compilation in `/usr` and result `42`; MMU 22-bit, 2040 KB; fonts ready; zero dropped ticks/lost input |
| Feather V7 combined image | Feather RP2350 HSTX | Boot, RK1 `/usr` mount, C compilation and result `42`; MMU 22-bit, 2040 KB; fonts ready; zero dropped ticks/lost input |
| RP2350 demo firmware | Pico 2 W with LAFVIN ST7796 | Guest enables the display; guest and panel frame counters advance; no HALT; silent backend |
| RP2040 demo firmware, source `fd78191` | Pico W, 200 MHz, LAFVIN ST7796 | Final Bluetooth-linked UF2 with silent settings: 367 panel frames over 367 vertical blanks, 60 FPS; no panel errors or HALT |

The RP2040 PCM-meter build also passed: panel/guest counters advance,
nonzero samples increase from 751,350 to 1,041,899, peak 9,072,
zero lost/late samples and zero dropped clock ticks. This checks the shared
four-voice producer, not audible playback. A short Bluetooth attempt reported
HCI status 4 (page timeout), with no stream established. The complete 2 MB
flash backup was restored afterward, followed by the final demo firmware
and silent settings. The board was left running the silent graphics demo.

The normal RP2040 Unix image rebuilt with the conditional device hooks is
byte-identical to the preceding publication (`55cc5e6f...`). The shared
renderer produces the identical RP2350 demo UF2 (`12c31d16...`), so that
previous hardware validation still applies. Unix images and disk payloads
were not replaced by this demo addition.

The PSRAM tests preserved complete pre-test flash snapshots. Each test image
was uploaded whole. The original flash contents were restored afterward by
comparing flash against the snapshot and restoring the changed sectors,
including the saved-change store. No board snapshots or personal settings
are included in the downloads.

The Pico Plus 2 W's existing saved V7 root filesystem was full. Its final
V7 package check used an empty temporary store and a workspace on `/usr`;
the previous saved filesystem was restored after the check. V6 compiler
checks use `cc file.c` and `a.out`, rather than V7's `-o` option.

Firmware-only downloads have exactly the same program bytes as the checked
combined images. The release check validates every file hash, UF2 family,
block count, address and settings checksum; compares standalone and combined
program payloads; and compares every old Unix payload address and byte
against the immutable pack-base revision. All disk payloads and pack nonces
are unchanged. LF checkout rules keep the hashed flash-map metadata stable
on Windows as well as Unix.

The four standard screen drivers are resident. LAFVIN glass was checked on
Pico W and Pico 2 W. Other physical screens and Bluetooth speaker playback
were not checked in this publication run. PSRAM boards were checked through
USB serial with the same glyph generator active.

The runtime-font validation also checked Lato-derived and monospace faces at
14, 15 and 16 pixels on RP2040/RP2350, with identical generated glyph bytes,
live resize without rebooting Unix, and rejection of an oversized request
while restoring the previous glyph cache. See [OUTPUTS.md](../OUTPUTS.md).
