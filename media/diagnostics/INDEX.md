# PDP-11 self-test / diagnostic software — index

Downloaded 2026-09-23 for exercising the PureMetal J-11 (KDJ11-BF) emulator at
`C:\Users\rajta\Desktop\pico-PDP11\PureMetal\J11_18MHz_KDJ11_BF\pico` (and `pico2`).

**What the emulator models today** (from `pico\cpu.pico`'s header, read before this
search): J-11 base instruction set + EIS (MUL, DIV, ASH, ASHC, XOR, SOB, SXT, MARK,
MFPS, MTPS, MFPT, SPL); no FPU (17xxxx traps reserved); 16-bit physical addressing,
MMU OFF, 56 KB RAM at 000000-157777, I/O page at 160000-177777 where **only the PSW
(177776) answers** — everything else in the I/O page is a bus error; **one processor
mode** (MFPI/MTPI/MFPD/MTPD act on the single space; no banked SP); no devices at all
— no DL11 console at 177560/177564, no clock, no disk. A bus/odd-address trap is taken
after the faulting instruction finishes, not before.

Every diagnostic below needs **at minimum a DL11-compatible console at 177560-177566**
(keyboard status/data 177560/177562, printer status/data 177564/177566) to show
anything or ring the bell; none of that exists in the emulator yet, so nothing here
runs today without adding it. That gap is called out per entry below, and summarized
at the end.

Nothing was executed. These are PDP-11 binaries/images; they were only downloaded.

---

## 1. `bitsavers-papertapeimages/` — source: bitsavers.org, `bits/DEC/pdp11/papertapeimages/{20040101,20040310}/`

Individual scanned MAINDEC absolute-format paper-tape images (small, single files,
each a self-contained diagnostic — no monitor/XXDP needed, just RAM + the absolute
loader + a console).

| File | Size | SHA-256 | Tests | Needs | Runs today? |
|---|---|---|---|---|---|
| `maindec-11-dzqkc-e-pb.bin` | 8351 | `663dbc1381c5a365540c632fdd1307d520f09d492449a7c152ffe257afb93eef` | MAINDEC-11-DZQKC-E, "11 Family Instruction Exerciser" — broad, randomized exercise of the base PDP-11 instruction set in all addressing modes | RAM (4K+), console, absolute loader | No console/loader yet; otherwise fits (no MMU, no EIS assumed) |
| `maindec-11-dqkdb-a-pb.bin` | 9482 | `641c85f7524364b946bc3d8f7daea77d30779365f81f955ea740b09fc3658b34` | MAINDEC-11-DQKDB-A, "PDP-11/6X Traps Test" — trap vectors, reserved instructions, stack limit | RAM, console | No console; written for 11/60-class (has MMU/cache) — expect some assumptions that don't hold on a bare MMU-off J-11 |
| `dec-11-uabla-a-po.bin` | 585 | `eed6a43a6a253be289441204fb23413db295393d3b91002e6d57edfce78d43f` | Not a test — the **non-switch-register Absolute Loader**, rev A | RAM, console (reads subsequent tapes in "Absolute Format") | This is the loader our emulator needs to implement (see format notes, section 5) |
| `dec-11-uablb-a-po.bin` | 632 | `c656ae290f48f8d97c252c2c69778c205d853102846f96c144d39110a6f654b9` | Same, rev B (successor to uabla) | same | same |
| `maindec-11-dfkaa-b1-pb.bin` | 12390 | `d2fe3c18d45f34218d3b91198dc4b454f8d5344acb6293ea522232e9907eb5be` | MAINDEC-11-DFKAA-B1, PDP-11/34 **Basic Instruction Test** | RAM, console | No console; 11/34 is EIS-capable like our J-11 base — good instruction-logic fit |
| `maindec-11-dfkab-c-pb.bin` | 8419 | `e7ec0e07cc0a72c1a2a00810d20f21effd911bd69d8ba0782f5ed2c4b9c340b5` | MAINDEC-11-DFKAB-C, PDP-11/34 **Traps Test** | RAM, console | No console; exercises vectors 4/10/14/20/30/34 which the emulator does implement |
| `maindec-11-dfkac-a-pb.bin` | 8767 | `2f20971e7cdf2d260c3fc535635b0b1f14698165d3ace13ba4dd96ec8936134f` | MAINDEC-11-DFKAC-A, PDP-11/34 **EIS Instruction Test** (MUL/DIV/ASH/ASHC) | RAM, console, EIS | No console; this is the closest real match to "EIS test names DCKBA/DZKMA-style" the task guessed — real MAINDEC name is **DFKAC**, not DZKMA (DZKMA is a memory exerciser, see next row) |
| `maindec-11-dzkma-d-pb.bin` | 5482 | `e0d1b7433fcc2ecd56097870333ec4c244923d9bfea40612a17dd169433a21c7` | MAINDEC-11-DZKMA-D, "MOS/Core Memory Exerciser 0-124K" — pattern-tests RAM, not instructions | RAM, console | No console; good fit for exercising the full 56 KB once console exists |
| `maindec-11-dzm9a-d-pb.bin` | 4344 | `88f12ad6199e0a2339151b700847b133e7baf940d1be75c99908692b777a3ed` | MAINDEC-11-DZM9A-D, M9301/M9400 Bootstrap-ROM Terminator diag | M9301 boot-ROM hardware | Not applicable — tests a ROM module our design doesn't have; low priority, kept for completeness |
| `maindec-11-dzkaq-g-pb.bin` | 3321 | `4be0d13fa6521e00af03f4001af65a7664a6d9724e12d80b8038acfc8db1ff7e` | MAINDEC-11-DZKAQ-G, PDP-11 Power-Fail Diagnostic | Power-fail trap (vector 24), console | Needs a trap vector the machine doesn't raise yet (no power-fail device); low priority |

## 2. `pcjs/tapes-diag/` — source: pcjs.org (`www.pcjs.org/software/dec/pdp11/tapes/diag/`, mirrored on GitHub `jeffpar/pcjs`, `gh-pages` branch), files stored as pcjs's own pre-decoded JSON tape format (`{"exec":<addr>,"words":[...]}` — already parsed from the Absolute-Format tape, not a raw punch image)

The **owner's requested source**. This is the classic "T1–T15" DEC test sequence,
predating XXDP, designed for a bare 4 KB PDP-11 + console + absolute loader — the
best structural match for the emulator's current bare-metal state of any diagnostic
found.

| File | Size | SHA-256 | Test | exec addr | Needs | Runs today / fit |
|---|---|---|---|---|---|---|
| `MAINDEC-11-D0AA-PB.json` | 25502 | `69a119c646cc1eef9421320993a59d00dd7af7cff83c54b9a4337730ce09f614` | T1 Branch | 000200 | RAM (4K), console | Clean fit — pure BR-family logic, loops and rings bell |
| `MAINDEC-11-D0BA-PB.json` | 11066 | `fda8c25ecffc4b19f200efe4a4303b471df20b6b2d443a5db153b7142c64e023` | T2 Conditional Branch | 000200 | same | Clean fit |
| `MAINDEC-11-D0CA-PB.json` | 13524 | `c9bd1421836a8d390a343ce87589fde536050b03dd56ea523bcf98857a48e292` | T3 Unary ops | 000200 | same | Clean fit |
| `MAINDEC-11-D0DA-PB.json` | 30785 | `4aaccd3e8d1c8dc5ca3dcccd2e4937db11aeae01e468421af278983b5670c0e3` | T4 Unary + binary ops | 000200 | same | Clean fit |
| `MAINDEC-11-D0EA-PB.json` | 19767 | `8683860c967b2659c14ee4559e9cde7154b9060f61050d4299ca0e95221533a3` | T5 Rotate/Shift | 000200 | same | Clean fit |
| `MAINDEC-11-D0FA-PB.json` | 30368 | `4dc728c1b1b37906d08f5d0799febe3496eb046f1c85ae153f9b03dca8df78b8` | T6 Compare (equality) | 000200 | same | Clean fit |
| `MAINDEC-11-D0GA-PB.json` | 25099 | `61bac0dd63f1cb69fd3f18066126665d6fc2719895d0570f07904753f22e876a` | T7 Compare (non-equality) | 000200 | same | Clean fit |
| `MAINDEC-11-D0HA-PB.json` | 22154 | `1ab2be8ef960fac803736e74e908537240c365a8b0f00b73aff38d260fd8c52c` | T8 Move | 000200 | same | Clean fit |
| `MAINDEC-11-D0IA-PB.json` | 25078 | `aeae9be1e1a4075fc342c66bad121ffb28e6a63196f7ed69ddecc9af10d060cc` | T9 BIS/BIC/BIT | 000200 | same | Clean fit |
| `MAINDEC-11-D0JA-PB.json` | 16024 | `e316c91cf5ea6d48def1fed7ff80e7afeae3bde1563e0f602654654293197695` | T10 Add | 000200 | same | Clean fit |
| `MAINDEC-11-D0KA-PB.json` | 14979 | `53b6c0babd5ff82240ec953411b6a3a2e3a74205c6f1431ef0d98f8cd20c7d0c` | T11 Subtract | 000200 | same | Clean fit |
| `MAINDEC-11-D0LA-PB.json` | 28369 | `376a367d23807a2c24e3ccad420e40a1453e15edc374062df2e6ed22751b71fc` | T12 Jump | 000200 | same | Clean fit |
| `MAINDEC-11-D0MA-PB.json` | 9541 | `618e411032049d20a373dd7765f1d761e7854c454e24a02f7358825ba36b4368` | T13 JSR/RTS/RTI, first R6 push/pop | 000200 | same | Mostly fits; **RTI behavior differs between the 11/20 and 11/45+ microcoded models** (pcjs's own dev notes) — J-11 follows the newer behavior, so treat any RTI-related failure as expected, not a bug |
| `MAINDEC-11-D0NA-PB.json` | 16448 | `08566f151627d3225e65c073bd616b30d32975ab96aee40e13e4b9f0b9a17ee0` | T14A Traps | 000214* | RAM, console | **Not compatible** — explicitly written for 11/20-class only; it expects MUL to trap as a reserved instruction, but the J-11 (EIS) executes MUL. Will false-fail. Kept for reference only |
| `MAINDEC-11-D0NB-PB.json` | 16490 | `71cb54499317cfe402c1c3ac0db0449b3d7de72a756e34d8b7fa11b9f7ed4a7b` | T14B Traps (rev B) | 000214* | same | Same MUL-trap incompatibility as D0NA |
| `MAINDEC-11-D0NC-PB.json` | 16970 | `e0c005bb618026e69167a8d4aab01f50394a22a90d106864bc9f332a42d9906e` | T14C Traps (rev C) | 000214* | same | Same MUL-trap incompatibility |
| `MAINDEC-11-D0OA-PB.json` | 19047 | `2c981ca47c8001d65c01a3b263ccb5227d615fc302ee098608870f80d736f2f1` | T15 "comprehensive check of all 11-family instructions", relocates itself through 0-28K, has printed output + switch-register options (SW15 halt-on-error etc.) | 000200 | RAM (4K-28K), console, (optional KW11-L line clock) | **Caution** — also documented by pcjs as failing on 11/45-and-newer due to the same RTI change noted for T13. Good stress test once console exists, but expect at least one RTI-related false failure |
| `MAINDEC-11-DEQKC-B1-PB.json` | 90081 | `209c92e6368ede3fba412f9c52f520cd6480afa9a8abbf8161c3a1cdd1d23f4a` | 11/70 CPU Instruction Exerciser — the modern, comprehensive, EIS-era exerciser; prints startup/config info, then exercises instructions across addressing modes including stack-limit checks | RAM, console | Best of the "big" exercisers for an EIS CPU; pcjs notes its stack-overflow checks are model-dependent (addressing modes 3/5/7 vs 6) — since our MMU is off and there's one mode, expect to need to tolerate/patch its stack-limit assumptions |

\* pcjs picked the 28K-system entry address (000214) as the default `exec`; the
diagnostic's own procedure lists 000200/202/204/206/210/212/214 depending on how much
RAM is present — for our 56 KB (28K words) machine, 000214 is actually the documented
correct start address.

`pcjs/tapes-diag/README.md` (17068 bytes, `971d8557adfba7aca6ff0fef8c9c8db9c04f19c7b7acfd250c069861ac6a15ad`) is pcjs's own
write-up of all the above: what each test checks, its DEC abstract text, and pcjs's
dev notes on where their emulator disagreed with real hardware (the MUL-trap and RTI
issues cited above came from here).

## 3. `pcjs/tapes-absloader/` — source: pcjs.org, same GitHub mirror

| File | Size | SHA-256 | What |
|---|---|---|---|
| `DEC-11-L2PC-PO.json` | 1662 | `a9fba85bab5249eaffd689b69d3bfc8b9455b9457fc8bf0db84ed49c4c47e1fc` | The DEC-11-L2PC-PO **Absolute Loader** binary, pcjs's decoded-word form |
| `README.md` | 3116 | `d33a88b75ac9f7240bf3f840ea15577bea85acaf31ef2e7d352a8b2cbeeeedcc` | pcjs's description of the "Absolute Format" tape structure (see section 5) plus links to two more DEC loader listing scans |

## 4. `bitsavers-xxdp-diag_listings/` — source: bitsavers.org, `pdf/dec/pdp11/xxdp/` (documentation/listings, no runnable code)

| File | Size | Documents |
|---|---|---|
| `AH-FG66P-MC_pdp11DiagIdx_Jun92.txt` | 374579 | **The master DEC diagnostic index** (mnemonic → file name → description) used to identify every test above, e.g. confirms `ZKDJ`/`CZKDJB2` = "KDJ11 CPU DIAG" and `ZQKC` = "11 FAMILY INSTRUCTION EXERCISER" (= DZQKC) |
| `MAINDEC-11-DZQKC-E-D_11_Family_Instruction_Exerciser_Mar75.pdf` | 3352670 | Listing for `maindec-11-dzqkc-e-pb.bin` above |
| `MAINDEC-11-DZQAB-B-D_MAINDEC_User_Reference_Manual_Oct73.pdf` | 8305612 | The MAINDEC user reference manual — includes the T1–T12 abstracts/procedures pcjs quotes for the D0AA–D0LA tests |
| `MAINDEC-11-D0NB-D_T14_TRAP_TEST_Feb71.pdf` | 2574152 | Listing for T14B trap test (`MAINDEC-11-D0NB-PB.json`) |
| `MAINDEC-11-D0OA_T15_COMBINED_INSTRUCTION_TEST_Mar70.pdf` | 1995869 | Listing for T15 (`MAINDEC-11-D0OA-PB.json`) |
| `MAINDEC-11-DZKAQ-G-D_PDP-11-Power-Fail-Diagnostic_Nov77.pdf` | 1874807 | Listing for `maindec-11-dzkaq-g-pb.bin` |
| `DEC-11-UABLB-A-LA_Non-Switch-Reg-PDP11-Abs-Loader_Jun75.pdf` | 298802 | Listing for the non-switch-register absolute loader (`dec-11-uabla/b-a-po.bin`) |
| `1134/AC-8041C-MC_CFKAAC0-1134-Bsc-Inst-Tst_Oct78.pdf` | 17072347 | Listing (later rev) for `maindec-11-dfkaa-b1-pb.bin` |
| `1134/MAINDEC-11-DFKAB-C-D_1134-Trap-Test_May77.pdf` | 5823649 | Listing (exact rev match) for `maindec-11-dfkab-c-pb.bin` |
| `1134/MAINDEC-11-DFKAC-A-D_1134-EIS-Instruction-Tests_Dec75.pdf` | 5680706 | Listing (exact rev match) for `maindec-11-dfkac-a-pb.bin` |
| `memory/MAINDEC-11-DZKMA-B-D_MOS-Core-Mem-Exer_Aug76.pdf` | 5285302 | Listing (earlier rev) for `maindec-11-dzkma-d-pb.bin` |
| `M9301/AC-8954E-MC_CZM9AE0-Bootstrap_Terminator-M9301_M9400_Apr79.pdf` | 2610069 | Listing for `maindec-11-dzm9a-d-pb.bin` |

## 5. `bitsavers-xxdp-disk-images/` — source: bitsavers.org, `bits/DEC/pdp11/xxdp/`

| File | Size | SHA-256 | What |
|---|---|---|---|
| `xxdp-plus-du.dsk.gz` | 3328876 | `04b3149ef2ceac004e8adcf81144fa430e84a31d006fe17a1d12816204dc398a` | Gzipped **XXDP+ disk image** (RD/DU-type). This is the only place the actual KDJ11-B/J-11-specific CPU diagnostic was findable: the master index (item 4) lists `ZKDJ`/`CZKDJB2` "KDJ11 CPU DIAG", plus KDJ11-B installation diagnostics `IKDB`/`IKDC` (enable/disable halt-on-break), `IKDJ` (cluster diag), `OKDA` (KDJ11-B cluster diag) and `IEES` (EEPROM setup) — none of these exist as standalone paper-tape files anywhere searched; they postdate paper tape and are XXDP-only. **Not extracted or run** — needs an XXDP-aware disk-image tool (e.g. SIMH's `dir`, or a XXDP file-system reader) to pull out individual `.BIN` files, which is future work, not done here |

The XXDP+ Programming Card / Users Manual describing this format were seen at the
same bitsavers path (`AC-F348E-MC_XXDP+_Users_Manual_Rev_E_Apr81.pdf`,
`AC-OXXDP-MC-001_XXDP+_Programming_Card_1981.pdf`) but were **not downloaded** —
flagged here in case extracting `ZKDJ.BIN` later needs them; they are on the same
bitsavers directory listed above.

---

## The Absolute-Format tape structure (needed to write our loader)

From `pcjs/tapes-absloader/README.md`, which reproduces PCjs's own reverse-engineered
notes on the format (also documented in DEC-11-UABLB, item 4):

- Data is organized into blocks. Each block starts with a 6-byte header, little-endian:
  - 2-byte signature `0x0001`
  - 2-byte block length (= N + 6, i.e. includes the header)
  - 2-byte load address
  - followed by N data bytes
  - followed by 1 checksum byte (8-bit sum of the whole block, including header and
    checksum, must be 0)
- A block with N = 0 means: the "load address" field is actually the **exec address**.
  The real Absolute Loader jumps there if the address is even, halts if it's odd
  (odd is almost always literally `1`, used as an end-of-tape/no-autostart marker).
- Leading zero words before the first `0x0001` signature are tolerated; a tape may
  also not end cleanly (loader stops at the first bad signature once ≥1 block loaded).

This is exactly what our emulator needs to add: a way to feed one of these tape
images into `Mem.u()` at the addresses each block specifies, then set PC to the exec
address — i.e. the same job the real DEC Absolute Loader (`dec-11-uabla/uablb`,
`DEC-11-L2PC-PO.json`) does from a running PDP-11, except done host-side since we
have no paper-tape reader to model.

---

## What each test prints / how you know it passed (from pcjs's README + the DEC abstracts)

- **T1–T12 (D0AA–D0LA)**: no printed output. Each loops forever; on successful
  completion of a pass it writes a bell character (with the high bit set — pcjs
  isn't sure why) to the console printer at `177566`/`177567` (`MOV #207,@#177566`
  then polls `TSTB @#177564` for ready), then jumps back to `000200` and repeats.
  A wrong branch/compare/etc. falls through to a `HALT`. So: **PASS = the machine
  keeps running and periodically pulses the console output; FAIL = CPU halts**
  (a real HALT would trap through vector 4 or actually stop the CPU, depending on
  mode — worth deciding how our emulator surfaces a HALT).
- **T13 (D0MA)**: same pattern — bell after ~2 minutes, no other printout.
- **T14 (D0NA/B/C)**: same, bell on completion — but again, expect a false HALT/trap
  on our EIS CPU because it treats MUL as a real instruction, not a reserved-trap.
- **T15 (D0OA)**: this one **does** print to the console, and has switch-register
  options (SW15 halt-on-error, SW14 loop-on-subtest, SW13 inhibit error printout,
  SW12 inhibit trace trapping, SW11 inhibit subtest iteration, SW10 ring bell on
  error, SW8/SW7-0 microbreak register). Our emulator has no switch register modeled
  either — another gap to note if this test is brought up later.
- **DEQKC (11/70 exerciser)**: prints startup/configuration information to the
  console before running, then reports errors to the console as they occur.
- **DZQKC ("11 Family Instruction Exerciser")**: per its MAINDEC abstract (see the
  listing PDF), it is a randomized/looping exerciser; behavior on error and console
  output format is in the listing PDF (not reproduced here — see the PDF for the
  exact error report format).

---

## Recommended order to try (simplest first)

1. **T1 Branch (`MAINDEC-11-D0AA-PB.json`)** — the simplest possible program: three
   instructions in a loop, no traps, no EIS, no addressing-mode variety. If this
   doesn't run, nothing will.
2. **T2–T12 (`D0BA`...`D0LA`)** — same shape, one instruction family at a time
   (conditional branch, unary/binary ops, shifts, compares, move, bit ops, add,
   subtract, jump). Together they're a clean, incremental instruction-set bring-up
   ladder with zero MMU/EIS/trap entanglement.
3. **PDP-11/34 Basic Instruction Test (`maindec-11-dfkaa-b1-pb.bin`)** — a denser,
   single-file basic-instruction test from a real EIS-era CPU (11/34), good second
   opinion once T1–T12 pass.

After that: the 11/34 Traps Test (`dfkab`) and EIS Instruction Test (`dfkac`) to
exercise trap vectors and MUL/DIV/ASH/ASHC/XOR specifically; then DZQKC and DEQKC as
broader randomized/comprehensive exercisers; T13/T15/T14 last, with the RTI/MUL
caveats above in mind; DZKMA to soak-test the full 56 KB; and finally, if the XXDP+
disk image gets extracted, the real `ZKDJ` KDJ11 CPU diagnostic as the authoritative
one for this exact CPU.

## What the emulator needs to gain to run any of these

1. **A DL11-compatible console** at 177560 (keyboard status), 177562 (keyboard
   data), 177564 (printer status), 177566 (printer data) — every single diagnostic
   above needs this at minimum to show progress or ring the bell; right now the I/O
   page only answers for the PSW at 177776 and everything else bus-errors.
2. **A way to load an absolute-format tape image into RAM and set the PC**, per the
   block format above — this replaces the physical paper-tape reader + toggled-in
   Absolute Loader (`dec-11-uabla`/`uablb`/`DEC-11-L2PC-PO`); simplest is to parse the
   format host-side (in the Pico's boot/setup code or a companion tool) and write
   `Mem.u()` directly rather than emulating a real PC11 paper-tape reader.
3. **A defined HALT behavior** (does it trap, stop `CpuRun`, or spin?) since several
   tests use HALT as their "test failed" signal.
4. Optional, for the later/bigger tests only: a switch register (T15's SW10-SW15),
   a line clock KW11-L (T15 optional), and — to run the real KDJ11-specific `ZKDJ`
   diagnostic — an XXDP+ file extractor for `xxdp-plus-du.dsk.gz` plus whatever
   minimal XXDP monitor environment that diagnostic expects at load time.

No MMU, no FPU, and no second processor mode are needed for anything recommended
above (items 1-3 in the run order); those only start to matter for the traps/EIS
tests' edge cases and for D0NA-D0NC/D0OA/D0MA's RTI/MUL-trap incompatibilities noted
per-file above.
