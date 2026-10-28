# Ready-to-flash firmware and Unix images

## 2026-10-27 builds

All six programs were freshly rebuilt from source `f4cc314` with
the fixed, signed compiler (`9a582ee9c05acb1d...`). Their UF2 bytes
match the accepted release, including full touched-sector padding and safe
RP2350 E10 prefixes. [Fresh rebuild record](FIXED-COMPILER-REBUILD-2026-10-27.json).
The M33 variants cache data-space MMU row bases, extract call opcode fields
directly and combine instruction-table indexing with its indirect jump.
The RP2040 Unix and demo programs retain their accepted bytes.

V7 images retain the earlier October 27 FP-fixed kernel, its 29 buffers,
2040 KB guest memory and 872 swap blocks. This rebuild preserves all
existing disk payloads and pack nonces, including V6 and Mini-Unix.
[Kernel source and upgrade](../docs/v7/PSRAM-KERNEL.md).

[CPU profile and fresh PSRAM results](../docs/bench/psram-profile-2026-10-27.md)
show the corrected full Unix workload improving about 4.2% on Feather and
3.9% on Pico Plus 2 W, with 404 bytes more free SRAM. V2 traverses each
board's installed `/usr`; the Plus 2 contains more files. Historical and
original-workload comparisons retain their own dates and runtime versions.
Panels, runtime 16-pixel gamma-corrected fonts and audio profiles remain.
The [manifest](manifest-2026-10-27.json) records source, compiler, kernel and
file hashes; [SHA256SUMS](SHA256SUMS) covers all 28 supplied files.

## Updating an existing installation

Firmware-only files preserve the installed guest kernel, Unix packs, output
settings and saved changes. To obtain the **V7 FP context fixes**, install
the matching new **V7 combined system image** or update the kernel in a
backed-up filesystem. Back up saved files before replacing an OS image:
changed pack nonces prevent old saved blocks from being replayed onto it.
For earlier V6 installations, the FP-enabled `rkfp` kernel still requires
the V6 system-image update described in [the V6 guide](../docs/v6/FP-KERNEL.md).

The updated PureMetal Forge uploader accepts the complete RP2350 UF2,
including its E10 prefix, through **Compiler > Flash Prebuilt File...**
or `--radio-firmware`. Native uploads passed on both PSRAM boards with
complete flash readbacks unchanged; [validation](UPLOADER-VALIDATION-2026-10-27.json).
The updated compiler also generates complete sector padding and E10
directly with `-o firmware.uf2`, including sparse flash-asset builds.
Directly compiled Feather and Plus2 files match these published firmware
files exactly; [generation validation](UF2-GENERATION-VALIDATION-2026-10-27.json).
You can also copy the complete file to the BOOTSEL drive. Current RP2350
images include the RP2350-E10 workaround; older prebuilt uploaders reject
its separate Absolute-family prefix. Use Explorer or the
[unchanged-copy helper](../docs/TOOLS.md#bootsel-uf2-copy); do not strip it.

Every touched flash sector contains all sixteen 256-byte payload pages.
Gaps between program, settings, radio and Unix packs stay unwritten. The E10
prefix targets the reserved `0x1004E000` sector, never the saved Unix store
at the end of flash. Firmware-only updates retain existing packs and nonces.

For RP2040 pipes and safe direct floating-point process state, also install the new `picow-mini-unix/minix.uf2`
in a second upload. Updating firmware alone retains the installed guest
kernel. The disk-pack file replaces the installed Mini-Unix pack.

| File | Bytes | SHA-256 |
| --- | ---: | --- |
| [picow-mini-unix/firmware.uf2](picow-mini-unix/firmware.uf2) | 401,408 | `5447f932960b395fa367a11e71e6925e2e0f007bbfe346328e1dbb5d4901728f` |
| [pico2w-v6/firmware.uf2](pico2w-v6/firmware.uf2) | 401,920 | `9c4d4afb7201ef5053bc4307be0d09d63f4f797e993e2bd6bcf8f19d33ff6c95` |
| [picoplus2/firmware.uf2](picoplus2/firmware.uf2) | 459,264 | `2508149b436f95776421a54a8feadc49c9b1658516fca0f5b0ebbd3bbbb8bf5a` |
| [feather/firmware.uf2](feather/firmware.uf2) | 459,264 | `44a96a85b23fcc3d4ff1a219aad3436d8321610099025605c9d3335fa1aa48d2` |

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
| [pico2w-v6/combined.uf2](pico2w-v6/combined.uf2) | 3,432,960 | `3d31d2c59cd62c66bba47d90ae499c01709e07da540dab4ef5cef4f62e317397` |
| [picow-mini-unix/minix.uf2](picow-mini-unix/minix.uf2) | 3,178,496 | `3d866848000a8346f9df8b6f2062144af64b7ed87316d3e6b3b7fa012ef4012e` |
| [picoplus2/combined.uf2](picoplus2/combined.uf2) | 9,560,576 | `fc3327d4872f3618fde9cf97aeae4902fc33f496f9d956a610911b89e7e2360d` |
| [picoplus2-v7/combined.uf2](picoplus2-v7/combined.uf2) | 22,946,304 | `53af2364b2be869af08a5ae274d0531c2497b60a3a7c1d087ee531cc8e1d00c4` |
| [feather/combined.uf2](feather/combined.uf2) | 9,560,576 | `ed0738c069e1337f8262220a806f44f0cf04302cc66e2648550af9a74b4cb5ab` |
| [feather-v7/combined.uf2](feather-v7/combined.uf2) | 9,560,576 | `1bcabc0d8a2c45b82b59136ca950473c213480a25979346e13dcd9316f02a87b` |

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
| [pico2w-demo/firmware.uf2](pico2w-demo/firmware.uf2) | 442,880 | `ed57afa3a77e5eca8523e1cd42e2ff472a4ed5fb50179c2723953d78a39e3dfd` |
| [picow-demo/firmware.uf2](picow-demo/firmware.uf2) | 499,712 | `3be1f48b132c20a221157a16f6412614551c3fb99d7b341da95f1b8e0fa61306` |

Flash the firmware matching the chip, then its [silent panel settings](output-settings/).
The built-in demo starts automatically with a centered 320 x 200 picture.
RP2350 uses 64 KB of guest memory and a silent backend. RP2040 uses 56 KB,
disables disks and links the optional Bluetooth backend; silent saved settings
keep its radio off. Both demo programs include the assembly and gamma/16-pixel updates from `338b5a5`. The manifest records the RP2040 Bluetooth link profile separately.

The firmware and settings preserve the installed disk pack. Flash normal
firmware to return to Unix. **Installing RP2040 radio firmware for sound
overwrites part of Mini-Unix:** back up first, then restore the pack or flash
backup when returning to Unix. See [sound setup and measured results](../OUTPUTS.md#graphics-and-sound-demo).
Speaker playback passed on the actual Pico W and was confirmed by the user.
The preceding firmware sustained 57.51 FPS with Bluetooth sound, with zero
audio underruns, overruns, errors or synthesis delays. This assembly refresh
retains the same audio producer/transport; the new binary was checked with
silent settings, without repeating speaker playback.

## Hardware validation

Current checks are in [VALIDATION-2026-10-27.md](VALIDATION-2026-10-27.md).
The standard and demo program bytes are unchanged after rebuilding; both
PSRAM programs and the V7 kernel were exercised on their physical boards.

### Earlier October 26 validation

[Previous validation](VALIDATION-2026-10-26.md) follows for context.

The new standard and demo programs were checked on Pico W and Pico 2 W.
Full flash readbacks match their final program pages. Pico W preserves its
original settings, pack and radio bytes; Pico 2 W preserves settings/radio
and installs the verified new V6 root pack. PSRAM variants were rebuilt. The new V6 kernel was checked on Feather; the
Pico Plus 2 variant uses the same kernel and was compiled/repackaged. Its
earlier hardware checks are recorded below. V7 disk bytes remain unchanged.
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
py -3 tools/demo_release.py --target rp2350 --audio silent --build-dir build_release/demo --manifest images/manifest-2026-10-26.json
```

The release step takes the existing combined images' disk payloads. It does
not replace them with newly generated packs or change their nonces. This
keeps saved-store identity stable during ordinary firmware updates. This
release separately updates V6 root packs using the committed
`media/unix/rkfp-j11` kernel and `tools/v6_fp_image.py`; see the kernel guide.
The manifest records the accepted pack revision and payload hashes. Source font preparation requires
FontTools only when regenerating `truetype_assets.pmi`; normal firmware builds
use the committed outline assets.
