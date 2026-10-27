#!/usr/bin/env python3
"""
psram_build.py - build the PSRAM boards' V6 image from this repository.

    python tools/psram_build.py --board feather   [--compiler EXE] [--out DIR] [--desk]
    python tools/psram_build.py --board picoplus2 [--compiler EXE] [--out DIR] [--desk]
    add --hub-port N or --usb-serial TEXT to upload the firmware as well, through the
    compiler's own uploader, to the running board found there (tools/pack_install.py
    finds boards the same way; the packs are its job)

Both boards ran the earlier builds on 2026-10-07 (V6 reports mem = 1036; the
README's PSRAM section has what each printed). The same image runs on the
desk in the PureMetal ARM emulator with its PSRAM model (arm_run ...
flash=8M psram=8M, or flash=16M psram=8M,cs=47).

THE BOARDS
    feather    Adafruit Feather RP2350 with HSTX port and 8 MB PSRAM
               (RP2350A, 8 MB flash, APS6404L PSRAM on QMI CS1 = GPIO8)
    picoplus2  Pimoroni Pico Plus 2 and Pico Plus 2 W
               (RP2350B, 16 MB flash, APS6404L PSRAM on QMI CS1 = GPIO47;
               the W's radio is not used). The board that ran it is the
               Pico Plus 2 W.

WHAT IT DOES
    1. Compiles J11_18MHz_KDJ11_BF/pico2/diag.pico2 with the board's actual profile and three
       constants (#PSRAM = 1, #PSRAM_CS_PIN, #FLASH_CHIP) - from a copy
       written beside diag.pico2 and removed afterwards; diag.pico2 itself
       is never changed. The one other difference from the Pico 2 W build:
       the unmapped run loop, CpuRun, runs from SRAM (a copy of
       instructions.pico2 with ProcedureRAM, removed afterwards too).
    2. Makes the V6 root pack as the Pico 2 W image does (the README's
       v6fs.py lines: /dev/rk0, /dev/rrk0, /dev/swap), plus /dev/rk1 and
       /dev/rrk1. Installs the native-built FP-enabled /rkfp kernel and
       sources, links /unix to it, and keeps old kernels for recovery.
    3. Packs it with rk_image.py: RK0 v6root, RK1 v6src (media/unix), and
       the PSRAM kernel patch _nswap 872 - the whole swap area - applied to
       the PSRAM copy only, so the fallback still boots with 112.

OUTPUT (in --out, default build_<board>/ at the repository root)
    diag.bin        the firmware
    combined.uf2    firmware and both packs, one UF2: for the board's boot
                    drive, or for tools/pack_install.py (the packs over USB
                    serial, then the firmware through the compiler's uploader)
    desk.bin        with --desk: the flat image for arm_run
"""
import argparse, gzip, os, shutil, subprocess, sys
from pathlib import Path

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
BOARDS = {
    #            CS pin  flash
    "feather":   (8,     0x800000),
    "picoplus2": (47,    0x1000000),
}
CONSTS = [("#PSRAM = 0 ", "#PSRAM = 1 "),
          ("#PSRAM_CS_PIN = 8 ", "#PSRAM_CS_PIN = %d "),
          ("#FLASH_CHIP = $400000 ", "#FLASH_CHIP = $%X ")]


def run(cmd, **kw):
    print("psram_build: " + " ".join(cmd))
    r = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, **kw)
    print(r.stdout, end="", flush=True)
    if r.returncode != 0:
        sys.exit("psram_build: that step failed (exit %d); nothing past it was built." % r.returncode)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--board", required=True, choices=sorted(BOARDS))
    ap.add_argument("--compiler", default="PureMetalForge.exe")
    ap.add_argument("--out")
    ap.add_argument("--desk", action="store_true")
    ap.add_argument("--hub-port", type=int)
    ap.add_argument("--usb-serial")
    a = ap.parse_args()
    pin, flash = BOARDS[a.board]
    out = os.path.abspath(a.out or os.path.join(REPO, "build_" + a.board))
    os.makedirs(out, exist_ok=True)

    # 1. the firmware
    text = open(os.path.join(SRC, "diag.pico2"), "rb").read().decode("utf-8")
    for old, new in CONSTS:
        if text.count(old) != 1:
            sys.exit("psram_build: diag.pico2 does not hold exactly one '%s' line - the board "
                     "constants have moved; update CONSTS here to match." % old.strip())
        text = text.replace(old, new % (pin if "CS_PIN" in old else flash) if "%" in new else new)
    # the unmapped run loop (CpuRun, 36 KB: Mini-Unix runs in it) from SRAM, where these
    # boards have the room and the Pico 2 W does not: a copy of instructions.pico2 that
    # says ProcedureRAM, beside the copy of diag.pico2 (the compiler takes no CompilerIf
    # inside a procedure's first line)
    inc = 'XIncludeFile "instructions.pico2"'
    head = "\nProcedure.i CpuRun(n.i)\n"
    ins = open(os.path.join(SRC, "instructions.pico2"), "rb").read().decode("utf-8").replace("\r\n", "\n")
    if text.count(inc) != 1 or ins.count(head) != 1:
        sys.exit("psram_build: diag.pico2's include of instructions.pico2, or CpuRun's first line, "
                 "has moved; update psram_build.py to match.")
    tmp_ins = os.path.join(SRC, "instructions_%s.pico2" % a.board)
    text = text.replace(inc, 'XIncludeFile "instructions_%s.pico2"' % a.board)
    ins = ins.replace(head, "\nProcedureRAM.i CpuRun(n.i)\n")
    open(tmp_ins, "wb").write(ins.encode("utf-8"))
    tmp = os.path.join(SRC, "diag_%s.pico2" % a.board)
    fw = os.path.join(out, "diag.bin")
    open(tmp, "wb").write(text.encode("utf-8"))
    profile = "Pimoroni_Pico_Plus_2_W.board" if a.board == "picoplus2" else "Adafruit_Feather_RP2350_HSTX.board"
    cmd = [a.compiler, "--compile", tmp, "-t", "rp2350", "--board", profile, "-o", fw]
    if a.hub_port is not None or a.usb_serial:
        sys.path.insert(0, HERE)
        import pack_install                  # the board by where it is plugged in, or by its serial number
        cmd += ["--port", pack_install.find_port(a)]
    try:
        run(cmd, cwd=SRC)
    finally:
        os.remove(tmp)
        os.remove(tmp_ins)

    # 2. the packs
    root = os.path.join(out, "v6root.rk")
    src = os.path.join(out, "v6src.rk")
    for gz, dst in (("v6root.gz", root), ("v6src.gz", src)):
        with gzip.open(os.path.join(REPO, "media", "unix", gz)) as f, open(dst, "wb") as g:
            shutil.copyfileobj(f, g)
    v6 = [sys.executable, os.path.join(HERE, "v6fs.py")]
    for args in (["mknod", root, "/dev/rk0", "b", "0", "0"],
                 ["mknod", root, "/dev/rrk0", "c", "9", "0"],
                 ["mknod", root, "/dev/rk1", "b", "0", "1"],
                 ["mknod", root, "/dev/rrk1", "c", "9", "1"],
                 ["mknod", root, "/dev/swap", "b", "0", "0"],
                 ["patch", root, "/rkunix", "_nswap", "112"]):
        run(v6 + args + ["-o", root])
    # Keep an older 22-bit kernel as a fallback when supplied. The current
    # default is the native-built FP-enabled m45 kernel, on every V6 profile.
    k70 = os.path.join(REPO, "media", "unix", "rk70unix")
    if os.path.exists(k70):
        run(v6 + ["put", root, k70, "/rk70unix", "--mode", "777", "-o", root])
    fp_kernel = Path(REPO)/'media/unix/rkfp-j11'
    if not fp_kernel.is_file():
        sys.exit('psram_build: native FP-enabled V6 kernel media/unix/rkfp-j11 is required')
    from v6_fp_image import patch_root
    fp_image, _ = patch_root(Path(root).read_bytes(), fp_kernel.read_bytes(), Path(REPO)/'docs/v6')
    Path(root).write_bytes(fp_image)
    run(v6 + ["check", root])

    # 3. the image
    cmd = [sys.executable, os.path.join(HERE, "rk_image.py"), "pack", root, "--chip", a.board,
           "--blocks", "4872", "--boot-block", "@/usr/mdec/rkuboot", "--swap", "4000,112",
           "--name", "v6root", "--autoboot", "rkfp", "--psram-patch", "rkfp,_nswap,872",
           "--drive1", src, "--firmware", fw, "--combined", os.path.join(out, "combined.uf2"),
           "-o", os.path.join(out, "v6root.uf2")]
    cmd += ["--autoboot-psram", "rkfp"]
    if a.desk:
        cmd += ["--desk", os.path.join(out, "desk.bin")]
    run(cmd)
    for f in (root, src, os.path.join(out, "v6root.uf2")):
        os.remove(f)
    print("psram_build: %s done - %s" % (a.board, os.path.join(out, "combined.uf2")))


if __name__ == "__main__":
    main()
