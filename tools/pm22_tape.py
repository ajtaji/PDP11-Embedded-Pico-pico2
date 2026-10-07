#!/usr/bin/env python3
"""pm22_tape.py - the 22-bit memory and Unibus map test for the J-11
emulator, as an absolute-format tape (tools/tape_ladder.py runs it on a
board; start address 1000).

USE
    python pm22_tape.py -o media/diagnostics/papertape/pm22-memory-unibus.bin
    python pm22_tape.py --check media/diagnostics/papertape/pm22-memory-unibus.bin
                 (the file is what this source assembles to)
    python pm22_tape.py --source          prints the assembly source

WHAT THE PROGRAM DOES, on the emulated machine, and prints a line for each:
    1  sizes memory with 18-bit mapping: kernel page 6 is pointed at one
       64-byte click after another until a read traps through 4, and the
       first click that traps is printed as an address and in KB
    2  the same with 22-bit mapping on (MMR3 bit 4)
    3  writes a different word pair into every 8 KB page from 8 KB up, and
       the last word of memory, then reads them all back (an address line
       stuck or a wrapped address shows as a wrong word)
    4  checks that nothing answers at 17000000 and 17757700 (above the
       memory this machine has) and that the I/O page answers at 17760000
    5  writes and reads the 32 Unibus map registers (bit 0 of the low word
       reads 0, the high word keeps six bits, a byte write changes a byte)
       and loads them one to one
    6  with the map on (MMR3 bit 5): reads RK0 block 0 to bus address 20000,
       then to bus address 40000 with map register 2 pointing at physical
       10000000 (2 MB) and compares the two through the processor's own
       mapping, checking that physical 40000 was not touched; the same
       through bus address 220000 (MEX = 1) to physical 04000000; with the
       map off, to bus address 40000 = physical 40000; with a register
       pointing at 17000000, where there is no memory, the controller must
       report NXM; and a block written FROM physical 10000000 reads back
       (RK0 block 4871, the last of the swap area, saved first and put
       back afterwards)
    A machine whose 22-bit memory ends below 2 MB + 8 KB skips 6's high
    transfers and says so.
It ends with "END PASS" and waits in a loop, or with "FAIL nnn" and a HALT (nnn is the number
in the source beside the check that failed).
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pdp11asm  # noqa: E402

START = 0o1000
_n = [0]


def ok(branch, code):
    """A check: the branch is taken when all is well; else FAIL code."""
    _n[0] += 1
    lab = "k%d$" % _n[0]
    return "  %s %s\n  mov #%o,r0\n  jmp fail\n%s:\n" % (branch, lab, code, lab)


def source():
    _n[0] = 0
    s = r"""
PSW = 177776
MMR0 = 177572
MMR3 = 172516
KIPDR0 = 172300
KIPAR0 = 172340
KIPAR6 = 172354
KIPAR7 = 172356
UBMAP = 170200
RKER = 177402
RKCS = 177404
RKWC = 177406
RKBA = 177410
RKDA = 177412
XCSR = 177564
XBUF = 177566
WIN = 140000            ; kernel page 6: the window the test looks through

.=1000
start:
  mov #1000,sp
  mov #trap4,@#4
  mov #340,@#6
  mov #trapmm,@#250
  mov #340,@#252
  mov #msg0,r0
  jsr pc,puts
; the kernel's map: pages 0-6 one to one, read/write, full length
  mov #KIPAR0,r1
  mov #KIPDR0,r2
  clr r0
  mov #7,r3
1$:
  mov r0,(r1)+
  mov #77406,(r2)+
  add #200,r0
  sob r3,1$
  mov #77406,(r2)
; ---- 1: 18-bit mapping
  clr @#MMR3
  mov #7600,@#KIPAR7
  mov #1,@#MMR0
  jsr pc,size
  mov r4,top18
  mov #msg18,r0
  jsr pc,puts
  jsr pc,ptop
; ---- 2: 22-bit mapping
  clr @#MMR0
  mov #20,@#MMR3
  mov #177600,@#KIPAR7
  mov #1,@#MMR0
  jsr pc,size
  mov r4,top22
  mov #msg22,r0
  jsr pc,puts
  jsr pc,ptop
; ---- 3: a word pair in every 8 KB page, and the last word
  mov #200,r3
p1:
  cmp r3,r4
  bhis p2
  mov r3,@#KIPAR6
  mov r3,@#WIN
  mov r3,r0
  com r0
  mov r0,@#WIN+2
  add #200,r3
  bne p1
p2:
  mov r4,r0
  dec r0
  mov r0,@#KIPAR6
  mov #125252,@#WIN+76
  mov #200,r3
p3:
  cmp r3,r4
  bhis p4
  mov r3,@#KIPAR6
  cmp r3,@#WIN
""" + ok("beq", 0o301) + r"""
  mov r3,r0
  com r0
  cmp r0,@#WIN+2
""" + ok("beq", 0o302) + r"""
  add #200,r3
  bne p3
p4:
  mov r4,r0
  dec r0
  mov r0,@#KIPAR6
  cmp #125252,@#WIN+76
""" + ok("beq", 0o303) + r"""
  mov #msg3,r0
  jsr pc,puts
; ---- 4: nothing above the memory fitted; the I/O page answers
  mov #170000,@#KIPAR6
  clr r5
  tst @#WIN
  tst r5
""" + ok("bne", 0o401) + r"""
  mov #177577,@#KIPAR6
  clr r5
  tst @#WIN
  tst r5
""" + ok("bne", 0o402) + r"""
  mov #177600,@#KIPAR6
  clr r5
  tst @#WIN+17776
  tst r5
""" + ok("beq", 0o403) + r"""
  mov #msg4,r0
  jsr pc,puts
; ---- 5: the Unibus map registers
  mov #UBMAP,r1
  mov #40,r3
u1:
  mov #177777,(r1)
  cmp (r1),#177776
""" + ok("beq", 0o501) + r"""
  mov #177777,2(r1)
  cmp 2(r1),#77
""" + ok("beq", 0o502) + r"""
  clr (r1)+
  clr (r1)+
  sob r3,u1
  movb #377,@#UBMAP+175
  cmp @#UBMAP+174,#177400
""" + ok("beq", 0o503) + r"""
  movb #125,@#UBMAP+174
  cmp @#UBMAP+174,#177524
""" + ok("beq", 0o504) + r"""
  jsr pc,ident
  cmp @#UBMAP+44,#20000
""" + ok("beq", 0o505) + r"""
  cmp @#UBMAP+46,#1
""" + ok("beq", 0o506) + r"""
  tst r5
""" + ok("beq", 0o507) + r"""
  mov #msg5,r0
  jsr pc,puts
; ---- 6: the RK11 through the map
  mov #60,@#MMR3
  mov #5,r0               ; read block 0 to bus 20000 = physical 20000
  mov #20000,r1
  clr r2
  jsr pc,rkio
""" + ok("bpl", 0o601) + r"""
  mov #20000,r1           ; the boot block is not all zeros
  mov #400,r3
  clr r0
r1:
  bis (r1)+,r0
  sob r3,r1
  tst r0
""" + ok("bne", 0o602) + r"""
  cmp top22,#100200
  bhis r2
  mov #msg6s,r0
  jsr pc,puts
  jmp r9
r2:
  mov #40000,r1           ; physical 40000 gets a mark that must stay
  mov #400,r3
r3:
  mov #52525,(r1)+
  sob r3,r3
  mov #100000,@#KIPAR6    ; physical 10000000, cleared
  jsr pc,clrwin
  clr @#UBMAP+10          ; map register 2 -> physical 10000000
  mov #40,@#UBMAP+12
  mov #5,r0
  mov #40000,r1
  clr r2
  jsr pc,rkio
""" + ok("bpl", 0o603) + r"""
  mov #WIN,r1
  mov #20000,r2
  jsr pc,cmpblk
""" + ok("beq", 0o604) + r"""
  mov #40000,r1
  mov #400,r3
r4:
  cmp #52525,(r1)+
""" + ok("beq", 0o605) + r"""
  sob r3,r4
  mov #40000,@#KIPAR6     ; physical 04000000, cleared
  jsr pc,clrwin
  clr @#UBMAP+44          ; map register 9 (bus 220000) -> physical 04000000
  mov #20,@#UBMAP+46
  mov #25,r0              ; read, MEX = 1
  mov #20000,r1
  clr r2
  jsr pc,rkio
""" + ok("bpl", 0o606) + r"""
  mov #WIN,r1
  mov #20000,r2
  jsr pc,cmpblk
""" + ok("beq", 0o607) + r"""
  mov #20,@#MMR3          ; the map off: bus 40000 is physical 40000
  mov #5,r0
  mov #40000,r1
  clr r2
  jsr pc,rkio
""" + ok("bpl", 0o610) + r"""
  mov #40000,r1
  mov #20000,r2
  jsr pc,cmpblk
""" + ok("beq", 0o611) + r"""
  mov #60,@#MMR3          ; a register pointing where no memory is: NXM
  clr @#UBMAP+14
  mov #74,@#UBMAP+16
  mov #5,r0
  mov #60000,r1
  clr r2
  jsr pc,rkio
""" + ok("bmi", 0o612) + r"""
  bit #2000,@#RKER
""" + ok("bne", 0o613) + r"""
  jsr pc,ident            ; one to one again, then register 2 -> 10000000
  clr @#UBMAP+10
  mov #40,@#UBMAP+12
  mov #5,r0               ; block 4871 saved at physical 60000
  mov #60000,r1
  mov #14533,r2
  jsr pc,rkio
""" + ok("bpl", 0o614) + r"""
  mov #100000,@#KIPAR6    ; a pattern at physical 10000000
  mov #WIN,r1
  mov #400,r3
  mov #1,r0
r5:
  mov r0,(r1)+
  add #3,r0
  sob r3,r5
  mov #3,r0               ; written from there to block 4871
  mov #40000,r1
  mov #14533,r2
  jsr pc,rkio
""" + ok("bpl", 0o615) + r"""
  mov #5,r0               ; and read back low
  mov #20000,r1
  mov #14533,r2
  jsr pc,rkio
""" + ok("bpl", 0o616) + r"""
  mov #WIN,r1
  mov #20000,r2
  jsr pc,cmpblk
""" + ok("beq", 0o617) + r"""
  mov #3,r0               ; block 4871 put back
  mov #60000,r1
  mov #14533,r2
  jsr pc,rkio
""" + ok("bpl", 0o620) + r"""
  tst r5
""" + ok("beq", 0o621) + r"""
  mov #msg6,r0
  jsr pc,puts
r9:
  mov #msgend,r0
  jsr pc,puts
  clr @#MMR0
done:
  br done                 ; a HALT is the sign of a failure: a pass waits here

; ---- the first click that does not answer, in r4
size:
  clr r4
1$:
  mov r4,@#KIPAR6
  clr r5
  tst @#WIN
  tst r5
  bne 2$
  inc r4
  bne 1$
2$:
  clr r5
  rts pc

; ---- r4 as an address (the click and two more octal zeros) and in KB
ptop:
  mov r4,r0
  jsr pc,oct
  mov #msgz,r0
  jsr pc,puts
  mov r4,r1
  clr r0
  div #20,r0
  jsr pc,dec
  mov #msgkb,r0
  jsr pc,puts
  rts pc

; ---- the map one to one: register n holds n * 20000
ident:
  mov #UBMAP,r1
  clr r2
  clr r0
  mov #37,r3
1$:
  mov r2,(r1)+
  mov r0,(r1)+
  add #20000,r2
  adc r0
  sob r3,1$
  rts pc

; ---- one block: r0 = RKCS (function, MEX, GO), r1 = RKBA, r2 = RKDA.
;      Returns with the flags of RKCS (minus = an error).
rkio:
  mov #1,@#RKCS
1$:
  tstb @#RKCS
  bpl 1$
  mov r2,@#RKDA
  mov r1,@#RKBA
  mov #-400,@#RKWC
  mov r0,@#RKCS
2$:
  tstb @#RKCS
  bpl 2$
  tst @#RKCS
  rts pc

clrwin:
  mov #WIN,r1
  mov #400,r3
1$:
  clr (r1)+
  sob r3,1$
  rts pc

; ---- 256 words at r1 against 256 at r2: equal on return if the same
cmpblk:
  mov #400,r3
1$:
  cmp (r1)+,(r2)+
  bne 2$
  sob r3,1$
  clr r3
2$:
  tst r3
  rts pc

puts:
  movb (r0)+,r1
  beq 1$
  jsr pc,putc
  br puts
1$:
  rts pc

putc:
  tstb @#XCSR
  bpl putc
  movb r1,@#XBUF
  rts pc

oct:
  mov r0,r2
  clr r1
  asl r2
  rol r1
  add #60,r1
  jsr pc,putc
  mov #5,r3
1$:
  clr r1
  asl r2
  rol r1
  asl r2
  rol r1
  asl r2
  rol r1
  add #60,r1
  jsr pc,putc
  sob r3,1$
  rts pc

dec:
  mov r0,r1
  clr r2
1$:
  clr r0
  div #12,r0
  add #60,r1
  mov r1,-(sp)
  inc r2
  mov r0,r1
  bne 1$
2$:
  mov (sp)+,r1
  jsr pc,putc
  sob r2,2$
  rts pc

trap4:
  mov #1,r5
  rti

trapmm:
  mov #250,r0
fail:
  mov r0,r4
  mov #msgf,r0
  jsr pc,puts
  mov r4,r0
  jsr pc,oct
  mov #msgnl,r0
  jsr pc,puts
  halt

top18: .word 0
top22: .word 0
msg0: .ascii /\r\nPM22 22-BIT MEMORY AND UNIBUS MAP TEST\r\n\0/
msg18: .ascii /18-BIT MAPPING: MEMORY ENDS AT \0/
msg22: .ascii /22-BIT MAPPING: MEMORY ENDS AT \0/
msgz: .ascii /00, \0/
msgkb: .ascii / KB\r\n\0/
msg3: .ascii /A WORD PAIR IN EVERY 8 KB PAGE AND THE LAST WORD OF MEMORY: OK\r\n\0/
msg4: .ascii /NO MEMORY AT 17000000 AND 17757700, THE I-O PAGE AT 17760000: OK\r\n\0/
msg5: .ascii /UNIBUS MAP REGISTERS 17770200-17770376: OK\r\n\0/
msg6: .ascii /RK11 THROUGH THE MAP TO 10000000 AND 04000000, MAP OFF, NXM, WRITE FROM 10000000: OK\r\n\0/
msg6s: .ascii /LESS THAN 2 MB + 8 KB OF MEMORY: THE RK11 TRANSFERS ABOVE 248 KB WERE NOT RUN\r\n\0/
msgend: .ascii /END PASS\r\n\0/
msgf: .ascii /FAIL \0/
msgnl: .ascii /\r\n\0/
"""
    return s


def build():
    words = pdp11asm.Asm(source()).assemble()
    return pdp11asm.tape(words, START), words


def main():
    ap = argparse.ArgumentParser(description="The 22-bit memory and Unibus map test tape.")
    ap.add_argument("-o", "--out")
    ap.add_argument("--check")
    ap.add_argument("--source", action="store_true")
    a = ap.parse_args()
    if a.source:
        print(source())
        return
    data, words = build()
    if a.check:
        if open(a.check, "rb").read() != data:
            sys.exit("pm22_tape: %s is NOT what this source assembles to. Write it again with -o." % a.check)
        print("pm22_tape: %s is what this source assembles to (%d bytes)" % (a.check, len(data)))
        return
    if not a.out:
        sys.exit("pm22_tape: give -o FILE, --check FILE or --source.")
    open(a.out, "wb").write(data)
    print("pm22_tape: wrote %s, %d bytes, %06o-%06o, start %06o" % (a.out, len(data), min(words), max(words), START))


if __name__ == "__main__":
    main()
