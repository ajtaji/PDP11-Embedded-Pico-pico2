# The PureMetal PDP-11 demo

A PDP-11 program written in PureMetal and compiled straight to PDP-11 machine code by PureMetal
Forge: no Unix, no operating system, just the machine. It runs on the PDP-11 emulator's display and
sound devices, which the desktop emulator has (its window and pdp11_cli); the boards follow when their
firmware has the devices.

- **The logo**, rendered from Lato (SIL Open Font License, `fonts/OFL.txt`), with a light band that
  runs down it.
- **A plasma field** that never stops moving - drawn once, then animated by nothing but palette
  changes, so it costs no drawing at all.
- **A spinning cube**, rotated with a sine table and the J-11's MUL and DIV, in perspective.
- **A scrolling message** in the demo's own 7x7 capitals.
- **An original tune**, four voices: lead, arpeggio, bass and drums.

The line clock's interrupt (60 a second) plays the music and moves the palette; the main loop draws
the cube and the scroller as fast as the machine allows, so the music keeps time on a slow machine
too.

## Building

You need PureMetal Forge with the PDP-11 target (the compiler build of 2026-10-23 or later).

```
PureMetalForge.exe --compile demo.pdp11 -o demo.hex
```

That writes `demo.lda`, a DEC absolute-loader file, which the emulator loads and starts.

The pictures, the font, the tables and the song are data, made by `make_demo_assets.py` into
`demo_assets.pdp11` (Python 3 with Pillow):

```
python make_demo_assets.py            # write demo_assets.pdp11 and preview/logo.png
python make_demo_assets.py --check    # fails if demo_assets.pdp11 is not what it writes
```

`make_preview.py` runs the demo on the emulator's console program and saves its screen as
`preview/frame.png`, which is how the drawing can be checked without the window.

## Files

| File | What it is |
|---|---|
| `demo.pdp11` | the program |
| `demo_assets.pdp11` | its data, written by `make_demo_assets.py` |
| `make_demo_assets.py` | renders the logo, the font, the tables and the song |
| `make_preview.py` | runs the demo and saves a frame |
| `fonts/` | Lato Regular and its licence |
