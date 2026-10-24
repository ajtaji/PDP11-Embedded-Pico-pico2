; desktop/pdp11_cli.pb - the desktop PDP-11 in a console: boots an image file
; and follows a script, printing what the PDP-11 types - the test run and the
; log beside the windowed program (PDP11Desktop.pb).
;
;   pdp11_cli IMAGE.uf2 [BOOT d,switches] [step ...]
;     steps: until:TEXT[:seconds]   wait until the PDP-11 has typed TEXT
;            send:TEXT              type TEXT and a return
;            raw:TEXT               type TEXT (\r \n \xHH understood)
;            wait:SECONDS           run on for that long
;            stats                  instructions and the rate so far
;            mark                   count instructions and time from here
;            ladder:PLAN[@NAME]     the diagnostic ladder (media/diagnostics/ladder.txt),
;                                   or the rungs whose names start with NAME; no image needed
;            regs, dump:A,N, trace:N   the processor, memory, one instruction at a time
XIncludeFile "machine.pbi"
XIncludeFile "gen/core.pbi"
XIncludeFile "machine_run.pbi"
XIncludeFile "machine_tape.pbi"
XIncludeFile "machine_disasm.pbi"

Global CliOut$                              ; everything typed, for until:

Procedure.s OctStr(v.l, width.l)            ; octal, zero-filled
  Protected s$
  Repeat : s$ = Chr('0' + (v & 7)) + s$ : v = (v >> 3) & $1FFFFFFF : Until v = 0
  ProcedureReturn RSet(s$, width, "0")
EndProcedure

Procedure.l OctVal(s$)
  Protected v.l, i.l
  For i = 1 To Len(s$) : v = v * 8 + Val(Mid(s$, i, 1)) : Next
  ProcedureReturn v
EndProcedure
Global CliT0.q

Procedure CliPump(ms.l)                     ; run the machine for ms of host time, printing
  Protected t.q = ElapsedMilliseconds() + ms, c.l
  While ElapsedMilliseconds() < t
    MachSlice()
    c = MachConGet()
    While c >= 0
      If c <> 13 And c <> 0
        Print(Chr(c))
        CliOut$ + Chr(c)
        If Len(CliOut$) > 4000 : CliOut$ = Right(CliOut$, 2000) : EndIf
      EndIf
      c = MachConGet()
    Wend
  Wend
EndProcedure

Procedure.l CliUntil(text$, ms.l)
  Protected t.q = ElapsedMilliseconds() + ms, at.l
  Repeat                                    ; what came before (a send's echo) counts; a match uses it up
    at = FindString(CliOut$, text$)
    If at
      CliOut$ = Mid(CliOut$, at + Len(text$))
      ProcedureReturn 1
    EndIf
    If ElapsedMilliseconds() >= t : Break : EndIf
    CliPump(20)
  ForEver
  PrintN("") : PrintN("[cli: no '" + text$ + "' within " + Str(ms / 1000) + " s]")
  ProcedureReturn 0
EndProcedure

Procedure CliType(s$)
  Protected i.l
  For i = 1 To Len(s$)
    While MachConPut(Asc(Mid(s$, i, 1))) = 0
      CliPump(5)
    Wend
  Next
EndProcedure

Procedure.s CliUnescape(s$)
  Protected out$, i.l = 1
  While i <= Len(s$)
    If Mid(s$, i, 1) = "\" And i < Len(s$)
      Select Mid(s$, i + 1, 1)
        Case "r" : out$ + Chr(13) : i + 2 : Continue
        Case "n" : out$ + Chr(10) : i + 2 : Continue
        Case "x" : out$ + Chr(Val("$" + Mid(s$, i + 2, 2))) : i + 4 : Continue
      EndSelect
    EndIf
    out$ + Mid(s$, i, 1) : i + 1
  Wend
  ProcedureReturn out$
EndProcedure

; The diagnostic ladder, as tools/tape_ladder.py runs it on a board: each tape
; loaded, started, and judged by what it types (a bell or END PASS/END OF a
; PASS, an XXDP pass line only with 0 errors, a HALT a FAIL).
Procedure CliLadder(plan$, only$)
  Protected t.q, t0.q, v$, npass.l, nfail.l, nnone.l, c.l, line$
  If MachReadLadder(plan$) = 0
    PrintN("cli: " + MachTapeWhy$) : ProcedureReturn
  EndIf
  ForEach MachLadder()
    If only$ <> "" And Left(MachLadder()\name$, Len(only$)) <> only$ : Continue : EndIf
    If MachRungStart() = 0
      PrintN(LSet(MachLadder()\name$, 12) + " LOAD FAILED: " + MachTapeWhy$) : nfail + 1 : Continue
    EndIf
    t0 = ElapsedMilliseconds() : t = t0 + MachLadder()\seconds * 1000 : v$ = ""
    While ElapsedMilliseconds() < t
      MachSlice()
      Repeat : c = MachTapeChar() : Until c < 0
      v$ = MachTapeVerdict()
      If v$ <> "" : Break : EndIf
    Wend
    If v$ = "" : v$ = "NO VERDICT" : nnone + 1 : ElseIf v$ = "PASS" : npass + 1 : Else : nfail + 1 : EndIf
    line$ = LSet(MachLadder()\name$, 12) + " " + LSet(v$, 10) + " " + Str(MachTotal) + " instructions, " + Str(MachBells) + " bells, " + StrF((ElapsedMilliseconds() - t0) / 1000.0, 2) + " s"
    If Halted : line$ + "  HALT at " + OctStr(Reg(7), 6) : EndIf
    If ElapsedMilliseconds() - t0 > 50
      line$ + ", " + StrF(MachTotal / ((ElapsedMilliseconds() - t0) / 1000.0) / 1000000.0, 1) + " M/s"
    EndIf
    PrintN(line$)
    If only$ <> ""                          ; one rung asked for: what it typed, too
      PrintN("| " + ReplaceString(MachTapeText$, Chr(10), Chr(10) + "| "))
    EndIf
  Next
  PrintN("cli: ladder " + Str(npass) + " PASS, " + Str(nfail) + " FAIL, " + Str(nnone) + " no verdict")
EndProcedure

OpenConsole()
If CountProgramParameters() < 1
  PrintN("pdp11_cli IMAGE.uf2 [BOOT d,switches] [until:TEXT[:s] | send:TEXT | raw:TEXT | wait:S | stats] ...")
  End 1
EndIf
Define img$ = ProgramParameter(0), k.l = 1, a$, verb$, rest$, secs.l, p.l, d.l = 0, sw.l = -1
If LCase(Left(img$, 7)) = "ladder:"
  k = 0
ElseIf MachLoadImage(img$) = 0
  PrintN("cli: " + MachWhy$) : End 1
Else
  PrintN("cli: " + img$ + ": RK0" + Mid(" RK1", 1, 4 * Bool(MdPresent & 2)) + Mid(" RP03", 1, 5 * MdRpLoaded) + "; auto-boot name '" + MachHdrAutoName$ + "', switches " + OctStr(MachHdrSwitches, 6) + ", then '" + MachHdrAutoThen$ + "', memory " + Str(MachHdrMemKb) + " KB")
EndIf
For k = k To CountProgramParameters() - 1
  a$ = ProgramParameter(k)
  If UCase(a$) = "BOOT" And k + 1 < CountProgramParameters()
    k + 1 : a$ = ProgramParameter(k)
    d = Val(StringField(a$, 1, ","))
    If FindString(a$, ",") : sw = OctVal(StringField(a$, 2, ",")) : EndIf
    If sw < 0 : sw = MachHdrSwitches : EndIf
    MachBootRk(d, sw)
    CliT0 = ElapsedMilliseconds()
    Continue
  EndIf
  p = FindString(a$, ":")
  verb$ = LCase(Left(a$, p - 1)) : rest$ = Mid(a$, p + 1)
  If p = 0 : verb$ = LCase(a$) : rest$ = "" : EndIf
  Select verb$
    Case "until"
      secs = 60
      If CountString(rest$, ":") And Val(StringField(rest$, CountString(rest$, ":") + 1, ":")) > 0
        secs = Val(StringField(rest$, CountString(rest$, ":") + 1, ":"))
        rest$ = Left(rest$, Len(rest$) - Len(StringField(rest$, CountString(rest$, ":") + 1, ":")) - 1)
      EndIf
      CliUntil(CliUnescape(rest$), secs * 1000)
    Case "send"
      CliType(CliUnescape(rest$) + Chr(13))
      CliPump(300)
    Case "raw"
      CliType(CliUnescape(rest$))
      CliPump(300)
    Case "wait"
      CliPump(Val(rest$) * 1000)
    Case "regs"
      PrintN("") : Define r.l, line$ = "[cli:"
      For r = 0 To 7 : line$ + " R" + Str(r) + "=" + OctStr(Reg(r), 6) : Next
      PrintN(line$ + " PSW=" + OctStr(PswGet(), 6) + " MMU " + Str(MmuOn) + " MMR3=" + OctStr(Mmr3, 2) + " waiting " + Str(Waiting) + " halted " + Str(Halted) + " IntReq " + Str(IntReq) + "]")
      PrintN("[cli: mem at PC: " + OctStr(Mem((Reg(7) >> 1) & $FFFFF), 6) + " " + OctStr(Mem(((Reg(7) >> 1) + 1) & $FFFFF), 6) + "  RK reads " + Str(RkReads) + " CS " + OctStr(RkCsRead(), 6) + " KwTicks " + Str(KwTicks) + " KwIe " + Str(KwIe) + "]")
    Case "dump"                             ; dump:ADDR,WORDS (octal physical address)
      Define da.l = OctVal(StringField(rest$, 1, ",")), dn.l = Val(StringField(rest$, 2, ",")), di.l
      For di = 0 To dn - 1
        If di % 8 = 0 : PrintN("") : Print(OctStr(da + di * 2, 6) + ":") : EndIf
        Print(" " + OctStr(Mem(((da >> 1) + di) & $FFFFF), 6))
      Next
      PrintN("")
    Case "trace"                            ; trace:N  one instruction at a time
      Define tn.l = Val(rest$), ti.l
      For ti = 1 To tn
        Print(OctStr(Reg(7), 6) + " ")
        CpuRun(1)
        If ti % 10 = 0 : PrintN("") : EndIf
      Next
      PrintN("")
    Case "ladder"
      CliLadder(StringField(rest$, 1, "@"), StringField(rest$, 2, "@"))
    Case "mark"                             ; the count and the clock from here (for stats)
      MachTotal = 0 : CliT0 = ElapsedMilliseconds()
    Case "dis"                              ; dis:ADDR,N  disassembly at a virtual address
      Define va.l = OctVal(StringField(rest$, 1, ",")), vn.l = Val(StringField(rest$, 2, ",")), vi.l, vt$
      For vi = 1 To vn
        vt$ = Disasm(va)
        PrintN(OctStr(va, 6) + "  " + OctStr(MachPeekVirt(va) & $FFFF, 6) + "  " + vt$)
        va = (va + DisLen * 2) & $FFFF
      Next
    Case "stats"
      PrintN("") : PrintN("[cli: " + Str(MachTotal) + " instructions in " + StrF((ElapsedMilliseconds() - CliT0) / 1000.0, 2) + " s = " + StrF(MachTotal / ((ElapsedMilliseconds() - CliT0 + 1) / 1000.0) / 1000000.0, 2) + " M/s]")
  EndSelect
Next
PrintN("")
