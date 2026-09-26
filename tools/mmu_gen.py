#!/usr/bin/env python3
"""mmu_gen.py - write the J-11 emulator's MAPPED run loop from its unmapped one.

    python mmu_gen.py            writes pico/instructions_mmu.pico and
                                 pico2/instructions_mmu.pico2
    python mmu_gen.py --check    changes nothing; fails if either file is not
                                 what this tool would write now

WHY A GENERATOR. The memory management unit gets a run loop of its own
(CpuRunM), used only while it is on, so the loop that runs while it is off
stays exactly as it was and costs nothing (cpu.pico, THE MEMORY MANAGEMENT
UNIT). The two loops must never drift apart, and the language cannot build
one procedure's body twice with different memory macros (a macro cannot be
redefined, and an IncludeFile is the same text both times). So the mapped
loop is WRITTEN from pico/instructions.pico - the same handlers, line for
line - with only these changes:
  * every label, the table, the loop's own macros and CpuRun get an M;
  * operand accesses use the translating macros (MReadWord -> MMReadWord,
    MSrcWord -> MMSrcWord...), and an immediate read at the PC reads I space;
  * EaWord, EaByte, Push, Pop and FetchWord become their mapped versions;
  * the instruction fetch goes through the fetch window (cpu, MmuFetchWindow)
    and notes the instruction's address for MMR2 (MmuInstrStart); the slow
    fetch keeps a trap left pending by a trap sequence for after the
    instruction, as the unmapped loop's fast fetch does;
  * MFPI/MFPD reach the previous mode's I/D space, MTPI/MTPD likewise;
  * the handover at RunEnd is turned round: the mapped loop returns as soon
    as the unit goes off.
The Pico's source is used for both chips: its table (8192 entries, 32 KB)
fits beside the Pico 2's big one, and the handlers are the same instructions.
Every change is an exact text replacement that must match, so a change to
instructions.pico that the generator does not know about stops it loudly.
Run it after every change to instructions.pico, and --check before a commit.
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
J11 = os.path.join(HERE, "..", "J11_18MHz_KDJ11_BF")
SRC = os.path.join(J11, "pico", "instructions.pico")
OUTS = [(os.path.join(J11, "pico", "instructions_mmu.pico"), "instructions_mmu.pico", "instructions.pico"),
        (os.path.join(J11, "pico2", "instructions_mmu.pico2"), "instructions_mmu.pico2", "instructions.pico")]


def fail(msg):
    sys.stderr.write("mmu_gen: " + msg + "\n")
    sys.exit(1)


def once(s, old, new, what):
    n = s.count(old)
    if n != 1:
        fail("%s: expected the text once in instructions.pico, found it %d times. The unmapped "
             "loop changed shape; teach tools/mmu_gen.py the new form." % (what, n))
    return s.replace(old, new)


FETCH_SYNCED = """  If PC < #RAM_BYTES
    If (PC & 1) = 0
      Op = Mem(PC >> 1)
      PC = PC + 2
      Goto OpTable(Op >> 3)
    EndIf
  EndIf
  Goto SlowFetch"""
FETCH_NATIVE = """  If PC < #RAM_BYTES
    Op = Mem(PC >> 1)
    PC = PC + 2
    Goto OpTable(Op >> 3)
  EndIf
  Goto SlowFetch"""
FETCH_LOOP = """Fetch:
  If PC < #RAM_BYTES
    If (PC & 1) = 0
      Op = Mem(PC >> 1)                  ; fast fetch, straight from RAM
      PC = PC + 2
      Goto OpTable(Op >> 3)
    EndIf
  EndIf"""
FETCH_MAPPED = """  If PC >= FetchLo                       ; the fetch, through the fetch window (cpu)
    If PC < FetchHi
      If (PC & 1) = 0
        MmuInstrStart(PC)
        Op = Mem((PC + FetchBase) >> 1)
        PC = PC + 2
        Goto OpTable(Op >> 3)
      EndIf
    EndIf
  EndIf"""
HANDOVER_U = """  ; ---- MMU HANDOVER (the mapped side is written by tools/mmu_gen.py) ----
  If MmuOn                               ; the memory management unit is on: the
    RunSave = RunFrom                    ; mapped run loop (instructions_mmu) runs
    CpuRunM(RunBank)                     ; the rest, and comes back with what it did
    RunFrom = RunSave                    ; not run when the unit goes off again
    PC = Reg(7)
  EndIf
  ; ---- END MMU HANDOVER ----"""
HANDOVER_M = """  ; ---- MMU HANDOVER: the unit is off - back to the unmapped loop ----
  If MmuOn = 0                           ; CpuRun (instructions) takes the rest
    ProcedureReturn InstrCount - RunFrom
  EndIf
  ; ---- END MMU HANDOVER ----"""


def generate():
    raw = open(SRC, "rb").read().decode("ascii").replace("\r\n", "\n")
    start = raw.index("Global Dim OpTable.Label(8192)")
    s = raw[start:]

    # the fetch paths, before any renaming
    s = once(s, FETCH_LOOP, "Fetch:\n" + FETCH_MAPPED, "the Fetch label")
    n = s.count(FETCH_SYNCED)
    if n != 1:
        fail("NextSynced's fetch: found %d times, expected once." % n)
    s = s.replace(FETCH_SYNCED, FETCH_MAPPED + "\n  Goto SlowFetch")
    n = s.count(FETCH_NATIVE)
    if n != 1:
        fail("NextNative's fetch: found %d times, expected once." % n)
    s = s.replace(FETCH_NATIVE, FETCH_MAPPED + "\n  Goto SlowFetch")
    # the slow fetch: a trap a trap sequence left pending (a push that failed,
    # TakeTrap) is not the fetch's own failure. The unmapped loop nearly always
    # fetches through its fast path, which executes the instruction and takes
    # that trap after it; the mapped loop comes here after every map or mode
    # change, so it must do the same.
    s = once(s, """  Reg(7) = PC
  Op = FetchWord()""", """  Reg(7) = PC
  MmuInstrStart(PC)
  TrapHeld = TrapVector
  TrapVector = 0
  Op = FetchWord()""", "SlowFetch")
    s = once(s, """1983, model differences 28 and 30)
  Goto OpTable(Op >> 3)""", """1983, model differences 28 and 30)
  TrapVector = TrapHeld
  Goto OpTable(Op >> 3)""", "SlowFetch's end")
    s = once(s, HANDOVER_U, HANDOVER_M, "the RunEnd handover")
    if "Mem(" in s.replace(FETCH_MAPPED, ""):
        fail("a direct Mem( is left in the loop: every access must go through a macro the generator maps.")

    # MFPI/MFPD and MTPI/MTPD: the operand is in the PREVIOUS mode; MFPD/MTPD
    # (bit 15 of the instruction) in D space, MFPI/MTPI in I space
    s = once(s, """    Ea = EaWord(Op & $3F)
    MReadWord(Src, Ea)
  EndIf
  If TrapVector = 0""", """    Ea = EaWord(Op & $3F)
    MMReadWordE(Src, Ea, PrvBase + ((Op >> 12) & 8))
  EndIf
  If TrapVector = 0""", "MFPI's operand")
    s = once(s, """      Reg(Op & 7) = Src
    EndIf
  Else
    Ea = EaWord(Op & $3F)
    MWriteWord(Ea, Src)
  EndIf""", """      Reg(Op & 7) = Src
    EndIf
  Else
    Ea = EaWord(Op & $3F)
    MMWriteWordE(Ea, Src, PrvBase + ((Op >> 12) & 8))
  EndIf""", "MTPI's operand")

    # an immediate read straight at the PC: I space
    s = re.sub(r"MReadWord\((\w+), PC\)", r"MMReadWordE(\1, PC, CurI)", s)
    s = re.sub(r"MReadByte\((\w+), PC\)", r"MMReadByteE(\1, PC, CurI)", s)
    # every other operand access: where the last operand address was formed
    for m in ("MReadWord(", "MWriteWord(", "MReadByte(", "MWriteByte(", "MSrcWord(", "MSrcByte("):
        s = s.replace(m, "M" + m)
    for h in ("EaWord", "EaByte", "Push", "Pop", "FetchWord"):
        s = re.sub(r"\b%s\(" % h, h + "M(", s)

    # the names: labels, the table, the loop's macros, the procedures, the globals
    labels = set(re.findall(r"(?m)^(\w+):", s))
    macros = set(re.findall(r"(?m)^Macro (\w+)\(", s))
    names = labels | macros | {"OpTable", "OpTableReady", "Ops", "FillFrom", "FillCount", "CpuRun",
                               "BuildOpcodeTable"}
    names.discard("MmuInstrStart")
    pat = re.compile(r"(?<![\w#])(%s)(?!\w)" % "|".join(sorted(names, key=len, reverse=True)))
    out = []
    for line in s.split("\n"):
        code, sep, comment = line.partition(";")
        out.append(pat.sub(lambda m: m.group(1) + "M", code) + sep + comment)
    return "\n".join(out)


def header(name, src_name):
    return """; ======================================================================
;  %s - GENERATED by PureMetal/tools/mmu_gen.py from pico/%s.
;  DO NOT EDIT: change pico/instructions.pico and run the tool again
;  (--check tells whether this file is current).
;
;  The J-11's MAPPED run loop: CpuRunM, the same handlers as CpuRun with
;  every memory access going through the memory management unit (cpu,
;  THE MEMORY MANAGEMENT UNIT). CpuRun hands over to it at a window's end
;  while MMR0 bit 0 is set, and it hands back as soon as the bit is clear,
;  so the unmapped loop is untouched and costs nothing when the unit is off.
;  Include it after cpu and before instructions.
; ======================================================================
""" % (name, src_name)


def main():
    body = generate()
    bad = []
    for path, name, src_name in OUTS:
        text = header(name, src_name) + body
        if name.endswith(".pico2"):          # the Pico 2: V6 runs here - SRAM (55 KB fits beside its tables)
            text = text.replace("\nProcedure.i CpuRunM(n.i)\n", "\nProcedureRAM.i CpuRunM(n.i)\n", 1)
        else:                                 # the Pico: its SRAM holds CpuRun (Mini-Unix); CpuRunM stays in flash
            text = text.replace("\nProcedureRAM.i CpuRunM(n.i)", "\nProcedure.i CpuRunM(n.i)", 1)
        if "--check" in sys.argv:
            try:
                have = open(path, "rb").read().decode("ascii").replace("\r\n", "\n")
            except OSError:
                have = None
            if have != text:
                bad.append(name)
        else:
            open(path, "w", newline="\n").write(text)
    if "--check" in sys.argv:
        if bad:
            fail("out of date: %s. Run tools/mmu_gen.py." % ", ".join(bad))
        print("mmu_gen: instructions_mmu is current")
    else:
        print("mmu_gen: wrote %s (%d lines)" % (", ".join(n for _, n, _ in OUTS), body.count("\n")))


if __name__ == "__main__":
    main()
