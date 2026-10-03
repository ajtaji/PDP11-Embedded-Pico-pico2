# Ready-to-flash Unix images

Each board **powers up into Unix**: the firmware boots the disk pack by
itself and Unix's `#` prompt appears with no typing. Press **Esc** within
2 s of the `auto-boot:` line to stay in the diagnostic console instead.
How to flash, connect and use them, and how to rebuild them from
`../media/unix/` with the tools, is in **[../README.md](../README.md)**.

Both run the emulated processor alone on core 0, with its run loop in
SRAM, and USB, the console and the disk's storage on core 1. Both builds
are **read-only**: the emulator never writes the flash. Swap
and every disk write go to RAM and are lost at power-off, so a board can be
unplugged at any time and always starts again from the pack as flashed.

The UNIX files inside the disk packs are covered by the Caldera licence in
`../Caldera-license.pdf`.

## Pico 2 W (RP2350): Sixth Edition Unix, memory management on

| File | Size | SHA-256 |
|---|---|---|
| `pico2w-v6/combined.uf2` | 5,305,344 | `6b59055917ec9dbec165088bd87c4df3637d27ef8e9096a8e9a21294155e309d` |

Firmware and disk pack in one UF2: hold BOOTSEL, plug in, copy the file to
the `RP2350` drive. At the serial console:

```
auto-boot: RK0, switches 173030, then "rkunix" at the @ prompt. Press Esc within 2 s for the diagnostic console.
booting RK0, switches 173030
@rkunix
mem = 76
#
```

`#` 3.4 s after the port opened on a Pico 2 W (2 s of the Esc wait, then the
boot). `time od /rkunix >/dev/null` takes real 17.0 s, user 16.4 s, 17.4 s timed
from the host (19.3 s before the dispatch pass of 2026-10-03, 21.7 s before
the speed pass of 2026-10-02). The file-write overlay is 38 blocks (it was 48):
ten went to MOV handlers in SRAM. The pack is the V6 root pack (`../media/unix/v6root.gz`) with V6's
own `rkuboot` installed in block 0.

The pack is changed with `tools/v6fs.py` (see `../README.md`): `/dev/rk0`,
`/dev/rrk0` and `/dev/swap` added, `/unix` linked to the kernel that runs,
and the kernel's swap sized to the firmware's 112-block swap RAM disk. `ps`
works; use `df /dev/rk0` (plain `df` looks for V6's built-in `/dev/rk2` and
`/dev/rp0`). V6's `dc` is too large for the 56 KB machine.

The PSRAM boards' images, not yet run on a board, are in
[untested/](untested/README.md).
So is a build of this Pico 2 W image with the newer compiler (main `f408822d`),
which has run only in the emulator: `untested/pico2w-v6-newcompiler/`.

## Pico W (RP2040): Mini-Unix

| File | Size | SHA-256 |
|---|---|---|
| `picow-mini-unix/firmware.uf2` | 270,848 | `479f3db8145e457f4297d588e59c9a0243bafcbd8fbb9fe55ded203e19914f3d` |
| `picow-mini-unix/minix.uf2` | 3,167,232 | `de8bb8dc541f17e25b38097f7b0063cdb0f11d7ff28a81eb8a1fb0e75460f55a` |

**Flash these as two separate copies**, firmware first, then the pack, each
from a fresh BOOTSEL (the `RPI-RP2` drive). On the RP2040 a single combined
UF2 leaves the pack area unwritten. The pack holds only the used blocks of
the Mini-Unix pack (`../mini-unix.rk05`, 3,061 blocks, mapped) so it fits
the Pico W's flash. It boots `rkmx` by itself; `#` 3.2 s after the port
opened on a Pico W. Mini-Unix runs with memory management off (the stats
block says `MMU off (16-bit)`). `time od /rkmx >/dev/null` takes real 6.0 s,
user 5.5 s on a Pico W, timed from the host 5.94 s a run (7.09 s before the
compiler's code generation pass of 2026-10-03 and the dispatch tails in
assembly, 8.09 s before the MOV handlers by addressing mode, 8.64 s before
the speed pass of 2026-10-03). The memory-management-off bench loop runs at
2,587,000 instructions/s (2,048,000 before). No clock ticks are dropped and
the longest gap between USB services is 332 us. Built with PureMetal Forge
main `f408822d`, with `#ASM_TAILS = 1` in `pico/instructions.pico`; the DEC
diagnostics DFKAA, DFKAB and DFKAC pass on the board with this file.

Known: the RAM for disk writes (124 blocks, shared with swap) fills after a
few commands; when it does, the console says so once and Unix sees a disk
error. Mini-Unix swaps whole processes, and a refused swap write can
restart the shell, so keep sessions short for now.
