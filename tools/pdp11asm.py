#!/usr/bin/env python3
"""pdp11asm.py - a small two-pass PDP-11 assembler, enough for the desk
test programs the RK11/KW11-L proof runs (tools/rk11_model.py). Not a
MACRO-11: one statement per line, numbers octal unless they end in '.',
character constants 'c, labels 'name:', local labels are just labels.

Operands: Rn SP PC, (Rn), (Rn)+, -(Rn), @(Rn)+, @-(Rn), X(Rn), @X(Rn),
#n, @#n, name (PC-relative), @name. n and X may be a label, a number,
'c, or label+n / label-n.

Directives: .=addr  .word a,b,...  .blkw n  .ascii /text/ (packed bytes)
            .even
Output: absolute-format paper tape bytes (the Absolute Loader's format,
DEC-11-UABLB), or the words by address.
"""
import re

REGS = {"R0": 0, "R1": 1, "R2": 2, "R3": 3, "R4": 4, "R5": 5, "R6": 6, "SP": 6, "R7": 7, "PC": 7}

DOUBLE = {"MOV": 0o010000, "CMP": 0o020000, "BIT": 0o030000, "BIC": 0o040000,
          "BIS": 0o050000, "ADD": 0o060000, "SUB": 0o160000,
          "MOVB": 0o110000, "CMPB": 0o120000, "BITB": 0o130000, "BICB": 0o140000, "BISB": 0o150000}
SINGLE = {"CLR": 0o005000, "COM": 0o005100, "INC": 0o005200, "DEC": 0o005300, "NEG": 0o005400,
          "ADC": 0o005500, "SBC": 0o005600, "TST": 0o005700, "ROR": 0o006000, "ROL": 0o006100,
          "ASR": 0o006200, "ASL": 0o006300, "JMP": 0o000100, "SWAB": 0o000300, "MTPS": 0o106400,
          "MFPS": 0o106700, "MFPI": 0o006500, "MTPI": 0o006600, "MFPD": 0o106500, "MTPD": 0o106600, "CLRB": 0o105000, "TSTB": 0o105700, "INCB": 0o105200, "SXT": 0o006700}
BRANCH = {"BR": 0o000400, "BNE": 0o001000, "BEQ": 0o001400, "BGE": 0o002000, "BLT": 0o002400,
          "BGT": 0o003000, "BLE": 0o003400, "BPL": 0o100000, "BMI": 0o100400, "BHI": 0o101000,
          "BLOS": 0o101400, "BLO": 0o103400, "BHIS": 0o103000, "BVC": 0o102000, "BVS": 0o102400, "BCC": 0o103000, "BCS": 0o103400}
NONE = {"HALT": 0, "WAIT": 1, "RTI": 2, "BPT": 3, "IOT": 4, "RESET": 5, "RTT": 6, "NOP": 0o240}


class AsmError(Exception):
    pass


class Asm:
    def __init__(self, text):
        self.lines = text.splitlines()
        self.sym = {}
        self.scope = ""

    def value(self, e, final):
        e = e.strip()
        m = re.match(r"^(.*?)([+-])([^+-]+)$", e)
        if m and m.group(1).strip():
            a = self.value(m.group(1), final)
            b = self.value(m.group(3), final)
            return (a + b if m.group(2) == "+" else a - b) & 0xFFFF
        if e.startswith("-"):
            return (-self.value(e[1:], final)) & 0xFFFF
        if e.startswith("'"):
            return ord(e[1])
        if re.match(r"^[0-9]+\.$", e):
            return int(e[:-1]) & 0xFFFF
        if re.match(r"^[0-7]+$", e):
            return int(e, 8) & 0xFFFF
        if e.endswith("$"):                    # a local label: scoped to the last plain one
            e = self.scope + ":" + e
        if e in self.sym:
            return self.sym[e]
        if final:
            raise AsmError("undefined symbol %r" % e)
        return 0

    def operand(self, op, final, pc_after_word):
        """Return (six-bit mode/register field, extra word or None).
        pc_after_word(n) is the address after the n-th extra word."""
        op = op.strip()
        u = op.upper()
        if u in REGS:
            return REGS[u], None
        m = re.match(r"^(@?)\((\w+)\)(\+?)$", op)
        if m and m.group(2).upper() in REGS:
            r = REGS[m.group(2).upper()]
            if m.group(3):
                return ((3 if m.group(1) else 2) << 3) | r, None
            if m.group(1):
                return (7 << 3) | r, ("idx", 0)
            return (1 << 3) | r, None
        m = re.match(r"^(@?)-\((\w+)\)$", op)
        if m:
            return ((5 if m.group(1) else 4) << 3) | REGS[m.group(2).upper()], None
        if op.startswith("#"):
            return 0o27, ("abs", self.value(op[1:], final))
        if op.startswith("@#"):
            return 0o37, ("abs", self.value(op[2:], final))
        m = re.match(r"^(@?)(.+)\((\w+)\)$", op)
        if m and m.group(3).upper() in REGS:
            return ((7 if m.group(1) else 6) << 3) | REGS[m.group(3).upper()], ("abs", self.value(m.group(2), final))
        if op.startswith("@"):
            return 0o77, ("rel", self.value(op[1:], final))
        return 0o67, ("rel", self.value(op, final))

    def assemble(self):
        for final in (False, True):
            self.words = {}
            self.scope = ""
            pc = 0
            for n, raw in enumerate(self.lines, 1):
                line = re.sub(r"(?<!');.*$", "", raw).rstrip()
                if not line.strip():
                    continue
                try:
                    pc = self.statement(line, pc, final)
                except AsmError as e:
                    raise AsmError("line %d: %s: %s" % (n, raw.strip(), e))
        return self.words

    def emit(self, pc, w):
        self.words[pc] = w & 0xFFFF
        return pc + 2

    def statement(self, line, pc, final):
        m = re.match(r"^\s*([\w$]+):(.*)$", line)
        if m:
            name = m.group(1)
            if name.endswith("$"):
                name = self.scope + ":" + name
            else:
                self.scope = name
            if not final:
                self.sym[name] = pc
            line = m.group(2)
            if not line.strip():
                return pc
        s = line.strip()
        if s.startswith(".="):
            return self.value(s[2:], True)
        m = re.match(r"^(\w+)\s*=\s*(.+)$", s)
        if m:
            self.sym[m.group(1)] = self.value(m.group(2), final)
            return pc
        parts = s.split(None, 1)
        mn = parts[0].upper()
        args = parts[1] if len(parts) > 1 else ""
        if mn == ".WORD":
            for a in args.split(","):
                pc = self.emit(pc, self.value(a, final))
            return pc
        if mn == ".BLKW":
            for _ in range(self.value(args, True)):
                pc = self.emit(pc, 0)
            return pc
        if mn == ".EVEN":
            return (pc + 1) & ~1
        if mn == ".ASCII":
            d = args.strip()
            text = d[1:d.index(d[0], 1)]
            data = bytes(text, "ascii").decode("unicode_escape").encode("latin-1")
            for i in range(0, len(data), 2):
                lo = data[i]
                hi = data[i + 1] if i + 1 < len(data) else 0
                pc = self.emit(pc, lo | (hi << 8))
            return pc
        ops = [a for a in re.split(r",(?![^(]*\))", args)] if args.strip() else []
        if mn in NONE:
            return self.emit(pc, NONE[mn])
        if mn in BRANCH:
            t = self.value(ops[0], final)
            if final and not -128 <= ((t - (pc + 2)) // 2) <= 127:
                raise AsmError("branch out of range")
            return self.emit(pc, BRANCH[mn] | (((t - (pc + 2)) // 2) & 0xFF if final else 0))
        if mn == "SOB":
            r = REGS[ops[0].strip().upper()]
            t = self.value(ops[1], final)
            off = ((pc + 2) - t) // 2 if final else 0
            if final and not 0 <= off <= 63:
                raise AsmError("SOB out of range")
            return self.emit(pc, 0o077000 | (r << 6) | off)
        if mn in ("MUL", "DIV", "ASH", "ASHC"):   # EIS: OP src,Rn
            r = REGS[ops[1].strip().upper()]
            code = {"MUL": 0o070000, "DIV": 0o071000, "ASH": 0o072000, "ASHC": 0o073000}[mn]
            return self.words_for(pc, code | (r << 6), [ops[0]], final, dst_only=True)
        if mn == "XOR":                                 # XOR Rn,dst
            r = REGS[ops[0].strip().upper()]
            return self.words_for(pc, 0o074000 | (r << 6), [ops[1]], final, dst_only=True)
        if mn == "RTS":
            return self.emit(pc, 0o000200 | REGS[ops[0].strip().upper()])
        if mn == "JSR":
            r = REGS[ops[0].strip().upper()]
            return self.words_for(pc, 0o004000 | (r << 6), [ops[1]], final, dst_only=True)
        if mn in SINGLE:
            return self.words_for(pc, SINGLE[mn], ops, final, dst_only=True)
        if mn in DOUBLE:
            return self.words_for(pc, DOUBLE[mn], ops, final, dst_only=False)
        raise AsmError("unknown mnemonic %s" % mn)

    def words_for(self, pc, base, ops, final, dst_only):
        extras = []
        fields = []
        for op in ops:
            f, x = self.operand(op, final, None)
            fields.append(f)
            extras.append(x)
        if dst_only:
            w = base | fields[0]
        else:
            w = base | (fields[0] << 6) | fields[1]
        pc0 = pc
        pc = self.emit(pc, w)
        for x in extras:
            if x is None:
                continue
            kind, v = x
            if kind == "rel":          # the address after this word, plus the offset
                v = (v - (pc + 2)) & 0xFFFF
            pc = self.emit(pc, v)
        return pc


def tape(words, start):
    """Absolute-format tape: one block per run of consecutive words."""
    out = bytearray(b"\0" * 8)
    addrs = sorted(words)
    runs = []
    for a in addrs:
        if runs and runs[-1][0] + 2 * len(runs[-1][1]) == a and len(runs[-1][1]) < 64:
            runs[-1][1].append(words[a])
        else:
            runs.append((a, [words[a]]))

    def block(addr, data):
        b = bytearray([1, 0, (len(data) + 6) & 0xFF, (len(data) + 6) >> 8, addr & 0xFF, addr >> 8]) + data
        b.append((-sum(b)) & 0xFF)
        return b
    for a, ws in runs:
        data = bytearray()
        for w in ws:
            data += bytes([w & 0xFF, w >> 8])
        out += block(a, data)
    out += block(start, bytearray())
    out += b"\0" * 8
    return bytes(out)
