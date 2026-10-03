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
| `pico2w-v6/combined.uf2` | 5,305,344 | `54586ace6e6f1bc1e075d8a4b99d98ec87b5fc453427419e31f04c1ee437065c` |

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

## Pico W (RP2040): Mini-Unix

| File | Size | SHA-256 |
|---|---|---|
| `picow-mini-unix/firmware.uf2` | 300,544 | `1f7ba676f40e522a12295d82488043f1793551004ee7a035d4e2ed45539fb706` |
| `picow-mini-unix/minix.uf2` | 3,167,232 | `de8bb8dc541f17e25b38097f7b0063cdb0f11d7ff28a81eb8a1fb0e75460f55a` |

**Flash these as two separate copies**, firmware first, then the pack, each
from a fresh BOOTSEL (the `RPI-RP2` drive). On the RP2040 a single combined
UF2 leaves the pack area unwritten. The pack holds only the used blocks of
the Mini-Unix pack (`../mini-unix.rk05`, 3,061 blocks, mapped) so it fits
the Pico W's flash. It boots `rkmx` by itself; `#` 3.2 s after the port
opened on a Pico W. Mini-Unix runs with memory management off (the stats
block says `MMU off (16-bit)`). `time od /rkmx >/dev/null` takes real 8.0 s,
user 7.5 s on a Pico W, timed from the host 8.09 s a run (8.64 s before the
speed pass of 2026-10-03: about 6% faster).

Known: the RAM for disk writes (124 blocks, shared with swap) fills after a
few commands; when it does, the console says so once and Unix sees a disk
error. Mini-Unix swaps whole processes, and a refused swap write can
restart the shell, so keep sessions short for now.
