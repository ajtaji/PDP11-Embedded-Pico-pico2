; desktop/machine_disasm.pbi - the desktop PDP-11's look at itself, for the
; window's panes: memory read without side effects (physical, and virtual
; through the MMU's registers as they stand), and a disassembler for the
; J-11's instruction set (the basic set, EIS, SPL/MARK/SOB/SXT/XOR, MFPT,
; MFPS/MTPS, the previous-mode moves, and the FPU's).

; A physical word, or -1 where there is no memory (the I/O page included).
Procedure.l MachPeekPhys(pa.l)
  pa & $3FFFFE
  If pa < #RAM_BYTES
    ProcedureReturn Mem(pa >> 1)
  ElseIf pa < MemTop
    ProcedureReturn PeekU(PsMem + pa)
  EndIf
  ProcedureReturn -1
EndProcedure

; The physical address a virtual one has in the current mode's I space, as
; the MMU's registers stand (no access check, no MMR change); -1 in the I/O page.
Procedure.l MachVirtToPhys(va.l)
  Protected r.l
  va & $FFFF
  If MmuOn = 0
    If va >= $E000 : ProcedureReturn -1 : EndIf
    ProcedureReturn va
  EndIf
  r = MapReg(CurI + (va >> 13))
  ProcedureReturn ((Par(r) << 6) + (va & $1FFF)) & MapMask
EndProcedure

Procedure.l MachPeekVirt(va.l)
  Protected pa.l = MachVirtToPhys(va)
  If pa < 0 : ProcedureReturn -1 : EndIf
  ProcedureReturn MachPeekPhys(pa)
EndProcedure

; ---- the disassembler -----------------------------------------------------
Global DisLen.l                    ; words the last instruction took

Procedure.s DisOct(v.l)
  Protected s$
  v & $FFFF
  Repeat : s$ = Chr('0' + (v & 7)) + s$ : v >> 3 : Until v = 0
  ProcedureReturn s$
EndProcedure

Procedure.s DisReg(r.l)
  Select r
    Case 6 : ProcedureReturn "SP"
    Case 7 : ProcedureReturn "PC"
  EndSelect
  ProcedureReturn "R" + Str(r)
EndProcedure

; One operand (6-bit mode/register) of the instruction at pc; it may take the
; next word (DisLen counts it).
Procedure.s DisOperand(spec.l, pc.l)
  Protected m.l = (spec >> 3) & 7, r.l = spec & 7, w.l, s$
  If r = 7 And (m = 2 Or m = 3 Or m = 6 Or m = 7)
    w = MachPeekVirt(pc + DisLen * 2) & $FFFF
    DisLen + 1
    Select m
      Case 2 : ProcedureReturn "#" + DisOct(w)
      Case 3 : ProcedureReturn "@#" + DisOct(w)
      Case 6 : ProcedureReturn DisOct((pc + DisLen * 2 + w) & $FFFF)
      Case 7 : ProcedureReturn "@" + DisOct((pc + DisLen * 2 + w) & $FFFF)
    EndSelect
  EndIf
  s$ = DisReg(r)
  Select m
    Case 0 : ProcedureReturn s$
    Case 1 : ProcedureReturn "(" + s$ + ")"
    Case 2 : ProcedureReturn "(" + s$ + ")+"
    Case 3 : ProcedureReturn "@(" + s$ + ")+"
    Case 4 : ProcedureReturn "-(" + s$ + ")"
    Case 5 : ProcedureReturn "@-(" + s$ + ")"
    Case 6, 7
      w = MachPeekVirt(pc + DisLen * 2) & $FFFF
      DisLen + 1
      If m = 6 : ProcedureReturn DisOct(w) + "(" + s$ + ")" : EndIf
      ProcedureReturn "@" + DisOct(w) + "(" + s$ + ")"
  EndSelect
EndProcedure

Procedure.s DisFpOperand(spec.l, pc.l)            ; mode 0 names an accumulator
  If (spec >> 3) & 7 = 0 : ProcedureReturn "AC" + Str(spec & 7) : EndIf
  ProcedureReturn DisOperand(spec, pc)
EndProcedure

; The instruction at virtual address pc, as text; DisLen its length in words.
Procedure.s Disasm(pc.l)
  Protected op.l, hi.l, s$, b.l, ac.l, f.l, cc$
  DisLen = 1
  op = MachPeekVirt(pc)
  If op < 0 : ProcedureReturn "(no memory)" : EndIf
  b = Bool(op & $8000)
  ; double operand
  Select (op >> 12) & 7
    Case 1 To 6
      s$ = StringField("MOV CMP BIT BIC BIS ADD", (op >> 12) & 7, " ")
      If b
        If (op >> 12) & 7 = 6 : s$ = "SUB" : Else : s$ + "B" : EndIf
      EndIf
      s$ + " " + DisOperand((op >> 6) & 63, pc)
      ProcedureReturn s$ + "," + DisOperand(op & 63, pc)
  EndSelect
  If (op & $F000) = $7000                         ; 07xxxx: EIS, XOR, SOB
    Select (op >> 9) & 7
      Case 0 To 3
        s$ = StringField("MUL DIV ASH ASHC", ((op >> 9) & 7) + 1, " ")
        ProcedureReturn s$ + " " + DisOperand(op & 63, pc) + "," + DisReg((op >> 6) & 7)
      Case 4 : ProcedureReturn "XOR " + DisReg((op >> 6) & 7) + "," + DisOperand(op & 63, pc)
      Case 7 : ProcedureReturn "SOB " + DisReg((op >> 6) & 7) + "," + DisOct((pc + 2 - (op & 63) * 2) & $FFFF)
    EndSelect
    ProcedureReturn ".WORD " + DisOct(op)
  EndIf
  If (op & $F000) = $F000                         ; 17xxxx: the FPU
    f = (op >> 8) & 15 : ac = (op >> 6) & 3
    If f = 0
      Select ac
        Case 0
          Select op & 63
            Case 0 : ProcedureReturn "CFCC"
            Case 1 : ProcedureReturn "SETF"
            Case 2 : ProcedureReturn "SETI"
            Case 9 : ProcedureReturn "SETD"
            Case 10 : ProcedureReturn "SETL"
          EndSelect
          ProcedureReturn ".WORD " + DisOct(op)
        Case 1 : ProcedureReturn "LDFPS " + DisOperand(op & 63, pc)
        Case 2 : ProcedureReturn "STFPS " + DisOperand(op & 63, pc)
        Case 3 : ProcedureReturn "STST " + DisOperand(op & 63, pc)
      EndSelect
    ElseIf f = 1
      ProcedureReturn StringField("CLRF TSTF ABSF NEGF", ac + 1, " ") + " " + DisFpOperand(op & 63, pc)
    EndIf
    s$ = StringField("- - MULF MODF ADDF LDF SUBF CMPF STF DIVF STEXP STCFI STCFD LDEXP LDCIF LDCDF", f + 1, " ")
    Select f
      Case 8, 10, 11, 12                          ; AC first
        ProcedureReturn s$ + " AC" + Str(ac) + "," + DisFpOperand(op & 63, pc)
      Case 13, 14                                 ; integer source
        ProcedureReturn s$ + " " + DisOperand(op & 63, pc) + ",AC" + Str(ac)
    EndSelect
    ProcedureReturn s$ + " " + DisFpOperand(op & 63, pc) + ",AC" + Str(ac)
  EndIf
  ; branches: 000400-003777, 100000-103777 (the offset a signed byte of words)
  hi = (op >> 8) & 7
  If (op & $F800) = $8000 Or ((op & $F800) = 0 And hi <> 0)
    If b
      s$ = StringField("BPL BMI BHI BLOS BVC BVS BCC BCS", hi + 1, " ")
    Else
      s$ = StringField("BR BNE BEQ BGE BLT BGT BLE", hi, " ")
    EndIf
    f = op & $FF
    If f & $80 : f - 256 : EndIf
    ProcedureReturn s$ + " " + DisOct((pc + 2 + f * 2) & $FFFF)
  EndIf
  If (op & $FF00) = $8800 : ProcedureReturn "EMT " + DisOct(op & $FF) : EndIf
  If (op & $FF00) = $8900 : ProcedureReturn "TRAP " + DisOct(op & $FF) : EndIf
  If (op & $FE00) = $0800 : ProcedureReturn "JSR " + DisReg((op >> 6) & 7) + "," + DisOperand(op & 63, pc) : EndIf
  ; single operand: 0050DD-0067DD and the byte forms
  Select op & $7FC0
    Case $0A00 To $0DC0
      s$ = StringField("CLR COM INC DEC NEG ADC SBC TST ROR ROL ASR ASL MARK MFPI MTPI SXT", ((op >> 6) & 63) - 40 + 1, " ")
      If b
        Select (op >> 6) & 63
          Case 52 : s$ = "MTPS"
          Case 53 : s$ = "MFPD"
          Case 54 : s$ = "MTPD"
          Case 55 : s$ = "MFPS"
          Default : s$ + "B"
        EndSelect
      EndIf
      If s$ = "MARK" : ProcedureReturn "MARK " + DisOct(op & 63) : EndIf
      ProcedureReturn s$ + " " + DisOperand(op & 63, pc)
  EndSelect
  If b : ProcedureReturn ".WORD " + DisOct(op) : EndIf
  Select op
    Case 0 : ProcedureReturn "HALT"
    Case 1 : ProcedureReturn "WAIT"
    Case 2 : ProcedureReturn "RTI"
    Case 3 : ProcedureReturn "BPT"
    Case 4 : ProcedureReturn "IOT"
    Case 5 : ProcedureReturn "RESET"
    Case 6 : ProcedureReturn "RTT"
    Case 7 : ProcedureReturn "MFPT"
    Case $40 To $7F : ProcedureReturn "JMP " + DisOperand(op & 63, pc)
    Case $80 To $87 : ProcedureReturn "RTS " + DisReg(op & 7)
    Case $98 To $9F : ProcedureReturn "SPL " + Str(op & 7)
    Case $A0, $B0 : ProcedureReturn "NOP"
    Case $A1 To $AF, $B1 To $BF
      If op & 8 : cc$ + "N" : EndIf
      If op & 4 : cc$ + "Z" : EndIf
      If op & 2 : cc$ + "V" : EndIf
      If op & 1 : cc$ + "C" : EndIf
      If op & $10 : ProcedureReturn "SE" + cc$ : EndIf
      ProcedureReturn "CL" + cc$
    Case $C0 To $FF : ProcedureReturn "SWAB " + DisOperand(op & 63, pc)
  EndSelect
  ProcedureReturn ".WORD " + DisOct(op)
EndProcedure
