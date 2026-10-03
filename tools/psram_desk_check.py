#!/usr/bin/env python3
"""
psram_desk_check.py - the PSRAM boards' image on the desk emulator: it uses
the PSRAM when a working chip is there, and when anything is wrong it falls
back to running exactly as the Pico 2 W build does.

    python tools/psram_desk_check.py --arm-run ARM_RUN.exe --image desk.bin --board feather
    python tools/psram_desk_check.py --arm-run ARM_RUN.exe --image desk.bin --board picoplus2

desk.bin comes from tools/psram_build.py --desk. arm_run is the PureMetal ARM
emulator with the QSPI PSRAM model (its psram= and flash= options; compiler
branch pdp11-psram-support, or a later main). The image is UNTESTED ON
HARDWARE; this is the proof that exists.

EACH CASE boots the image to V6's "#" with nothing typed and checks the
banner, the RK0 line and V6's own memory size line:

  ok          the board's chip (psram=8M on its CS pin): "8 MB on GPIOn",
              the packs copied and checked, RK0 running from its PSRAM copy
              with the whole swap area, "mem = 1036" (248 KB)
  warm        the chip left in QPI mode by the last firmware (psram=8M,qpi):
              the bring-up's F5h gets it back, same as ok
  none        a board with no chip on CS1 (psram=0)       -> the fallback
  absent      no psram option at all (a plain Pico 2)     -> the fallback
  small       a 4 MB chip (psram=4M): the write test sees it wrap -> fallback
  wrong_pin   the chip on the other board's CS pin        -> the fallback

THE FALLBACK must say "not in use", run RK0 from the flash with the swap RAM
disk, and V6 must report "mem = 76" (56 KB) - the Pico 2 W's behaviour.

Each case is a separate arm_run of about 2.5e9 instructions; they run in
parallel. Exit 1 on any failure.
"""
import argparse, concurrent.futures as cf, os, re, subprocess, sys

BOARDS = {"feather": (8, "8M", 47), "picoplus2": (47, "16M", 8)}   # pin, flash, the other board's pin


def cases(board):
    pin, flash, other = BOARDS[board]
    base = ["flash=" + flash]
    use = [r"PSRAM \(UNTESTED ON HARDWARE\): 8 MB on GPIO%d, ID 0D 5D 40" % pin,
           r"RK0: v6root, 4872 blocks, running from its PSRAM copy: writable.*the whole swap area \(4000-4871\)",
           r"mem = 1036\s*#"]
    fall = [r"PSRAM \(UNTESTED ON HARDWARE\): not in use - ",
            r"RK0: v6root, 4872 blocks, swap 4000-4111 on a RAM disk, READ-ONLY",
            r"mem = 76\s*#"]
    pin_opt = "" if pin == 8 else ",cs=%d" % pin
    return [
        ("ok", base + ["psram=8M" + pin_opt], use),
        ("warm", base + ["psram=8M%s,qpi" % pin_opt], use),
        ("none", base + ["psram=0" + pin_opt], fall),
        ("absent", base, fall),
        ("small", base + ["psram=4M" + pin_opt], fall + [r"the write test failed"]),
        ("wrong_pin", base + ["psram=8M" + ("" if other == 8 else ",cs=%d" % other)], fall),
    ]


def run(arm_run, image, opts):
    p = subprocess.run([arm_run, image, "rp2350", "2500000000", "host=open"] + opts,
                       capture_output=True, timeout=3600)
    return p.returncode, p.stdout.decode("latin-1") + p.stderr.decode("latin-1")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--arm-run", required=True)
    ap.add_argument("--image", required=True)
    ap.add_argument("--board", required=True, choices=sorted(BOARDS))
    a = ap.parse_args()
    p = subprocess.run([a.arm_run], capture_output=True)
    if b"psram=" not in p.stdout + p.stderr:
        print("FAIL: %s has no psram= option - it cannot model the boards' PSRAM." % a.arm_run)
        return 1
    todo = cases(a.board)
    bad = 0
    with cf.ThreadPoolExecutor(len(todo)) as ex:
        futs = [(name, want, ex.submit(run, a.arm_run, a.image, opts)) for name, opts, want in todo]
        for name, want, fut in futs:
            rc, out = fut.result()
            miss = [w for w in want if not re.search(w, out)]
            fault = [l for l in out.splitlines() if "FAULT" in l.upper() and "status 0" not in l]
            ok = not miss and not fault
            bad += not ok
            print("  [%s] %-10s %s" % ("PASS" if ok else "FAIL", name,
                  "banner, RK0 line and V6's memory size as expected" if ok else
                  "missing: " + " | ".join(miss) + (" fault: " + fault[0] if fault else "")))
    print("psram_desk_check: %s - %d of %d cases" % ("PASS" if not bad else "FAIL", len(todo) - bad, len(todo)))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
