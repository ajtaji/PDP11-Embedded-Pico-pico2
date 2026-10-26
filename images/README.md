# Ready-to-flash firmware and Unix images

## 2026-10-26 builds

These builds include the CPU optimizations, standard panel console and live
TrueType fonts. This refresh adds complete native operand handlers on both
chips and faster mapped fetch/address dispatch on RP2350. Measured Unix
work takes 1.6% less time on Pico W and 2.1% less on Pico 2 W; see
[BENCHMARKS](../docs/BENCHMARKS.md#additional-assembly-pass-2026-10-26).
Runtime source: `3f81486`. The PSRAM build tool now selects
the actual board profile, including its flash size and PSRAM chip select.
The [manifest](manifest-2026-10-26.json) records program/file hashes, compiler
hash and board profiles. [SHA256SUMS](SHA256SUMS) covers the supplied files.

The existing Unix disk payloads and pack nonces are **byte-for-byte unchanged**.
The firmware was replaced with `tools/uf2_firmware.py`; the release tool
checks every preserved address and payload. The Pico W disk remains the
same Mini-Unix pack. Unix licensing remains in [Caldera-license.pdf](../Caldera-license.pdf).

## Updating an existing installation

Download only the firmware for the board. These small files keep the installed
Unix pack and, on PSRAM boards, its saved changes. Output settings also survive.
Use **Compiler > Flash Prebuilt File...** in PureMetal Forge, or copy the file
to the BOOTSEL drive.

| File | Bytes | SHA-256 |
| --- | ---: | --- |
| [picow-mini-unix/firmware.uf2](picow-mini-unix/firmware.uf2) | 364,032 | `1f49f122f7dc36bc693f64cb53f8683505571ceea1a80da41956a0bd45c8e661` |
| [pico2w-v6/firmware.uf2](pico2w-v6/firmware.uf2) | 399,872 | `def17d528839940b344b186437465ce4f728e21990048d355cae29d6d98e6317` |
| [picoplus2/firmware.uf2](picoplus2/firmware.uf2) | 457,728 | `25782f045bb0f1be6d18039601a021a564e235acb8f33ac3caf26682789a9aa1` |
| [feather/firmware.uf2](feather/firmware.uf2) | 457,728 | `7c8f848e7deabc51a77487e2bef95a78f7f5a8f8602a0bd12b106afd80f8681b` |

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
| [pico2w-v6/combined.uf2](pico2w-v6/combined.uf2) | 3,332,608 | `9c371ca24c6d165506b1c574449a69b8ca8972751ba48c6dddb6e111c456bfbc` |
| [picow-mini-unix/minix.uf2](picow-mini-unix/minix.uf2) | 3,167,232 | `0ec2c16c5201f3ed789c785174c7c1480f414197fcda6ce772600585bf0be54c` |
| [picoplus2/combined.uf2](picoplus2/combined.uf2) | 9,559,040 | `ed34e9ca65b7f3e3210ddf5ca97ffb11c6f4c7d402d680e381eefe1befa39159` |
| [picoplus2-v7/combined.uf2](picoplus2-v7/combined.uf2) | 22,944,768 | `ac29c2ec4807b2dc4167c297db1605d92f0a9020561931e3716b70961b68acc4` |
| [feather/combined.uf2](feather/combined.uf2) | 9,559,040 | `9e80a45185adcaceb8aff28dfd7525206863fa46398201787260dc9e3c404aa9` |
| [feather-v7/combined.uf2](feather-v7/combined.uf2) | 9,559,040 | `834d98b855b43a8d5989abad9c7a39b8568d0dc0f61703d17ac859ecb2902ba6` |

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

These files select silent audio and Lato-derived Terminal Sans at 14 pixels.
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
| [pico2w-demo/firmware.uf2](pico2w-demo/firmware.uf2) | 437,248 | `6bef75f31893b0c709391296114163ddc47554f1c8b0dbbb2e0dc506bcb65d03` |
| [picow-demo/firmware.uf2](picow-demo/firmware.uf2) | 471,552 | `c6a8cb5cb72133798dcb79b243480b9fc6ab47ff4559ad9db349bcf200ad920d` |

Flash the firmware matching the chip, then its [silent panel settings](output-settings/).
The built-in demo starts automatically with a centered 320 x 200 picture.
RP2350 uses 64 KB of guest memory and a silent backend. RP2040 uses 56 KB,
disables disks and links the optional Bluetooth backend; silent saved settings
keep its radio off. Both demo programs use runtime source `3f81486`, matching the refreshed Unix
firmware. The manifest records the RP2040 Bluetooth link profile separately.

The firmware and settings preserve the installed disk pack. Flash normal
firmware to return to Unix. **Installing RP2040 radio firmware for sound
overwrites part of Mini-Unix:** back up first, then restore the pack or flash
backup when returning to Unix. See [sound setup and measured results](../OUTPUTS.md#graphics-and-sound-demo).
Speaker playback passed on the actual Pico W and was confirmed by the user.
The preceding firmware sustained 57.51 FPS with Bluetooth sound, with zero
audio underruns, overruns, errors or synthesis delays. This CPU refresh
retains the same audio producer/transport; the new binary was checked with
silent settings, without repeating speaker playback.

## Hardware validation

Detailed checks are in [VALIDATION-2026-10-26.md](VALIDATION-2026-10-26.md).

The final program and Unix bytes were checked on their corresponding boards.
V7 PSRAM installation transferred the changed sectors from each complete
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
remains 56 KB on RP2040 and 152 KB on Pico 2 W. The Pico W keeps 124 write
blocks. Pico 2 W has 248 file-write blocks plus 112 swap blocks; runtime font
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
