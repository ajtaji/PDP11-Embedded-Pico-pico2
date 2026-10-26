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

## Building the desktop version

The window is drawn with the [Neon Arcade Display Engine](https://github.com/ajtaji/Neon-Arcade-Dispay-Engine),
cloned beside this repository. With PureBasic 6.41 (x64, the C back end, `pbcompilerc.exe`), from PowerShell:

```
git clone https://github.com/ajtaji/PDP11-Embedded-Pico-pico2.git
git clone https://github.com/ajtaji/Neon-Arcade-Dispay-Engine.git
cd PDP11-Embedded-Pico-pico2\desktop
& "C:\Program Files\PureBasic\Compilers\pbcompilerc.exe" PDP11Desktop.pb /EXE PDP11Desktop.exe /THREAD /DPIAWARE /OPTIMIZER
& "C:\Program Files\PureBasic\Compilers\pbcompilerc.exe" pdp11_cli.pb /CONSOLE /OPTIMIZER /EXE pdp11_cli.exe
.\PDP11Desktop.exe
```

`build_desktop.ps1` and `build_cli.ps1` run the same lines. An engine elsewhere: add
`/CONSTANT GL_ENGINE_DIR$=<folder>/` (the trailing slash matters), or `.\build_desktop.ps1 -Engine <folder>/`.
`pdp11_cli.exe` needs no engine.

## The window

`PDP11Desktop [IMAGE.uf2]`. With no argument it loads
`images/picoplus2-v7/combined.uf2` and boots it, as the board does at
power-up: the bootstrap, then the kernel's name typed at the boot block's `@`
and the second step at its prompt.

- **Console**: type into it (the keys are under Controls, below).
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
- **Controls**: every key the window takes, drawn from the same table the
  keyboard code reads (`desktop/controls.pbi`), so the two cannot disagree.
- **Full screen** (the button, or F11; Esc leaves): a borderless window over
  the window's own monitor (the display mode does not change) showing only the
  machine's screen - the console, 80 x 24 in a font sized to the monitor, or
  the 320 x 200 raster when the Display tab is up, at a whole-number scale
  when that loses under a tenth of the height - centred on black. The pointer
  hides after two idle seconds. Leaving puts the window back where it was, at
  the size it was. Esc leaves full screen, so there the terminal's ESC is
  Ctrl+[ (in the window Esc and Ctrl+[ both send it).
  `PDP11Desktop IMAGE --fullscreen-test log.txt [--fullscreen-shot f.png]`
  checks it with posted keys, no pointer: the window covers its monitor, the
  view has its aspect and is centred, Esc leaves, the windowed rectangle and
  style come back (`--tab 3` for the raster).

## Controls

| Key | What it does |
|---|---|
| Letters, digits, punctuation | sent to the console as they are, when the Console tab shows (or in full screen) and no field has the focus |
| Return | CR (015) |
| Backspace | ^H (010); V6's and V7's erase is `#` unless `stty` says otherwise |
| Tab | TAB (011) |
| Delete | DEL (177), Unix's interrupt |
| Esc | ESC (033), in the window (in full screen Esc leaves it: use Ctrl+[) |
| Ctrl+[ | ESC (033), in the window and in full screen |
| Ctrl+A ... Ctrl+Z | the control characters 001-032 (Ctrl+D end of file, Ctrl+S / Ctrl+Q stop and start output) |
| Ctrl+\ | FS (034), Unix's quit |
| Ctrl+] | GS (035) |
| Mouse wheel | scrolls the console back through its history (any key goes back to the bottom) |
| F11 | full screen on and off (also the Full screen button) |
| Esc, in full screen | leaves full screen |

## The demo devices (desktop only, for now)

A raster display and a 4-voice tone generator for the compiler's PDP-11 demo
(`desktop/machine_demo.pbi`; the registers are listed at its top). The display
is 320x200 at 4 bits a pixel. Its framebuffer is in memory, at the address
DPBASE (164002) gives in 64-byte units. The CSR is at 164000 and the frame
interrupt is at vector 320, BR4. Each voice has a pitch in Hz, a volume and a
waveform, at 164100; SNDCSR (164142) turns the sound on. The window has a
Display tab and plays the voices. `pdp11_cli shot:FILE.bmp` saves the frame.
They are not in the board's firmware: desktop_gen.py hooks them into the core.
They move into the pico2 sources when a board has a video and audio output for them.

## The console program

```
pdp11_cli IMAGE.uf2 [BOOT d,switches] [step ...]
pdp11_cli ladder:PLAN[@NAME]
pdp11_cli [fill:BYTE] lda:FILE.lda[@SECONDS] [regs | dump:A,N | dis:A,N ...]
```

`lda:` runs a standalone program, as a compiler's absolute-loader output. It
clears memory, loads the file, and starts at the file's transfer address with
the MMU off and the switches at 0. It prints what the program types on the
console (177560) and runs until a HALT or the timeout (10 s by default). The
last line is `cli: HALT at <the HALT's address> R0=... SP=... PSW=... after N instructions`
or `cli: TIMEOUT ...`. The exit code is 0 on a HALT, 2 on a timeout and 1 if
the load failed. `fill:BYTE` (octal) before it leaves that byte, not 0, in
000000-157777 wherever the file loads nothing, so a test can tell which bytes
the program wrote.

Steps: `until:TEXT[:s]`, `send:TEXT` (with a return), `raw:TEXT`
(`\r \n \xHH` understood), `wait:S`, `mark`, `stats`, `regs`, `dump:A,N`,
`dis:A,N`, `trace:N`, `shot:FILE.bmp`. Examples:

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
