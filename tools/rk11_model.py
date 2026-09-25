#!/usr/bin/env python3
"""rk11_model.py - the desk proof of the emulator's RK11 disk controller
and KW11-L line clock: a PYTHON REFERENCE MODEL of the RK11, a PDP-11 test
program that drives the emulated controller through every access pattern,
and the check that the two agree word for word.

USE
    python rk11_model.py --tape rktest.bin
        writes the test program as an absolute-format tape (for
        tape2pico.py; build diag.pico with #DISK_BACKEND = 1, the RAM packs)
    python rk11_model.py --expect
        prints the console lines the model says the program must type
    python rk11_model.py --check LOG
        compares the "| " lines of a diag firmware log (arm_run output)
        with the model, line by line; exit 1 on any difference

THE MODEL follows the same sources as rk11.pico - DEC's RK11-D manual
EK-RK11D-OP-001 (PureMetal/EK-RK11D-OP-001.pdf) with simh pdp11_rk.c as the
cross-check - but it is written independently of the firmware: from the
register descriptions, not from the PureBasic. The RAM packs of disk.pico
(#DISK_BACKEND = 1) start out holding DiskPattern in every block; the
model starts from the same.

THE PROGRAM runs a table of operations and types one line per operation:
    R cs er wc ba da ds n [cs ds]...   an RK11 function: the six registers
                                       after it, the interrupts taken, and
                                       RKCS/RKDS as each interrupt saw them
    S sum                              a checksum of a memory range
    V value                            a register read
    K ...                              the line clock's register and interrupts
and "END" at the end, then HALTs.
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pdp11asm  # noqa: E402

RKDS, RKER, RKCS, RKWC, RKBA, RKDA = 0o177400, 0o177402, 0o177404, 0o177406, 0o177410, 0o177412
RKDB = 0o177416
LKS = 0o177546
BLOCKS = 4872
RAM_BYTES = 0o160000


def pattern(d, blk, i):
    """disk.pico DiskPattern: the words of a block never written."""
    return (((blk << 8) + i) ^ (d * 0xA5A5) ^ ((blk >> 8) * 0x1111)) & 0xFFFF


# ======================================================================
#  THE REFERENCE MODEL
# ======================================================================
class RK11:
    DRIVES = 2

    def __init__(self, mem):
        self.mem = mem                  # dict byte address -> word
        self.disk = {}                  # (drive, block) -> 256 words
        self.lock = [0] * 8
        self.init()

    def init(self):                     # bus INIT
        self.cs, self.er, self.wc, self.ba, self.da, self.db = 0o200, 0, 0, 0, 0, 0
        self.intdrive = 0
        self.seeking = set()
        self.lock = [0] * 8
        self.req = False

    def block(self, d, b):
        if (d, b) not in self.disk:
            return [pattern(d, b, i) for i in range(256)]
        return list(self.disk[(d, b)])

    def rd(self, a):
        if a == RKDS:
            d = (self.da >> 13) & 7
            v = self.intdrive << 13
            if d < self.DRIVES:
                v |= 0o4000 | 0o400 | 0o200 | 0o20
                if d not in self.seeking:
                    v |= 0o100
                if self.lock[d]:
                    v |= 0o40
                if (self.da & 15) < 12:
                    v |= self.da & 15
            return v
        if a == RKER:
            return self.er
        if a == RKCS:
            v = self.cs
            if self.er:
                v |= 0o100000
                if self.er & 0o177740:
                    v |= 0o40000
            return v
        if a == RKWC:
            return self.wc
        if a == RKBA:
            return self.ba
        if a == RKDA:
            return self.da
        if a == RKDB:
            return self.db
        return 0

    def ask(self):
        if self.cs & 0o100:
            self.req = True

    def done(self):
        self.cs |= 0o200
        self.ask()

    def fail(self, bits):
        self.er |= bits
        self.done()

    def wr(self, a, v):
        v &= 0xFFFF
        ready = self.cs & 0o200
        if a == RKCS:
            oldie = self.cs & 0o100
            if not ready:
                self.cs = (self.cs & ~0o100) | (v & 0o100)
            else:
                self.cs = (self.cs & ~0o6576) | (v & 0o6576)
            if not v & 0o100:
                self.req = False
            elif not oldie and (self.cs & 0o200) and not v & 1:
                self.ask()
            if v & 1 and self.cs & 0o200:
                self.go()
        elif ready:
            if a == RKWC:
                self.wc = v
            elif a == RKBA:
                self.ba = v & 0o177776
            elif a == RKDA:
                self.da = v

    def go(self):
        f = (self.cs >> 1) & 7
        d = (self.da >> 13) & 7
        self.cs &= ~(0o200 | 0o20000)
        self.req = False
        self.er &= ~3
        self.intdrive = d
        if f == 0:
            self.cs, self.er, self.wc, self.ba, self.da, self.db = 0o200, 0, 0, 0, 0, 0
            self.intdrive = 0
            return
        if d >= self.DRIVES:
            return self.fail(0o200)                    # NXD
        if self.cs & 0o2000 and f not in (1, 2):
            return self.fail(0o4000)                   # PGE
        if f == 7:
            self.lock[d] = 1
            return self.done()
        cyl = (self.da >> 5) & 0o377
        if f in (4, 6):
            if f == 6:
                cyl = 0
            elif cyl > 0o312:
                return self.fail(0o100)                # NXC
            self.seeking.add(d)
            self.pending_seek = d
            return self.done()
        if f == 1 and self.lock[d]:
            return self.fail(0o20000)                  # WLO
        if (self.da & 15) >= 12:
            return self.fail(0o40)                     # NXS
        if cyl > 0o312:
            return self.fail(0o100)                    # NXC
        self.transfer(f, d, (cyl * 2 + ((self.da >> 4) & 1)) * 12 + (self.da & 15))

    def transfer(self, f, d, blk):
        left = (65536 - self.wc) & 0xFFFF or 65536
        ma = ((self.cs & 0o60) << 12) | self.ba
        step = 0 if self.cs & 0o4000 else 2
        moved = 0
        stop = False
        while left > 0 and not stop:
            if blk >= BLOCKS:
                self.er |= 0o40000                     # OVR
                break
            n = min(256, left)
            if f == 1:
                buf = []
                for i in range(n):
                    if ma >= RAM_BYTES:
                        self.er |= 0o2000              # NXM
                        n = i
                        stop = True
                        break
                    w = self.mem.get(ma, 0)
                    buf.append(w)
                    self.db = w
                    ma = (ma + step) & 0o777777
                if n == 0:
                    break
                self.disk[(d, blk)] = buf + [0] * (256 - len(buf))
            else:
                if f == 2 and self.cs & 0o2000:
                    buf = [(blk // 24) << 5]
                    n = 1
                else:
                    buf = self.block(d, blk)
                if f == 2:
                    for i in range(n):
                        self.db = buf[i]
                        if ma >= RAM_BYTES:
                            self.er |= 0o2000
                            n = i
                            stop = True
                            break
                        self.mem[ma] = buf[i]
                        ma = (ma + step) & 0o777777
                elif f == 3:
                    m0 = ma
                    for i in range(n):
                        if ma >= RAM_BYTES:
                            self.er |= 0o2000
                            n = i
                            stop = True
                            break
                        w = self.mem.get(ma, 0)
                        self.db = w
                        if w != buf[i]:
                            self.er |= 1
                        ma = (ma + step) & 0o777777
                    if self.er & 1 and self.cs & 0o400:
                        stop = True
                elif f == 5:
                    pass
                if n == 0:
                    break
            moved += n
            left -= n
            blk += 1
        self.wc = (self.wc + moved) & 0xFFFF
        if f != 5:
            self.ba = ma & 0xFFFF
            self.cs = (self.cs & ~0o60) | ((ma >> 12) & 0o60)
        else:
            self.ba = ma & 0xFFFF
        self.da = (self.da & 0o160000) | ((blk // 24) << 5) | (((blk // 12) & 1) << 4) | (blk % 12)
        self.done()


# ======================================================================
#  THE TEST PROGRAM (PDP-11), and the operations it runs
# ======================================================================
DRIVER = r"""
RKDS=177400
RKER=177402
RKCS=177404
RKWC=177406
RKBA=177410
RKDA=177412
LKS=177546
XCSR=177564
XBUF=177566

.=4
 .word buserr,340
.=100
 .word kwisr,340
.=220
 .word rkisr,340

.=1000
start:  MOV #776,SP
        MTPS #0
        MOV #table,R5
next:   MOV (R5)+,R0
        BEQ fin
        ASL R0
        JMP @jt(R0)
fin:    MOV #msgend,R1
        JSR PC,puts
        HALT
        BR fin

jt:     .word 0,oprk,opfill,opsum,opwr,opwrb,oprd,opwait,opclk,opreset,opnowait

; ---- R: an RK11 function: da, ba, wc, cs, then how to wait (0 poll RDY,
; n: n interrupts) - then the line
oprk:   CLR intcnt
        MOV (R5)+,@#RKDA
        MOV (R5)+,@#RKBA
        MOV (R5)+,@#RKWC
        MOV (R5)+,R4
        MOV (R5)+,R3
        MOV R4,@#RKCS
        JSR PC,await
        JSR PC,prk
        JMP next

; wait: R3 = 0 poll RDY, else until intcnt >= R3 (bounded)
await:  TST R3
        BNE 2$
1$:     TSTB @#RKCS
        BPL 1$
        RTS PC
2$:     MOV #177777,R2
3$:     CMP intcnt,R3
        BGE 4$
        DEC R2
        BNE 3$
        MOV #msgto,R1
        JSR PC,puts
4$:     RTS PC

; the line: R cs er wc ba da ds n [snap...]
prk:    MOV #'R,R2
        JSR PC,putc
        MOV @#RKCS,R0
        JSR PC,sp8
        MOV @#RKER,R0
        JSR PC,sp8
        MOV @#RKWC,R0
        JSR PC,sp8
        MOV @#RKBA,R0
        JSR PC,sp8
        MOV @#RKDA,R0
        JSR PC,sp8
        MOV @#RKDS,R0
        JSR PC,sp8
        MOV intcnt,R0
        JSR PC,sp8
        MOV intcnt,R4
        CMP R4,#4
        BLE 1$
        MOV #4,R4
1$:     MOV #snap,R3
        TST R4
        BEQ 3$
2$:     MOV (R3)+,R0
        JSR PC,sp8
        MOV (R3)+,R0
        JSR PC,sp8
        SOB R4,2$
3$:     JSR PC,crlf
        RTS PC

; ---- F: fill addr, count, seed (seed += 11065 per word)
opfill: MOV (R5)+,R1
        MOV (R5)+,R2
        MOV (R5)+,R3
1$:     MOV R3,(R1)+
        ADD #11065,R3
        SOB R2,1$
        JMP next

; ---- S: checksum addr, count: s = swab(s + w)
opsum:  MOV (R5)+,R1
        MOV (R5)+,R2
        CLR R0
1$:     ADD (R1)+,R0
        SWAB R0
        SOB R2,1$
        MOV R0,R4
        MOV #'S,R2
        JSR PC,putc
        MOV R4,R0
        JSR PC,sp8
        JSR PC,crlf
        JMP next

; ---- W / B: a word / a byte into an address
opwr:   MOV (R5)+,R1
        MOV (R5)+,(R1)
        JMP next
opwrb:  MOV (R5)+,R1
        MOVB (R5),(R1)
        TST (R5)+
        JMP next

; ---- V: read an address
oprd:   MOV @(R5)+,R4
        MOV #'V,R2
        JSR PC,putc
        MOV R4,R0
        JSR PC,sp8
        JSR PC,crlf
        JMP next

; ---- A: wait (R3 = the argument, as await) and print the RK line
opwait: MOV (R5)+,R3
        JSR PC,await
        JSR PC,prk
        JMP next

; ---- N: an RK11 function started, NOT waited for: da, ba, wc, cs
opnowait: CLR intcnt
        MOV (R5)+,@#RKDA
        MOV (R5)+,@#RKBA
        MOV (R5)+,@#RKWC
        MOV (R5)+,@#RKCS
        JMP next

; ---- Z: the RESET instruction (bus INIT)
opreset: RESET
        MTPS #0
        JMP next

; ---- K: the line clock. After INIT bit 7 is set; a 0 written clears it;
; the next tick sets it again; with bit 6, ticks interrupt through 100.
opclk:  MOV @#LKS,R4
        MOV #'K,R2
        JSR PC,putc
        MOV R4,R0
        JSR PC,sp8
        CLR @#LKS
        MOV @#LKS,R0
        JSR PC,sp8
1$:     TSTB @#LKS
        BPL 1$
        MOV @#LKS,R0
        JSR PC,sp8
        CLR kwcnt
        MOV #100,@#LKS
2$:     CMP kwcnt,#3
        BLT 2$
        CLR @#LKS
        MOV kwcnt,R0
        CMP R0,#3
        BNE 3$
        MOV #'+,R2
        JSR PC,putc
3$:     JSR PC,crlf
        JMP next

; ---- the interrupt handlers
rkisr:  MOV R0,-(SP)
        MOV intcnt,R0
        CMP R0,#4
        BGE 1$
        ASL R0
        ASL R0
        MOV @#RKCS,snap(R0)
        MOV @#RKDS,snap+2(R0)
1$:     INC intcnt
        MOV (SP)+,R0
        RTI
kwisr:  INC kwcnt
        RTI
buserr: MOV #msgbus,R1
        JSR PC,puts
        HALT

; ---- output: sp8 = a space and R0 in six octal digits
sp8:    MOV R3,-(SP)
        MOV #40,R2
        JSR PC,putc
        MOV R0,R1
        CLR R2
        ASL R1
        ADC R2
        ADD #'0,R2
        JSR PC,putc
        MOV #5,R3
1$:     CLR R2
        ASL R1
        ROL R2
        ASL R1
        ROL R2
        ASL R1
        ROL R2
        ADD #'0,R2
        JSR PC,putc
        SOB R3,1$
        MOV (SP)+,R3
        RTS PC
crlf:   MOV #15,R2
        JSR PC,putc
        MOV #12,R2
putc:   TSTB @#XCSR
        BPL putc
        MOVB R2,@#XBUF
        RTS PC
puts:   MOVB (R1)+,R2
        BEQ 1$
        JSR PC,putc
        BR puts
1$:     RTS PC

intcnt: .word 0
kwcnt:  .word 0
snap:   .blkw 10
msgend: .ascii /END\r\n\0/
msgto:  .ascii / TIMEOUT\0/
msgbus: .ascii /BUS ERROR\r\n\0/
.even
table:
"""

BUF = 0o20000          # the transfer buffer
BUF2 = 0o60000


def da(drive=0, cyl=0, sur=0, sec=0):
    return (drive << 13) | (cyl << 5) | (sur << 4) | sec


def rk(d, ba, wc, cs, wait=0):
    return [1, d, ba, (-wc) & 0xFFFF, cs, wait]


READ = 0o5
WRITE = 0o3
WCHK = 0o7
SEEK = 0o11
RCHK = 0o13
DRST = 0o15
WLK = 0o17
CRESET = 0o1
IDE = 0o100
SSE = 0o400
FMT = 0o2000
IBA = 0o4000


def ops():
    """The operations, as (words, what they test)."""
    T = []
    T.append(([1, 0, 0, 0, CRESET, 0], "control reset"))
    T.append(([6, RKDS], "RKDS of drive 0 after reset"))
    T.append((rk(da(0, 0, 0, 0), BUF, 256, READ), "read one sector, block 0"))
    T.append(([3, BUF, 256], "its data"))
    T.append((rk(da(0, 0, 0, 10), BUF, 1024, READ), "read 4 sectors across the surface boundary"))
    T.append(([3, BUF, 1024], ""))
    T.append((rk(da(0, 5, 1, 11), BUF, 768, READ), "read 3 sectors across the cylinder boundary"))
    T.append(([3, BUF, 768], ""))
    T.append((rk(da(0, 100, 1, 3), BUF, 100, READ), "a short read, 100 words"))
    T.append(([3, BUF, 256], ""))
    T.append(([2, BUF, 700, 0o123], "fill"))
    T.append((rk(da(0, 10, 0, 4), BUF, 600, WRITE), "write 600 words: two sectors and a short one"))
    T.append(([2, BUF, 800, 0], "clear"))
    T.append((rk(da(0, 10, 0, 4), BUF, 768, READ), "read the three sectors back (the short one zero-filled)"))
    T.append(([3, BUF, 768], ""))
    T.append((rk(da(0, 10, 0, 4), BUF, 600, WCHK), "write check, matching"))
    T.append(([4, BUF + 0o1000, 0o7777], "change a word of the second sector"))
    T.append((rk(da(0, 10, 0, 4), BUF, 600, WCHK), "write check, a mismatch: WCE, runs on"))
    T.append((rk(da(0, 10, 0, 4), BUF, 600, WCHK | SSE), "the same with SSE: stops after that sector"))
    T.append((rk(da(0, 10, 0, 4), BUF, 512, RCHK), "read check"))
    T.append((rk(da(0, 3, 0, 0), BUF2, 512, READ | IBA), "IBA read: 512 words into one address"))
    T.append(([6, BUF2], ""))
    T.append(([4, BUF2, 0o4567], ""))
    T.append((rk(da(0, 20, 1, 0), BUF2, 300, WRITE | IBA), "IBA write: one word 300 times"))
    T.append((rk(da(0, 20, 1, 0), BUF, 512, READ), ""))
    T.append(([3, BUF, 512], ""))
    T.append((rk(da(0, 1, 0, 0), 0o157000, 512, READ), "NXM: the transfer runs into the I/O page"))
    T.append(([1, 0, 0, 0, CRESET, 0], "control reset clears the hard error"))
    T.append((rk(da(0, 1, 0, 0), 0, 256, READ | 0o20), "MEX = 1: address 200000, no memory there"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(0, 1, 0, 12), BUF, 256, READ), "NXS: sector 12"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(0, 203, 0, 0), BUF, 256, READ), "NXC: cylinder 203"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(2, 0, 0, 0), BUF, 256, READ), "NXD: drive 2"))
    T.append(([6, RKDS], "RKDS with drive 2 selected"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(1, 7, 1, 5), BUF, 256, READ), "drive 1"))
    T.append(([3, BUF, 256], ""))
    T.append((rk(da(0, 202, 1, 11), BUF, 512, READ), "OVR: past the last sector of the pack"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(1, 0, 0, 0), 0, 0, WLK), "write lock drive 1"))
    T.append(([2, BUF, 256, 0o777], ""))
    T.append((rk(da(1, 30, 0, 0), BUF, 256, WRITE), "a write to it: WLO"))
    T.append(([1, 0, 0, 0, CRESET, 0], "a control reset does not unlock it"))
    T.append((rk(da(1, 30, 0, 0), BUF, 256, WRITE), ""))
    T.append(([9], "the RESET instruction (bus INIT) does"))
    T.append((rk(da(1, 30, 0, 0), BUF, 256, WRITE), ""))
    T.append((rk(da(0, 30, 0, 0), BUF2, 256, READ), "drive 0 at the same place is untouched"))
    T.append(([3, BUF2, 256], ""))
    T.append((rk(da(1, 30, 0, 0), BUF2, 256, READ), "drive 1 has the new data"))
    T.append(([3, BUF2, 256], ""))
    T.append((rk(da(0, 7, 0, 0), BUF, 3, READ | FMT), "format read: one header word per sector"))
    T.append(([3, BUF, 3], ""))
    T.append((rk(da(0, 7, 0, 0), 0, 0, SEEK | FMT), "FMT with a seek: PGE"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(0, 150, 0, 0), 0, 0, SEEK | IDE, 2), "seek with IDE: an interrupt at once, and SCP when it arrives"))
    T.append((rk(da(1, 0, 0, 0), 0, 0, DRST | IDE, 2), "drive reset on drive 1, the same two"))
    T.append((rk(da(0, 202, 0, 0), 0, 0, SEEK | IDE, 2), "seek to the last cylinder"))
    T.append((rk(da(0, 203, 0, 0), 0, 0, SEEK | IDE, 1), "seek to cylinder 203: NXC, one interrupt"))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(0, 40, 1, 2), BUF, 1024, READ | IDE, 1), "read with an interrupt at the end"))
    T.append(([3, BUF, 1024], ""))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append(([4, RKCS, IDE], "IDE set while ready, no GO: an interrupt"))
    T.append(([7, 1], ""))
    T.append(([4, RKCS, 0], ""))
    T.append(([10, da(0, 50, 0, 0), BUF, (-2048) & 0xFFFF, READ], "RKDA written while busy is ignored"))
    T.append(([4, RKDA, da(0, 60, 0, 0)], ""))
    T.append(([7, 0], ""))
    T.append(([3, BUF, 2048], ""))
    T.append(([5, RKCS + 1, 1], "a byte into RKCS's high byte: SSE"))
    T.append(([6, RKCS], ""))
    T.append(([5, RKCS, 0o40], "a byte into its low byte keeps the high one"))
    T.append(([6, RKCS], ""))
    T.append(([1, 0, 0, 0, CRESET, 0], ""))
    T.append((rk(da(0, 0, 0, 0), BUF, 0, READ | IBA), "word count 0: 65536 words, 256 sectors, into one address"))
    T.append(([6, BUF], ""))
    T.append((rk(da(0, 100, 0, 0), BUF, 8192, WRITE | IBA), "32 sectors of one word"))
    T.append((rk(da(0, 100, 0, 0), BUF, 8192, WCHK | IBA), "write check of all that: matches"))
    T.append(([8], "the line clock"))
    return T


def program():
    body = DRIVER
    words = []
    for w, _ in ops():
        words += w
    words.append(0)
    body += "\n".join("  .word %o" % w for w in words) + "\n"
    a = pdp11asm.Asm(body)
    return a.assemble()


def expect(drives=2):
    mem = dict(program())
    rk = RK11(mem)
    rk.DRIVES = drives
    out = []
    deferred = None                          # N: started, not waited for (busy until A)

    def sum_(a, n):
        s = 0
        for i in range(n):
            s = (s + mem.get(a + 2 * i, 0)) & 0xFFFF
            s = ((s >> 8) | (s << 8)) & 0xFFFF
        return s

    for w, _ in ops():
        op = w[0]
        if op in (1, 10):
            snaps = []
            ints = 0
            rk.wr(RKDA, w[1])
            rk.wr(RKBA, w[2])
            rk.wr(RKWC, w[3])
            seek0 = set(rk.seeking)
            if op == 10:
                deferred = w[4]
                rk.cs &= ~0o200                  # busy, as the emulator is for #RK_XFER_INSTRUCTIONS
                continue
            rk.wr(RKCS, w[4])
            want = w[5]
            if rk.req:                       # the interrupt at the end of the function (or at once)
                rk.req = False
                snaps.append((rk.rd(RKCS), rk.rd(RKDS)))
                ints += 1
            # the seek arriving: the hardware poll
            for d in sorted(rk.seeking - seek0) + sorted(rk.seeking & seek0):
                rk.seeking.discard(d)
                if rk.cs & 0o100:
                    rk.cs |= 0o20000
                    rk.intdrive = d
                    snaps.append((rk.rd(RKCS), rk.rd(RKDS)))
                    ints += 1
            line = "R " + " ".join("%06o" % rk.rd(r) for r in (RKCS, RKER, RKWC, RKBA, RKDA, RKDS))
            line += " %06o" % ints
            if want > ints:                  # the program waited for more and gave up
                line = " TIMEOUT" + line
            for c, s in snaps[:4]:
                line += " %06o %06o" % (c, s)
            out.append(line)
        elif op == 2:
            a, n, s = w[1], w[2], w[3]
            for i in range(n):
                mem[a + 2 * i] = s
                s = (s + 0o11065) & 0xFFFF
        elif op == 3:
            out.append("S %06o" % sum_(w[1], w[2]))
        elif op == 4:
            if w[1] >= 0o160000:
                rk.wr(w[1], w[2])
            else:
                mem[w[1]] = w[2]
        elif op == 5:
            a, v = w[1], w[2] & 0xFF
            cur = rk.rd(a & ~1) & ~(1 if (a & ~1) == RKCS else 0)
            nw = (cur & 0xFF) | (v << 8) if a & 1 else (cur & 0xFF00) | v
            rk.wr(a & ~1, nw)
        elif op == 6:
            out.append("V %06o" % (rk.rd(w[1]) if w[1] >= 0o160000 else mem.get(w[1], 0)))
        elif op == 7:
            ints = 0
            snaps = []
            if deferred is not None:
                rk.cs |= 0o200
                rk.wr(RKCS, deferred)
                deferred = None
            if rk.req:
                rk.req = False
                snaps.append((rk.rd(RKCS), rk.rd(RKDS)))
                ints = 1
            line = "R " + " ".join("%06o" % rk.rd(r) for r in (RKCS, RKER, RKWC, RKBA, RKDA, RKDS))
            line += " %06o" % ints
            for c, s in snaps:
                line += " %06o %06o" % (c, s)
            out.append(line)
        elif op == 8:
            out.append("K 000200 000000 000200+")
        elif op == 9:
            rk.init()
    out.append("END")
    return out


def check(log, drives=2):
    got = []
    for line in open(log, encoding="ascii", errors="replace"):
        line = line.rstrip("\r\n")
        if line.startswith("| "):
            got.append(line[2:].rstrip())
    want = expect(drives)
    bad = 0
    for i in range(max(len(want), len(got))):
        w = want[i] if i < len(want) else "(nothing)"
        g = got[i] if i < len(got) else "(nothing)"
        if w != g:
            bad += 1
            print("line %d differs:\n  model:    %s\n  emulator: %s" % (i + 1, w, g))
    print("rk11_model: %d lines, %d differ" % (len(want), bad))
    return bad == 0


CLOCK = r"""
LKS=177546
.=100
 .word kwisr,340
.=1000
start:  MOV #776,SP
        MTPS #0
        MOV #100,@#LKS
1$:     WAIT
        CMP ticks,#1130
        BLO 1$
        CLR @#LKS
        HALT
kwisr:  INC ticks
        RTI
ticks:  .word 0
"""


def main():
    ap = argparse.ArgumentParser(description="RK11 reference model and desk test.")
    ap.add_argument("--tape")
    ap.add_argument("--expect", action="store_true")
    ap.add_argument("--check")
    ap.add_argument("--drives", type=int, default=2, help="drives the firmware has: 2 for the RAM packs, 1 for the flash pack")
    ap.add_argument("--image", help="write a 4872-block RK05 image holding the pattern of drive 0, for the flash pack")
    ap.add_argument("--clock-tape", help="a program that takes 600 line-clock interrupts (WAITing between) and halts")
    a = ap.parse_args()
    if a.clock_tape:
        open(a.clock_tape, "wb").write(pdp11asm.tape(pdp11asm.Asm(CLOCK).assemble(), 0o1000))
        print("rk11_model: clock test -> %s (start 001000)" % a.clock_tape)
    if a.tape:
        open(a.tape, "wb").write(pdp11asm.tape(program(), 0o1000))
        print("rk11_model: test program -> %s (start 001000)" % a.tape)
    if a.image:
        out = bytearray()
        for b in range(BLOCKS):
            for i in range(256):
                w = pattern(0, b, i)
                out += bytes([w & 0xFF, w >> 8])
        open(a.image, "wb").write(out)
        print("rk11_model: pattern pack -> %s" % a.image)
    if a.expect:
        for l in expect(a.drives):
            print(l)
    if a.check:
        sys.exit(0 if check(a.check, a.drives) else 1)


if __name__ == "__main__":
    main()
