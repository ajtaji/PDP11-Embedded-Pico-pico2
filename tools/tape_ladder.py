#!/usr/bin/env python3
"""tape_ladder.py - run PDP-11 diagnostic tapes on the J-11 emulator over
its USB serial port: ONE firmware stays flashed (diag.pico / diag.pico2
built with `tape2pico.py --empty`), and each tape is sent like a paper tape
through a reader, loaded, started and judged, all on ONE open of the port.

USE
    python tape_ladder.py --port COM29 --plan ladder.txt
    python tape_ladder.py --hub-port 9 --plan ladder.txt      (or --usb-serial TEXT: the board
                 by the USB hub port it is plugged into or by its USB serial number, as
                 tools/pack_install.py finds it, instead of a port name)
    python tape_ladder.py --port COM29 <tape> [--start OCTAL] [--switches OCTAL]
                          [--patch A=W,...] [--seconds N]
    python tape_ladder.py --dump tape_image.pico --plan ladder.txt
                 writes the exact bytes it would send into an (empty) tape
                 image, as the feed of the diagnostic firmware's desk probe
                 (arm_run cannot send bytes to the board); nothing is opened.

  --plan FILE    one tape per line:  name | tape | tape2pico options | seconds
                 (blank lines and lines starting with # are skipped; the tape
                 path is relative to --tapes, default the plan's own folder)
  --no-report    leave the firmware in the tape reader at the end, instead
                 of switching it to the report firmware's behaviour
  --transcript FILE   everything each tape's program typed until its verdict,
                 added to FILE under a line "=== name: verdict"

EACH TAPE
    R  (reset, clear memory)          -> "#READY"
    T  the tape in 200-byte pieces    -> "#T n" after each, "#LOADED ..." at the end
    W  the --patch words, if any      -> "#W n"
    G  start, switches                -> "#GO start"
    then the program's own output is read until a verdict:
      PASS  a status line with 1 or more bells, or "END PASS" / "END OF" typed
      FAIL  "HALT at"
      NO VERDICT  neither within the tape's seconds
    and the next tape starts with R. At the end, Q (the report firmware's
    self-test and benchmark) and its "self-test: ... PASS" line is read.

THE FRAMES (diag.pico, THE SERIAL TAPE READER)
    $F5  cmd  len-lo len-hi  payload  sum      cmd+len+payload+sum = 0 mod 256
"""
import argparse
import os
import re
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tape2pico  # noqa: E402

FRAME_START = 0xF5
CHUNK = 200


def frame(cmd, payload=b""):
    body = bytes([ord(cmd), len(payload) & 0xFF, len(payload) >> 8]) + payload
    return bytes([FRAME_START]) + body + bytes([(-sum(body)) & 0xFF])


def tape_frames(entry):
    """The frames for one tape: R, the T pieces, W, G."""
    data, pcjs_exec = tape2pico.read_tape_bytes(entry["tape"])
    mem, transfer, blocks = tape2pico.parse_absolute(data, entry["tape"])   # checked on the host too
    start = tape2pico.resolve_start(entry.get("start"), transfer, pcjs_exec)
    switches = int(entry.get("switches") or "0", 8) & 0xFFFF
    patches = tape2pico.parse_patches(entry.get("patch") or "")
    out = [("R", frame("R"), "#READY")]
    for i in range(0, len(data), CHUNK):
        out.append(("T", frame("T", data[i:i + CHUNK]), "#T"))
    if patches:
        pay = b"".join(bytes([a & 255, a >> 8, w & 255, w >> 8]) for a, w in patches)
        out.append(("W", frame("W", pay), "#W"))
    out.append(("G", frame("G", bytes([start & 255, start >> 8, switches & 255, switches >> 8])), "#GO"))
    return out, start


def parse_options(words):
    ap = argparse.ArgumentParser(add_help=False)
    ap.add_argument("--start")
    ap.add_argument("--switches")
    ap.add_argument("--patch")
    return vars(ap.parse_args(words))


def read_plan(path, tapes_dir):
    entries = []
    for n, line in enumerate(open(path), 1):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        f = [x.strip() for x in line.split("|")]
        if len(f) < 2:
            tape2pico.fail("%s line %d: expected 'name | tape | options | seconds'." % (path, n))
        e = {"name": f[0], "tape": os.path.join(tapes_dir, f[1])}
        e.update(parse_options(f[2].split() if len(f) > 2 else []))
        e["seconds"] = float(f[3]) if len(f) > 3 and f[3] else 120.0
        entries.append(e)
    return entries


def verdict(text):
    if "HALT at" in text:
        return "FAIL"
    if re.search(r"\b[1-9]\d* bells", text) or "END PASS" in text or "END OF" in text:
        return "PASS"
    return None


class Port:
    def __init__(self, name):
        import serial
        self.s = serial.Serial(name, 115200, timeout=0.2)
        self.buf = ""

    def send(self, b):
        self.s.write(b)

    def read(self):
        got = self.s.read(4096)
        if got:
            self.buf += got.decode("ascii", "replace")
        return got

    def wait_line(self, prefix, seconds):
        """Wait for a reply line starting with prefix (or '#ERR')."""
        end = time.time() + seconds
        while time.time() < end:
            self.read()
            for line in self.buf.splitlines():
                if line.startswith("#ERR"):
                    raise RuntimeError(line)
                if line.startswith(prefix):
                    self.buf = self.buf[self.buf.index(line) + len(line):]
                    return line
        raise RuntimeError("no %r reply within %g s - the firmware is not the serial tape reader, "
                           "or it is not answering. Check the port and the firmware." % (prefix, seconds))


def run(args, entries):
    p = Port(args.port)
    time.sleep(1.0)
    p.read()
    results = []
    for e in entries:
        frames, start = tape_frames(e)
        for kind, fb, reply in frames:
            p.send(fb)
            line = p.wait_line(reply, 5)
            if kind == "G":
                print("%s: %s" % (e["name"], line))
        end = time.time() + e["seconds"]          # p.buf holds what the program typed after "#GO"
        v = None
        while time.time() < end and v is None:
            p.read()
            v = verdict(p.buf)
        v = v or "NO VERDICT"
        last = [l for l in p.buf.splitlines() if l.strip()]
        print("%-28s %-10s %s" % (e["name"], v, last[-1][:100] if last else ""))
        if args.transcript:
            with open(args.transcript, "a", newline="\n") as t:
                t.write("=== %s: %s\n" % (e["name"], v))
                t.write("\n".join(x.rstrip() for x in p.buf.replace("\r", "").split("\n")) + "\n")
        results.append((e["name"], v))
    if not args.no_report:
        p.send(frame("Q"))
        p.wait_line("#REPORT", 5)
        line = p.wait_line("self-test:", 10)
        print("report: " + line)
    p.s.close()
    return results


def dump(args, entries, out):
    """The byte stream, as the firmware's desk-probe feed: a 256 after each
    G stands for the host waiting for a verdict."""
    stream = []
    for e in entries:
        frames, start = tape_frames(e)
        for kind, fb, reply in frames:
            stream.extend(fb)
        stream.append(256)
    if not args.no_report:
        stream.extend(frame("Q"))
    ext = os.path.splitext(out)[1] or ".pico"
    text = tape2pico.render("serial", "(none: the desk feed of " + ", ".join(e["name"] for e in entries) + ")",
                            1, 0, [], ext, (), stream)
    open(out, "w", newline="\n").write(text)
    print("tape_ladder: %d bytes for %d tapes -> %s" % (len(stream), len(entries), out))


def main():
    ap = argparse.ArgumentParser(description="Run PDP-11 tapes over the J-11 emulator's serial port.")
    ap.add_argument("tape", nargs="?")
    ap.add_argument("--port")
    ap.add_argument("--hub-port", type=int)
    ap.add_argument("--usb-serial")
    ap.add_argument("--plan")
    ap.add_argument("--tapes")
    ap.add_argument("--start")
    ap.add_argument("--switches")
    ap.add_argument("--patch")
    ap.add_argument("--seconds", type=float, default=120.0)
    ap.add_argument("--dump")
    ap.add_argument("--no-report", action="store_true")
    ap.add_argument("--transcript")
    a = ap.parse_args()
    if a.plan:
        entries = read_plan(a.plan, a.tapes or os.path.dirname(os.path.abspath(a.plan)))
    elif a.tape:
        entries = [{"name": os.path.splitext(os.path.basename(a.tape))[0], "tape": a.tape,
                    "start": a.start, "switches": a.switches, "patch": a.patch, "seconds": a.seconds}]
    else:
        tape2pico.fail("give a tape, or --plan with a list of tapes.")
    if a.dump:
        dump(a, entries, a.dump)
        return
    if not a.port and (a.hub_port is not None or a.usb_serial):
        import pack_install                      # the board by where it is plugged in, or by its serial number
        a.port = pack_install.find_port(a)
    if not a.port:
        tape2pico.fail("give --port with the board's COM port, or --dump for the desk.")
    try:
        results = run(a, entries)
    except RuntimeError as err:
        tape2pico.fail(str(err))
    bad = [n for n, v in results if v != "PASS"]
    print("tape_ladder: %d of %d PASS%s" % (len(results) - len(bad), len(results),
                                           ("; not passed: " + ", ".join(bad)) if bad else ""))


if __name__ == "__main__":
    main()
