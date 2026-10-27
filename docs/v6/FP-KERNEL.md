# FP-enabled V6 kernel for the J-11

The new V6 system images boot `/rkfp`. The former `/rkunix` and, on PSRAM
images, `/rk70unix` remain as recovery kernels. `/unix` points at `/rkfp`
so tools such as `ps` use the running kernel's symbols.

The previous V6 images disabled floating-point context support: the normal
11/40 kernel's `_savfp` was just RTS PC, and the earlier PSRAM m45 build used
`.fpp = 0`. Individual numerical programs could run, but switching between
FP processes or executing a new program did not preserve/reset the state.
The unchanged preceding firmware reproduces the state failure.

This kernel uses V6's stock m45 configuration with `.fpp = 1`, which the
emulated J-11 supports on both Pico 2 W and the PSRAM boards. The changes are:

- Save FPS and all six complete D-format accumulators in the existing
  25-word user-area slot, including when the user selected F mode.
- Use D mode with FP exceptions masked during state transfers, then restore
  the original FPS. Reserved/dirty-zero bit patterns survive the transfer.
- Use reserved FPS bit 010000 as the internal lazy-save marker. V6's original
  bit 020 collides with the real J-11 maintenance bit.
- Retain V6's exec clearing and trap handling; with the FP paths enabled,
  live registers now reset on exec and FP exceptions deliver signal 8.
- Compute the memory-display figure without overflowing a 16-bit integer,
  as required by the PSRAM boards. Guest memory/process limits are unchanged.

## Updating

A firmware-only upload keeps the installed kernel. To obtain this V6 fix,
install the updated **V6 combined system image** for the board. Back up saved
files first: replacing a factory filesystem is a system-image update.
The changed V6 RK0 pack has a new nonce, so saved blocks from the previous
filesystem cannot be applied to the new one. RK1 source disks and V7 disks
and their nonces are unchanged. V7 already has its own FP kernel support.

For an existing UF2 image, `tools/v6_fp_image.py` adds the new kernel and its
sources, preserves every existing regular file and fallback kernel, relinks
`/unix`, and produces either an updated combined image or a pack-only UF2:

```text
py -3 tools/v6_fp_image.py old-combined.uf2 --chip pico2 --kernel media/unix/rkfp-j11 --pack-only updated-pack.uf2 -o updated-combined.uf2
```

Use `--chip picoplus2` or `--chip feather` for those V6 images. This tool edits
filesystem bytes; it does not execute an emulated CPU. It is for V6 images,
not V7. A PSRAM board's live saved changes must be backed up separately;
editing a factory UF2 does not merge its flash journal.

## Build on a physical board

The accepted kernel was compiled, assembled and linked under V6 on a physical
Feather RP2350 with PSRAM. Its larger writable filesystem is required for
the linker's temporary files; the standard read-only overlay is too small.
The production firmware retains its full guest/overlay allocations.
Unix-derived sources retain the repository's [Caldera licence](../../Caldera-license.pdf).

The image tool installs [m45fp.s](m45fp.s) in `/usr/sys/conf/` and
[mainfp.c](mainfp.c) in `/usr/sys/ken/`. The [patch](fp-context.patch) records
the changes against the distribution's sources. On the board:

```text
chdir /usr/sys/ken
cc -c -O mainfp.c
chdir ../conf
as m45fp.s
mv a.out m45fp.o
cc mkconf.c
mv a.out mkconf
mkconf
rk
tm
tc
done
cc -c c.c
as data.s l.s
ld -x -r -d a.out m45fp.o c.o ../ken/mainfp.o ../lib1 ../lib2
nm -ug a.out
sysfix a.out x
od -b x
```

The linker and `nm -ug` must report no unresolved symbols. Export `od -b`
using the documented native-board workflow, retaining its repeated rows.
The image tool configures `_nswap = 112` in the exported data for standard
firmware; the PSRAM pack header patches it to 872 in the PSRAM copy only.

V6 `sysfix` produces a special **0407 data-first** file, with text linked at
8192. It is not an ordinary user 0407 executable or an 0411 file. The tool
checks this layout, symbols, bounds and a real FP save body before installation.
The accepted file is 28,504 bytes, SHA-256
`d4329cfdcbc620ecb28a54f922af329f7761e7a39fd0fa565daef617dfa0cfc1`.

## Validation

On both Pico 2 W and Feather, the new kernel passes general numerical tests,
fork/blocking-pipe isolation for all six accumulators and FPS, exec reset,
and divide-by-zero signal 8. The maintenance-bit case passes as well.
Both original and optimized Pico 2 W firmware pass with the same new kernel.
The image builder verifies all 288 pre-existing regular files byte-for-byte.
The Pico Plus 2 image uses this same kernel and is compiled/repackaged;
its earlier physical hardware checks were not repeated for this kernel update.
The Feather's original complete 8 MB flash was restored and compared exactly
after testing, including its saved filesystem.
