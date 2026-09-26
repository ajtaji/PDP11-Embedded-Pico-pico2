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
`../../UNIX-LICENSE.txt`.

## Pico 2 W (RP2350): Sixth Edition Unix, memory management on

| File | Size | SHA-256 |
|---|---|---|
| `pico2w-v6/combined.uf2` | 5,286,912 | `c5247a8f4fc4d1068967bf303e7bd6e957b4b07d6f0b9a7ee52c4599b11730b7` |

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
boot). `time od /rkunix >/dev/null` takes 21 s (about 460,000 PDP-11
instructions per second). The pack is the V6 root pack (`../media/unix/v6root.gz`) with V6's
own `rkuboot` installed in block 0.

Known: `ps` and `df` fail because the pack's `/dev` has no disk or swap
entries; V6's `dc` is too large for the 56 KB machine.

## Pico W (RP2040): Mini-Unix

| File | Size | SHA-256 |
|---|---|---|
| `picow-mini-unix/firmware.uf2` | 292,864 | `7db478cc28da839809294f3c23f0d6e0d7f340c1bc7206140533956120a638cf` |
| `picow-mini-unix/minix.uf2` | 3,167,232 | `de8bb8dc541f17e25b38097f7b0063cdb0f11d7ff28a81eb8a1fb0e75460f55a` |

**Flash these as two separate copies**, firmware first, then the pack, each
from a fresh BOOTSEL (the `RPI-RP2` drive). On the RP2040 a single combined
UF2 leaves the pack area unwritten. The pack holds only the used blocks of
the Mini-Unix pack (`../mini-unix.rk05`, 3,061 blocks, mapped) so it fits
the Pico W's flash. It boots `rkmx` by itself; `#` 3.2 s after the port
opened on a Pico W, and the processor runs about 800,000 PDP-11
instructions per second.

Known: the RAM for disk writes (124 blocks, shared with swap) fills after a
few commands. Mini-Unix swaps whole processes, and a refused swap write can
restart the shell, so keep sessions short for now.
