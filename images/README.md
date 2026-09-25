# Ready-to-flash Unix images

These are the exact files flashed to real boards on 2026-09-25, when Unix ran
on the emulator on silicon. Each contains the PDP-11 emulator firmware
(diagnostic build, with the live statistics block on `Ctrl-]` then `s`) and
an RK05 disk pack stored in flash. Both builds are **read-only**: the flash is
never written. Swap and every disk write go to RAM and are lost at power-off.

The UNIX files inside the disk packs are covered by the Caldera licence in
`../../UNIX-LICENSE.txt`.

## Pico 2 W (RP2350): Sixth Edition Unix, MMU on

| File | Size | SHA-256 |
|---|---|---|
| `pico2w-v6/combined.uf2` | 5,270,528 | `93a8cc86d992d9f68842e6d95d025a7e2b632fc3bbcd470987d90d8d2dd1ac31` |

Firmware and disk pack in one UF2. Hold BOOTSEL, plug in, copy the file to the
drive. At the serial console (115200):

```
BOOT RK0 173030
@rkunix
```

Boot to `#` takes about 3 s. The pack is the V6 root pack with V6's own
`rkuboot` installed in block 0 (`tools/rk_image.py --boot-block`).

Known: `ps` and `df` fail because the pack's `/dev` has no disk or swap
entries; V6's `dc` is too large for the 56 KB machine.

## Pico W (RP2040): Mini-Unix

| File | Size | SHA-256 |
|---|---|---|
| `picow-mini-unix/firmware.uf2` | 277,504 | `9c627c9b22a000a9e506c7686761a183efb3efac9c6ffa5831413c3e8cd8ff0d` |
| `picow-mini-unix/minix.uf2` | 3,159,040 | `0b6de55d5117c08ff066031a53e4b044df852684037a36a7339a3c38316eb0eb` |

**Flash these as two separate copies**, firmware first, then the pack, each
from a fresh BOOTSEL. On the RP2040 a single combined UF2 leaves the pack
area unwritten. The pack holds only the used blocks of the Mini-Unix pack
(3,053 blocks, mapped) so it fits the Pico W's flash. At the console:

```
BOOT RK0 173030
@rkmx
```

Boot to `#` takes about 2 s.

Known: the RAM swap area (128 blocks) fills after a few commands. Mini-Unix
swaps whole processes, and a refused swap write can restart a process, so
keep sessions short for now. `df` reports "BAD FREE COUNT" on this pack; the
image tool now keeps the free-list blocks, and the next pack will not.
