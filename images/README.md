# Ready-to-flash firmware and Unix images

## 2026-10-26 builds

The preceding CPU/FP hardware rerun takes **48.29 s on Pico W** and **55.44 s on
Pico 2 W**; see [fresh Sieve/Whetstone and Unix results](../docs/bench/fp-2026-10-26.md).

RP2040 now executes FP11 F/D instructions directly, with general Thumb-1 arithmetic. Whetstone improves from 5.80 to 241.1 KWIPS; broad correctness and Unix process-state tests also pass. Install both its firmware and disk pack to enable this safely under Unix.

This text refresh corrects dark antialiased strokes and selects the clearer
16-pixel readable default on both Pico families. Native 14/16-pixel glyph and
RGB565 exports match on both boards; [comparison and limits](../docs/FONT-READABILITY.md).
All six firmware programs, including PSRAM variants and both demos, were rebuilt.
The CPU/Unix performance figures describe the preceding FP release; they were
not remeasured for this text-only change.

These builds include the CPU optimizations, standard panel console and live
TrueType fonts. This refresh adds complete native operand handlers on both
chips and faster mapped fetch/address dispatch on RP2350. Measured Unix
work takes 1.6% less time on Pico W and 2.1% less on Pico 2 W; see
[BENCHMARKS](../docs/BENCHMARKS.md#additional-assembly-pass-2026-10-26).
Runtime source: `37c7690`. The Mini-Unix FP context kernel is unchanged from the preceding release. The PSRAM build tool now selects
the actual board profile, including its flash size and PSRAM chip select.
The [manifest](manifest-2026-10-26.json) records program/file hashes, compiler
hash and board profiles. [SHA256SUMS](SHA256SUMS) covers the supplied files.

The RP2350 Unix disk payloads and pack nonces remain **byte-for-byte unchanged**.
The Pico W pack now includes the board-built J-11 Mini-Unix pipe/FP-context kernel,
patched sources and `/rkmx.prev` fallback. Its firmware has a 63 KB lossless
compressed RAM write overlay. See [the kernel guide](../docs/minix/j11-pipes.md).
Both demo programs include the animation-counter fix for long-running plasma
colors and the white logo sweep. Unix licensing remains in
[Caldera-license.pdf](../Caldera-license.pdf).

## Updating an existing installation

Download only the firmware for the board. These small files keep the installed
Unix pack and, on PSRAM boards, its saved changes. Output settings also survive.
Use **Compiler > Flash Prebuilt File...** in PureMetal Forge, or copy the file
to the BOOTSEL drive.

For RP2040 pipes and safe direct floating-point process state, also install the new `picow-mini-unix/minix.uf2`
in a second upload. Updating firmware alone retains the installed guest
kernel. The disk-pack file replaces the installed Mini-Unix pack.

| File | Bytes | SHA-256 |
| --- | ---: | --- |
| [picow-mini-unix/firmware.uf2](picow-mini-unix/firmware.uf2) | 395,264 | `0b67ef0232211aa26e167f5426923e960b2128ee77e5f860913574f475bd4057` |
| [pico2w-v6/firmware.uf2](pico2w-v6/firmware.uf2) | 400,384 | `c955b8da0c3aa43a13f849f4ef90cde74fb9b82ca1aa9f6b8416887e2a5766e8` |
| [picoplus2/firmware.uf2](picoplus2/firmware.uf2) | 458,240 | `8576a4c8a242ebc6d44efa8cf82a531f3256e23cea8e5a48ae939e3860fbe311` |
| [feather/firmware.uf2](feather/firmware.uf2) | 457,728 | `fd33e2face1c974719e47bf882d233d19c5d3e494c69a624e06cb09a2bd73f16` |

- Pico W: `picow-mini-unix/firmware.uf2`, RP2040 at 200 MHz.
- Pico 2 W: `pico2w-v6/firmware.uf2`, RP2350 at 150 MHz.
- Pico Plus 2 / 2 W: `picoplus2/firmware.uf2`, GPIO47 PSRAM, 16 MB flash.
- Feather RP2350 HSTX: `feather/firmware.uf2`, GPIO8 PSRAM, 8 MB flash.

The same PSRAM board firmware supports its V6 and V7 installations. Choose by
**board**, not by Unix version. The `.uf2.regions` companions contain the flash
map for the IDE, with repository-relative source references.

## First installation: firmware and Unix

| File | Bytes | SHA-256 |
| --- | ---: | --- |
| [pico2w-v6/combined.uf2](pico2w-v6/combined.uf2) | 3,333,120 | `56ed002b2d9c746b510b0893e820dfb6ef9cc1057a846b3347544916d5c75cc7` |
| [picow-mini-unix/minix.uf2](picow-mini-unix/minix.uf2) | 3,171,328 | `faa6b1f0987bfdb45f6f3d97b1fe0e4a826cbae9df39f5b1ae97b026bdc3e3d3` |
| [picoplus2/combined.uf2](picoplus2/combined.uf2) | 9,559,552 | `3fefdfe127239ed88f4b8d7749237a18df078a9d7b0f1426385bd16218050294` |
| [picoplus2-v7/combined.uf2](picoplus2-v7/combined.uf2) | 22,945,280 | `09622b7c5612114899ce1c1243bdeaf768705cc3f1aeb60a8354f31c2f54c209` |
| [feather/combined.uf2](feather/combined.uf2) | 9,559,040 | `659e003533f6868a8feab0c76c6527ccca033f04104dff087a7731006bf7e9ca` |
| [feather-v7/combined.uf2](feather-v7/combined.uf2) | 9,559,040 | `4139dc1a3eee3cfa937c15268cb6b3f8c0b9cdf23f68009f76e9ae3160ef1871` |

**Pico W needs two separate flashes:** first its `firmware.uf2` above, then
`minix.uf2`. On RP2040, combining the firmware and pack into one file can
leave the disk area unwritten. A board reporting `RK0: no pack` still needs
the disk file. The Pico W's pack occupies the radio firmware area, so its
current Mini-Unix installation cannot use Bluetooth.

**RP2350 boards use one `combined.uf2`** for a first installation. Pico 2 W
boots V6. The PSRAM folders offer V6 or V7; use the folder matching the board.
V7 on the Pico Plus 2 W has the whole distribution `/usr` on an emulated RP03;
the Feather uses the smaller RK1 `/usr` because its flash is 8 MB.
V6's kernel uses its 18-bit address space; V7 asks for 2040 KB. The PSRAM
firmware provides up to 3812 KB, with the hot 224 KB window in SRAM.

Pico W and Pico 2 W use read-only flash packs: disk changes live in RAM and
are lost at reset. PSRAM boards save disk changes to their flash store.
See [HOWTO](../docs/HOWTO.md) for booting, saving, mounting `/usr` and updating.

## Panels and live fonts

LAFVIN ST7796 is the default. A board with this panel boots and shows Unix
without a serial terminal open. USB serial is still used for keyboard input.
Use a tiny settings UF2 to select another resident screen driver:

| Panel | RP2040 settings | RP2350 settings |
| --- | --- | --- |
| LAFVIN ST7796, default | [lafvin](output-settings/rp2040-lafvin.uf2) | [lafvin](output-settings/rp2350-lafvin.uf2) |
| Display Pack 2 ST7789 | [display-pack2](output-settings/rp2040-display-pack2.uf2) | [display-pack2](output-settings/rp2350-display-pack2.uf2) |
| ILI9341 SPI1 | [ili9341](output-settings/rp2040-ili9341.uf2) | [ili9341](output-settings/rp2350-ili9341.uf2) |
| HX8357D SPI1 | [hx8357d](output-settings/rp2040-hx8357d.uf2) | [hx8357d](output-settings/rp2350-hx8357d.uf2) |
| No panel, USB serial only | [none](output-settings/rp2040-none.uf2) | [none](output-settings/rp2350-none.uf2) |

These files select silent audio and Lato-derived Terminal Sans at 16 pixels.
They write only the output-settings sector. Other font/audio combinations can
be made with `tools/output_config.py`. Wiring and APIs: [OUTPUTS.md](../OUTPUTS.md).
The LAFVIN physical panel is hardware checked; the other controllers are
implemented and compiled, with physical-screen validation still pending.

The Pico rasterizes real TrueType outlines at runtime, caching glyphs in RAM.
Press **Ctrl-]**, release it, then **f** to change face, **+** to increase size,
or **-** to decrease it. Natural spacing is used; a monospace face is also
available. The guest continues running, and an oversized request restores the
previous font. Standard images are silent; optional audio modules are built
from source as described in OUTPUTS.md. Speaker playback is not claimed by the
silent builds or PCM meter example.

## Graphics demo on both chips

| File | Bytes | SHA-256 |
| --- | ---: | --- |
| [pico2w-demo/firmware.uf2](pico2w-demo/firmware.uf2) | 437,760 | `a08969ca545d6097408d7b8c8bb6f93a51f9c2453eafa08b1183cc076a879ee6` |
| [picow-demo/firmware.uf2](picow-demo/firmware.uf2) | 499,712 | `6b440f8fb6a7c77acf3be8f459a2cf6a4dfdad83cc54e2eaf8767c2ba14165d9` |

Flash the firmware matching the chip, then its [silent panel settings](output-settings/).
The built-in demo starts automatically with a centered 320 x 200 picture.
RP2350 uses 64 KB of guest memory and a silent backend. RP2040 uses 56 KB,
disables disks and links the optional Bluetooth backend; silent saved settings
keep its radio off. Both demo programs include the shared gamma/16-pixel update from `37c7690`. The manifest records the RP2040 Bluetooth link profile separately.

The firmware and settings preserve the installed disk pack. Flash normal
firmware to return to Unix. **Installing RP2040 radio firmware for sound
overwrites part of Mini-Unix:** back up first, then restore the pack or flash
backup when returning to Unix. See [sound setup and measured results](../OUTPUTS.md#graphics-and-sound-demo).
Speaker playback passed on the actual Pico W and was confirmed by the user.
The preceding firmware sustained 57.51 FPS with Bluetooth sound, with zero
audio underruns, overruns, errors or synthesis delays. This text refresh
retains the same audio producer/transport; the new binary was checked with
silent settings, without repeating speaker playback.

## Hardware validation

Detailed checks are in [VALIDATION-2026-10-26.md](VALIDATION-2026-10-26.md).

The new standard and demo programs were checked on Pico W and Pico 2 W.
Full flash readbacks match their final program pages and preserve the original
settings, packs and radio bytes. PSRAM variants were rebuilt and their original
Unix disk payloads/nonces verified unchanged; their earlier hardware checks
are recorded below.
The earlier V7 PSRAM validation transferred the changed sectors from each complete
image; V6 PSRAM images were uploaded whole.
The firmware-only files contain byte-identical program payloads. Boot,
filesystem access and statistics were checked on Pico W and Pico 2 W; a C
program compiled and printed `42` under V6 and V7 on both PSRAM boards.
The V7 Pico Plus 2 test used a clean temporary store and a workspace under
`/usr`, isolating the board's previously full saved root filesystem.
The PSRAM boards' original flash snapshots were restored after testing;
complete 16 MB/8 MB readbacks matched the snapshots byte-for-byte.
The RP2350 demo's guest and panel frame counters advanced on the LAFVIN panel.
The RP2040 demo sustained 60 panel frames/s with its final public firmware and
silent settings. The preceding demo's PCM-meter and live speaker checks
passed as recorded in the validation notes; those sound tests were not
repeated for the new binary.

Live-font switching, cache-limit rejection and identical glyph data across
RP2040/RP2350 were checked in the runtime-font work. Standard guest memory
remains 56 KB on RP2040 and 152 KB on Pico 2 W. The Pico W uses a 63 KB compressed overlay with 255 unique records
and byte-checked sharing. Pico 2 W has 248 file-write blocks plus 112 swap blocks; runtime font
workspace uses six former file-write blocks. Optional audio builds have the
separate memory budgets listed in OUTPUTS.md.

## Rebuild this set

Use the matching PureMetal Forge compiler and SDK libraries. From the root:

```text
py -3 tools/output_build.py --target rp2040 --compiler PureMetalForge.exe --out build_release/rp2040.uf2
py -3 tools/output_build.py --target rp2350 --compiler PureMetalForge.exe --out build_release/rp2350.uf2
py -3 tools/psram_build.py --board picoplus2 --compiler PureMetalForge.exe --out build_release/picoplus2
py -3 tools/psram_build.py --board feather --compiler PureMetalForge.exe --out build_release/feather
py -3 tools/demo_build.py --compiler PureMetalForge.exe --out build_release/demo
py -3 tools/demo_build.py --target rp2040 --audio bluetooth --compiler PureMetalForge.exe --out build_release/demo2040
py -3 tools/firmware_release.py --build-dir build_release --date 2026-10-26 --compiler-sha256 COMPILER_SHA256
py -3 tools/demo_release.py --target rp2040 --audio bluetooth --build-dir build_release/demo2040 --manifest images/manifest-2026-10-26.json
```

The release step takes the existing combined images' disk payloads. It does
not replace them with newly generated packs or change their nonces. This
matters when `media/unix/rk70unix` is absent: rebuilding a PSRAM pack from
incomplete inputs would otherwise change the kernel selection. The manifest
records the unchanged payload hashes. Source font preparation requires
FontTools only when regenerating `truetype_assets.pmi`; normal firmware builds
use the committed outline assets.
