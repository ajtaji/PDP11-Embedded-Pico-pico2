# The PDP-11 on the PC

The emulator the Pico boards run, as a Windows program: the same J-11 with its
FPU and MMU, the KW11-L clock, the RK11 and RP11 disks and the console DL11,
booting the same image files (`images/*/combined.uf2`). It comes as a window
(`PDP11Desktop.exe`) and as a console program for scripted runs and logs
(`pdp11_cli.exe`).

## The same machine, not a second one

The core is not a port kept by hand. `tools/desktop_gen.py` writes
`gen/core.pbi` from the board's own sources in `J11_18MHz_KDJ11_BF/pico2`
(cpu, fp11, the two instruction files, kw11, rk11, rp11), handler for handler.
It makes only the changes listed in its header: the Arm assembly is dropped so
each handler runs its plain version (the one `asm_check.pico2` holds the
assembly to on the board), the 32-bit word size is kept, the dispatch becomes a
computed goto, and a few names are changed. Each rewrite must match exactly,
so a change to the board's sources that one of them no longer fits stops the
tool instead of producing a different machine.

```
python desktop/tools/desktop_gen.py           # after changing the board's sources
python desktop/tools/desktop_gen.py --check   # fails if gen/core.pbi is out of date
```

The board's firmware jobs (BOOT, the auto-boot, the paper-tape reader, the
disks) are in `machine_*.pbi`. The disks are the image file's packs, read the
way the firmware reads them from flash. Writes go to the packs in memory and
the image file is never changed. Memory is 248 KB below the 18-bit I/O page
plus the rest up to what the pack asks for (V7 on the Pico Plus 2: 2040 KB),
as on a board with PSRAM.

There is one terminal, the console at 177560, as on the board. The second
DL11 at 176500 (`docs/TERMINALS.md`) is a plan for the firmware. When it is in
the core it will be here too, with its own pane.

## Building (PowerShell, x64)

```
.\build_cli.ps1       # pdp11_cli.exe
.\build_desktop.ps1   # PDP11Desktop.exe; -Engine <folder/> if the engine is elsewhere
```

The window is drawn with the Neon Arcade Display Engine, found by default at
`C:/Users/ajtaj/Desktop/Neon-Arcade-Dispay-Engine/`.

## The window

`PDP11Desktop [IMAGE.uf2]`. With no argument it loads
`images/picoplus2-v7/combined.uf2` and boots it, as the board does at
power-up: the bootstrap, then the kernel's name typed at the boot block's `@`
and the second step at its prompt.

- **Console**: type into it. Return is CR, Backspace is ^H, Delete is DEL
  (the Unix interrupt), Ctrl+letter is the control character, Ctrl+\ is QUIT.
  The mouse wheel scrolls back through the screen's history.
- **Diagnostic ladder**: runs `media/diagnostics/ladder.txt` tape by tape and
  judges each one as `tools/tape_ladder.py` does. The machine then holds the
  last tape; press Boot to start the image again.
- **Front panel**: the PC's physical address on the 22 address lights, the
  display register (177570) on the data lights, and the switch register.
  Click a switch to flip it.
- **Registers**, **Disassembly at PC** / **Trace**, and **Memory**
  (physical, octal; type an address, or jump to the PC or the SP).
- **Run / Halt / Step / Step 100**. **Break at** stops before the instruction
  at a virtual address in the current mode. **Trace on** records every
  instruction. With a breakpoint or the trace on, the processor runs one
  instruction at a time, which is slower, and the speed readout says so.

## The console program

```
pdp11_cli IMAGE.uf2 [BOOT d,switches] [step ...]
pdp11_cli ladder:PLAN[@NAME]
```

Steps: `until:TEXT[:s]`, `send:TEXT` (with a return), `raw:TEXT`
(`\r \n \xHH` understood), `wait:S`, `mark`, `stats`, `regs`, `dump:A,N`,
`dis:A,N`, `trace:N`. Examples:

```
.\pdp11_cli.exe ..\images\picoplus2\combined.uf2 BOOT 0,173030 "until:@" "send:rkunix" "until:# " "send:ls -l /" "until:# "
.\pdp11_cli.exe ..\images\picoplus2-v7\combined.uf2 BOOT 0,200000 "until:@" "send:boot" "until:: " "send:rk(0,0)rkunix" "until:# "
.\pdp11_cli.exe ladder:..\media\diagnostics\ladder.txt
```

## What it does (2026-10-23, this laptop)

- **V6** (`images/picoplus2`) boots to `#` (`mem = 1036`); `ls -l /` and `date` work.
- **V7** (`images/picoplus2-v7`, RK0 and the RP03) boots with 2040 KB
  (`mem = 2012672`) and mounts `/dev/rp3`. `cc -O` compiles and the program runs.
- **The ladder**: 19 PASS. 18_DZQKC halts at 014304 and 19_DEQKC at 000006,
  as `ladder.txt` expects for a J-11, the same as on the board. The FPA's own
  diagnostics, 20_JFPAA1 and 21_JFPBA0, end with "TOTAL ERRORS SINCE LAST REPORT 0".
- **Speed**: a C loop under V7 (user mode, the MMU on) ran 800 million PDP-11
  instructions in 6.55 s, which is **122 million instructions a second**. The
  window, which shares each frame with drawing, shows about 107 million. The
  CPU instruction tapes run at 190 to 480 million a second.
- **The dispatch** (`bench/`): a computed goto through the C back end does
  133 million dispatches a second, against 111 million for a table of
  procedure pointers.
