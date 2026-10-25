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
    # the Pico's handlers write the operand address as EaFast() (cpu.pico: __eaw1
    # with #ASM_EA = 1); the mapped loop gets the EaWord line it stands for
    raw = raw.replace("EaFast()", "Ea = EaWord(Op & $3F)")
    # ... and the Pico 2's unmapped handlers EaFastB() for the byte form (cpu.pico2: __eaub)
    raw = raw.replace("EaFastB()", "Ea = EaByte(Op & $3F)")
    # the unmapped loop's own MOV handlers (and their table lines) stay out:
    # they use the unmapped operand code directly, and the Pico 2's mapped
    # loop gets handlers written here instead (specialise, below)
    b0 = "; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----\n"
    b1 = "; ---- END UNMAPPED ONLY ----\n"
    while b0 in raw:
        i = raw.index(b0)
        raw = raw[:i] + raw[raw.index(b1, i) + len(b1):]
    # the unmapped loop's tails in assembly (#ASM_TAILS) stay out too: the
    # mapped loop's tails are written from the macros in the Else branch
    b0 = "; ---- UNMAPPED ONLY: the tails in assembly (tools/mmu_gen.py leaves this block out) ----\n"
    while b0 in raw:
        i = raw.index(b0)
        raw = raw[:i] + raw[raw.index(b1, i) + len(b1):]
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


# ----------------------------------------------------------------------
#  THE PICO 2's MOV, SPECIALISED BY ADDRESSING MODE (speed, 2026-10-03)
#  The mapped table is indexed by Op >> 3, which already holds the source
#  mode, the source register and the destination mode. So a MOV whose two
#  modes are both common under V6 gets a handler of its own, with exactly
#  the lines EaWordM would have run for those modes written in place: no
#  call, and no test of the mode. Everything else about the instruction -
#  the order of the register changes, MMR1, the stack limit, the traps -
#  is the general handler's, line for line. Only the Pico 2's file has
#  them (its mapped loop runs V6 from SRAM). MOV_PAIRS is the measured
#  choice: SRAM limits how many there can be.
# ----------------------------------------------------------------------
MOV_PAIRS = [(0, 4), (4, 0), (6, 0), (6, 4), (2, 0), (6, 1), (0, 6)]     # (source mode, destination mode)

SRC_CODE = {
    0: "  Src = Reg((Op >> 6) & 7)\n",
    1: "  EaReg = (Op >> 6) & 7\n  Ea = Reg(EaReg)\n  MMReadWordE(Src, Ea, CurD)\n",
    2: "  EaReg = (Op >> 6) & 7\n  Ea = Reg(EaReg)\n  Reg(EaReg) = (Ea + 2) & $FFFF\n"
       "  MmrRecord(EaReg, 2)\n  MMReadWordE(Src, Ea, CurD)\n",          # the table sends only R0-R6 here
    4: "  EaReg = (Op >> 6) & 7\n  Ea = (Reg(EaReg) - 2) & $FFFF\n  Reg(EaReg) = Ea\n  MmrRecord(EaReg, -2)\n"
       "  If EaReg = 6\n    StackCheckFast()\n  EndIf\n  MMReadWordE(Src, Ea, CurD)\n",
    6: "  EaReg = (Op >> 6) & 7\n  Adr = Reg(7)\n  Reg(7) = (Adr + 2) & $FFFF\n  MMReadWordE(Tmp, Adr, CurI)\n"
       "  Ea = (Tmp + Reg(EaReg)) & $FFFF\n  MMReadWordE(Src, Ea, CurD)\n",
}
DST_CODE = {
    0: "  Reg(Op & 7) = Src\n",
    1: "  EaReg = Op & 7\n  Ea = Reg(EaReg)\n  MMWriteWordE(Ea, Src, CurD)\n",
    2: "  EaReg = Op & 7\n  Ea = Reg(EaReg)\n  Reg(EaReg) = (Ea + 2) & $FFFF\n"
       "  If EaReg = 7\n    MMWriteWordE(Ea, Src, CurI)\n  Else\n    MmrRecord(EaReg, 2)\n"
       "    MMWriteWordE(Ea, Src, CurD)\n  EndIf\n",
    4: "  EaReg = Op & 7\n  Ea = (Reg(EaReg) - 2) & $FFFF\n  Reg(EaReg) = Ea\n  MmrRecord(EaReg, -2)\n"
       "  If EaReg = 6\n    StackCheckFast()\n  EndIf\n  MMWriteWordE(Ea, Src, CurD)\n",
    6: "  EaReg = Op & 7\n  Adr = Reg(7)\n  Reg(7) = (Adr + 2) & $FFFF\n  MMReadWordE(Tmp, Adr, CurI)\n"
       "  Ea = (Tmp + Reg(EaReg)) & $FFFF\n  MMWriteWordE(Ea, Src, CurD)\n",
}


NATIVE_EVEN = True     # the Pico 2's native tail does not test the PC for odd (see native_even)


def native_even(text):
    """The Pico 2's file: NextNativeM without the odd-PC test. A native handler
    is reached only through a fetch that found the PC even, and it moves the PC
    by an even amount or not at all - the reason the unmapped NextNative has no
    such test either. One test fewer on every branch and register-form tail."""
    i = text.index("Macro NextNativeM()\n")
    j = text.index("EndMacro\n", i)
    old = """      If (PC & 1) = 0
        MmuInstrStart(PC)
        Op = Mem((PC + FetchBase) >> 1)
        PC = PC + 2
        Goto OpTableM(Op >> 3)
      EndIf
"""
    new = """      MmuInstrStart(PC)
      Op = Mem((PC + FetchBase) >> 1)
      PC = PC + 2
      Goto OpTableM(Op >> 3)
"""
    if text[i:j].count(old) != 1:
        fail("native_even: NextNativeM changed shape; teach tools/mmu_gen.py.")
    return text[:i] + text[i:j].replace(old, new) + text[j:]


ASM_FETCH_M = """    ldr r3, =global_fw
    ldr r1, [r3, #0]
    cmp r0, r1
    blt __ul_cpurunm_slowfetchm
    ldr r1, [r3, #4]
    cmp r0, r1
    bge __ul_cpurunm_slowfetchm
%s    str r0, [r3, #12]
    ldr r1, [r3, #8]
    ldrh r2, [r1, r0]
    mov r8, r2
    adds.w r9, r9, #2
    lsrs r2, r2, #3
    lsls r2, r2, #2
    ldr r1, =global_optablem
    ldr r1, [r1, r2]
    bx r1
  EndASM
EndMacro
"""
ASM_SYNCED_M = """Macro NextSyncedM()
  ASM Uses PC, RunLeft, Op
    ldr r1, =global_reg
    ldr r0, [r1, #28]
    mov r9, r0
    ldr r1, =global_trapvector
    ldr r1, [r1]
    cmp r1, #0
    bne __ul_cpurunm_slowtailm
    subs.w r11, r11, #1
    beq __ul_cpurunm_runendm
""" + ASM_FETCH_M % "    lsls r1, r0, #31\n    bne __ul_cpurunm_slowfetchm\n"
ASM_NATIVE_M = """Macro NextNativeM()
  ASM Uses PC, RunLeft, Op
    subs.w r11, r11, #1
    beq __ul_cpurunm_runendm
    mov r0, r9
""" + ASM_FETCH_M % ""


def pico2_tails(text):
    """The Pico 2's file: the fetch window and the instruction's address are
    the array Fw (cpu.pico2), and each tail macro also exists as an assembly
    block, chosen by #ASM_TAILS (cpu.pico2). The assembly is the macro's own
    steps for the Cortex-M33, with the four Fw words reached through one base
    register."""
    for name, asm in (("NextSyncedM", ASM_SYNCED_M), ("NextNativeM", ASM_NATIVE_M)):
        i = text.index("Macro %s()\n" % name)
        j = text.index("EndMacro\n", i) + len("EndMacro\n")
        text = (text[:i] + "CompilerIf #ASM_TAILS = 1\n" + asm + "CompilerElse\n" + text[i:j] +
                "CompilerEndIf\n" + text[j:])
    out = []
    for line in text.split("\n"):
        code, sep, comment = line.partition(";")
        for a, b in (("FetchLo", "Fw(0)"), ("FetchHi", "Fw(1)"), ("FetchBase", "Fw(2)")):
            code = re.sub(r"\b%s\b" % a, b, code)
        # the Pico 2's fetch window holds a host address (cpu.pico2, MapHost): the word at
        # the PC is at PC + Fw(2), in SRAM or in PSRAM alike
        code = code.replace("Op = Mem((PC + Fw(2)) >> 1)", "Op = PeekU(PC + Fw(2))")
        out.append(code + sep + comment)
    text = "\n".join(out)
    if "Mem((PC + Fw(2))" in text:
        fail("pico2_tails: a mapped fetch still indexes Mem; teach tools/mmu_gen.py its form.")
    return text


# ----------------------------------------------------------------------
#  THE MOV HANDLERS IN ASSEMBLY (#ASM_MOV = 1, cpu.pico2). Each MOV_PAIRS
#  handler gets a Cortex-M33 fast path in front of its Basic body. The fast
#  path makes EVERY test the Basic makes before it changes anything: the
#  register is not R7 where the Basic would reach Reg(7) through a variable,
#  each access lies in its entry's fast window (cpu.pico2, MMReadWordE /
#  MMWriteWordE) and is even, a pushed SP stays at or above 000400. If any
#  test fails it branches, with nothing changed, to the Basic body (the label
#  with "Ref"), which does the whole instruction the slow way - so the Basic
#  is both the slow path and the reference the fast path is held to
#  (asm_check.pico2 compares the two on random machine states). When every
#  test passes nothing can trap, so the handler ends with the native tail
#  and leaves Reg(7) stale, as every native handler does.
#  Registers: r0-r3 only, plus Op (r8), PC (r9), RunLeft (r11) and FlagNZ
#  (r4, written only after the last test).
# ----------------------------------------------------------------------
ASM_REC = {2: 0x10, -2: 0xF0}          # MmrRecord's byte: ((amount & $1F) << 3) | register


def asm_mov(sm, dm, ref):
    tag = "__mv%d%d_" % (sm, dm)
    bail = "__ul_cpurunm_" + ref.lower()
    L = []
    e = L.append

    def window(addr, base, kind, s1, s2):
        # s2 = the entry's host base when addr is in its fast window (else to the Basic)
        e("    ldr %s, =global_cur%s" % (s1, base))
        e("    ldr %s, [%s]" % (s1, s1))
        e("    add.w %s, %s, %s, lsr #13" % (s1, s1, addr))
        e("    lsls %s, %s, #2" % (s1, s1))       # the entry's byte offset in the Map arrays
        e("    ldr %s, =global_map%slo" % (s2, kind))
        e("    ldr %s, [%s, %s]" % (s2, s2, s1))
        e("    cmp %s, %s" % (addr, s2))
        e("    blt %s" % bail)
        e("    ldr %s, =global_map%shi" % (s2, kind))
        e("    ldr %s, [%s, %s]" % (s2, s2, s1))
        e("    cmp %s, %s" % (addr, s2))
        e("    bge %s" % bail)
        e("    lsls %s, %s, #31" % (s2, addr))
        e("    bne %s" % bail)
        e("    ldr %s, =global_maphost" % s2)
        e("    ldr %s, [%s, %s]" % (s2, s2, s1))

    def reg_of(out, field_shift):
        # out = the register field of Op at field_shift (0 destination, 6 source)
        if field_shift:
            e("    ubfx %s, r8, #6, #3" % out)
        else:
            e("    and.w %s, r8, #7" % out)

    def mmr_record(rreg, amount):
        # MmrRecord(r, amount) (cpu.pico2) with r in rreg; uses r0-r3
        e("    ldr r3, =global_mmr0")
        e("    ldr r3, [r3]")
        e("    lsrs r3, r3, #13")
        e("    bne %sr9" % tag)
        e("    adds %s, #%d" % (rreg, ASM_REC[amount]))
        e("    ldr r3, =global_fw")
        e("    ldr r3, [r3, #12]")
        e("    ldr r0, =global_mmupcrec")
        e("    ldr r1, [r0]")
        e("    cmp r1, r3")
        e("    beq %sr1" % tag)
        e("    str r3, [r0]")
        e("    ldr r0, =global_mmr1")
        e("    str %s, [r0]" % rreg)
        e("    b %sr9" % tag)
        e("%sr1:" % tag)
        e("    ldr r0, =global_mmr1")
        e("    ldr r1, [r0]")
        e("    uxtb r1, r1")
        e("    cmp r1, #0")
        e("    beq %sr2" % tag)
        e("    lsls %s, %s, #8" % (rreg, rreg))
        e("    orrs r1, %s" % rreg)
        e("    str r1, [r0]")
        e("    b %sr9" % tag)
        e("%sr2:" % tag)
        e("    str %s, [r0]" % rreg)
        e("%sr9:" % tag)

    def index_word(out, pc_reg):
        # out = (the word at pc_reg, I space) + the base register; pc_reg + 2 is the new PC
        window(pc_reg, "i", "r", "r2", "r3")
        e("    ldrh r3, [r3, %s]" % pc_reg)

    # ---- the tests, in the order the Basic makes its accesses ----
    # r1 = Src at the end of the tests; r0 the destination address (memory
    # destinations), r3 its entry's host base
    if sm == 6:
        e("    mov r0, r9")
        index_word("r3", "r0")                 # r3 = the index word
        reg_of("r1", 6)
        e("    cmp r1, #7")
        e("    bne %ss1" % tag)
        e("    adds r1, r0, #2")              # X(PC): the PC after the index word
        e("    b %ss2" % tag)
        e("%ss1:" % tag)
        e("    ldr r2, =global_reg")
        e("    lsls r1, r1, #2")
        e("    ldr r1, [r2, r1]")
        e("%ss2:" % tag)
        e("    adds r0, r3, r1")
        e("    uxth r0, r0")                 # the source address
        window("r0", "d", "r", "r2", "r3")
        e("    ldrh r1, [r3, r0]")           # Src
    elif sm == 4:
        reg_of("r2", 6)
        e("    cmp r2, #7")
        e("    beq %s" % bail)
        e("    ldr r3, =global_reg")
        e("    lsls r0, r2, #2")
        e("    ldr r0, [r3, r0]")
        e("    subs r0, r0, #2")
        e("    uxth r0, r0")
        e("    cmp r2, #6")
        e("    bne %ss1" % tag)
        e("    cmp.w r0, #0x100")
        e("    blt %s" % bail)
        e("%ss1:" % tag)
        window("r0", "d", "r", "r2", "r3")
        e("    ldrh r1, [r3, r0]")
    elif sm == 2:
        reg_of("r2", 6)                        # the table sends only R0-R6 here
        e("    ldr r3, =global_reg")
        e("    lsls r0, r2, #2")
        e("    ldr r0, [r3, r0]")
        window("r0", "d", "r", "r2", "r3")
        e("    ldrh r1, [r3, r0]")

    if dm == 0:
        reg_of("r2", 0)
        e("    cmp r2, #7")
        e("    beq %s" % bail)
    elif dm == 1:
        reg_of("r2", 0)
        e("    cmp r2, #7")
        e("    beq %s" % bail)
        e("    ldr r3, =global_reg")
        e("    lsls r0, r2, #2")
        e("    ldr r0, [r3, r0]")
        window("r0", "d", "w", "r2", "r3")
    elif dm == 4:
        reg_of("r2", 0)
        e("    cmp r2, #7")
        e("    beq %s" % bail)
        e("    ldr r3, =global_reg")
        e("    lsls r0, r2, #2")
        e("    ldr r0, [r3, r0]")
        e("    subs r0, r0, #2")
        e("    uxth r0, r0")
        e("    cmp r2, #6")
        e("    bne %sd1" % tag)
        e("    cmp.w r0, #0x100")
        e("    blt %s" % bail)
        e("%sd1:" % tag)
        window("r0", "d", "w", "r2", "r3")
    elif dm == 6:
        e("    mov r0, r9")
        index_word("r3", "r0")
        reg_of("r1", 0)
        e("    cmp r1, #7")
        e("    bne %sd1" % tag)
        e("    adds r1, r0, #2")
        e("    b %sd2" % tag)
        e("%sd1:" % tag)
        e("    ldr r2, =global_reg")
        e("    lsls r1, r1, #2")
        e("    ldr r1, [r2, r1]")
        e("%sd2:" % tag)
        e("    adds r0, r3, r1")
        e("    uxth r0, r0")
        window("r0", "d", "w", "r2", "r3")
    if sm == 0:
        # a register source is read AFTER the destination's address is worked
        # out (mmu_gen's specialise): R7 is the PC as it stands then, and a
        # source that is the autodecremented destination register reads its new value
        reg_of("r1", 6)
        e("    cmp r1, #7")
        e("    bne %sa1" % tag)
        e("    mov r1, r9")
        if dm == 6:
            e("    adds r1, r1, #2")
        e("    b %sa9" % tag)
        e("%sa1:" % tag)
        if dm == 4:
            e("    and.w r2, r8, #7")
            e("    cmp r1, r2")
            e("    bne %sa2" % tag)
            e("    movs r1, r0")
            e("    b %sa9" % tag)
            e("%sa2:" % tag)
        e("    ldr r2, =global_reg")
        e("    lsls r1, r1, #2")
        e("    ldr r1, [r2, r1]")
        e("%sa9:" % tag)

    # ---- every test passed: the instruction, as the Basic does it ----
    if dm in (1, 4, 6):
        e("    strh r1, [r3, r0]")
    e("    movs r4, r1")                      # FlagNZ = Src
    if sm in (6,) or dm == 6:
        e("    adds.w r9, r9, #%d" % (4 if (sm == 6 and dm == 6) else 2))
    flagv = ["    ldr r3, =global_flagv", "    movs r0, #0", "    str r0, [r3]"]
    if sm in (2, 4):
        # the source register moves first, then the destination register is
        # written (they may be the same register), then MmrRecord(rs, +-2)
        e("    ubfx r2, r8, #6, #3")
        e("    ldr r3, =global_reg")
        if sm == 2:
            e("    adds r0, r0, #2")
            e("    uxth r0, r0")
        e("    lsls r2, r2, #2")
        e("    str r0, [r3, r2]")
        e("    lsrs r2, r2, #2")
        e("    and.w r0, r8, #7")
        e("    lsls r0, r0, #2")
        e("    str r1, [r3, r0]")             # dm is 0 for every sm 2/4 pair
        L.extend(flagv)
        mmr_record("r2", 2 if sm == 2 else -2)
    elif dm == 0:
        e("    and.w r0, r8, #7")
        e("    ldr r3, =global_reg")
        e("    lsls r0, r0, #2")
        e("    str r1, [r3, r0]")
        L.extend(flagv)
    elif dm == 4:
        e("    and.w r2, r8, #7")
        e("    ldr r3, =global_reg")
        e("    lsls r2, r2, #2")
        e("    str r0, [r3, r2]")
        e("    lsrs r2, r2, #2")
        L.extend(flagv)
        mmr_record("r2", -2)
    else:
        L.extend(flagv)
    # the native tail (NextNativeM)
    tail = ASM_NATIVE_M.split("\n")[2:]
    tail = tail[:tail.index("  EndASM")]
    no_scaled_index("\n".join(L), "asm_mov")
    return "\n".join(L + tail) + "\n"


# ----------------------------------------------------------------------
#  THE OPERAND ADDRESS IN ASSEMBLY (#ASM_EA = 1, cpu.pico2): __eaw, a
#  subroutine the mapped handlers reach with "bl" instead of calling EaWordM
#  (a call, a frame and a return cost about as much as the work). In: r0 =
#  the 6-bit mode and register. Out: r0 = the address, with EaReg, EaBase,
#  Tmp, Adr, the register and MMR1 left exactly as EaWordM leaves them.
#  X(R), -(R), (R)+, (R), @(R)+ and @X(R) are done here (2026-10-21: @#a
#  and @a, the absolute and deferred forms, were 4% of V7's time in EaWordM);
#  anything else - the index word outside the I fast window or odd, -(R) or
#  (R) on R7 (I space: cpu.pico2, THE PC'S SPACE) or -(R) taking SP below
#  000400, the other modes - goes on to EaWordM itself
#  with the spec, nothing changed that EaWordM does not set again, and lr
#  still the handler's, so EaWordM returns straight to the handler. It
#  clobbers r0-r3, r12 and lr only. asm_check.pico2 holds it to EaWordM.
# ----------------------------------------------------------------------
ASM_EAW = """    mov r12, r0
    and.w r1, r0, #7
    ldr r2, =global_eareg
    str r1, [r2]
    ldr r2, =global_curd
    ldr r2, [r2]
    ldr r3, =global_eabase
    str r2, [r3]
    ubfx r0, r0, #3, #3
    cmp r0, #6
    bne __eaw_m4
    ldr r2, =global_reg
    ldr r3, [r2, #28]
    ldr r2, =global_curi
    ldr r2, [r2]
    add.w r2, r2, r3, lsr #13
    lsls r2, r2, #2
    ldr r0, =global_maprlo
    ldr r0, [r0, r2]
    cmp r3, r0
    blt __eaw_slow
    ldr r0, =global_maprhi
    ldr r0, [r0, r2]
    cmp r3, r0
    bge __eaw_slow
    lsls r0, r3, #31
    bne __eaw_slow
    ldr r0, =global_adr
    str r3, [r0]
    ldr r0, =global_maphost
    ldr r0, [r0, r2]
    ldrh r0, [r0, r3]
    ldr r2, =global_tmp
    str r0, [r2]
    adds r3, r3, #2
    uxth r3, r3
    ldr r2, =global_reg
    str r3, [r2, #28]
    lsls r3, r1, #2
    ldr r3, [r2, r3]
    adds r0, r0, r3
    uxth r0, r0
    b __eaw_out
__eaw_m4:
    cmp r0, #4
    bne __eaw_m2
    cmp r1, #7
    beq __eaw_slow
    ldr r2, =global_reg
    lsls r3, r1, #2
    adds r2, r2, r3
    ldr r3, [r2]
    subs r3, r3, #2
    uxth r3, r3
    cmp r1, #6
    bne __eaw_m4a
    cmp.w r3, #0x100
    blt __eaw_slow
__eaw_m4a:
    str r3, [r2]
    ldr r2, =global_tmp
    str r0, [r2]
    movs r0, r3
    adds r1, #240
    b __eaw_rec
__eaw_m2:
    cmp r0, #2
    bne __eaw_m1
    ldr r2, =global_reg
    lsls r3, r1, #2
    adds r2, r2, r3
    ldr r3, [r2]
    adds r0, r3, #2
    uxth r0, r0
    str r0, [r2]
    ldr r2, =global_tmp
    str r3, [r2]
    movs r0, r3
    cmp r1, #7
    bne __eaw_m2a
    ldr r2, =global_curi
    ldr r2, [r2]
    ldr r3, =global_eabase
    str r2, [r3]
    b __eaw_out
__eaw_m2a:
    adds r1, #16
    b __eaw_rec
__eaw_m1:
    cmp r0, #1
    bne __eaw_m3
    cmp r1, #7
    beq __eaw_slow
    ldr r2, =global_tmp
    str r0, [r2]
    ldr r2, =global_reg
    lsls r0, r1, #2
    ldr r0, [r2, r0]
    b __eaw_out
__eaw_m3:
    cmp r0, #3
    bne __eaw_m7
    ldr r2, =global_reg
    lsls r3, r1, #2
    ldr r3, [r2, r3]
    lsls r0, r3, #31
    bne __eaw_slow
    cmp r1, #7
    beq __eaw_m3i
    ldr r2, =global_curd
    b __eaw_m3e
__eaw_m3i:
    ldr r2, =global_curi
__eaw_m3e:
    ldr r2, [r2]
    add.w r2, r2, r3, lsr #13
    lsls r2, r2, #2
    ldr r0, =global_maprlo
    ldr r0, [r0, r2]
    cmp r3, r0
    blt __eaw_slow
    ldr r0, =global_maprhi
    ldr r0, [r0, r2]
    cmp r3, r0
    bge __eaw_slow
    ldr r0, =global_adr
    str r3, [r0]
    ldr r0, =global_maphost
    ldr r0, [r0, r2]
    ldrh r0, [r0, r3]
    ldr r2, =global_tmp
    str r0, [r2]
    adds r3, r3, #2
    uxth r3, r3
    ldr r2, =global_reg
    add.w r2, r2, r1, lsl #2
    str r3, [r2]
    cmp r1, #7
    beq __eaw_out
    adds r1, #16
    b __eaw_rec
__eaw_m7:
    cmp r0, #7
    bne __eaw_slow
    ldr r2, =global_reg
    ldr r3, [r2, #28]
    lsls r0, r3, #31
    bne __eaw_slow
    ldr r2, =global_curi
    ldr r2, [r2]
    add.w r2, r2, r3, lsr #13
    lsls r2, r2, #2
    ldr r0, =global_maprlo
    ldr r0, [r0, r2]
    cmp r3, r0
    blt __eaw_slow
    ldr r0, =global_maprhi
    ldr r0, [r0, r2]
    cmp r3, r0
    bge __eaw_slow
    ldr r0, =global_maphost
    ldr r0, [r0, r2]
    ldrh r0, [r0, r3]
    adds r3, r3, #2
    uxth r3, r3
    cmp r1, #7
    beq __eaw_m7p
    ldr r2, =global_reg
    add.w r2, r2, r1, lsl #2
    ldr r2, [r2]
    b __eaw_m7a
__eaw_m7p:
    movs r2, r3
__eaw_m7a:
    adds r0, r0, r2
    uxth r0, r0
    push {r5}
    movs r5, r3
    lsls r3, r0, #31
    bne __eaw_m7x
    ldr r2, =global_curd
    ldr r2, [r2]
    add.w r2, r2, r0, lsr #13
    lsls r2, r2, #2
    ldr r3, =global_maprlo
    ldr r3, [r3, r2]
    cmp r0, r3
    blt __eaw_m7x
    ldr r3, =global_maprhi
    ldr r3, [r3, r2]
    cmp r0, r3
    bge __eaw_m7x
    ldr r3, =global_adr
    str r0, [r3]
    ldr r3, =global_maphost
    ldr r3, [r3, r2]
    ldrh r0, [r3, r0]
    ldr r3, =global_tmp
    str r0, [r3]
    ldr r3, =global_reg
    str r5, [r3, #28]
    pop {r5}
    b __eaw_out
__eaw_m7x:
    pop {r5}
    b __eaw_slow
__eaw_rec:
    ldr r2, =global_mmr0
    ldr r2, [r2]
    lsrs r2, r2, #13
    bne __eaw_out
    ldr r3, =global_fw
    ldr r3, [r3, #12]
    ldr r2, =global_mmupcrec
    ldr r2, [r2]
    cmp r2, r3
    beq __eaw_rec1
    ldr r2, =global_mmupcrec
    str r3, [r2]
    ldr r2, =global_mmr1
    str r1, [r2]
    b __eaw_out
__eaw_rec1:
    ldr r3, =global_mmr1
    ldr r2, [r3]
    uxtb r2, r2
    cmp r2, #0
    beq __eaw_rec2
    lsls r1, r1, #8
    orrs r2, r1
    str r2, [r3]
    b __eaw_out
__eaw_rec2:
    str r1, [r3]
__eaw_out:
    bx lr
__eaw_slow:
    mov r0, r12
    ldr r1, =global_easpec
    str r0, [r1]
    b eawordm
"""
EAW_CALL = """CompilerIf #ASM_EA = 1
  ASM Uses Op
    and.w r0, r8, #0x3f
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
  EndASM
CompilerElse
  Ea = EaWordM(Op & $3F)
CompilerEndIf
"""


def no_scaled_index(text, what):
    """The RP2350 assembler of the 2026-10-17 release dropped the shift of
    "ldr/str Rt, [Rn, Rm, lsl #n]" without a word (forum 1355, fixed in
    compiler 38267549e); a firmware built with it would run wrong. So the
    generated assembly shifts into a register first and never uses the form."""
    if re.search(r"\[[^\]]*lsl", text):
        fail(what + ": a scaled index ([Rn, Rm, lsl #n]) in the generated assembly; shift first (no_scaled_index).")


def pico2_eaw(text):
    """The Pico 2's file: __eaw after the slow fetch (it is reached only by bl),
    and the handlers' "Ea = EaWordM(Op & $3F)" lines call it."""
    at = "  TrapVector = TrapHeld\n  Goto OpTableM(Op >> 3)\n"
    if text.count(at) != 1:
        fail("pico2_eaw: the slow fetch's end moved; teach tools/mmu_gen.py.")
    no_scaled_index(ASM_EAW, "__eaw")
    text = text.replace(at, at + "CompilerIf #ASM_EA = 1\n  ASM\n__eaw:\n" + ASM_EAW + "  EndASM\nCompilerEndIf\n")
    out, n = [], 0
    for line in text.split("\n"):
        if line.strip() == "Ea = EaWordM(Op & $3F)":
            ind = line[:len(line) - len(line.lstrip())]
            out.append("\n".join(l if l.startswith("Compiler") else ind + l
                                 for l in EAW_CALL.rstrip("\n").split("\n")))
            n += 1
        else:
            out.append(line)
    if n < 30:
        fail("pico2_eaw: only " + str(n) + " EaWordM call sites found; teach tools/mmu_gen.py.")
    return "\n".join(out)


# ----------------------------------------------------------------------
#  THE STACK AND DIV IN ASSEMBLY (#ASM_OPS = 1, cpu.pico2). __pushm and
#  __popm are PushM and PopM's fast paths, reached by bl like __eaw: the
#  word at SP in the current D space's fast window, SP even and (for a
#  push) not going below 000400. In: r0 = the word to push / out: r0 = the
#  word popped. Anything else goes on to PushM / PopM themselves, nothing
#  changed, lr still the handler's. They clobber r0-r3 only.
#  JSR, RTS and DIV get an assembly version in front of their plain one
#  (InstructionXXXRefM, the reference): JSR and RTS call __eaw, __pushm and
#  __popm and move the registers; DIV's arithmetic is SDIV and MLS. The
#  plain versions stay as the slow path and as asm_check.pico2's reference
#  (OpAsmM / OpRefM, filled with the table).
# ----------------------------------------------------------------------
ASM_STACK = """__pushm:
    ldr r2, =global_reg
    ldr r1, [r2, #24]
    subs r1, r1, #2
    uxth r1, r1
    cmp.w r1, #0x100
    blt __pushm_slow
    lsls r2, r1, #31
    bne __pushm_slow
    ldr r3, =global_curd
    ldr r3, [r3]
    add.w r3, r3, r1, lsr #13
    lsls r3, r3, #2
    ldr r2, =global_mapwlo
    ldr r2, [r2, r3]
    cmp r1, r2
    blt __pushm_slow
    ldr r2, =global_mapwhi
    ldr r2, [r2, r3]
    cmp r1, r2
    bge __pushm_slow
    ldr r2, =global_maphost
    ldr r2, [r2, r3]
    strh r0, [r2, r1]
    ldr r2, =global_reg
    str r1, [r2, #24]
    bx lr
__pushm_slow:
    b pushm
__popm:
    ldr r2, =global_reg
    ldr r1, [r2, #24]
    lsls r0, r1, #31
    bne __popm_slow
    ldr r3, =global_curd
    ldr r3, [r3]
    add.w r3, r3, r1, lsr #13
    lsls r3, r3, #2
    ldr r0, =global_maprlo
    ldr r0, [r0, r3]
    cmp r1, r0
    blt __popm_slow
    ldr r0, =global_maprhi
    ldr r0, [r0, r3]
    cmp r1, r0
    bge __popm_slow
    ldr r0, =global_maphost
    ldr r0, [r0, r3]
    ldrh r0, [r0, r1]
    adds r1, r1, #2
    uxth r1, r1
    str r1, [r2, #24]
    bx lr
__popm_slow:
    b popm
"""

# __eab: EaByteM's assembly, reached like __eaw (r0 = the spec, r0 back = the
# address; lr kept). Only (R)+ and -(R) differ from a word operand - they step
# by 1 except on SP and PC - so every other mode goes straight on to __eaw,
# which is exactly what EaByteM does with EaWordM. EaStep, EaReg, EaBase, Tmp,
# the register and MMR1 are left as EaByteM leaves them; -(PC) and -(SP) below
# 000400 go on to EaByteM itself with the spec rebuilt. asm_check.pico2 holds
# it to EaByteM (ASMCHECK eab).
ASM_EAB = """__eab:
    mov r12, r0
    and.w r1, r0, #7
    movs r3, #1
    cmp r1, #6
    blt __eab_s1
    movs r3, #2
__eab_s1:
    ldr r2, =global_eastep
    str r3, [r2]
    ubfx r0, r0, #3, #3
    cmp r0, #2
    beq __eab_m2
    cmp r0, #4
    beq __eab_m4
    mov r0, r12
    b __eaw
__eab_m2:
    ldr r2, =global_eareg
    str r1, [r2]
    ldr r2, =global_curd
    ldr r2, [r2]
    ldr r0, =global_eabase
    str r2, [r0]
    lsls r0, r3, #3
    orr.w r12, r1, r0
    ldr r2, =global_reg
    lsls r0, r1, #2
    adds r2, r2, r0
    ldr r0, [r2]
    adds r3, r0, r3
    uxth r3, r3
    str r3, [r2]
    ldr r2, =global_tmp
    str r0, [r2]
    cmp r1, #7
    bne __eab_m2r
    ldr r2, =global_curi
    ldr r2, [r2]
    ldr r3, =global_eabase
    str r2, [r3]
    bx lr
__eab_m2r:
    mov r1, r12
    b __eaw_rec
__eab_m4:
    cmp r1, #7
    beq __eab_slow4
    movs r0, #32
    subs r0, r0, r3
    lsls r0, r0, #3
    orr.w r12, r1, r0
    ldr r2, =global_reg
    lsls r0, r1, #2
    adds r2, r2, r0
    ldr r0, [r2]
    subs r0, r0, r3
    uxth r0, r0
    cmp r1, #6
    bne __eab_m4a
    cmp.w r0, #0x100
    blt __eab_slow4
__eab_m4a:
    str r0, [r2]
    ldr r2, =global_eareg
    str r1, [r2]
    ldr r2, =global_curd
    ldr r2, [r2]
    ldr r3, =global_eabase
    str r2, [r3]
    ldr r2, =global_tmp
    movs r3, #4
    str r3, [r2]
    mov r1, r12
    b __eaw_rec
__eab_slow4:
    movs r0, r1
    adds r0, #32
    b eabytem
"""
EAB_CALL = """CompilerIf #ASM_EA = 1
  ASM Uses Op
    and.w r0, r8, #0x3f
    bl __eab
    ldr r1, =global_ea
    str r0, [r1]
  EndASM
CompilerElse
  Ea = EaByteM(Op & $3F)
CompilerEndIf
"""

JSR_ASM = """  PcOutM()
  If (Op & $38) = 0
    TrapVector = #VEC_BUS                ; JSR to a register is illegal
  Else
    ASM Uses Op
      and.w r0, r8, #0x3f
      bl __eaw
      ldr r1, =global_ea
      str r0, [r1]
      ubfx r0, r8, #6, #3
      lsls r0, r0, #2
      ldr r1, =global_reg
      ldr r0, [r1, r0]
      bl __pushm
      ubfx r0, r8, #6, #3
      lsls r0, r0, #2
      ldr r1, =global_reg
      ldr r2, [r1, #28]
      str r2, [r1, r0]
      ldr r2, =global_ea
      ldr r2, [r2]
      str r2, [r1, #28]
    EndASM
  EndIf
  NextSyncedM()
"""

RTS_ASM = """  PcOutM()
  ASM Uses Op
    ldr r1, =global_reg
    and.w r0, r8, #7
    lsls r0, r0, #2
    ldr r2, [r1, r0]
    str r2, [r1, #28]
    bl __popm
    and.w r1, r8, #7
    lsls r1, r1, #2
    ldr r2, =global_reg
    str r0, [r2, r1]
  EndASM
  NextSyncedM()
"""

# after the operand is in Src: the quotient to R, the remainder to R|1 (in that
# order: for an odd R the remainder is what stays), N and Z as SetNZ leaves them
DIV_ASM = """  ASM Uses Op, FlagNZ
    push {r5, r6}
    ldr r0, =global_src
    ldr r0, [r0]
    sxth r0, r0
    ldr r2, =global_reg
    ubfx r1, r8, #6, #3
    lsls r1, r1, #2
    orr.w r3, r1, #4
    adds r3, r3, r2
    adds r1, r1, r2
    ldr r2, [r1]
    ldr r5, [r3]
    orr.w r2, r5, r2, lsl #16
    cmp r0, #0
    beq __divm_zero
    adds r5, r0, #1
    bne __divm_go
    cmp.w r2, #0x80000000
    beq __divm_over
__divm_go:
    sdiv r5, r2, r0
    sxth r6, r5
    cmp r6, r5
    bne __divm_over
    mls r6, r5, r0, r2
    uxth r0, r5
    str r0, [r1]
    uxth r6, r6
    str r6, [r3]
    movs r4, #1
    cmp r5, #0
    bgt __divm_nz
    mov.w r4, #0x8000
    blt __divm_nz
    movs r4, #0
__divm_nz:
    movs r5, #0
    movs r6, #0
    b __divm_flags
__divm_zero:
    mov.w r5, #0x8000
    mov.w r6, #0x10000
    b __divm_flags
__divm_over:
    mov.w r5, #0x8000
    movs r6, #0
__divm_flags:
    ldr r0, =global_flagv
    str r5, [r0]
    ldr r0, =global_flagc
    str r6, [r0]
    pop {r5, r6}
  EndASM
"""
JMP_ASM = """CompilerIf #ASM_EA = 1
    ASM Uses Op
      and.w r0, r8, #0x3f
      bl __eaw
      ldr r1, =global_reg
      str r0, [r1, #28]
    EndASM
CompilerElse
"""
# __rdw / __wrw: a word operand read or written through its fast window, in the
# space EaBase names (as MMReadWord / MMWriteWord). In: r0 = the address (and
# r1 = the word, for __wrw). Out: r0 = the word read. Outside the window or odd:
# on to MmuReadWord(va, entry) / MmuWriteWord(va, entry, word), which do the
# rest (the I/O page, an abort, the first write to a page), lr still the
# handler's. They clobber r0-r3 and r12 only.
ASM_RW = """__rdw:
    ldr r2, =global_eabase
    ldr r2, [r2]
    add.w r2, r2, r0, lsr #13
    lsls r2, r2, #2
    lsls r3, r0, #31
    bne __rdw_slow
    ldr r3, =global_maprlo
    ldr r3, [r3, r2]
    cmp r0, r3
    blt __rdw_slow
    ldr r3, =global_maprhi
    ldr r3, [r3, r2]
    cmp r0, r3
    bge __rdw_slow
    ldr r3, =global_maphost
    ldr r3, [r3, r2]
    ldrh r0, [r3, r0]
    bx lr
__rdw_slow:
    lsrs r1, r2, #2
    b mmureadword
__wrw:
    ldr r2, =global_eabase
    ldr r2, [r2]
    add.w r2, r2, r0, lsr #13
    lsls r2, r2, #2
    lsls r3, r0, #31
    bne __wrw_slow
    ldr r3, =global_mapwlo
    ldr r3, [r3, r2]
    cmp r0, r3
    blt __wrw_slow
    ldr r3, =global_mapwhi
    ldr r3, [r3, r2]
    cmp r0, r3
    bge __wrw_slow
    ldr r3, =global_maphost
    ldr r3, [r3, r2]
    strh r1, [r3, r0]
    bx lr
__wrw_slow:
    mov r12, r1
    lsrs r1, r2, #2
    mov r2, r12
    b mmuwriteword
"""

# CMP after MMSrcWord(): Dst from a register or through __eaw and __rdw;
# Res = Src - Dst, C = Res, V = (Src ^ Dst) & (Src ^ Res), NZ = Res & $FFFF
CMP_ASM = """  PcOutM()
  MMSrcWord()
  ASM Uses Op, Res, FlagNZ
    and.w r0, r8, #0x38
    cmp r0, #0
    bne __cmpm_mem
    and.w r0, r8, #7
    lsls r0, r0, #2
    ldr r1, =global_reg
    ldr r0, [r1, r0]
    b __cmpm_have
__cmpm_mem:
    and.w r0, r8, #0x3f
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
    bl __rdw
__cmpm_have:
    ldr r2, =global_dst
    str r0, [r2]
    ldr r1, =global_src
    ldr r1, [r1]
    subs r2, r1, r0
    mov r10, r2
    ldr r3, =global_flagc
    str r2, [r3]
    eors r0, r1
    eors r1, r2
    ands r0, r1
    ldr r3, =global_flagv
    str r0, [r3]
    uxth r4, r2
  EndASM
  NextSyncedM()
"""

TST_ASM = """  PcOutM()
  ASM Uses Op, FlagNZ
    and.w r0, r8, #0x38
    cmp r0, #0
    bne __tstm_mem
    and.w r0, r8, #7
    lsls r0, r0, #2
    ldr r1, =global_reg
    ldr r4, [r1, r0]
    b __tstm_flags
__tstm_mem:
    and.w r0, r8, #0x3f
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
    bl __rdw
    movs r4, r0
__tstm_flags:
    movs r0, #0
    ldr r1, =global_flagv
    str r0, [r1]
    ldr r1, =global_flagc
    str r0, [r1]
  EndASM
  NextSyncedM()
"""

# INC and DEC: Dst +/- 1 to the register or back through __wrw; V when Dst was
# $7FFF (INC) or $8000 (DEC); NZ = Res; C untouched
INCDEC_ASM = """  PcOutM()
  ASM Uses Op, Res, FlagNZ
    and.w r0, r8, #0x38
    cmp r0, #0
    bne __%(l)sm_mem
    and.w r0, r8, #7
    lsls r0, r0, #2
    ldr r1, =global_reg
    adds r1, r1, r0
    ldr r0, [r1]
    %(op)s r2, r0, #1
    uxth r2, r2
    str r2, [r1]
    b __%(l)sm_flags
__%(l)sm_mem:
    and.w r0, r8, #0x3f
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
    bl __rdw
    %(op)s r2, r0, #1
    uxth r2, r2
    ldr r1, =global_dst
    str r0, [r1]
    mov r10, r2
    ldr r0, =global_ea
    ldr r0, [r0]
    movs r1, r2
    bl __wrw
    ldr r0, =global_dst
    ldr r0, [r0]
    mov r2, r10
__%(l)sm_flags:
    ldr r1, =global_dst
    str r0, [r1]
    mov r10, r2
    movs r4, r2
    movs r1, #0
    ldr r3, =%(v)s
    cmp r0, r3
    bne __%(l)sm_nov
    mov.w r1, #0x8000
__%(l)sm_nov:
    ldr r3, =global_flagv
    str r1, [r3]
  EndASM
  NextSyncedM()
"""

# SXT: Res = $FFFF when N, else 0, to the register or through __wrw; then
# SetNZ(N, 1 - N): N leaves $8000, not N leaves 0; V = 0; C untouched
SXT_ASM = """  PcOutM()
  ASM Uses Op, Res, FlagNZ
    movs r2, #0
    ldr r0, =0x18000
    tst r4, r0
    beq __sxtm_res
    ldr r2, =0xffff
__sxtm_res:
    mov r10, r2
    and.w r0, r8, #0x38
    cmp r0, #0
    bne __sxtm_mem
    and.w r0, r8, #7
    lsls r0, r0, #2
    ldr r1, =global_reg
    str r2, [r1, r0]
    b __sxtm_done
__sxtm_mem:
    and.w r0, r8, #0x3f
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
    mov r1, r10
    bl __wrw
__sxtm_done:
    movs r4, #0
    mov r2, r10
    cmp r2, #0
    beq __sxtm_nz
    mov.w r4, #0x8000
__sxtm_nz:
    movs r0, #0
    ldr r1, =global_flagv
    str r0, [r1]
  EndASM
  NextSyncedM()
"""
# MFPI / MFPD and MTPI / MTPD: the memory operand in assembly, in the PREVIOUS
# mode's space (PrvBase, plus 8 for the D space when bit 15 is set: MFPD, MTPD)
# - __eaw forms the address in the current mode, EaBase is pointed at the
# previous mode's entries, and __rdw / __wrw go through that window (or on to
# MmuReadWord / MmuWriteWord). MFPI pushes with __pushm unless the read aborted
# (V6's fuword relies on nothing being pushed); MTPI pops with __popm first, as
# the plain handler does. A register operand (and the previous mode's SP)
# stays in Basic. 2026-10-23: the kernel's copyin, copyout, fuword and suword
# are MFPI/MTPI - 5.7% of a compile's time in the plain handlers.
MFPI_ASM = """  PcOutM()
  If (Op & $38) = 0
    Src = Reg(Op & 7)
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      Src = ModeSp((PswHigh >> 12) & 3)
    EndIf
    PushM(Src)
  Else
    ASM Uses Op
      and.w r0, r8, #0x3f
      bl __eaw
      ldr r1, =global_ea
      str r0, [r1]
      ldr r1, =global_prvbase
      ldr r1, [r1]
      ubfx r2, r8, #15, #1
      add.w r1, r1, r2, lsl #3
      ldr r2, =global_eabase
      str r1, [r2]
      bl __rdw
      ldr r1, =global_src
      str r0, [r1]
      ldr r1, =global_trapvector
      ldr r1, [r1]
      cmp r1, #0
      bne __mfpim_nopush
      bl __pushm
__mfpim_nopush:
    EndASM
  EndIf
  FlagNZ = Src
  FlagV = 0
  NextSyncedM()
"""

MTPI_ASM = """  PcOutM()
  ASM
    bl __popm
    ldr r1, =global_src
    str r0, [r1]
  EndASM
  If (Op & $38) = 0
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      SetModeSp((PswHigh >> 12) & 3, Src)
    Else
      Reg(Op & 7) = Src
    EndIf
  Else
    ASM Uses Op
      and.w r0, r8, #0x3f
      bl __eaw
      ldr r1, =global_ea
      str r0, [r1]
      ldr r1, =global_prvbase
      ldr r1, [r1]
      ubfx r2, r8, #15, #1
      add.w r1, r1, r2, lsl #3
      ldr r2, =global_eabase
      str r1, [r2]
      ldr r1, =global_src
      ldr r1, [r1]
      bl __wrw
    EndASM
  EndIf
  FlagNZ = Src
  FlagV = 0
  NextSyncedM()
"""
# MOV's general handler (the mode pairs MOV_PAIRS does not specialise): the
# source from a register or through __eaw and __rdw, the destination to a
# register or through __eaw and __wrw - CMP's shape. As the plain handler, a
# source read that aborts still goes on to the destination (the trap is taken
# at the tail), and N and Z are set last: a destination write that aborts saves
# the PSW as it was (asm_check caught the earlier order). 2026-10-23: 4.0% of od's and a compile's time, on average.
MOV_ASM = """  PcOutM()
  ASM Uses Op, FlagNZ
    and.w r0, r8, #0xe00
    cmp r0, #0
    bne __movm_smem
    ubfx r0, r8, #6, #3
    lsls r0, r0, #2
    ldr r1, =global_reg
    ldr r0, [r1, r0]
    b __movm_shave
__movm_smem:
    ubfx r0, r8, #6, #6
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
    bl __rdw
__movm_shave:
    ldr r1, =global_src
    str r0, [r1]
    and.w r1, r8, #0x38
    cmp r1, #0
    bne __movm_dmem
    and.w r1, r8, #7
    lsls r1, r1, #2
    ldr r2, =global_reg
    str r0, [r2, r1]
    b __movm_done
__movm_dmem:
    and.w r0, r8, #0x3f
    bl __eaw
    ldr r1, =global_ea
    str r0, [r1]
    ldr r1, =global_src
    ldr r1, [r1]
    bl __wrw
__movm_done:
    ldr r1, =global_src
    ldr r4, [r1]
    movs r0, #0
    ldr r1, =global_flagv
    str r0, [r1]
  EndASM
  NextSyncedM()
"""
OPS = ["JSR_004", "RTS_00020", "DIV_071", "CMP_02", "TST_0057", "INC_0052", "DEC_0053", "SXT_0067",
       "MFPI_0065", "MTPI_0066", "MOV_01"]


def handler(text, name):
    """The plain handler's lines after its label, up to and including its NextSyncedM()."""
    lab = "\nInstruction%sM:" % name
    if text.count(lab) != 1:
        fail("pico2_ops: Instruction%sM is not there once; teach tools/mmu_gen.py." % name)
    i = text.index("\n", text.index(lab) + 1) + 1
    j = text.index("  NextSyncedM()\n", i) + len("  NextSyncedM()\n")
    return i, j


def pico2_ops(text):
    """The Pico 2's file: __pushm/__popm after __eaw, and the assembly JSR, RTS, DIV."""
    at = "__eaw_slow:\n    mov r0, r12\n    ldr r1, =global_easpec\n    str r0, [r1]\n    b eawordm\n  EndASM\nCompilerEndIf\n"
    if text.count(at) != 1:
        fail("pico2_ops: __eaw's end moved; teach tools/mmu_gen.py.")
    no_scaled_index(ASM_STACK + JSR_ASM + RTS_ASM + DIV_ASM + ASM_RW + CMP_ASM + TST_ASM + INCDEC_ASM + SXT_ASM
                    + MFPI_ASM + MTPI_ASM + MOV_ASM, "ASM_STACK")
    no_scaled_index(ASM_EAB, "__eab")
    text = text.replace(at, at + "CompilerIf #ASM_OPS = 1\n  ASM\n" + ASM_STACK + ASM_RW + "  EndASM\nCompilerEndIf\n"
                        + "CompilerIf #ASM_EA = 1\n  ASM\n" + ASM_EAB + "  EndASM\nCompilerEndIf\n")
    out, n = [], 0
    for line in text.split("\n"):
        if line.strip() == "Ea = EaByteM(Op & $3F)":
            ind = line[:len(line) - len(line.lstrip())]
            out.append("\n".join(l if l.startswith("Compiler") else ind + l
                                 for l in EAB_CALL.rstrip("\n").split("\n")))
            n += 1
        else:
            out.append(line)
    if n < 20:
        fail("pico2_ops: only " + str(n) + " EaByteM call sites found; teach tools/mmu_gen.py.")
    text = "\n".join(out)
    for name in OPS:
        i, j = handler(text, name)
        plain = text[i:j]
        if name.startswith("DIV"):
            a = plain.index("  Src = Src - ((Src & $8000) << 1)\n")
            b = plain.index("  ; ClockCycles")
            fast = plain[:a] + DIV_ASM + plain[b:]
        elif name.startswith("JSR"):
            fast = JSR_ASM
        elif name.startswith("RTS"):
            fast = RTS_ASM
        elif name.startswith("CMP"):
            fast = CMP_ASM
        elif name.startswith("TST"):
            fast = TST_ASM
        elif name.startswith("INC"):
            fast = INCDEC_ASM % {"l": "inc", "op": "adds", "v": "0x7fff"}
        elif name.startswith("DEC"):
            fast = INCDEC_ASM % {"l": "dec", "op": "subs", "v": "0x8000"}
        elif name.startswith("MFPI"):
            fast = MFPI_ASM
        elif name.startswith("MTPI"):
            fast = MTPI_ASM
        elif name == "MOV_01":
            fast = MOV_ASM
        else:
            fast = SXT_ASM
        text = (text[:i] + "CompilerIf #ASM_OPS = 1\n" + fast + "CompilerEndIf\n"
                + "Instruction%sRefM:         ; the plain version: the reference (asm_check.pico2)\n" % name
                + plain + text[j:])
    jmp = "    Reg(7) = EaWordM(Op & $3F)\n"
    if text.count(jmp) != 1:
        fail("pico2_ops: JMP's EaWordM line moved; teach tools/mmu_gen.py.")
    text = text.replace(jmp, JMP_ASM + jmp + "CompilerEndIf\n")
    fill = "".join("  OpAsmM(%d) = ?Instruction%sM\n  OpRefM(%d) = ?Instruction%sRefM\n" % (k, n, k, n)
                   for k, n in enumerate(OPS))
    if text.count("  OpTableReadyM = 1\n") != 1:
        fail("pico2_ops: the table's end moved; teach tools/mmu_gen.py.")
    text = text.replace("  OpTableReadyM = 1\n", fill + "  OpTableReadyM = 1\n")
    decl = "Global Dim OpTableM.Label(8192)\n"
    return text.replace(decl, decl + "Global Dim OpAsmM.Label(%d)                 ; JSR, RTS, DIV: the assembly "
                        "entry ...\nGlobal Dim OpRefM.Label(%d)                 ; ... and the plain one "
                        "(tools/mmu_gen.py, pico2_ops)\n" % (len(OPS), len(OPS)))


def specialise(text):
    """The Pico 2's file: MOV handlers for MOV_PAIRS, and their table entries."""
    if NATIVE_EVEN:
        text = native_even(text)
    if not MOV_PAIRS:
        return text
    hs, fill = "", "  ; ---- MOV by addressing mode (tools/mmu_gen.py, MOV_PAIRS) ----\n"
    for sm, dm in MOV_PAIRS:
        name = "InstructionMOV_01_M%d%dM" % (sm, dm)
        if sm == 0:
            # a register source is read AFTER the destination's address is worked out
            # (instructions.pico, REGISTER SOURCE, MEMORY DESTINATION): before the one store
            if DST_CODE[dm].count("  MMWriteWordE(") != 1:
                fail("specialise: destination mode %d stores in more than one place; a register "
                     "source cannot be placed before 'the' store. Teach tools/mmu_gen.py." % dm)
            k = DST_CODE[dm].index("  MMWriteWordE(")
            body = DST_CODE[dm][:k] + SRC_CODE[0] + DST_CODE[dm][k:]
        else:
            body = SRC_CODE[sm] + DST_CODE[dm]
        ref = name[:-1] + "RefM"
        hs += ("%s:            ; MOV, source mode %d, destination mode %d\n" % (name, sm, dm)
               + "CompilerIf #ASM_MOV = 1\n  ASM Uses PC, RunLeft, Op, FlagNZ\n" + asm_mov(sm, dm, ref)
               + "  EndASM\nCompilerEndIf\n"
               + "%s:         ; the plain version: the fast path's slow path and its reference\n  PcOutM()\n" % ref
               + body + "  FlagNZ = Src\n  FlagV = 0\n  NextSyncedM()\n\n")
        regs = range(7) if sm == 2 else range(8)          # (R7)+ is an immediate: the general handler
        for sr in regs:
            fill += "  OpTableM($%04X) = ?%s\n" % (0x200 | sm << 6 | sr << 3 | dm, name)
        k = MOV_PAIRS.index((sm, dm))
        fill += "  MovAsmM(%d) = ?%s\n  MovRefM(%d) = ?%s\n" % (k, name, k, ref)
    mark = "\n; ======================================================================\n;  THE TABLE - filled"
    if text.count(mark) != 1 or text.count("  OpTableReadyM = 1\n") != 1:
        fail("specialise: the mapped file's table section moved; teach tools/mmu_gen.py.")
    text = text.replace(mark, "\n" + hs.rstrip("\n") + "\n" + mark)
    # each handler's two entry points, for asm_check.pico2 (it points the
    # table at one or the other); filled with the table, read by nothing else
    decl = "Global Dim OpTableM.Label(8192)\n"
    if text.count(decl) != 1:
        fail("specialise: the mapped table's declaration moved; teach tools/mmu_gen.py.")
    text = text.replace(decl, decl + "Global Dim MovAsmM.Label(%d)                ; the MOV handlers by mode: the "
                        "assembly entry ...\nGlobal Dim MovRefM.Label(%d)                ; ... and the plain one "
                        "(tools/mmu_gen.py, asm_mov)\n" % (len(MOV_PAIRS), len(MOV_PAIRS)))
    return text.replace("  OpTableReadyM = 1\n", fill + "  OpTableReadyM = 1\n")


def main():
    body = generate()
    bad = []
    for path, name, src_name in OUTS:
        text = header(name, src_name) + body
        if name.endswith(".pico2"):          # the Pico 2: V6 runs here - SRAM (55 KB fits beside its tables)
            text = text.replace("\nProcedure.i CpuRunM(n.i)\n", "\nProcedureRAM.i CpuRunM(n.i)\n", 1)
            text = specialise(text)
            text = pico2_tails(text)
            text = pico2_eaw(text)
            text = pico2_ops(text)
        else:                                # the Pico: its SRAM holds CpuRun (Mini-Unix); CpuRunM stays in flash
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
