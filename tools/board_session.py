#!/usr/bin/env python3
"""
board_session.py - type a list of commands at a board's Unix prompt over
its USB serial port, on ONE open of the port, time each from the host and
keep the transcript.

    python tools/board_session.py (--hub-port N | --usb-serial TEXT) --script FILE
                                  [--out TRANSCRIPT] [--max-seconds 240] [--prompt "# "]

The board is found by where it is plugged in or by its USB serial number,
never by a COM number (see tools/pack_install.py). The board must be
running the PDP-11 firmware; nothing is uploaded here.

THE SCRIPT, one step per line:
    any text          typed, then Return; the step ends when the prompt is
                      back (or after the step's timeout, which is an error)
    !boot             wait for the first prompt after power-up or an upload
                      (the firmware boots Unix by itself); if the system is
                      already up, a Return gets the prompt
    !timeout N        the timeout of the steps that follow, seconds (default 30)
    !stats            the firmware's statistics block (Ctrl-] then s)
    !eof              Ctrl-D (ends "cat >file")
    !raw TEXT         typed with no Return and no wait
    !line TEXT        typed with a Return, no wait for the prompt (a line of
                      a file being typed into "cat >file")
    !wait N           N seconds, reading
    !expect TEXT      the transcript so far must contain TEXT, else the
                      session stops with exit 1
    !kernel NAME      boot RK0 again WITHOUT resetting the board (the
                      firmware's B frame: drive 0, switches 173030), type
                      NAME at the boot block's "@" and wait for the prompt.
                      The packs in PSRAM keep what was written to them, so
                      a kernel just built can be booted. Type "sync" first.
    # at the start    a comment
After each timed step the transcript gets a line "[host: N.NN s]": the time
from the Return to the prompt, as the host saw it.

Exit 0: every step ran and every !expect was met. Exit 1: a prompt did not
come back in time, or an !expect failed. Exit 2: --max-seconds ran out.
"""
import argparse
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pack_install  # noqa: E402  (the board finder)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--hub-port", type=int)
    g.add_argument("--usb-serial")
    ap.add_argument("--script", required=True)
    ap.add_argument("--out")
    ap.add_argument("--max-seconds", type=float, default=240.0)
    ap.add_argument("--prompt", default="# ")
    a = ap.parse_args()
    import serial

    t_start = time.time()
    port = None
    while port is None:                       # just after an upload the port takes a few seconds
        port = pack_install.find_port_quiet(a)
        if port is None:
            if time.time() - t_start > 25:
                sys.exit("board_session: no single running board there after 25 s. Stop and look at the board.")
            time.sleep(1)
    s = serial.Serial(port, 115200, timeout=0.05, write_timeout=10)
    log = []
    text = [""]

    def emit(t):
        log.append(t)
        sys.stdout.write(t)
        sys.stdout.flush()

    def pump(seconds, until=None):
        """Read for `seconds`, or until the text so far ends with `until`. True if it did."""
        end = time.time() + seconds
        while True:
            d = s.read(s.in_waiting or 1)
            if d:
                t = d.decode("ascii", "replace").replace("\r", "")
                text[0] += t
                emit(t)
            if until is not None and text[0].endswith(until):
                return True
            if time.time() > end:
                return False

    timeout = 30.0
    rc = 0
    prompt = a.prompt
    for raw in open(a.script, encoding="utf-8"):
        line = raw.rstrip("\r\n")
        if not line or line.startswith("#"):
            continue
        if time.time() - t_start > a.max_seconds:
            emit("\n[board_session: --max-seconds ran out before: %s]\n" % line)
            rc = 2
            break
        if line.startswith("!timeout "):
            timeout = float(line.split()[1])
        elif line == "!boot":
            if not pump(3.0, prompt):
                s.write(b"\r")
                if not pump(timeout, prompt):
                    emit("\n[board_session: no prompt within %.0f s of !boot]\n" % timeout)
                    rc = 1
                    break
        elif line == "!stats":
            s.write(b"\x1ds")
            pump(2.0)
        elif line == "!eof":
            s.write(b"\x04")
            pump(0.3)
        elif line.startswith("!raw "):
            s.write(line[5:].encode("ascii"))
            pump(0.2)
        elif line.startswith("!line"):
            s.write(line[6:].encode("ascii") + b"\r")
            pump(0.3)
        elif line.startswith("!wait "):
            pump(float(line.split()[1]))
        elif line.startswith("!kernel "):
            body = bytes([ord("B"), 3, 0, 0, 0o173030 & 255, 0o173030 >> 8])
            s.write(bytes([0xF5]) + body + bytes([(-sum(body)) & 255]))
            if not pump(10.0, "@"):
                emit("\n[board_session: no @ from the boot block within 10 s of !kernel]\n")
                rc = 1
                break
            t0 = time.time()
            s.write(line[8:].strip().encode("ascii") + b"\r")
            if not pump(timeout, prompt):
                emit("\n[board_session: no prompt within %.0f s of booting %s]\n" % (timeout, line[8:].strip()))
                rc = 1
                break
            emit("\n[host: %.2f s]\n%s" % (time.time() - t0, prompt))
        elif line.startswith("!expect "):
            if line[8:] not in text[0]:
                emit("\n[board_session: EXPECTED TEXT NOT SEEN: %s]\n" % line[8:])
                rc = 1
                break
        else:
            t0 = time.time()
            s.write(line.encode("ascii") + b"\r")
            ok = pump(timeout, prompt)
            dt = time.time() - t0
            if not ok:
                emit("\n[board_session: no prompt within %.0f s of: %s]\n" % (timeout, line))
                rc = 1
                break
            emit("\n[host: %.2f s]\n%s" % (dt, prompt))
    s.close()
    emit("\n[board_session: exit %d]\n" % rc)
    if a.out:
        open(a.out, "w", encoding="utf-8", newline="\n").write("".join(log))
    return rc


if __name__ == "__main__":
    sys.exit(main())
