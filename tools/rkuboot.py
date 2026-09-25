#!/usr/bin/env python3
"""rkuboot.py - the RK05 boot block for Seventh Edition Unix.

The V7 tape carries only /mdec/rpuboot.s and hpuboot.s, the 512-byte
programs that sit in block 0 of an RP03 or RP04 pack. This is rpuboot.s
with its disk driver (rblk) rewritten for the RK11 - everything else is
the same program, line for line: the RK05 bootstrap ROM (or the emulator's
BOOT RK0) reads block 0 to address 0 and jumps there; it copies itself to
the top of 28K words (157000), reads a path name from the console, walks
the V7 file system from the root inode to that file, loads it at 0 (over
the a.out header, if it has one) and calls it. The file is normally /boot,
the standalone boot, which then loads the kernel.

    rblk, for the RK: the block number in dno; cylinder*2+surface =
    block / 12 and the sector = block % 12 (DIV), so
    RKDA = (block / 12) << 4 | block % 12, drive 0; then RKBA = buf,
    RKWC = -256, RKCS = read + go, and wait for RDY.

USE
    python rkuboot.py -o rkuboot.bin            the 512-byte block
    python rkuboot.py --into PACK               write it into block 0 of an image
    python rkuboot.py --test-pack OUT NAME=FILE ...
        a small V7 file system (root directory and the named files, each
        up to 10 + 128 blocks, as this boot program can load) with the boot
        block in block 0 - the desk proof of the boot block, not a Unix
        pack.

The source below is in pdp11asm.py's syntax (# immediate, @# absolute,
labels for 1f/1b). Where it follows rpuboot.s the labels keep that file's
comments.
"""
import argparse
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pdp11asm  # noqa: E402

SOURCE = r"""
; disk boot program to load and transfer to a unix entry (V7 rpuboot.s,
; with rblk for the RK11). entry is made by jsr pc,@#0, so return can be rts pc
CORE = 28.
TOP = 157000                   ; [core*2048.]-512.
RKCS = 177404
RKWC = 177406
RKBA = 177410
RKDA = 177412
TKS = 177560
TKB = 177562
TPS = 177564
TPB = 177566
INOD = TOP-2000                ; ..-1024.
ADDR = INOD+14                 ; inod+12.
BUF = INOD+100                 ; inod+64.
BNO = BUF+1000                 ; buf+512.
DNO = BNO+2
NAMES = DNO+2

.=TOP
; establish sp and check if running below intended origin, if so, copy
; program up to 'core' K words.
start:  MOV #TOP,SP
        MOV SP,R1
        CMP PC,R1
        BHIS clr0
        CLR R0
        CMP (R0),#407
        BNE cpy
        MOV #20,R0
cpy:    MOV (R0)+,(R1)+
        CMP R1,#end
        BLO cpy
        JMP (SP)
; clear core to make things clean
clr0:   CLR (R0)+
        CMP R0,SP
        BLO clr0
; at origin, read pathname; spread out in array 'names', one component
; every 14 bytes
        MOV #NAMES,R1
nam1:   MOV R1,R2
nam2:   JSR PC,getc
        CMP R0,#12
        BEQ walk
        CMP R0,#57
        BEQ nam3
        MOVB R0,(R2)+
        BR nam2
nam3:   CMP R1,R2
        BEQ nam2
        ADD #14.,R1
        BR nam1
; now start reading the inodes starting at the root and going through
; directories
walk:   MOV #NAMES,R1
        MOV #2,R0
wk1:    CLR @#BNO
        JSR PC,iget
        TST (R1)
        BEQ load
wk2:    JSR PC,rmblk
        BR start
        MOV #BUF,R2
wk3:    MOV R1,R3
        MOV R2,R4
        ADD #16.,R2
        TST (R4)+
        BEQ wk5
wk4:    CMPB (R3)+,(R4)+
        BNE wk5
        CMP R4,R2
        BLO wk4
        MOV -16.(R2),R0
        ADD #14.,R1
        BR wk1
wk5:    CMP R2,#BUF+1000
        BLO wk3
        BR wk2
; read file into core until a mapping error (no disk address)
load:   CLR R1
ld1:    JSR PC,rmblk
        BR ld3
        MOV #BUF,R2
ld2:    MOV (R2)+,(R1)+
        CMP R2,#BUF+1000
        BLO ld2
        BR ld1
; relocate core around assembler header
ld3:    CLR R0
        CMP (R0),#407
        BNE ld5
ld4:    MOV 20(R0),(R0)+
        CMP R0,SP
        BLO ld4
; enter program and restart if return
ld5:    JSR PC,@#0
        BR start

; get the inode specified in r0
iget:   ADD #15.,R0
        MOV R0,R5
        ASH #-3.,R0
        BIC #160000,R0
        MOV R0,@#DNO
        CLR R0
        JSR PC,rblk
        BIC #177770,R5
        ASH #6,R5
        ADD #BUF,R5
        MOV #INOD,R4
ig1:    MOV (R5)+,(R4)+
        CMP R4,#INOD+100
        BLO ig1
        RTS PC

; read a mapped block; offset in file is in bno. skip if success, no skip
; if fail. the algorithm only handles a single indirect block, so files
; longer than 10+128 blocks cannot be loaded.
rmblk:  ADD #2,(SP)
        MOV @#BNO,R0
        CMP R0,#10.
        BLT rm1
        MOV #10.,R0
rm1:    MOV R0,-(SP)
        ASL R0
        ADD (SP)+,R0
        ADD #ADDR+1,R0
        MOVB (R0)+,@#DNO
        MOVB (R0)+,@#DNO+1
        MOVB -3(R0),R0
        BNE rm2
        TST @#DNO
        BEQ rm4
rm2:    JSR PC,rblk
        MOV @#BNO,R0
        INC @#BNO
        SUB #10.,R0
        BLT rm5
        ASH #2,R0
        MOV BUF+2(R0),@#DNO
        MOV BUF(R0),R0
        BNE rblk
        TST @#DNO
        BNE rblk
rm4:    SUB #2,(SP)
rm5:    RTS PC

; rk05 disk driver. low order address in dno, high order in r0 (always 0
; on an RK05, 4872 blocks).
rblk:   MOV R1,-(SP)
        MOV @#DNO,R1
        CLR R0
        DIV #12.,R0
        ASH #4,R0
        BIS R1,R0
        MOV R0,@#RKDA
        MOV #BUF,@#RKBA
        MOV #-256.,@#RKWC
        MOV #5,@#RKCS
rb1:    TSTB @#RKCS
        BPL rb1
        MOV (SP)+,R1
        RTS PC

; read and echo a teletype character
getc:   MOV #TKS,R0
        INC (R0)
gc1:    TSTB (R0)
        BPL gc1
        MOV @#TKB,R0
        BIC #177600,R0
        CMP R0,#101
        BLO putc
        CMP R0,#132
        BHI putc
        ADD #40,R0
; print a teletype character
putc:   TSTB @#TPS
        BPL putc
        MOV R0,@#TPB
        CMP R0,#15
        BNE pc1
        MOV #12,R0
        BR putc
pc1:    RTS PC
end:
"""


def block():
    words = pdp11asm.Asm(SOURCE).assemble()
    lo, hi = min(words), max(words) + 2
    if hi - lo > 512:
        sys.exit("rkuboot: the boot program is %d bytes; a boot block holds 512." % (hi - lo))
    out = bytearray(512)
    for a, w in words.items():
        struct.pack_into("<H", out, a - lo, w)
    return bytes(out), hi - lo


def ltol3(n):
    return bytes([(n >> 16) & 0xFF, n & 0xFF, (n >> 8) & 0xFF])


def test_pack(out, files, boot):
    """A minimal V7 file system: block 0 boot, 1 superblock, 2-3 i-list
    (16 inodes), then data. Root is inode 2."""
    isize = 2
    blocks = {0: boot}
    nxt = 2 + isize
    inodes = {}

    def put(data):
        nonlocal nxt
        bl = []
        for i in range(0, len(data), 512):
            blocks[nxt] = data[i:i + 512].ljust(512, b"\0")
            bl.append(nxt)
            nxt += 1
        addr = bl[:10]
        if len(bl) > 10:
            if len(bl) > 10 + 128:
                sys.exit("rkuboot: a test file is longer than 138 blocks.")
            ind = bytearray(512)
            for k, b in enumerate(bl[10:]):
                struct.pack_into("<HH", ind, 4 * k, b >> 16, b & 0xFFFF)
            blocks[nxt] = bytes(ind)
            addr.append(nxt)
            nxt += 1
        return addr

    names = []
    ino = 3
    for name, path in files:
        data = open(path, "rb").read()
        inodes[ino] = (0o100755, data, put(data))
        names.append((name, ino))
        ino += 1
    d = bytearray()
    for n, i in [(".", 2), ("..", 2)] + names:
        d += struct.pack("<H", i) + n.encode("ascii")[:14].ljust(14, b"\0")
    inodes[2] = (0o040755, bytes(d), put(bytes(d)))
    for i, (mode, data, addr) in inodes.items():
        b = 2 + (i - 1) // 8
        blk = bytearray(blocks.get(b, bytes(512)))
        o = ((i - 1) % 8) * 64
        struct.pack_into("<HhhhHH", blk, o, mode, 2 if mode & 0o040000 else 1, 0, 0,
                         len(data) >> 16, len(data) & 0xFFFF)
        a = b"".join(ltol3(x) for x in addr).ljust(40, b"\0")
        blk[o + 12:o + 52] = a
        blocks[b] = bytes(blk)
    sb = bytearray(512)
    struct.pack_into("<HHH", sb, 0, isize, 0, nxt)       # s_isize, s_fsize (long)
    blocks[1] = bytes(sb)
    img = bytearray(512 * nxt)
    for b, data in blocks.items():
        img[512 * b:512 * b + 512] = data
    open(out, "wb").write(img)
    return nxt


def main():
    ap = argparse.ArgumentParser(description="The RK05 boot block for V7 Unix.")
    ap.add_argument("-o")
    ap.add_argument("--into")
    ap.add_argument("--test-pack", nargs="+", metavar="ARG")
    a = ap.parse_args()
    boot, n = block()
    if a.o:
        open(a.o, "wb").write(boot)
        print("rkuboot: %d bytes of program -> %s" % (n, a.o))
    if a.into:
        img = bytearray(open(a.into, "rb").read())
        img[0:512] = boot
        open(a.into, "wb").write(img)
        print("rkuboot: written into block 0 of %s" % a.into)
    if a.test_pack:
        out = a.test_pack[0]
        files = [tuple(x.split("=", 1)) for x in a.test_pack[1:]]
        nb = test_pack(out, files, boot)
        print("rkuboot: test pack %s, %d blocks, files %s" % (out, nb, ", ".join(f for f, _ in files)))


if __name__ == "__main__":
    main()
