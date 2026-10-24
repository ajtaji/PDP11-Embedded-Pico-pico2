; desktop/machine_tape.pbi - paper tapes on the desktop PDP-11: what the board's
; serial tape reader does for tools/tape_ladder.py (diag.pico2, THE SERIAL TAPE
; READER: R, T, W, G), done from the tape files themselves, and the ladder's
; verdicts judged the way tape_ladder.py judges them.
;
; A tape is an absolute-format image (.bin, .bic, .ptap: the punch bytes) or a
; PCjs tape (.json: {"exec": ..., "words": [...]}, the bytes as words, hex
; literals allowed). The ladder plan is media/diagnostics/ladder.txt:
;   name | tape (relative to the plan's folder) | options | seconds
; with the options --start OCTAL, --switches OCTAL, --patch A=W,... (octal).

Global MachTapeWhy$                ; the last tape's complaint
Global MachTapeStart.l             ; the tape's transfer address (odd: do not start)
Global MachTapeExec.l = -1         ; a PCjs tape's documented start, -1 none
Global MachBells.l                 ; bells the program has typed since its start
Global MachTapeText$               ; what it typed since its start, for the verdict

; The tape's bytes into *buf (a new buffer); its length, 0 when it cannot be read.
Procedure.i MachTapeBytes(file$, *len.Long)
  Protected f.i, n.l, *b, s$, p.l, q.l, v.l, c.l, words.l
  MachTapeExec = -1
  f = ReadFile(#PB_Any, file$)
  If f = 0
    MachTapeWhy$ = "cannot open " + file$
    ProcedureReturn 0
  EndIf
  n = Lof(f)
  *b = AllocateMemory(n + 16)
  ReadData(f, *b, n)
  CloseFile(f)
  If LCase(GetExtensionPart(file$)) <> "json"
    *len\l = n
    ProcedureReturn *b
  EndIf
  ; a PCjs tape: "exec" and the "words" list; numbers decimal or 0x hex
  s$ = PeekS(*b, n, #PB_Ascii)
  FreeMemory(*b)
  *b = AllocateMemory(Len(s$) + 16)
  p = FindString(s$, Chr(34) + "exec" + Chr(34))
  If p
    p = FindString(s$, ":", p) + 1
    While Mid(s$, p, 1) = " " : p + 1 : Wend
    q = p
    While FindString("0123456789abcdefABCDEFx", Mid(s$, q, 1)) : q + 1 : Wend
    If LCase(Left(Mid(s$, p, q - p), 2)) = "0x"
      MachTapeExec = Val("$" + Mid(s$, p + 2, q - p - 2))
    Else
      MachTapeExec = Val(Mid(s$, p, q - p))
    EndIf
  EndIf
  p = FindString(s$, Chr(34) + "words" + Chr(34))
  If p = 0
    MachTapeWhy$ = file$ + " has no " + Chr(34) + "words" + Chr(34) + " list, so it is not a PCjs tape"
    FreeMemory(*b)
    ProcedureReturn 0
  EndIf
  p = FindString(s$, "[", p) + 1
  Repeat
    c = Asc(Mid(s$, p, 1))
    If c = ']' Or c = 0 : Break : EndIf
    If c >= '0' And c <= '9'
      q = p
      While FindString("0123456789abcdefABCDEFx", Mid(s$, q, 1)) : q + 1 : Wend
      If LCase(Mid(s$, p, 2)) = "0x"
        v = Val("$" + Mid(s$, p + 2, q - p - 2))
      Else
        v = Val(Mid(s$, p, q - p))
      EndIf
      PokeA(*b + words * 2, v & $FF)
      PokeA(*b + words * 2 + 1, (v >> 8) & $FF)
      words + 1
      p = q
    Else
      p + 1
    EndIf
  ForEver
  *len\l = words * 2
  ProcedureReturn *b
EndProcedure

; Load an absolute-format tape into memory, as the absolute loader does (and
; tape2pico.parse_absolute checks): 1 loaded, 0 with MachTapeWhy$.
Procedure.l MachLoadTape(file$)
  Protected *d, n.Long, pos.l, count.l, addr.l, i.l, sum.l, blocks.l, a.l
  *d = MachTapeBytes(file$, @n)
  If *d = 0 : ProcedureReturn 0 : EndIf
  Repeat
    While pos < n\l And PeekA(*d + pos) = 0 : pos + 1 : Wend
    If pos + 6 > n\l Or PeekA(*d + pos) <> 1 Or PeekA(*d + pos + 1) <> 0
      MachTapeWhy$ = file$ + ": no absolute-format block at byte " + Str(pos) + " after " + Str(blocks) + " blocks"
      FreeMemory(*d)
      ProcedureReturn 0
    EndIf
    count = PeekA(*d + pos + 2) | (PeekA(*d + pos + 3) << 8)
    addr = PeekA(*d + pos + 4) | (PeekA(*d + pos + 5) << 8)
    If count < 6 Or pos + count + 1 > n\l
      MachTapeWhy$ = file$ + ": block " + Str(blocks + 1) + " does not fit the tape"
      FreeMemory(*d)
      ProcedureReturn 0
    EndIf
    sum = 0
    For i = 0 To count : sum + PeekA(*d + pos + i) : Next
    If sum & $FF
      MachTapeWhy$ = file$ + ": block " + Str(blocks + 1) + " has a bad checksum"
      FreeMemory(*d)
      ProcedureReturn 0
    EndIf
    blocks + 1
    If count = 6
      MachTapeStart = addr
      FreeMemory(*d)
      ProcedureReturn 1
    EndIf
    For i = 0 To count - 7
      a = (addr + i) & $FFFF
      If a & 1
        Mem(a >> 1) = (Mem(a >> 1) & $FF) | (PeekA(*d + pos + 6 + i) << 8)
      Else
        Mem(a >> 1) = (Mem(a >> 1) & $FF00) | PeekA(*d + pos + 6 + i)
      EndIf
    Next
    pos + count + 1
  ForEver
EndProcedure

; The board's R: reset, memory cleared.
Procedure MachTapeReset()
  CpuReset()
  FillMemory(@Mem(0), #RAM_BYTES, 0, #PB_Byte)
  Halted = 1
EndProcedure

; The board's G (StartCpu, StartProgram): reset, switches, PSW 0, SP = PC = start.
Procedure MachTapeGo(start.l, switches.l)
  CpuReset()
  SwitchReg = switches & $FFFF
  PswSet(0)
  Reg(6) = start
  Reg(7) = start
  ConInTail = ConInHead
  ConOutTail = ConOutHead
  KwNext = Micros() + #KW_PERIOD_US
  MachTotal = 0
  MachBells = 0
  MachTapeText$ = ""
  MachBootDrive = -1
EndProcedure

; What the program typed, as the board's core 1 takes it: a bell counted, the
; rest kept for the verdict and handed back (-1 none).
Procedure.l MachTapeChar()
  Protected c.l = MachConGet()
  If c = 7
    MachBells + 1
  ElseIf c > 0 And c <> 127 And c <> 13
    MachTapeText$ + Chr(c)
    If Len(MachTapeText$) > 8000 : MachTapeText$ = Right(MachTapeText$, 4000) : EndIf
  EndIf
  ProcedureReturn c
EndProcedure

; tape_ladder.py's verdict: "PASS", "FAIL" or "" (none yet). A HALT is FAIL.
Procedure.s MachTapeVerdict()
  Protected t$ = MachTapeText$, p.l, line$, e$
  If Halted
    ProcedureReturn "FAIL"
  EndIf
  ; an XXDP pass line counts its errors, judged once the line is whole
  p = FindString(t$, "END PASS")
  While p
    line$ = Mid(t$, p)
    If FindString(line$, Chr(10)) = 0
      ProcedureReturn ""                  ; not whole yet
    EndIf
    line$ = Left(line$, FindString(line$, Chr(10)) - 1)
    If FindString(line$, "TOTAL ERRORS SINCE LAST REPORT")
      e$ = Trim(Mid(line$, FindString(line$, "TOTAL ERRORS SINCE LAST REPORT") + 30))
      If Val(e$) : ProcedureReturn "FAIL" : EndIf
    EndIf
    ProcedureReturn "PASS"
  Wend
  If MachBells > 0 Or FindString(t$, "END OF")
    ProcedureReturn "PASS"
  EndIf
  ProcedureReturn ""
EndProcedure

; ---- the ladder plan ---------------------------------------------------------
Structure MachRung
  name$
  tape$
  start.l                          ; -1 the tape's own
  switches.l
  patch$
  seconds.l
EndStructure
Global NewList MachLadder.MachRung()

Procedure.l MachOct(s$)
  Protected v.l, i.l
  For i = 1 To Len(s$) : v = v * 8 + Val(Mid(s$, i, 1)) : Next
  ProcedureReturn v
EndProcedure

Procedure.l MachReadLadder(plan$)
  Protected f.i, l$, dir$ = GetPathPart(plan$), opts$, w$, i.l
  ClearList(MachLadder())
  f = ReadFile(#PB_Any, plan$)
  If f = 0
    MachTapeWhy$ = "cannot open " + plan$
    ProcedureReturn 0
  EndIf
  While Not Eof(f)
    l$ = Trim(ReadString(f))
    If l$ = "" Or Left(l$, 1) = "#" : Continue : EndIf
    AddElement(MachLadder())
    MachLadder()\name$ = Trim(StringField(l$, 1, "|"))
    MachLadder()\tape$ = dir$ + ReplaceString(Trim(StringField(l$, 2, "|")), "/", "\")
    MachLadder()\seconds = Val(Trim(StringField(l$, 4, "|")))
    If MachLadder()\seconds <= 0 : MachLadder()\seconds = 120 : EndIf
    MachLadder()\start = -1
    opts$ = Trim(StringField(l$, 3, "|"))
    For i = 1 To CountString(opts$, " ") + 1
      w$ = StringField(opts$, i, " ")
      Select w$
        Case "--start" : i + 1 : MachLadder()\start = MachOct(StringField(opts$, i, " "))
        Case "--switches" : i + 1 : MachLadder()\switches = MachOct(StringField(opts$, i, " "))
        Case "--patch" : i + 1 : MachLadder()\patch$ = StringField(opts$, i, " ")
      EndSelect
    Next
  Wend
  CloseFile(f)
  ProcedureReturn ListSize(MachLadder())
EndProcedure

; Load and start the current rung: 1 started, 0 with MachTapeWhy$.
Procedure.l MachRungStart()
  Protected start.l, i.l, item$
  MachTapeReset()
  If MachLoadTape(MachLadder()\tape$) = 0 : ProcedureReturn 0 : EndIf
  start = MachLadder()\start
  If start < 0
    start = MachTapeStart
    If start & 1 And MachTapeExec >= 0 And (MachTapeExec & 1) = 0
      start = MachTapeExec                ; "do not start": PCjs's documented start (tape2pico)
    EndIf
  EndIf
  If start & 1
    MachTapeWhy$ = MachLadder()\tape$ + ": the tape says do not start; give --start"
    ProcedureReturn 0
  EndIf
  For i = 1 To CountString(MachLadder()\patch$, ",") + 1
    item$ = StringField(MachLadder()\patch$, i, ",")
    If FindString(item$, "=")
      Mem((MachOct(StringField(item$, 1, "=")) >> 1) & $FFFF) = MachOct(StringField(item$, 2, "=")) & $FFFF
    EndIf
  Next
  MachTapeGo(start, MachLadder()\switches)
  ProcedureReturn 1
EndProcedure
