#!/usr/bin/env python3
"""desktop_gen.py - write the desktop PDP-11's core (desktop/gen/core.pbi) from
the Pico 2's own sources, so the board and the PC run the same machine.

    python desktop/tools/desktop_gen.py           writes desktop/gen/core.pbi
    python desktop/tools/desktop_gen.py --check   changes nothing; fails if the
                                                  file is not what it would write

WHY A GENERATOR. The emulator is written in PureMetal for the RP2350
(J11_18MHz_KDJ11_BF/pico2). The desktop program is PureBasic with its C back
end. The two languages are the same BASIC but for a handful of things the
board needs and the PC does not, so the desktop core is WRITTEN from the
board's files - the same handlers, line for line - with only these changes,
each an exact rewrite that must match (a source change that breaks one stops
this tool rather than producing a different machine):

  * The Arm assembly goes: every ASM ... EndASM block is dropped and the
    #ASM_ switches are 0, so each handler runs its plain version - the one
    asm_check.pico2 holds the assembly to on the board.
  * ProcedureRAM (the board's "run from SRAM") is Procedure.
  * THE WORD SIZE. A PureMetal .i is 32 bits; a PureBasic .i on x64 is 64.
    Every .i in the core becomes .l, so every store wraps exactly as on the
    board. PureBasic still works out expressions in 64 bits, so the two
    places that use an UNSTORED 32-bit result are rewritten (BranchTo's sign
    extension, the FPU's unsigned compare). A COMPARISON is the other way
    round: with .l operands it is made in 32 bits even when a 64-bit mask is
    inside it (Bool((a & $FFFFFFFF) < ...) compared signed), so the unsigned
    compare goes through quad variables. The holders of HOST addresses
    stay 64-bit: MapHost, Fw, FwSave and the locals of the procedures that
    use them.
  * THE DISPATCH. The board jumps through a table of labels
    ("Goto OpTable(Op >> 3)"); PureBasic has no computed goto, but its C back
    end passes a "!" line through, and ?Label inside a procedure is the C
    label's address. So the table is an integer array of ?Label values,
    filled where the board fills it, and the jump is a C computed goto -
    about 20% faster on the PC than a table of procedure pointers
    (desktop/bench, 133 against 111 million dispatches a second).
  * Core procedures named like PureBasic commands (ReadWord, WriteWord,
    ReadByte, WriteByte: the File library) are renamed Pdp... throughout,
    and a local named step (PureBasic's Step) stepv.
  * The memory past 248 KB: on a board it is in the PSRAM (#PSRAM = 1, which
    also brings the RP11's flash storage); here cpu.pico2's and rk11.pico2's
    memory blocks answer to #DESK_MEM and the window #PS_MEM is PsMem, a
    buffer (machine.pbi), so V7's 2 MB runs as on the Pico Plus 2.
  * Declare lines for every procedure (PureBasic, unlike PureMetal, wants a
    procedure declared before a call that comes first).

Left out, and supplied by the desktop machine layer (desktop/machine*.pbi):
the board's disk storage (disk.pico2, psram_pdp11.pico2, store.pico2 - the
PC reads the same image files instead), and the RP11's storage half (inside
rp11.pico2's CompilerIf #PSRAM = 1, which the desktop build leaves off).
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.normpath(os.path.join(HERE, "..", ".."))
SRC = os.path.join(REPO, "J11_18MHz_KDJ11_BF", "pico2")
OUT = os.path.join(REPO, "desktop", "gen", "core.pbi")

# The board's include order (diag.pico2), and where the machine layer's disk
# goes in (disk.pico2's place).
FILES = ["cpu.pico2", "fp11.pico2", "instructions_mmu.pico2", "instructions.pico2",
         "@disk", "kw11.pico2", "rk11.pico2", "rp11.pico2"]
# Host addresses stay 64-bit: the fast windows' memory (MapHost), the fetch
# window (Fw, FwSave), the FPU's operand in a window (FrwA), and the label tables with the parameter that fills
# them (a label's address is a host address).
KEEP_I = {"MapHost", "Fw", "FwSave", "FrwA", "OpTable", "OpTableM", "OpAsmM", "OpRefM", "target"}
# Core procedures whose names are PureBasic commands (the File library): renamed
# everywhere, consistently.
RENAME = {"ReadWord": "PdpReadWord", "WriteWord": "PdpWriteWord", "ReadByte": "PdpReadByte",
          "WriteByte": "PdpWriteByte",
          "step": "stepv"}       # a local named like PureBasic's Step keyword (case-sensitive: the keyword is Step)
KEEP_PROC_IF = re.compile(r"\bMapHost\b|\bFw\(|\bFwSave\(|@")   # a procedure using one keeps its .i


def fail(msg):
    sys.exit("desktop_gen: " + msg)


def drop_asm(text, name):
    out, inasm, n = [], False, 0
    for line in text.split("\n"):
        t = line.strip()
        if not inasm and re.match(r"^ASM(\s|$)", t):
            inasm, n = True, n + 1
            continue
        if inasm:
            if t.startswith("EndASM"):
                inasm = False
            continue
        out.append(line)
    if inasm:
        fail(name + ": an ASM block has no EndASM")
    return "\n".join(out), n


def exact(text, old, new, name, count=None):
    k = text.count(old)
    if k == 0 or (count is not None and k != count):
        fail("%s: %r is there %d times; teach desktop/tools/desktop_gen.py." % (name, old[:60], k))
    return text.replace(old, new)


def retype(text):
    """.i -> .l, procedure by procedure (KEEP_PROC_IF keeps a procedure's .i)."""
    out, keep = [], False
    lines = text.split("\n")
    # find each procedure's extent once, to decide keep for its lines
    i = 0
    while i < len(lines):
        line = lines[i]
        m = re.match(r"^\s*Procedure(\.\w+)?\s+(\w+)\s*\(", line)
        if m:
            j = i
            while j < len(lines) and not re.match(r"^\s*EndProcedure\b", lines[j]):
                j += 1
            body = "\n".join(l.split(";")[0] for l in lines[i:j + 1])
            keep = bool(KEEP_PROC_IF.search(body)) and m.group(2) not in ("CpuRun", "CpuRunM")
            for l in lines[i:j + 1]:
                out.append(l if keep else conv(l))
            i = j + 1
            continue
        out.append(conv(line))
        i += 1
    return "\n".join(out)


def conv(line):
    code, sep, comment = line.partition(";")
    def r(m):
        return m.group(0) if m.group(1) in KEEP_I else m.group(1) + ".l"
    code = re.sub(r"\b([A-Za-z_]\w*)\.i\b", r, code)
    code = re.sub(r"\bProcedure\.i\b", "Procedure.l", code)
    return code + sep + comment


def transform(name, text):
    text, nasm = drop_asm(text, name)
    text = re.sub(r"\bProcedureRAM\b", "Procedure", text)
    for a, b in RENAME.items():
        text = re.sub(r"\b%s\b" % a, b, text)
    text = re.sub(r"\.Label\b", ".i", text)
    text = re.sub(r"(?m)^(#ASM_\w+\s*=\s*)1\b", r"\g<1>0", text)
    text = re.sub(r"(?m)^(#RESERVE_REGISTERS\s*=\s*)1\b", r"\g<1>0", text)   # PureMetal's register pinning
    text = re.sub(r"(?m)^\s*ReserveRegister\b.*$", "", text)
    text = re.sub(r"(?m)^\s*XIncludeFile\b.*$", "", text)
    if name in ("instructions.pico2", "instructions_mmu.pico2"):
        tab = "optablem" if name == "instructions_mmu.pico2" else "optable"
        lab = "OpTableM" if tab == "optablem" else "OpTable"
        text = exact(text, "Goto %s(Op >> 3)" % lab,
                     "! goto *(void*)((integer*)a_%s.a)[g_op >> 3];" % tab, name)
        text = exact(text, "((Op << 24) >> 23)", "((Op << 56) >> 55)", name)
    if name in ("cpu.pico2", "rk11.pico2"):
        # THE MEMORY PAST 248 KB. On a board it is in the PSRAM, under #PSRAM = 1,
        # which also brings the RP11's flash storage (rp11.pico2) that the PC
        # replaces; so here the memory blocks answer to #DESK_MEM instead, and
        # the PSRAM's window (#PS_MEM, a fixed address on the board) is PsMem,
        # a buffer machine.pbi allocates. #RAM_BYTES stays #PSRAM's choice.
        text, k = re.subn(r"CompilerIf #PS_MEM_UNCACHED = 1\n#PS_MEM = [^\n]*\nCompilerElse\n#PS_MEM = [^\n]*\nCompilerEndIf\n",
                          "", text)
        if name == "cpu.pico2" and k != 1:
            fail("cpu.pico2: the #PS_MEM definitions are not where they were; teach desktop/tools/desktop_gen.py.")
        text = re.sub(r"#PS_MEM\b", "PsMem", text)
        text, k = re.subn(r"CompilerIf #PSRAM = 1(?!\s*\n#RAM_BYTES)", "CompilerIf #DESK_MEM = 1", text)
        if k == 0:
            fail(name + ": no CompilerIf #PSRAM = 1 to give #DESK_MEM; teach desktop/tools/desktop_gen.py.")
    if name == "fp11.pico2":
        text = exact(text, "ProcedureReturn Bool((a ! $80000000) < (b ! $80000000))",
                     "Protected ua.q = a & $FFFFFFFF, ub.q = b & $FFFFFFFF : ProcedureReturn Bool(ua < ub)   ; desktop_gen: unsigned, in quads (a compare of .l operands is 32-bit even with a 64-bit mask in it)",
                     name, 1)
    return retype(text), nasm


def declares(texts):
    seen, out = set(), []
    for t in texts:
        for m in re.finditer(r"(?m)^\s*Procedure(\.\w+)?\s+(\w+)\s*\(([^)]*)\)", t):
            if m.group(2) in seen:
                continue
            seen.add(m.group(2))
            out.append("Declare%s %s(%s)" % (m.group(1) or "", m.group(2), m.group(3)))
    return out


def build():
    parts, texts, report = [], [], []
    for f in FILES:
        if f == "@disk":
            parts.append('XIncludeFile "../machine_disk.pbi"      ; the desktop\'s disk storage (disk.pico2\'s place)\n')
            continue
        src = open(os.path.join(SRC, f), encoding="utf-8", errors="strict").read().replace("\r\n", "\n")
        t, nasm = transform(f, src)
        texts.append(t)
        report.append("%s (%d ASM blocks dropped)" % (f, nasm))
        parts.append("; ======== %s (J11_18MHz_KDJ11_BF/pico2) ========\n%s\n" % (f, t))
    head = ("; desktop/gen/core.pbi - WRITTEN BY desktop/tools/desktop_gen.py from the Pico 2's\n"
            "; sources; do not edit (edit the board's files and run the tool again).\n"
            "; " + "; ".join(report) + "\n\n" + "\n".join(declares(texts)) + "\n\n")
    return head + "".join(parts)


def main():
    text = build()
    if "--check" in sys.argv:
        old = open(OUT, encoding="utf-8").read() if os.path.exists(OUT) else ""
        if old != text:
            fail("desktop/gen/core.pbi is not what the board's sources make now; run the tool.")
        print("desktop_gen: core.pbi is current")
        return
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8", newline="\n").write(text)
    print("desktop_gen: wrote desktop/gen/core.pbi (%d lines)" % text.count("\n"))


if __name__ == "__main__":
    main()
