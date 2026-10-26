#!/usr/bin/env python3
"""
Build the RP2040/RP2350 PDP-11 graphics/sound demo with shared output modules.

    python tools/demo_build.py --compiler EXE [--out DIR] [--port COMnn]
                               [--target rp2040|rp2350]
                               [--audio silent|plugin|bluetooth] [--speaker MAC]

The guest demo boots automatically. Its 320x200 picture is centered on the
configured panel. All four resident panel drivers are shared with the Unix
console; no per-screen firmware build is necessary. The guest uses 56 KB
on RP2040, 64 KB on RP2350, and CpuRun runs from SRAM. The standalone
RP2040 profile disables disks to reserve SRAM for graphics and audio.

--speaker selects the shared Bluetooth PCM backend. Builds also
write output_settings.uf2/.bin: upload that small settings file separately
to select the panel/font and enable the linked backend. --port uploads it too. It contains the speaker address when supplied;
keep it private. A Bluetooth build without --speaker generates silent settings;
enable it later with output_config.py and install the SDK radio firmware.
On RP2040 the radio data overlaps Mini-Unix: back up the pack first, and
restore its pack UF2 when returning to Unix. Silent builds omit the radio and PCM ring. The plugin choice
uses the supplied silent PCM meter until audio_plugin.pmi is replaced.

Outputs: demo_firmware.uf2 and .bin; temporary source copies are removed.
No pairing key is saved automatically and no pack sector is written.
"""
import argparse, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
EDITS = [("#DEMO_DEV = 0 ", "#DEMO_DEV = 1 "),
         ("#SRAM_MEM_KB = 152 ", "#SRAM_MEM_KB = 64 "),
         ('XIncludeFile "tape_image.pico2"', 'XIncludeFile "tape_image_demo.pico2"'),
         ('XIncludeFile "../outputs/terminal.pmi"', 'XIncludeFile "../outputs/terminal.pmi"\n'
                                      'XIncludeFile "demo_dev.pico2"')]



def run(cmd, **kw):
    print("demo_build: " + " ".join(cmd))
    r = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, **kw)
    print(r.stdout, end="", flush=True)
    if r.returncode != 0:
        sys.exit("demo_build: that step failed (exit %d); nothing past it was built." % r.returncode)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--compiler", default="PureMetalForge.exe")
    ap.add_argument("--target", choices=["rp2040", "rp2350"], default="rp2350")
    ap.add_argument("--lda", default=os.path.join(REPO, "demo", "demo.lda"))
    ap.add_argument("--out")
    ap.add_argument("--port", help="upload through the compiler's uploader to the board on this port")
    ap.add_argument("--keep", action="store_true",
                    help="leave diag_demo and its copies beside diag (the compiler's message on a failed "
                         "build shows only when it is run by hand on them)")
    ap.add_argument("--speaker", help="a Bluetooth speaker's address, AA:BB:CC:DD:EE:FF: the demo's sound goes there")
    ap.add_argument("--audio", choices=["silent", "bluetooth", "plugin"], default="silent")
    ap.add_argument("--panel", choices=["none","lafvin","display-pack2","ili9341","hx8357d"], default="lafvin")
    ap.add_argument("--font", choices=["readable","compact"], default="readable")
    a = ap.parse_args()
    global SRC
    ext = "pico" if a.target == "rp2040" else "pico2"
    SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico" if a.target == "rp2040" else "pico2")
    edits = [(old.replace('.pico2', '.'+ext), new.replace('.pico2', '.'+ext)) for old,new in EDITS]
    if a.target == "rp2040":
        edits = [pair for pair in edits if '#SRAM_MEM_KB' not in pair[0]]
        edits[-1] = ('XIncludeFile "../outputs/terminal.pmi"', 'XIncludeFile "../outputs/terminal.pmi"\nXIncludeFile "../outputs/demo.pmi"')
    if a.speaker: a.audio = "bluetooth"
    out = os.path.abspath(a.out or os.path.join(REPO, "build_demo"))
    os.makedirs(out, exist_ok=True)

    tape = os.path.join(SRC, "tape_image_demo."+ext)
    tmp = os.path.join(SRC, "diag_demo."+ext)
    tmp_ins = os.path.join(SRC, "instructions_demo."+ext)
    try:
        run([sys.executable, os.path.join(HERE, "tape2pico.py"), a.lda, "--name", "demo", "-o", tape])
        text = open(os.path.join(SRC, "diag."+ext), "rb").read().decode("utf-8")
        for old, new in edits:
            if text.count(old) != 1:
                sys.exit("demo_build: diag.pico2 does not hold exactly one '%s' - it has moved; "
                         "update EDITS here to match." % old.strip())
            text = text.replace(old, new)
        if a.target == 'rp2040':
            # The standalone graphics profile spends SRAM on display/audio,
            # rather than the flash disk's write overlay. It never mounts a pack.
            text = text.replace('#DISK_BACKEND = 2 ', '#DISK_BACKEND = 0 ', 1)
        from output_config import record, uf2 as settings_uf2
        try:
            settings = record(a.panel, 'silent' if a.audio == 'bluetooth' and not a.speaker else a.audio, a.speaker, a.font)
        except ValueError as error:
            sys.exit('demo_build: ' + str(error))
        text = text.replace('#OUTPUT_AUDIO_DRIVER = 0 ', '#OUTPUT_AUDIO_DRIVER = %d ' % {'silent':0,'bluetooth':1,'plugin':2}[a.audio], 1)
        settings_path = os.path.join(out, 'output_settings.uf2')
        open(settings_path, 'wb').write(settings_uf2(settings, a.target))
        open(os.path.join(out, 'output_settings.bin'), 'wb').write(settings)
        # The unmapped run loop (CpuRun: the demo runs with memory management off) from SRAM, as
        # psram_build.py does for the PSRAM boards: from flash it shares the 16 KB XIP cache with
        # core 1's panel code, and the two evict each other (420,000 instructions/s, 2026-10-24).
        inc = 'XIncludeFile "instructions.'+ext+'"'
        head = "\nProcedure.i CpuRun(n.i)\n"
        ins = open(os.path.join(SRC, "instructions."+ext), "rb").read().decode("utf-8").replace("\r\n", "\n")
        if a.target == 'rp2040': head = "\nProcedureRAM.i CpuRun(n.i)\n"
        if text.count(inc) != 1 or ins.count(head) != 1:
            sys.exit("demo_build: diag.pico2's include of instructions.pico2, or CpuRun's first line, "
                     "has moved; update demo_build.py to match.")
        text = text.replace(inc, 'XIncludeFile "instructions_demo.'+ext+'"')
        open(tmp_ins, "wb").write(ins.replace(head, "\nProcedureRAM.i CpuRun(n.i)\n").encode("utf-8"))
        open(tmp, "wb").write(text.encode("utf-8"))
        uf2 = os.path.join(out, "demo_firmware.uf2")
        cmd = [a.compiler, "--compile", tmp, "-t", a.target, "-o", uf2]
        if a.port:
            cmd += ["--port", a.port]
        run(cmd, cwd=SRC)
        run([a.compiler, "--compile", tmp, "-t", a.target, "-o", os.path.join(out, "demo_firmware.bin")], cwd=SRC)
        if a.port:
            run([a.compiler, "--radio-firmware", settings_path, "--port", a.port, "-t", a.target], cwd=SRC)
    finally:
        for f in (tmp, tape, tmp_ins):
            if os.path.exists(f) and not a.keep:
                os.remove(f)
    print("demo_build: done - %s" % os.path.join(out, "demo_firmware.uf2"))


if __name__ == "__main__":
    main()
