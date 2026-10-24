; desktop/machine_demo.pbi - two invented devices for the PDP-11 demo (the
; compiler's demo/, written in PureMetal): a raster display and a 4-voice tone
; generator. The PDP-11 had no standard raster display; this one is a
; framebuffer in memory that the program writes with ordinary MOVs.
;
; DESKTOP ONLY FOR NOW. The board's firmware does not have them (nothing in
; J11_18MHz_KDJ11_BF/pico2 changes): desktop_gen.py hooks them into the core
; at IoRead, IoWrite, WriteByte and DevService. They move into the board's
; sources when a board has a video and audio output for them.
;
; THE REGISTERS (octal; agreed with the compiler's PDP-11 back end, 2026-10-23;
; its board file names them DP_CSR, DP_BASE, DP_SCRY, DP_PAL, SND_VOICE0-3,
; SND_VOL, SND_CSR, FRAME_VECTOR). The user-device range 164000-164177.
;   DISPLAY  320 x 200, 4 bits a pixel, 160 bytes a row (32000 bytes); pixel x
;            of a row is in byte x/2, the LOW nibble the even (left) x
;     164000 DPCSR    bit 0 ENABLE, bit 6 IE (frame interrupt enable), bit 7
;                     FRAME (set at each 60 Hz vertical blank; writing 1
;                     clears it); the other bits read 0
;     164002 DPBASE   the framebuffer's physical address in 64-byte units, as a
;                     PAR: address = DPBASE << 6 (byte 100000 is DPBASE 001000)
;     164004 DPSCRY   the framebuffer row shown on the top line, 0-199 (wraps)
;     164006          reserved, reads 0
;     164040-164076   DPPAL0-15, 12-bit RGB: bits 11-8 red, 7-4 green, 3-0 blue
;     the frame interrupt: vector 320, BR4 - one request at each frame while IE
;     is set (and at once if IE is set with FRAME already set)
;   SOUND    4 voices; voice n at 164100 + 10n (164100, 164110, 164120, 164130):
;     +0 FREQ (Hz, 0 = silent, at most 20000)  +2 VOL (0-15)  +4 WAVE (0 square,
;     1 triangle, 2 sawtooth, 3 noise)  +6 reserved
;     164140 SNDVOL   the master volume, 0-15
;     164142 SNDCSR   bit 0 ENABLE (no sound while it is 0)
;   Everything else in 164000-164177 reads 0 and ignores writes.
;
; #DEMO_BASE, #INT_DEMO and #VEC_DEMO (000320: 300/304 are the second DL11's,
; docs/TERMINALS.md) are in machine.pbi, before the core that uses them.

#DEMO_W      = 320
#DEMO_H      = 200
#DEMO_ROW    = 160                   ; bytes a row
#DEMO_FRAME_US = 16667

Global DdCsr.l, DdBase.l = $100, DdScroll.l   ; DPBASE 000400: byte 040000, so 32000 bytes end below 160000
Global Dim DdPal.l(16)
Global Dim DdFreq.l(4)
Global Dim DdVol.l(4)
Global Dim DdWave.l(4)
Global DdMaster.l = 15, DdSndCsr.l
Global DdSeq.l, DdSeen.l             ; frames counted (DdTick, between slices) and acted on (DdPoll)
Global DdNext.l                      ; Micros() of the next frame
Global DdFrames.l                    ; frames since the start, for the window
Global DdUsed.l                      ; the program has touched a register: the window shows the display

Procedure DdReset()
  Protected i.l
  DdCsr = 0 : DdBase = $100 : DdScroll = 0 : DdMaster = 15 : DdSndCsr = 0 : DdUsed = 0
  For i = 0 To 15                    ; a default palette: the EGA's sixteen
    DdPal(i) = PeekU(?DdEgaPal + i * 2)
  Next
  For i = 0 To 3 : DdFreq(i) = 0 : DdVol(i) = 0 : DdWave(i) = 0 : Next
  IntReq = IntReq & ~#INT_DEMO
EndProcedure

Procedure.l DdRead(a.l)
  Protected r.l = (a - #DEMO_BASE) & $7E, n.l
  DdUsed = 1
  Select r
    Case 0 : ProcedureReturn DdCsr & $C1
    Case 2 : ProcedureReturn DdBase
    Case 4 : ProcedureReturn DdScroll
    Case $20 To $3E : ProcedureReturn DdPal((r - $20) >> 1)
    Case $40 To $5E
      n = (r - $40) >> 3
      Select r & 7
        Case 0 : ProcedureReturn DdFreq(n)
        Case 2 : ProcedureReturn DdVol(n)
        Case 4 : ProcedureReturn DdWave(n)
      EndSelect
    Case $60 : ProcedureReturn DdMaster
    Case $62 : ProcedureReturn DdSndCsr
  EndSelect
  ProcedureReturn 0
EndProcedure

Procedure DdWrite(a.l, v.l)
  Protected r.l = (a - #DEMO_BASE) & $7E, n.l, wasIe.l
  DdUsed = 1
  v & $FFFF
  Select r
    Case 0
      wasIe = DdCsr & $40
      If v & $80 : DdCsr & ~$80 : IntReq = IntReq & ~#INT_DEMO : EndIf   ; FRAME: write 1 to clear
      DdCsr = (DdCsr & $80) | (v & $41)
      If (DdCsr & $40) = 0
        IntReq = IntReq & ~#INT_DEMO
      ElseIf wasIe = 0 And (DdCsr & $80)
        IntReq = IntReq | #INT_DEMO
        IntCheck()
      EndIf
    Case 2 : DdBase = v
    Case 4 : DdScroll = v % #DEMO_H
    Case $20 To $3E : DdPal((r - $20) >> 1) = v & $FFF
    Case $40 To $5E
      n = (r - $40) >> 3
      Select r & 7
        Case 0 : DdFreq(n) = v
        Case 2 : DdVol(n) = v & 15
        Case 4 : DdWave(n) = v & 3
      EndSelect
    Case $60 : DdMaster = v & 15
    Case $62 : DdSndCsr = v & 1
  EndSelect
EndProcedure

; A byte write is a write of that byte into the register (the other byte kept).
Procedure DdWriteByte(a.l, v.l)
  Protected w.l = DdRead(a & $FFFE)
  If a & 1
    DdWrite(a & $FFFE, (w & $FF) | ((v & $FF) << 8))
  Else
    DdWrite(a, (w & $FF00) | (v & $FF))
  EndIf
EndProcedure

; Between slices (core 1's side, like KwTick): the 60 Hz vertical blank.
Procedure DdTick()
  Protected now.l = Micros()
  If now - DdNext >= 0
    DdNext = DdNext + #DEMO_FRAME_US
    If now - DdNext >= 0 : DdNext = now + #DEMO_FRAME_US : EndIf
    DdSeq = DdSeq + 1
  EndIf
EndProcedure

; In DevService (the processor's side): FRAME at a new frame, the request
; when enabled, and the interrupt taken when it is the only one asked for
; (with others, DevService's own chain takes theirs first: they are BR4 and
; above, and this is the lowest).
Procedure DdPoll()
  If DdSeq <> DdSeen
    DdSeen = DdSeq
    DdFrames + 1
    DdCsr = DdCsr | $80
    If DdCsr & $40
      IntReq = IntReq | #INT_DEMO
    EndIf
  EndIf
  If IntReq = #INT_DEMO
    If (PswHigh & $E0) < $80
      Waiting = 0
      IntReq = 0
      TakeTrap(#VEC_DEMO)
      TakeStackTrap()
    EndIf
  EndIf
EndProcedure

; A byte of physical memory for the display (0 where there is none).
Procedure.l DdByte(pa.l)
  If pa < #RAM_BYTES
    ProcedureReturn PeekA(@Mem(0) + pa)
  ElseIf pa < MemTop
    ProcedureReturn PeekA(PsMem + pa)
  EndIf
  ProcedureReturn 0
EndProcedure

; The frame as 32-bit pixels (B, G, R, A in memory), rows top first, each
; row rowStride bytes after the last (negative for bottom-up).
Procedure DdRender(*out, rowStride.l)
  Protected y.l, x.l, src.l, b.l, *p.Long, row.l, base.l = (DdBase << 6) & $3FFFFF
  Protected Dim c.l(16)
  For x = 0 To 15
    c(x) = $FF000000 | ((((DdPal(x) >> 8) & 15) * $11) << 16) | ((((DdPal(x) >> 4) & 15) * $11) << 8) | ((DdPal(x) & 15) * $11)
  Next
  For y = 0 To #DEMO_H - 1
    row = (y + DdScroll) % #DEMO_H
    src = base + row * #DEMO_ROW
    *p = *out + y * rowStride
    If src + #DEMO_ROW <= #RAM_BYTES                 ; the usual case: the row is in Mem()
      For x = 0 To #DEMO_ROW - 1
        b = PeekA(@Mem(0) + src + x)
        *p\l = c(b & 15) : *p + 4
        *p\l = c(b >> 4) : *p + 4
      Next
    Else
      For x = 0 To #DEMO_ROW - 1
        b = DdByte(src + x)
        *p\l = c(b & 15) : *p + 4
        *p\l = c(b >> 4) : *p + 4
      Next
    EndIf
  Next
EndProcedure

DataSection
  DdEgaPal:
  Data.u $000, $00A, $0A0, $0AA, $A00, $A0A, $A50, $AAA, $555, $55F, $5F5, $5FF, $F55, $F5F, $FF5, $FFF
EndDataSection
