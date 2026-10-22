#!/usr/bin/env python3
"""fp11_model.py - the FPJ11 (FP11) floating point unit in Python, the reference
the emulator's pico2/fp11.pico2 is held to.

    python tools/fp11_model.py --check TRANSCRIPT     check fp_check.pico2's output
    python tools/fp11_model.py --selftest             known values

It is a port of SIMH's pdp11_fp.c (Robert M Supnik, the "32b version"; the
permission notice is at the foot) made separately from the emulator's own port,
for the instructions whose operands are accumulators or general registers:
ADDf SUBf MULf DIVf MODf CMPf LDf STf (AC to AC) LDCff' STCff' (AC to AC) LDEXP
STEXP LDCif STCfi CLRf TSTf ABSf NEGf CFCC SETF SETD SETI SETL, with every FPS
mode and enable, FEC, and the trap request. Memory operands go through the
same code in the emulator once their address is formed; they are tested by
programs on the board (DEC's diagnostics, Unix).

THE TRANSCRIPT. fp_check.pico2 prints one line per case:
    F op fps r h0 l0 h1 l1 h2 l2 h3 l3 > fps' fec cpu r' h0 l0 h1 l1 h2 l2 h3 l3 trap
(hex; op the instruction; fps the status before; r the general register its
mode-0 integer operand names; h/l the accumulators AC0-AC3 before and after;
cpu the processor's N Z V C after, as 4 bits; trap 1 when the FP trap through
244 is requested). --check replays every case here and reports the first
difference field by field.
"""
import argparse
import sys

M32 = 0xFFFFFFFF
FPS_ER, FPS_ID, FPS_IUV, FPS_IU, FPS_IV, FPS_IC = 0x8000, 0x4000, 0x0800, 0x0400, 0x0200, 0x0100
FPS_D, FPS_L, FPS_T, FPS_N, FPS_Z, FPS_V, FPS_C = 0x80, 0x40, 0x20, 8, 4, 2, 1
FPS_CC = 0xF
FPS_RW = FPS_ER | FPS_ID | FPS_IUV | FPS_IU | FPS_IV | FPS_IC | FPS_D | FPS_L | FPS_T | 0o20 | FPS_CC  # 0o20: FMM, as pico2/fp11.pico2
FEC_OP, FEC_DZRO, FEC_ICVT, FEC_OVFLO, FEC_UNFLO, FEC_UNDFV = 2, 4, 6, 8, 10, 12
FP_SIGN, FP_EXP, FP_HB, FP_FRACH, FP_BIAS, FP_GUARD = 0x80000000, 0x7F800000, 0x00800000, 0x007FFFFF, 0o200, 3
ZERO = (0, 0)                       # (h, l)


def exp_of(h):
    return (h >> 23) & 0xFF


def lt(a, b):                       # F_LT, unsigned 64-bit
    return (a[0], a[1]) < (b[0], b[1])


def v64(p):
    return (p[0] << 32) | p[1]


def p64(v):
    v &= (1 << 64) - 1
    return (v >> 32, v & M32)


def lsh(p, n):
    return p64(v64(p) << n)


def rsh(p, n):
    return p64(v64(p) >> n)


def add(a, b):
    return p64(v64(a) + v64(b))


def sub(a, b):
    return p64(v64(a) - v64(b))


def frac(p):                        # F_GET_FRAC_P
    return ((p[0] & FP_FRACH) | FP_HB, p[1])


class FPU:
    def __init__(self):
        self.fps = self.fec = self.fea = 0
        self.fr = [ZERO] * 6
        self.trap = 0
        self.backup_pc = 0

    # exceptions
    def notrap(self, code):
        test = {FEC_ICVT: FPS_IC, FEC_OVFLO: FPS_IV, FEC_UNFLO: FPS_IU, FEC_UNDFV: FPS_IUV}
        if code in test and (self.fps & test[code]) == 0:
            return True
        self.fps |= FPS_ER
        self.fec = code
        self.fea = (self.backup_pc - 2) & 0xFFFF
        if (self.fps & FPS_ID) == 0:
            self.trap = 1
        return False

    def setfcc(self, old, h, newv):
        old = (old & ~FPS_CC) | newv
        if h & FP_SIGN:
            old |= FPS_N
        if exp_of(h) == 0:
            old |= FPS_Z
        return old

    def round_and_pack(self, sign_h, ex, f, r):
        if r and (self.fps & FPS_T) == 0:
            f = add(f, (0, 4) if self.fps & FPS_D else (4, 0))
            if (f[0] >> (23 + FP_GUARD + 1)) & 1:
                f = rsh(f, 1)
                ex += 1
        f = rsh(f, FP_GUARD)
        res = ((sign_h & FP_SIGN) | ((ex & 0xFF) << 23) | (f[0] & FP_FRACH), f[1])
        if ex > 0xFF:
            if self.notrap(FEC_OVFLO):
                res = ZERO
            return res, FPS_V
        if ex <= 0 and self.notrap(FEC_UNFLO):
            res = ZERO
        return res, 0

    def roundf(self, p):            # roundfp11
        o = add(p, (0, 1 << 31))
        if (o[0] ^ p[0]) & FP_SIGN:
            o = (o[0] ^ FP_SIGN, o[1])
            return (ZERO if self.notrap(FEC_OVFLO) else o), FPS_V
        return o, 0

    @staticmethod
    def normalize(f, ex, big):
        if big:
            if (f[0] & (0x00FFFFFF << FP_GUARD)) == 0:
                f = lsh(f, 24); ex -= 24
            if (f[0] & (0x00FFF000 << FP_GUARD)) == 0:
                f = lsh(f, 12); ex -= 12
            if (f[0] & (0x00FC0000 << FP_GUARD)) == 0:
                f = lsh(f, 6); ex -= 6
        while ((f[0] >> (23 + FP_GUARD)) & 1) == 0:
            f = lsh(f, 1); ex -= 1
        return f, ex

    def addf(self, fac, src):
        if ((fac[0] & ~FP_SIGN) & M32, fac[1]) < ((src[0] & ~FP_SIGN) & M32, src[1]):
            fac, src = src, fac
        fe, se = exp_of(fac[0]), exp_of(src[0])
        if fe == 0:
            return (src if se else ZERO), 0
        if se == 0:
            return fac, 0
        ed = fe - se
        if ed >= 60:
            return fac, 0
        ff, sf = lsh(frac(fac), FP_GUARD), lsh(frac(src), FP_GUARD)
        if (fac[0] ^ src[0]) & FP_SIGN:
            if ed:
                sf = rsh(sf, ed)
            ff = sub(ff, sf)
            if ff == ZERO:
                return ZERO, 0
            ff, fe = self.normalize(ff, fe, ed <= 1)
        else:
            if ed:
                sf = rsh(sf, ed)
            ff = add(ff, sf)
            if (ff[0] >> (23 + FP_GUARD + 1)) & 1:
                ff = rsh(ff, 1); fe += 1
        return self.round_and_pack(fac[0], fe, ff, 1)

    @staticmethod
    def frac_mul(mpy, mpc):
        """the shift-and-add multiply: the top 64 bits, exactly as simh develops them"""
        mpc = lsh(mpc, FP_GUARD)
        r = 0
        if (mpy[1] | mpc[1]) == 0:
            rh, my = 0, mpy[0]
            res = 0
            for _ in range(24):
                if my & 1:
                    res = (res + (mpc[0] << 32)) & ((1 << 64) - 1)
                res >>= 1
                my >>= 1
            return p64(res)
        res = 0
        c = v64(mpc)
        ml, mh = mpy[1], mpy[0]
        if ml:
            for _ in range(32):
                if ml & 1:
                    res = (res + c) & ((1 << 64) - 1)
                res >>= 1
                ml >>= 1
        for _ in range(24):
            if mh & 1:
                res = (res + c) & ((1 << 64) - 1)
            res >>= 1
            mh >>= 1
        return p64(res)

    def mulf(self, fac, src):
        fe, se = exp_of(fac[0]), exp_of(src[0])
        if fe == 0 or se == 0:
            return ZERO, 0
        fe = fe + se - FP_BIAS
        sign = fac[0] ^ src[0]
        ff = self.frac_mul(frac(fac), frac(src))
        if ((ff[0] >> (23 + FP_GUARD)) & 1) == 0:
            ff = lsh(ff, 1); fe -= 1
        return self.round_and_pack(sign, fe, ff, 1)

    def modf(self, fac, src):       # returns (integer, fraction, newV)
        fe, se = exp_of(fac[0]), exp_of(src[0])
        if fe == 0 or se == 0:
            return ZERO, ZERO, 0
        fe = fe + se - FP_BIAS
        sign = fac[0] ^ src[0]
        ff = self.frac_mul(frac(fac), frac(src))
        if ((ff[0] >> (23 + FP_GUARD)) & 1) == 0:
            ff = lsh(ff, 1); fe -= 1
        if fe <= FP_BIAS:
            m, v = self.round_and_pack(sign, fe, ff, 1)
            return ZERO, m, v
        if fe > (FP_BIAS + 56 if self.fps & FPS_D else FP_BIAS + 24):
            i, v = self.round_and_pack(sign, fe, ff, 0)
            return i, ZERO, v
        mask = rsh(((1 << (23 + FP_GUARD + 1)) - 1, M32), fe - FP_BIAS)
        sf = (ff[0] & mask[0], ff[1] & mask[1])
        if sf == ZERO:
            m = ZERO
        else:
            sf = lsh(sf, fe - FP_BIAS)
            sf, se2 = self.normalize(sf, FP_BIAS, True)
            m, _ = self.round_and_pack(sign, se2, sf, 1)
        ff = (ff[0] & ~mask[0] & M32, ff[1] & ~mask[1] & M32)
        i, v = self.round_and_pack(sign, fe, ff, 0)
        return i, m, v

    def divf(self, fac, src):
        se, fe = exp_of(src[0]), exp_of(fac[0])
        if fe == 0:
            return ZERO, 0
        ff, sf = lsh(frac(fac), FP_GUARD), lsh(frac(src), FP_GUARD)
        fe = fe - se + FP_BIAS + 1
        sign = fac[0] ^ src[0]
        qd = self.fps & FPS_D
        count = 23 + FP_GUARD + (33 if qd else 1)
        q = ZERO
        i = count
        while i > 0 and ff != ZERO:
            q = lsh(q, 1)
            if not lt(ff, sf):
                ff = sub(ff, sf)
                q = (q[0], q[1] | 1) if qd else (q[0] | 1, q[1])
            ff = lsh(ff, 1)
            i -= 1
        if i > 0:
            q = lsh(q, i)
        if ((q[0] >> (23 + FP_GUARD)) & 1) == 0:
            q = lsh(q, 1); fe -= 1
        return self.round_and_pack(sign, fe, q, 1)

    # ---- one instruction with mode-0 operands; R = the one general register named ----
    def execute(self, op, r):
        """op with dest spec mode 0; r = the general register's value; returns (r', cpu_cc or None)"""
        self.trap = 0
        self.backup_pc = 0o1002                # fp_check runs every instruction from 001000
        ac = (op >> 6) & 3
        ds = op & 0o77
        qd = self.fps & FPS_D
        lenf = 8 if qd else 4
        cc = None
        load = lambda a: (self.fr[a][0], self.fr[a][1] if qd else 0)

        def store(a, p):
            self.fr[a] = (p[0], p[1] if qd else self.fr[a][1])

        def readf(spec, ln):            # mode 0 only
            if spec >= 6:
                self.notrap(FEC_OP)
                return None
            p = (self.fr[spec][0], self.fr[spec][1] if ln == 8 else 0)
            if (p[0] & FP_SIGN) and exp_of(p[0]) == 0 and not self.notrap(FEC_UNDFV):
                return None
            return p

        code = (op >> 8) & 0o17
        if code == 0:
            if ac == 0:
                if op == 0o170000:
                    cc = ((self.fps >> 3) & 1, (self.fps >> 2) & 1, (self.fps >> 1) & 1, self.fps & 1)
                elif op == 0o170001: self.fps &= ~FPS_D
                elif op == 0o170002: self.fps &= ~FPS_L
                elif op == 0o170011: self.fps |= FPS_D
                elif op == 0o170012: self.fps |= FPS_L
                else: self.notrap(FEC_OP)
            elif ac == 1:
                self.fps = r & FPS_RW
            elif ac == 2:
                self.fps &= FPS_RW
                r = self.fps
            else:
                r = self.fec
            return r, cc
        if code == 1:
            if ds >= 6:
                self.notrap(FEC_OP)
                return r, cc
            if ac == 0:
                self.fr[ds] = (0, 0 if qd else self.fr[ds][1])
                self.fps = (self.fps & ~FPS_CC) | FPS_Z
            else:
                s = readf(ds, lenf)
                if s is not None:
                    if ac == 2 or ac == 3:
                        if exp_of(s[0]) == 0:
                            s = ZERO
                        elif ac == 2:
                            s = (s[0] & ~FP_SIGN & M32, s[1])
                        else:
                            s = (s[0] ^ FP_SIGN, s[1])
                        store(ds, s)
                    self.fps = self.setfcc(self.fps, s[0], 0)
            return r, cc
        if code == 0o5:
            s = readf(ds, lenf)
            if s is not None:
                store(ac, s)
                self.fps = self.setfcc(self.fps, s[0], 0)
        elif code == 0o10:
            if ds >= 6:
                self.notrap(FEC_OP)
            else:
                store(ds, load(ac))
        elif code == 0o17:                      # LDCff'
            s = readf(ds, 12 - lenf)
            if s is not None:
                if exp_of(s[0]) == 0:
                    s = ZERO
                newv = 0
                if (self.fps & (FPS_D | FPS_T)) == 0:
                    s, newv = self.roundf(s)
                store(ac, s)
                self.fps = self.setfcc(self.fps, s[0], newv)
        elif code == 0o14:                      # STCff'
            f = load(ac)
            if exp_of(f[0]) == 0:
                f = ZERO
            newv = 0
            if (self.fps & (FPS_D | FPS_T)) == FPS_D:
                f, newv = self.roundf(f)
            if ds >= 6:
                self.notrap(FEC_OP)
            else:
                ln = 12 - lenf
                self.fr[ds] = (f[0], f[1] if ln == 8 else self.fr[ds][1])
                self.fps = self.setfcc(self.fps, f[0], newv)
        elif code == 0o7:                       # CMPf
            s = readf(ds, lenf)
            if s is not None:
                f = load(ac)
                if exp_of(s[0]) == 0: s = ZERO
                if exp_of(f[0]) == 0: f = ZERO
                if s == f:
                    self.fps = (self.fps & ~FPS_CC) | FPS_Z
                    if s == ZERO:
                        store(ac, ZERO)
                else:
                    self.fps = (self.fps & ~FPS_CC) | ((s[0] >> 28) & FPS_N)
                    if ((s[0] ^ f[0]) & FP_SIGN) == 0 and f[0] != 0 and lt(s, f):
                        self.fps ^= FPS_N
        elif code == 0o15:                      # LDEXP (register)
            dst = r
            f = load(ac)
            f = ((f[0] & ~FP_EXP & M32) | (((dst + FP_BIAS) & 0xFF) << 23), f[1])
            newv = 0
            if 0o177 < dst <= 0o177600:
                if dst < 0o100000:
                    if self.notrap(FEC_OVFLO):
                        f = ZERO
                    newv = FPS_V
                elif self.notrap(FEC_UNFLO):
                    f = ZERO
            store(ac, f)
            self.fps = self.setfcc(self.fps, f[0], newv)
        elif code == 0o12:                      # STEXP (register)
            dst = (exp_of(self.fr[ac][0]) - FP_BIAS) & 0xFFFF
            n, z = (dst >> 15) & 1, int(dst == 0)
            cc = (n, z, 0, 0)
            self.fps = (self.fps & ~FPS_CC) | (n << 3) | (z << 2)
            r = dst
        elif code == 0o16:                      # LDCif (register)
            fl = (r << 16) & M32
            fh = 0
            if fl:
                sign = (fl >> 31) & 1
                if sign:
                    fl = ((fl ^ M32) + 1) & M32
                i = 0
                while ((fl >> 31) & 1) == 0:
                    fl = (fl << 1) & M32; i += 1
                ex = (FP_BIAS + 32 if self.fps & FPS_L else FP_BIAS + 16) - i
                fh = (sign << 31) | (ex << 23) | ((fl >> 8) & FP_FRACH)
                fl = (fl << 24) & M32
                if (self.fps & (FPS_D | FPS_T)) == 0:
                    (fh, fl), _ = self.roundf((fh, fl))
            store(ac, (fh, fl))
            self.fps = self.setfcc(self.fps, fh, 0)
        elif code == 0o13:                      # STCfi (register)
            h = self.fr[ac][0]
            sign, ex = (h >> 31) & 1, exp_of(h)
            f = ((h & FP_FRACH) | FP_HB, self.fr[ac][1] if qd else 0)
            leni, lim = (4, FP_BIAS + 32) if self.fps & FPS_L else (2, FP_BIAS + 16)
            c = 0
            if ex <= FP_BIAS:
                dst = 0
            elif ex > lim:
                dst, c = 0, 1
            else:
                s = rsh(f, 23 + 1 + lim - ex)
                sl = s[1] & (~0xFFFF & M32) if leni == 2 else s[1]
                limit = {(4, 0): 0x80000000, (4, 1): 0x80000001, (2, 0): 0x80000000, (2, 1): 0x80010000}[(leni, sign)]
                if sl >= limit:
                    dst, c = 0, 1
                else:
                    dst = (-sl) & M32 if sign else sl
            n, z = (dst >> 31) & 1, int(dst == 0)
            cc = (n, z, 0, c)
            if c:
                self.notrap(FEC_ICVT)
            self.fps = (self.fps & ~FPS_CC) | (n << 3) | (z << 2) | c
            r = (dst >> 16) & 0xFFFF
        else:                                   # MUL 2, MOD 3, ADD 4, SUB 6, DIV 9
            s = readf(ds, lenf)
            if s is not None:
                f = load(ac)
                if code == 0o2:
                    f, newv = self.mulf(f, s)
                    store(ac, f); self.fps = self.setfcc(self.fps, f[0], newv)
                elif code == 0o3:
                    i, m, newv = self.modf(f, s)
                    store(ac | 1, i); store(ac, m); self.fps = self.setfcc(self.fps, m[0], newv)
                elif code == 0o11:
                    if exp_of(s[0]) == 0:
                        self.notrap(FEC_DZRO)
                    else:
                        f, newv = self.divf(f, s)
                        store(ac, f); self.fps = self.setfcc(self.fps, f[0], newv)
                else:
                    if code == 0o6 and exp_of(s[0]) != 0:
                        s = (s[0] ^ FP_SIGN, s[1])
                    f, newv = self.addf(f, s)
                    store(ac, f); self.fps = self.setfcc(self.fps, f[0], newv)
        return r, cc


def check(path):
    n = bad = 0
    for line in open(path, errors="replace"):
        line = line.strip()
        if not line.startswith("F ") or ">" not in line:
            continue
        a, _, b = line[2:].partition(">")
        x = [int(t, 16) for t in a.split()]
        y = [int(t, 16) for t in b.split()]
        if len(x) != 11 or len(y) != 14:
            continue
        op, fps, r = x[0], x[1], x[2]
        u = FPU()
        u.fps = fps
        u.fr = [(x[3], x[4]), (x[5], x[6]), (x[7], x[8]), (x[9], x[10]), ZERO, ZERO]
        r2, cc = u.execute(op, r)
        want = [u.fps, u.fec, None if cc is None else (cc[0] << 3 | cc[1] << 2 | cc[2] << 1 | cc[3]), r2]
        want += [v for p in u.fr[:4] for v in p] + [u.trap]
        names = ["fps", "fec", "cpu", "r"] + ["h0", "l0", "h1", "l1", "h2", "l2", "h3", "l3"] + ["trap"]
        n += 1
        for k, (w, g) in enumerate(zip(want, y)):
            if w is not None and (w & M32) != g:
                bad += 1
                if bad <= 10:
                    print("fp11_model: case %d op %06o fps %06o: %s board %X model %X\n  %s" % (n, op, fps, names[k], g, w & M32, line))
                break
    print("fp11_model: %d cases, %d differ" % (n, bad))
    return 1 if bad or n == 0 else 0


def selftest():
    u = FPU()
    one = (0x40800000, 0)                         # 1.0: exponent 129, fraction .1
    two = (0x41000000, 0)
    u.fps = FPS_D
    r, _ = u.addf(one, one)
    assert r == two, r
    r, _ = u.mulf(two, two)
    assert r == (0x41800000, 0), r
    r, _ = u.divf(one, (0x41400000, 0))           # 1/3
    assert r == (0x3FAAAAAA, 0xAAAAAAAB), r
    print("fp11_model: self-test passed (1+1, 2*2, 1/3 in D)")
    return 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--check")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()
    if a.selftest:
        sys.exit(selftest())
    if a.check:
        sys.exit(check(a.check))
    ap.print_help()

# SIMH's notice, as its terms require: Copyright (c) 1993-2023, Robert M Supnik.
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in the
# Software without restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions: The above copyright notice and this
# permission notice shall be included in all copies or substantial portions of the
# Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL ROBERT M
# SUPNIK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. Except as contained in this
# notice, the name of Robert M Supnik shall not be used in advertising or otherwise
# to promote the sale, use or other dealings in this Software without prior written
# authorization from Robert M Supnik.
