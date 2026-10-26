#!/usr/bin/env python3
"""asm_mov_gen.py - write the Pico's assembly fast paths into pico/instructions.pico.

    python asm_mov_gen.py            rewrites the generated parts of
                                     J11_18MHz_KDJ11_BF/pico/instructions.pico
    python asm_mov_gen.py --check    changes nothing; fails if the file is not
                                     what this tool would write now

The Pico (RP2040, Cortex-M0+) runs Mini-Unix in the UNMAPPED loop, CpuRun.
A profile of `od /rkmx` on a Pico W (2026-10-19, a SysTick sampler on core
0) put 19% of core 0's time in the seven MOV handlers by addressing mode and
14% in EaWord. This tool gives them Thumb-1 assembly:

  * each MOV handler by mode gets a fast path in front of its Basic body.
    The fast path makes every test the Basic makes before it changes
    anything - the register is not R7 where the Basic would reach Reg(7)
    through a variable, every access is in RAM (below 160000) and even, a
    pushed SP stays at or above 000400 - and if one fails it branches, with
    nothing changed, to the Basic body (the label with "Ref"), which does
    the instruction the slow way. So the Basic is both the slow path and the
    reference: asm_check.pico runs both on random states on the board.
  * __eaw1, a subroutine the handlers reach with bl in place of calling
    EaWord (cpu.pico, EaFast): X(R), -(R), (R)+ and (R) are done there, and
    anything else goes on to EaWord itself.

Both are switched by #ASM_MOV and #ASM_EA in cpu.pico. The generated text
sits between "; ---- ASM (tools/asm_mov_gen.py)" and "; ---- END ASM" lines
and inside the UNMAPPED ONLY blocks tools/mmu_gen.py leaves out, so the
mapped loop is not touched. Run this after changing the MOV handlers' Basic
bodies, and --check before a commit.
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "J11_18MHz_KDJ11_BF", "pico", "instructions.pico")

PAIRS = [(0, 4), (4, 0), (6, 0), (6, 4), (2, 0), (6, 1), (0, 6)]   # the handlers by mode, as in the table
G0 = "; ---- ASM (tools/asm_mov_gen.py) ----\n"
G1 = "; ---- END ASM ----\n"
U0 = "; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----\n"
U1 = "; ---- END UNMAPPED ONLY ----\n"

# the native tail (NextNative, instructions.pico), for the Cortex-M0+
TAIL = """    mov r1, r11
    subs r1, #1
    mov r11, r1
    beq __ul_cpurun_runend
    mov r0, r9
    ldr r1, =#RAM_BYTES
    cmp r0, r1
    bhs __ul_cpurun_slowfetch
    ldr r1, =global_mem
    ldrh r2, [r1, r0]
    mov r8, r2
    adds r0, #2
    mov r9, r0
    lsrs r2, r2, #3
    lsls r2, r2, #2
    ldr r1, =global_optable
    ldr r1, [r1, r2]
    bx r1
"""


def fail(msg):
    sys.stderr.write("asm_mov_gen: " + msg + "\n")
    sys.exit(1)


def mov_asm(sm, dm):
    tag = "__um%d%d_" % (sm, dm)
    bail = "__ul_cpurun_instructionmov_01_m%d%dref" % (sm, dm)
    L = []
    e = L.append

    def ram_even(a, s):
        # a must be in RAM and even, else to the Basic (s is clobbered)
        e("    ldr %s, =#RAM_BYTES" % s)
        e("    cmp %s, %s" % (a, s))
        e("    bhs %s" % bail)
        e("    lsrs %s, %s, #1" % (s, a))
        e("    bcs %s" % bail)

    def rd(out):
        e("    mov %s, r8" % out)
        e("    lsls %s, %s, #29" % (out, out))
        e("    lsrs %s, %s, #29" % (out, out))

    def rs(out):
        e("    mov %s, r8" % out)
        e("    lsls %s, %s, #23" % (out, out))
        e("    lsrs %s, %s, #29" % (out, out))

    def reg_load(out, r, base, s):
        e("    ldr %s, =global_reg" % base)
        e("    lsls %s, %s, #2" % (s, r))
        e("    ldr %s, [%s, %s]" % (out, base, s))

    def indexed(field):
        # r0 = (the word at the PC + the field's register) & $FFFF, the index word read at
        # the PC (r9); r1 = the register number; the PC itself is not moved yet
        e("    mov r2, r9")
        ram_even("r2", "r3")
        e("    ldr r3, =global_mem")
        e("    ldrh r0, [r3, r2]")                 # the index word
        field("r1")
        e("    cmp r1, #7")
        e("    bne %sx1" % tag)
        e("    adds r2, #2")                       # X(PC): the PC after the index word
        e("    b %sx2" % tag)
        e("%sx1:" % tag)
        e("    ldr r3, =global_reg")
        e("    lsls r2, r1, #2")
        e("    ldr r2, [r3, r2]")
        e("%sx2:" % tag)
        e("    adds r0, r0, r2")
        e("    uxth r0, r0")

    # ---- the tests, in the order the Basic makes its accesses ----
    if sm == 6:
        indexed(rs)
        ram_even("r0", "r3")
        e("    ldr r3, =global_mem")
        e("    ldrh r3, [r3, r0]")                 # r3 = Src
        e("    mov r12, r3")
    elif sm == 4:
        rs("r1")
        e("    cmp r1, #7")
        e("    beq %s" % bail)
        reg_load("r0", "r1", "r3", "r2")
        e("    subs r0, #2")
        e("    uxth r0, r0")
        e("    cmp r1, #6")
        e("    bne %ss1" % tag)
        e("    lsrs r3, r0, #8")
        e("    beq %s" % bail)
        e("%ss1:" % tag)
        ram_even("r0", "r3")
        e("    ldr r3, =global_mem")
        e("    ldrh r3, [r3, r0]")
        e("    mov r12, r3")                       # r12 = Src, r0 = the new Rs, r1 = Rs
    elif sm == 2:
        rs("r1")                                   # the table sends only R0-R6 here
        reg_load("r0", "r1", "r3", "r2")
        ram_even("r0", "r3")
        e("    ldr r3, =global_mem")
        e("    ldrh r3, [r3, r0]")
        e("    mov r12, r3")                       # r12 = Src, r0 = the old Rs, r1 = Rs

    if dm == 0:
        rd("r2")
        e("    cmp r2, #7")
        e("    beq %s" % bail)
    elif dm == 1:
        rd("r2")
        e("    cmp r2, #7")
        e("    beq %s" % bail)
        reg_load("r0", "r2", "r3", "r1")
        ram_even("r0", "r3")                       # r0 = the destination address
    elif dm == 4:
        rd("r2")
        e("    cmp r2, #7")
        e("    beq %s" % bail)
        reg_load("r0", "r2", "r3", "r1")
        e("    subs r0, #2")
        e("    uxth r0, r0")
        e("    cmp r2, #6")
        e("    bne %sd1" % tag)
        e("    lsrs r3, r0, #8")
        e("    beq %s" % bail)
        e("%sd1:" % tag)
        ram_even("r0", "r3")                       # r0 = the new Rd, r2 = Rd
    elif dm == 6:
        indexed(rd)
        ram_even("r0", "r3")                       # r0 = the destination address
    if sm == 0:
        # a register source is read AFTER the destination's address is worked out
        # (REGISTER SOURCE, MEMORY DESTINATION): R7 is the PC as it stands then, and
        # a source that is the autodecremented destination register reads its new value
        rs("r3")
        e("    cmp r3, #7")
        e("    bne %sa1" % tag)
        e("    mov r3, r9")
        if dm == 6:
            e("    adds r3, #2")
        e("    b %sa9" % tag)
        e("%sa1:" % tag)
        if dm == 4:
            e("    cmp r3, r2")
            e("    bne %sa2" % tag)
            e("    movs r3, r0")
            e("    b %sa9" % tag)
            e("%sa2:" % tag)
        e("    ldr r1, =global_reg")
        e("    lsls r3, r3, #2")
        e("    ldr r3, [r1, r3]")
        e("%sa9:" % tag)
        e("    mov r12, r3")

    # ---- every test passed: the instruction, as the Basic does it ----
    # r12 = Src
    if dm in (1, 4, 6):
        e("    ldr r1, =global_mem")
        e("    mov r3, r12")
        e("    strh r3, [r1, r0]")
    if dm == 4:
        e("    ldr r1, =global_reg")
        e("    lsls r2, r2, #2")
        e("    str r0, [r1, r2]")
    if sm == 6 or dm == 6:
        e("    mov r1, r9")
        e("    adds r1, #%d" % (4 if sm == 6 and dm == 6 else 2))
        e("    mov r9, r1")
    if sm in (2, 4):
        # the source register moves first, then the destination register is
        # written (they may be the same register)
        e("    ldr r3, =global_reg")
        if sm == 2:
            e("    adds r0, #2")
            e("    uxth r0, r0")
        e("    lsls r1, r1, #2")
        e("    str r0, [r3, r1]")
    if dm == 0:
        e("    ldr r3, =global_reg")
        e("    lsls r2, r2, #2")
        e("    mov r0, r12")
        e("    str r0, [r3, r2]")
    e("    mov r4, r12")                           # FlagNZ = Src
    e("    ldr r1, =global_flagv")
    e("    movs r0, #0")
    e("    str r0, [r1]")
    return "\n".join(L) + "\n" + TAIL


# __eaw1: in r0 = the 6-bit mode and register; out r0 = the address, with EaReg,
# Tmp, Adr and the register left exactly as EaWord leaves them; anything it
# does not do goes on to EaWord itself, called with the spec (lr kept on the
# stack: a far tail branch is not certain on the Cortex-M0+).
EAW1 = """__eaw1:
    mov r12, r0
    movs r1, #7
    ands r1, r0
    ldr r2, =global_eareg
    str r1, [r2]
    lsrs r0, r0, #3
    cmp r0, #6
    bne __eaw1_m4
    ldr r2, =global_reg
    ldr r3, [r2, #28]
    ldr r0, =#RAM_BYTES
    cmp r3, r0
    bhs __eaw1_slow
    lsrs r0, r3, #1
    bcs __eaw1_slow
    ldr r0, =global_adr
    str r3, [r0]
    ldr r0, =global_mem
    ldrh r0, [r0, r3]
    ldr r2, =global_tmp
    str r0, [r2]
    adds r3, #2
    uxth r3, r3
    ldr r2, =global_reg
    str r3, [r2, #28]
    lsls r1, r1, #2
    ldr r1, [r2, r1]
    adds r0, r0, r1
    uxth r0, r0
    bx lr
__eaw1_m4:
    cmp r0, #4
    bne __eaw1_m2
    cmp r1, #7
    beq __eaw1_slow
    ldr r2, =global_reg
    lsls r3, r1, #2
    ldr r0, [r2, r3]
    subs r0, #2
    uxth r0, r0
    cmp r1, #6
    bne __eaw1_m4a
    lsrs r1, r0, #8
    beq __eaw1_slow
__eaw1_m4a:
    str r0, [r2, r3]
    movs r1, #4
    ldr r2, =global_tmp
    str r1, [r2]
    bx lr
__eaw1_m2:
    cmp r0, #2
    bne __eaw1_m1
    ldr r2, =global_reg
    lsls r3, r1, #2
    ldr r0, [r2, r3]
    adds r1, r0, #2
    uxth r1, r1
    str r1, [r2, r3]
    ldr r2, =global_tmp
    str r0, [r2]
    bx lr
__eaw1_m1:
    cmp r0, #1
    bne __eaw1_slow
    ldr r2, =global_tmp
    str r0, [r2]
    ldr r2, =global_reg
    lsls r1, r1, #2
    ldr r0, [r2, r1]
    bx lr
__eaw1_slow:
    mov r0, r12
    ldr r1, =global_easpec
    str r0, [r1]
    push {lr}
    bl eaword
    pop {pc}
"""


# Byte auto modes use a one-byte step except through SP/PC. All other
# modes use __eaw1 directly, retaining its checked indexed/deferred fallback.
EAB1 = """__eab1:
    mov r12, r0
    movs r1, #7
    ands r1, r0
    movs r2, #1
    cmp r1, #6
    blo __eab1_step
    movs r2, #2
__eab1_step:
    ldr r3, =global_eastep
    str r2, [r3]
    lsrs r3, r0, #3
    cmp r3, #2
    beq __eab1_inc
    cmp r3, #4
    beq __eab1_dec
    b __eaw1
__eab1_inc:
    ldr r3, =global_eareg
    str r1, [r3]
    lsls r1, r1, #2
    ldr r3, =global_reg
    ldr r0, [r3, r1]
    adds r2, r0, r2
    uxth r2, r2
    str r2, [r3, r1]
    ldr r3, =global_tmp
    str r0, [r3]
    bx lr
__eab1_dec:
    cmp r1, #7
    beq __eab1_slow
    lsls r1, r1, #2
    ldr r3, =global_reg
    ldr r0, [r3, r1]
    subs r0, r0, r2
    uxth r0, r0
    cmp r1, #24
    bne __eab1_commit
    lsrs r2, r0, #8
    beq __eab1_slow
__eab1_commit:
    str r0, [r3, r1]
    lsrs r1, r1, #2
    ldr r3, =global_eareg
    str r1, [r3]
    movs r1, #4
    ldr r3, =global_tmp
    str r1, [r3]
    bx lr
__eab1_slow:
    mov r0, r12
    ldr r1, =global_easpec
    str r0, [r1]
    push {lr}
    bl eabyte
    pop {pc}
"""


def strip_generated(s):
    while U0 + G0 in s:                            # __eaw1's block, with its UNMAPPED ONLY lines
        i = s.index(U0 + G0)
        s = s[:i] + s[s.index(G1 + U1, i) + len(G1 + U1):]
    while G0 in s:
        i = s.index(G0)
        s = s[:i] + s[s.index(G1, i) + len(G1):]
    return s


def build(s):
    s = strip_generated(s)
    for sm, dm in PAIRS:
        lab = "InstructionMOV_01_M%d%d:" % (sm, dm)
        if s.count("\n" + lab) != 1:
            fail("the handler %s is not in instructions.pico once." % lab)
        i = s.index("\n" + lab) + 1
        j = s.index("\n", i) + 1
        gen = (G0 + "CompilerIf #ASM_MOV = 1\n  ASM Uses PC, RunLeft, Op, FlagNZ\n" + mov_asm(sm, dm)
               + "  EndASM\nCompilerEndIf\n"
               + "InstructionMOV_01_M%d%dRef:         ; the plain version: the fast path's slow path and its reference\n"
               % (sm, dm) + G1)
        s = s[:j] + gen + s[j:]
    # __eaw1, after the slow fetch (reached only by bl), left out of the mapped loop
    at = "                                         ; 1983, model differences 28 and 30)\n  Goto OpTable(Op >> 3)\n"
    if s.count(at) != 1:
        fail("the slow fetch's end moved; teach tools/asm_mov_gen.py.")
    s = s.replace(at, at + U0 + G0 + "CompilerIf #ASM_EA = 1\n  ASM\n" + EAW1 + EAB1 + "  EndASM\nCompilerEndIf\n" + G1 + U1)
    # each handler's two entry points, for asm_check.pico
    at = "; ---- MOV ENTRY POINTS ----\n"
    if s.count(at) != 1:
        fail("the table's end moved; teach tools/asm_mov_gen.py.")
    fill = "".join("  MovAsm(%d) = ?InstructionMOV_01_M%d%d\n  MovRef(%d) = ?InstructionMOV_01_M%d%dRef\n"
                   % (k, sm, dm, k, sm, dm) for k, (sm, dm) in enumerate(PAIRS))
    s = s.replace(at, G0 + fill + G1 + at)
    return s


def main():
    raw = open(SRC, "rb").read().decode("ascii")
    crlf = "\r\n" in raw
    have = raw.replace("\r\n", "\n")
    want = build(have)
    if "--check" in sys.argv:
        if want != have:
            fail("pico/instructions.pico is out of date. Run tools/asm_mov_gen.py.")
        print("asm_mov_gen: pico/instructions.pico is current")
        return
    out = want.replace("\n", "\r\n") if crlf else want
    open(SRC, "wb").write(out.encode("ascii"))
    print("asm_mov_gen: wrote pico/instructions.pico")


if __name__ == "__main__":
    main()
