; desktop/PDP11Desktop.pb - the PDP-11 on the PC, in a window: the same machine
; the Pico runs (the core is written from the board's own sources by
; tools/desktop_gen.py: the J-11 with its FPU and MMU, the KW11-L, the RK11
; and the RP11, the console DL11), the same image files, drawn with the Neon
; Arcade Display Engine.
;
;   PDP11Desktop [IMAGE.uf2]     (no image: images/picoplus2-v7/combined.uf2 beside
;                                 the desktop folder, if it is there)
;
; The window: the console terminal (type into it; Del is the interrupt key
; for Unix, Ctrl+\ quit), the diagnostic ladder, a log; beside them the front
; panel (the address and data lights, the switch register - click a switch),
; the registers, the disassembly at the PC or the trace of the last
; instructions, and memory. Run, Halt, Step, a breakpoint, and the speed.
;
; Build (PowerShell, x64):  .\build_desktop.ps1
;   pbcompilerc PDP11Desktop.pb /EXE PDP11Desktop.exe /THREAD /DPIAWARE /OPTIMIZER
;      /CONSTANT GL_ENGINE_DIR$=C:/Users/ajtaj/Desktop/Neon-Arcade-Dispay-Engine/

CompilerIf Not Defined(GL_ENGINE_DIR$, #PB_Constant)
  #GL_ENGINE_DIR$ = "C:/Users/ajtaj/Desktop/Neon-Arcade-Dispay-Engine/"
CompilerEndIf
XIncludeFile #GL_ENGINE_DIR$ + "GlTypes.pbi"
XIncludeFile #GL_ENGINE_DIR$ + "GlUtilities.pbi"
XIncludeFile #GL_ENGINE_DIR$ + "GlMath.pbi"
XIncludeFile #GL_ENGINE_DIR$ + "GlUI.pbi"
XIncludeFile #GL_ENGINE_DIR$ + "GlUIChrome.pbi"

XIncludeFile "machine.pbi"                 ; EnableExplicit from here on
XIncludeFile "gen/core.pbi"
XIncludeFile "machine_run.pbi"
XIncludeFile "machine_tape.pbi"
XIncludeFile "machine_disasm.pbi"

; ---- the state of the front end ----------------------------------------------
Global DeskWin.i, DeskGl.i
Global DeskRunning.l                       ; the processor runs (the user's RUN, not the HALT instruction)
Global DeskImage$
Global DeskQuit.l
Global DeskTab.l                           ; 0 console, 1 ladder, 2 log
Global DeskViewTab.l                       ; 0 disassembly, 1 trace
Global DeskSpeed.d, DeskSpeedN.q, DeskSpeedT.q
Global DeskBreak.l = -1                    ; the breakpoint's virtual address, -1 none
Global DeskTrace.l                         ; record every instruction (slower)
Global DeskAutoStage.l                     ; 1 wait for '@', 2 wait for the second prompt
Global DeskBell.q                          ; when the last bell rang, for the flash
Global DeskMemAddr.l = $DE00               ; the memory pane's first physical address
Global DeskMemS.String, DeskBrkS.String
Global *DeskTermFont.GLFont
Global DeskWheel.l

#DESK_TRACE = 64
Global Dim DeskTracePc.l(#DESK_TRACE)
Global DeskTraceN.l

; ---- the log -----------------------------------------------------------------
Global NewList DeskLog.s()
Procedure DeskSay(s$)
  AddElement(DeskLog())
  DeskLog() = FormatDate("%hh:%ii:%ss  ", Date()) + s$
  If ListSize(DeskLog()) > 400
    FirstElement(DeskLog()) : DeleteElement(DeskLog())
    LastElement(DeskLog())
  EndIf
EndProcedure

Procedure.s DeskOct(v.l, width.l)
  Protected s$
  Repeat : s$ = Chr('0' + (v & 7)) + s$ : v = (v >> 3) & $1FFFFFFF : Until v = 0
  ProcedureReturn RSet(s$, width, "0")
EndProcedure

Procedure.l DeskOctVal(s$)
  Protected v.l, i.l, c.l
  s$ = Trim(s$)
  For i = 1 To Len(s$)
    c = Asc(Mid(s$, i, 1))
    If c < '0' Or c > '7' : ProcedureReturn -1 : EndIf
    v = v * 8 + c - '0'
  Next
  If s$ = "" : ProcedureReturn -1 : EndIf
  ProcedureReturn v
EndProcedure

; ---- the terminal --------------------------------------------------------------
; The console's screen: 80 columns, the lines kept in a ring for scrolling back.
#TERM_COLS = 80
#TERM_ROWS = 24
#TERM_KEEP = 2000
Global Dim TermLine.s(#TERM_KEEP)
Global TermFirst.l, TermLast.l             ; the lines kept, as absolute numbers
Global TermCol.l
Global TermBack.l                          ; lines scrolled back from the bottom

Procedure TermNewLine()
  TermLast + 1
  TermLine(TermLast % #TERM_KEEP) = ""
  If TermLast - TermFirst >= #TERM_KEEP
    TermFirst + 1
  EndIf
EndProcedure

Procedure TermPut(c.l)
  Protected l$
  Select c
    Case 13 : TermCol = 0
    Case 10 : TermNewLine()
    Case 8
      If TermCol > 0 : TermCol - 1 : EndIf
    Case 9
      TermCol = (TermCol + 8) & ~7
      If TermCol >= #TERM_COLS : TermCol = #TERM_COLS - 1 : EndIf
    Case 7 : DeskBell = ElapsedMilliseconds()
    Case 32 To 126
      If TermCol >= #TERM_COLS
        TermNewLine() : TermCol = 0
      EndIf
      l$ = TermLine(TermLast % #TERM_KEEP)
      If Len(l$) < TermCol : l$ + Space(TermCol - Len(l$)) : EndIf
      TermLine(TermLast % #TERM_KEEP) = Left(l$, TermCol) + Chr(c) + Mid(l$, TermCol + 2)
      TermCol + 1
  EndSelect
EndProcedure

Procedure TermClear()
  TermFirst = 0 : TermLast = 0 : TermCol = 0 : TermBack = 0
  TermLine(0) = ""
EndProcedure

; ---- the machine, from the window ----------------------------------------------------
Procedure DeskLoad(file$)
  DeskRunning = 0
  If MachLoadImage(file$) = 0
    DeskSay("could not load: " + MachWhy$)
    ProcedureReturn
  EndIf
  DeskImage$ = file$
  DeskSay("loaded " + GetFilePart(file$) + ": RK0" + Mid(" RK1", 1, 4 * Bool(MdPresent & 2)) + Mid(" RP03", 1, 5 * MdRpLoaded) +
          "; boot switches " + DeskOct(MachHdrSwitches, 6) + ", memory " + Str(MemTop / 1024) + " KB")
EndProcedure

; BOOT, as the board does at power-up: the bootstrap, then the auto-boot types
; the kernel's name at the boot block's '@' and the second step at its prompt.
Procedure DeskBoot()
  If *MdPack0 = 0 : DeskSay("no image loaded") : ProcedureReturn : EndIf
  TermClear()
  MachBootRk(0, MachHdrSwitches)
  DeskAutoStage = Bool(MachHdrAutoName$ <> "")
  DeskRunning = 1
  DeskTraceN = 0
  DeskSay("BOOT RK0, switches " + DeskOct(MachHdrSwitches, 6) + Mid(", typing '" + MachHdrAutoName$ + "'", 1, 999 * DeskAutoStage))
EndProcedure

Procedure DeskType(c.l)
  MachConPut(c & $7F)
EndProcedure

Procedure DeskTypeString(s$)
  Protected i.l
  For i = 1 To Len(s$) : DeskType(Asc(Mid(s$, i, 1))) : Next
EndProcedure

; What the PDP-11 typed, onto the screen; the auto-boot watches it.
Procedure DeskDrainConsole()
  Protected c.l = MachConGet()
  While c >= 0
    If c <> 0 And c <> 127
      TermPut(c)
      TermBack = 0
    EndIf
    If DeskAutoStage = 1 And c = '@'
      DeskTypeString(MachHdrAutoName$ + Chr(13))
      DeskAutoStage = 0
      If MachHdrAutoThen$ <> "" : DeskAutoStage = 2 : EndIf
    ElseIf DeskAutoStage = 2 And c = Asc(MachHdrAutoThen$)
      DeskTypeString(Mid(MachHdrAutoThen$, 2) + Chr(13))
      DeskAutoStage = 0
    EndIf
    c = MachConGet()
  Wend
EndProcedure

; One instruction, recorded for the trace.
Procedure DeskStep1()
  DeskTracePc(DeskTraceN % #DESK_TRACE) = Reg(7) & $FFFF
  DeskTraceN + 1
  MachTotal + CpuRun(1)
EndProcedure

; Run for ms of the host's time (the frame's share), then the clock, the disks
; and the console as core 1 does them.
Procedure DeskRunFor(ms.l)
  Protected t.q = ElapsedMilliseconds() + ms, n.l, i.l, first.l = 1
  While ElapsedMilliseconds() < t And DeskRunning
    If DeskTrace Or DeskBreak >= 0
      For i = 1 To 2000                          ; one at a time, the PC looked at before each
        If DeskBreak = (Reg(7) & $FFFF) And first = 0
          DeskRunning = 0
          DeskSay("breakpoint at " + DeskOct(DeskBreak, 6))
          Break 2
        EndIf
        first = 0
        DeskStep1()
        DeskSpeedN + 1
        If Halted : Break : EndIf
      Next
      KwTick() : DkServe()
    Else
      n = MachSlice()
      DeskSpeedN + n
    EndIf
    DeskDrainConsole()
    If Halted
      DeskRunning = 0
      DeskSay("HALT at " + DeskOct(Reg(7), 6) + " (" + Str(MachTotal) + " instructions)")
      Break
    EndIf
    If Waiting : Break : EndIf                    ; WAIT: nothing to do until the clock or a key
  Wend
  DeskDrainConsole()
EndProcedure

; ---- the ladder in the window -------------------------------------------------------
Global DeskLadderOn.l, DeskLadderT0.q, DeskLadderPlan$
Structure DeskRungResult
  name$
  verdict$
  detail$
EndStructure
Global NewList DeskRungs.DeskRungResult()
Global *DeskRung.DeskRungResult            ; the running tape's row (the pane's ForEach moves the list's own)

Procedure DeskLadderStart()
  DeskRunning = 0
  DeskLadderPlan$ = GetPathPart(ProgramFilename()) + "..\media\diagnostics\ladder.txt"
  If MachReadLadder(DeskLadderPlan$) = 0
    DeskSay("ladder: " + MachTapeWhy$)
    ProcedureReturn
  EndIf
  ClearList(DeskRungs())
  ForEach MachLadder()
    AddElement(DeskRungs()) : DeskRungs()\name$ = MachLadder()\name$ : DeskRungs()\verdict$ = "-"
  Next
  FirstElement(MachLadder()) : *DeskRung = FirstElement(DeskRungs())
  DeskLadderOn = 1
  DeskLadderT0 = 0
  DeskTab = 1
  DeskSay("ladder: " + Str(ListSize(MachLadder())) + " tapes from " + DeskLadderPlan$)
EndProcedure

; A frame's share of the ladder: start the rung, run it, judge it, go on.
Procedure DeskLadderRun(ms.l)
  Protected t.q = ElapsedMilliseconds() + ms, v$, c.l
  If DeskLadderOn = 0 : ProcedureReturn : EndIf
  If DeskLadderT0 = 0
    If MachRungStart() = 0
      *DeskRung\verdict$ = "LOAD" : *DeskRung\detail$ = MachTapeWhy$
      v$ = "next"
    Else
      DeskLadderT0 = ElapsedMilliseconds()
      *DeskRung\verdict$ = "running"
    EndIf
  EndIf
  If v$ = ""
    While ElapsedMilliseconds() < t
      DeskSpeedN + MachSlice()
      Repeat : c = MachTapeChar() : Until c < 0
      v$ = MachTapeVerdict()
      If v$ <> "" : Break : EndIf
    Wend
    If v$ = "" And ElapsedMilliseconds() - DeskLadderT0 > MachLadder()\seconds * 1000
      v$ = "NO VERDICT"
    EndIf
    If v$ <> ""
      *DeskRung\verdict$ = v$
      *DeskRung\detail$ = Str(MachTotal) + " instructions, " + Str(MachBells) + " bells, " + StrF((ElapsedMilliseconds() - DeskLadderT0) / 1000.0, 2) + " s"
      If Halted : *DeskRung\detail$ + ", HALT at " + DeskOct(Reg(7), 6) : EndIf
      DeskSay("ladder: " + *DeskRung\name$ + " " + v$ + " (" + *DeskRung\detail$ + ")")
    EndIf
  EndIf
  If v$ <> ""
    DeskLadderT0 = 0
    If NextElement(MachLadder()) = 0
      DeskLadderOn = 0
      Protected np.l, nf.l
      ForEach DeskRungs()
        If DeskRungs()\verdict$ = "PASS" : np + 1 : Else : nf + 1 : EndIf
      Next
      DeskSay("ladder: " + Str(np) + " PASS, " + Str(nf) + " not (18_DZQKC and 19_DEQKC halt by design on a J-11: ladder.txt)")
      DeskSay("the machine now holds the last tape; Boot starts the image again")
    Else
      ChangeCurrentElement(DeskRungs(), *DeskRung)
      *DeskRung = NextElement(DeskRungs())
    EndIf
  EndIf
EndProcedure

; ---- drawing ------------------------------------------------------------------------
Global DeskW.f, DeskH.f                    ; the canvas, physical pixels

Procedure.f S(v.f)
  ProcedureReturn Neon_S(v)
EndProcedure

Procedure DeskLamp(x.f, y.f, d.f, on.l, r.f, g.f, b.f)
  If on
    Neon_Glow(x - 2, y - 2, d + 4, d + 4, r, g, b, 0.35)
    Neon_Box(x, y, d, d, r, g, b)
  Else
    Neon_Box(x, y, d, d, 0.22, 0.18, 0.16)
  EndIf
EndProcedure

; The front panel: 22 address lights (the PC's physical address), 16 data
; lights (the display register, 177570, as the program writes it), the
; switch register (click a switch), and the state.
Procedure DeskFrontPanel(x.f, y.f, w.f, h.f)
  Protected i.l, lx.f, d.f = S(13), gap.f = S(4), grp.f = S(7), pa.l, bit.l, mode.l, ty.f
  Neon_Panel(x, y, w, h, "Front panel", Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB, S(26))
  pa = MachVirtToPhys(Reg(7))
  If pa < 0 : pa = $3FE000 + (Reg(7) & $1FFF) : EndIf
  ty = y + S(34)
  Neon_Text(*Neon_FontSmall, x + S(10), ty, "ADDRESS", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  lx = x + S(80)
  For i = 21 To 0 Step -1
    DeskLamp(lx, ty + S(2), d, (pa >> i) & 1, 0.95, 0.35, 0.25)
    lx + d + gap
    If i % 3 = 0 : lx + grp : EndIf
  Next
  ty + S(22)
  Neon_Text(*Neon_FontSmall, x + S(10), ty, "DATA", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  lx = x + S(80) + 6 * (d + gap) + 2 * grp
  For i = 15 To 0 Step -1
    DeskLamp(lx, ty + S(2), d, (DisplayReg >> i) & 1, 0.95, 0.35, 0.25)
    lx + d + gap
    If i % 3 = 0 : lx + grp : EndIf
  Next
  ty + S(24)
  Neon_Text(*Neon_FontSmall, x + S(10), ty + S(3), "SWITCHES", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  lx = x + S(80) + 6 * (d + gap) + 2 * grp
  For i = 15 To 0 Step -1
    bit = (SwitchReg >> i) & 1
    Neon_Box(lx, ty, d, S(20), 0.30, 0.30, 0.34)
    If bit
      Neon_Box(lx + S(2), ty + S(2), d - S(4), S(8), Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB)
    Else
      Neon_Box(lx + S(2), ty + S(10), d - S(4), S(8), 0.55, 0.55, 0.58)
    EndIf
    Neon_HotZone(lx, ty, d, S(20), Neon_HotKey(40, lx, ty))
    If Neon_MouseClicked And Neon_Hit(lx, ty, d, S(20))
      SwitchReg = SwitchReg ! (1 << i)
    EndIf
    lx + d + gap
    If i % 3 = 0 : lx + grp : EndIf
  Next
  Neon_Text(*Neon_FontMono, lx + S(6), ty + S(2), DeskOct(SwitchReg, 6), Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
  ty + S(30)
  mode = (PswGet() >> 14) & 3
  lx = x + S(10)
  DeskLamp(lx, ty + S(3), S(10), Bool(DeskRunning And Not Waiting), Neon_C_GrnR, Neon_C_GrnG, Neon_C_GrnB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "RUN", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(56)
  DeskLamp(lx, ty + S(3), S(10), Bool(DeskRunning And Waiting), Neon_C_AccR, Neon_C_AccG, Neon_C_AccB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "WAIT", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(60)
  DeskLamp(lx, ty + S(3), S(10), Bool(Halted Or Not DeskRunning), Neon_C_RedR, Neon_C_RedG, Neon_C_RedB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "HALT", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(60)
  DeskLamp(lx, ty + S(3), S(10), MmuOn, Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "MMU", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(56)
  DeskLamp(lx, ty + S(3), S(10), Bool(Mmr3 & $10), Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "22-BIT", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(70)
  DeskLamp(lx, ty + S(3), S(10), Bool(mode = 0), Neon_C_VioR, Neon_C_VioG, Neon_C_VioB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "KERNEL", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(72)
  DeskLamp(lx, ty + S(3), S(10), Bool(mode = 1), Neon_C_VioR, Neon_C_VioG, Neon_C_VioB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "SUPER", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB) : lx + S(66)
  DeskLamp(lx, ty + S(3), S(10), Bool(mode = 3), Neon_C_VioR, Neon_C_VioG, Neon_C_VioB)
  Neon_Text(*Neon_FontSmall, lx + S(14), ty, "USER", Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
EndProcedure

Procedure DeskRegisters(x.f, y.f, w.f, h.f)
  Protected psw.l = PswGet(), i.l, col.l, row.l, tx.f, ty.f, lh.f = S(19), c2.f = x + w / 2, f$, m$
  Neon_Panel(x, y, w, h, "Registers", Neon_C_AccR, Neon_C_AccG, Neon_C_AccB, S(26))
  ty = y + S(34) : tx = x + S(12)
  For i = 0 To 7
    col = i / 4 : row = i % 4
    Neon_Text(*Neon_FontMono, tx + col * S(150), ty + row * lh, LSet(StringField("R0 R1 R2 R3 R4 R5 SP PC", i + 1, " "), 3) + DeskOct(Reg(i), 6), Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
  Next
  m$ = StringField("K S ? U", ((psw >> 14) & 3) + 1, " ") + "/" + StringField("K S ? U", ((psw >> 12) & 3) + 1, " ")
  If psw & 8 : f$ + "N" : Else : f$ + "-" : EndIf
  If psw & 4 : f$ + "Z" : Else : f$ + "-" : EndIf
  If psw & 2 : f$ + "V" : Else : f$ + "-" : EndIf
  If psw & 1 : f$ + "C" : Else : f$ + "-" : EndIf
  If psw & 16 : f$ + " T" : EndIf
  tx = x + S(320)
  Neon_Text(*Neon_FontMono, tx, ty, "PSW " + DeskOct(psw, 6), Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB)
  Neon_Text(*Neon_FontMono, tx, ty + lh, "mode " + m$ + " pri " + Str((psw >> 5) & 7), Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
  Neon_Text(*Neon_FontMono, tx, ty + 2 * lh, "flags " + f$, Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
  Neon_Text(*Neon_FontMono, tx, ty + 3 * lh, "set " + Str((psw >> 11) & 1), Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
  ty + 4 * lh + S(6)
  tx = x + S(12)
  Neon_Text(*Neon_FontMono, tx, ty, "KSP " + DeskOct(StackBank(0), 6) + "  SSP " + DeskOct(StackBank(1), 6) + "  USP " + DeskOct(StackBank(3), 6) + "  (the running mode's is SP)", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  ty + lh
  Neon_Text(*Neon_FontMono, tx, ty, "MMR0 " + DeskOct(Mmr0, 6) + "  MMR1 " + DeskOct(Mmr1, 6) + "  MMR2 " + DeskOct(Mmr2, 6) + "  MMR3 " + DeskOct(Mmr3, 2), Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  ty + lh
  Neon_Text(*Neon_FontMono, tx, ty, "FPS " + DeskOct(Fps, 6) + "  CPUERR " + DeskOct(CpuErr, 3) + "  memory " + Str(MemTop / 1024) + " KB  clock " + Str(KwTicks), Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  ty + lh
  Neon_Text(*Neon_FontMono, tx, ty, "disk: " + Str(MdReads) + " blocks read, " + Str(MdWrites) + " written   " + Str(MachTotal) + " instructions", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
EndProcedure

Procedure DeskCode(x.f, y.f, w.f, h.f)
  Protected va.l, i.l, ty.f, lh.f = S(19), rows.l, t$, k.l, n.l, col.f
  Neon_Panel(x, y, w, h, "", Neon_C_AccR, Neon_C_AccG, Neon_C_AccB)
  DeskViewTab = Neon_TabStrip(20, x + 1, y + 1, w - 2, S(28), "Disassembly at PC|Trace (last " + Str(#DESK_TRACE) + ")", DeskViewTab)
  ty = y + S(36)
  rows = (h - S(44)) / lh
  Neon_ScissorSet(x + 1, y + S(30), w - 2, h - S(31))
  If DeskViewTab = 0
    va = Reg(7) & $FFFF
    For i = 0 To rows - 1
      t$ = Disasm(va)
      col = 0.0
      If i = 0
        Neon_Box(x + S(4), ty - S(1), w - S(8), lh, 0.157, 0.365, 0.408, 0.6)
      EndIf
      If va = DeskBreak
        Neon_Box(x + S(4), ty - S(1), S(4), lh, Neon_C_RedR, Neon_C_RedG, Neon_C_RedB)
      EndIf
      Neon_Text(*Neon_FontMono, x + S(12), ty, DeskOct(va, 6) + "  " + DeskOct(MachPeekVirt(va) & $FFFF, 6) + "  " + t$, Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
      va = (va + DisLen * 2) & $FFFF
      ty + lh
    Next
  Else
    If DeskTrace = 0 And DeskBreak < 0
      Neon_Text(*Neon_FontSmall, x + S(12), ty, "Turn Trace on (top bar) to record each instruction; Step records too.", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
      ty + lh
    EndIf
    n = DeskTraceN
    If n > #DESK_TRACE : n = #DESK_TRACE : EndIf
    If n > rows : n = rows : EndIf
    For i = n To 1 Step -1                         ; the oldest shown first, the latest last
      k = (DeskTraceN - i) % #DESK_TRACE
      va = DeskTracePc(k)
      Neon_Text(*Neon_FontMono, x + S(12), ty, DeskOct(va, 6) + "  " + Disasm(va), Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
      ty + lh
    Next
  EndIf
  Neon_ScissorClear()
EndProcedure

Procedure DeskMemory(x.f, y.f, w.f, h.f)
  Protected ty.f, lh.f = S(19), rows.l, r.l, c.l, a.l, line$, v.l, ascii$, ch.l
  Neon_Panel(x, y, w, h, "Memory (physical, octal)", Neon_C_GrnR, Neon_C_GrnG, Neon_C_GrnB, S(26))
  If Neon_TextInput(30, x + S(220), y + S(3), S(110), S(20), @DeskMemS, "address")
    a = DeskOctVal(DeskMemS\s)
    If a >= 0 : DeskMemAddr = a & $3FFFF0 : EndIf
  EndIf
  If Neon_Button(x + S(336), y + S(3), S(48), S(20), "PC")
    a = MachVirtToPhys(Reg(7))
    If a >= 0 : DeskMemAddr = a & $3FFFF0 : DeskMemS\s = DeskOct(DeskMemAddr, 8) : EndIf
  EndIf
  If Neon_Button(x + S(388), y + S(3), S(48), S(20), "SP")
    a = MachVirtToPhys(Reg(6))
    If a >= 0 : DeskMemAddr = a & $3FFFF0 : DeskMemS\s = DeskOct(DeskMemAddr, 8) : EndIf
  EndIf
  rows = (h - S(36)) / lh
  If DeskWheel And Neon_Hit(x, y, w, h)
    DeskMemAddr - (DeskWheel / 40) * 16 * 3
    If DeskMemAddr < 0 : DeskMemAddr = 0 : EndIf
    DeskMemAddr & $3FFFF0
    DeskWheel = 0
  EndIf
  ty = y + S(34)
  a = DeskMemAddr
  For r = 0 To rows - 1
    line$ = DeskOct(a, 8) + " "
    ascii$ = ""
    For c = 0 To 7
      v = MachPeekPhys(a + c * 2)
      If v < 0
        line$ + " ------"
        ascii$ + "  "
      Else
        line$ + " " + DeskOct(v, 6)
        ch = v & $7F : If ch < 32 Or ch > 126 : ch = '.' : EndIf
        ascii$ + Chr(ch)
        ch = (v >> 8) & $7F : If ch < 32 Or ch > 126 : ch = '.' : EndIf
        ascii$ + Chr(ch)
      EndIf
    Next
    Neon_Text(*Neon_FontMono, x + S(12), ty, line$ + "  " + ascii$, Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
    a + 16
    ty + lh
  Next
EndProcedure

Procedure DeskTerminal(x.f, y.f, w.f, h.f)
  Protected adv.f, lh.f, rows.l, first.l, i.l, ln.l, ty.f, flash.f, cx.f
  adv = GetGLTextWidth(*DeskTermFont, "MMMMMMMMMM") / 10.0
  lh = *DeskTermFont\LineHeight
  Neon_Box(x, y, w, h, 0.05, 0.06, 0.07)
  flash = 1.0 - (ElapsedMilliseconds() - DeskBell) / 250.0
  If flash > 0.0
    Neon_Box(x, y, w, h, Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB, 0.12 * flash)
  EndIf
  rows = (h - S(12)) / lh
  If DeskWheel And Neon_Hit(x, y, w, h)
    TermBack + DeskWheel / 40
    DeskWheel = 0
  EndIf
  If TermBack > TermLast - TermFirst - rows + 1 : TermBack = TermLast - TermFirst - rows + 1 : EndIf
  If TermBack < 0 : TermBack = 0 : EndIf
  first = TermLast - rows + 1 - TermBack
  If first < TermFirst : first = TermFirst : EndIf
  Neon_ScissorSet(x, y, w, h)
  ty = y + S(6)
  For i = 0 To rows - 1
    ln = first + i
    If ln > TermLast : Break : EndIf
    Neon_Text(*DeskTermFont, x + S(10), ty, TermLine(ln % #TERM_KEEP), 0.70, 0.95, 0.75)
    If ln = TermLast And TermBack = 0 And (ElapsedMilliseconds() / 530) % 2 = 0
      cx = x + S(10) + TermCol * adv
      Neon_Box(cx, ty + 1, adv, lh - 2, 0.70, 0.95, 0.75, 0.75)
    EndIf
    ty + lh
  Next
  Neon_ScissorClear()
  If TermBack
    Neon_TextRight(*Neon_FontSmall, x + w - S(10), y + h - S(20), "scrolled back " + Str(TermBack) + " lines", Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB)
  EndIf
EndProcedure

Procedure DeskLadderPane(x.f, y.f, w.f, h.f)
  Protected ty.f = y + S(12), lh.f = S(21), r.f, g.f, b.f, lines.l, i.l, t$
  Neon_Box(x, y, w, h, Neon_C_PanelR, Neon_C_PanelG, Neon_C_PanelB)
  If Neon_Button(x + S(12), ty, S(150), S(26), "Run the ladder", #False, Bool(DeskLadderOn = 0))
    DeskLadderStart()
  EndIf
  Neon_Text(*Neon_FontSmall, x + S(176), ty + S(5), "media/diagnostics/ladder.txt: the board's tapes, judged as tools/tape_ladder.py judges them", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  ty + S(40)
  ForEach DeskRungs()
    r = Neon_C_TextR : g = Neon_C_TextG : b = Neon_C_TextB
    Select DeskRungs()\verdict$
      Case "PASS" : r = Neon_C_GrnR : g = Neon_C_GrnG : b = Neon_C_GrnB
      Case "FAIL", "LOAD", "NO VERDICT" : r = Neon_C_RedR : g = Neon_C_RedG : b = Neon_C_RedB
      Case "running" : r = Neon_C_AmbR : g = Neon_C_AmbG : b = Neon_C_AmbB
    EndSelect
    Neon_Text(*Neon_FontMono, x + S(16), ty, LSet(DeskRungs()\name$, 14) + LSet(DeskRungs()\verdict$, 12) + DeskRungs()\detail$, r, g, b)
    ty + lh
  Next
  If DeskLadderOn                                 ; the running tape's last lines
    ty + S(8)
    t$ = MachTapeText$
    lines = CountString(t$, Chr(10))
    For i = lines - 5 To lines + 1
      If i >= 1
        Neon_Text(*Neon_FontMono, x + S(16), ty, "| " + StringField(t$, i, Chr(10)), Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
        ty + lh
      EndIf
    Next
  EndIf
EndProcedure

Procedure DeskLogPane(x.f, y.f, w.f, h.f)
  Protected ty.f, lh.f = S(19), rows.l, n.l
  Neon_Box(x, y, w, h, Neon_C_PanelR, Neon_C_PanelG, Neon_C_PanelB)
  rows = (h - S(16)) / lh
  ty = y + S(8)
  n = ListSize(DeskLog()) - rows
  ForEach DeskLog()
    If n > 0 : n - 1 : Continue : EndIf
    Neon_Text(*Neon_FontMono, x + S(12), ty, DeskLog(), Neon_C_TextR, Neon_C_TextG, Neon_C_TextB)
    ty + lh
  Next
EndProcedure

Procedure DeskTopBar(h.f)
  Protected x.f = S(12), y.f = S(8), bh.f = h - S(16), f$, a.l
  Neon_Box(0, 0, DeskW, h, Neon_C_HeadR, Neon_C_HeadG, Neon_C_HeadB)
  Neon_Box(0, h - 1, DeskW, 1, Neon_C_LineR, Neon_C_LineG, Neon_C_LineB)
  Neon_Text(*Neon_FontBold, x, y + (bh - *Neon_FontBold\LineHeight) / 2, "PDP-11/J-11", Neon_C_AmbR, Neon_C_AmbG, Neon_C_AmbB)
  x + S(120)
  If Neon_Button(x, y, S(70), bh, "Open...")
    f$ = OpenFileRequester("A PDP-11 image (the board's combined UF2)", DeskImage$, "UF2 images (*.uf2)|*.uf2|All files (*.*)|*.*", 0)
    If f$ <> "" : DeskLoad(f$) : EndIf
  EndIf
  x + S(76)
  If Neon_Button(x, y, S(64), bh, "Boot", #False, Bool(*MdPack0 <> 0)) : DeskLadderOn = 0 : DeskBoot() : EndIf
  x + S(70)
  If DeskRunning
    If Neon_Button(x, y, S(64), bh, "Halt", #True) : DeskRunning = 0 : DeskSay("halted by the user at " + DeskOct(Reg(7), 6)) : EndIf
  Else
    If Neon_Button(x, y, S(64), bh, "Run", #False, Bool(DeskLadderOn = 0))
      If Halted : Halted = 0 : EndIf             ; CONTINUE after a HALT
      DeskRunning = 1
    EndIf
  EndIf
  x + S(70)
  If Neon_Button(x, y, S(56), bh, "Step", #False, Bool(DeskRunning = 0 And DeskLadderOn = 0))
    Halted = 0 : DeskStep1() : DeskDrainConsole()
  EndIf
  x + S(62)
  If Neon_Button(x, y, S(72), bh, "Step 100", #False, Bool(DeskRunning = 0 And DeskLadderOn = 0))
    Halted = 0
    For a = 1 To 100 : DeskStep1() : If Halted Or (Reg(7) & $FFFF) = DeskBreak : Break : EndIf : Next
    DeskDrainConsole()
  EndIf
  x + S(84)
  Neon_Text(*Neon_FontSmall, x, y + S(5), "Break at", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  x + S(56)
  If Neon_TextInput(31, x, y, S(80), bh, @DeskBrkS, "octal")
    DeskBreak = DeskOctVal(DeskBrkS\s)
    If DeskBreak >= 0 : DeskSay("breakpoint at " + DeskOct(DeskBreak, 6) + " (virtual, the current mode)") : Else : DeskSay("breakpoint cleared") : EndIf
  EndIf
  x + S(84)
  If Neon_Button(x, y, S(50), bh, "Clear", #False, Bool(DeskBreak >= 0))
    DeskBreak = -1 : DeskBrkS\s = "" : DeskSay("breakpoint cleared")
  EndIf
  x + S(56)
  If Neon_Button(x, y, S(76), bh, "Trace " + StringField("off on", DeskTrace + 1, " "), DeskTrace)
    DeskTrace = 1 - DeskTrace
  EndIf
  ; the speed, at the right
  Protected sp$
  If DeskRunning Or DeskLadderOn
    sp$ = StrF(DeskSpeed / 1000000.0, 1) + " M instructions/s"
    If DeskTrace Or DeskBreak >= 0 : sp$ + " (one at a time)" : EndIf
  Else
    sp$ = "stopped"
  EndIf
  Neon_TextRight(*Neon_FontBold, DeskW - S(14), y + (bh - *Neon_FontBold\LineHeight) / 2, sp$, Neon_C_GrnR, Neon_C_GrnG, Neon_C_GrnB)
  Neon_TextRight(*Neon_FontSmall, DeskW - S(14) - GetGLTextWidth(*Neon_FontBold, sp$) - S(16), y + S(6), GetFilePart(DeskImage$), Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
EndProcedure

Procedure DeskDraw()
  Protected top.f = S(46), gap.f = S(8), rw.f, lw.f, lx.f, rx.f, y.f, fh.f, rh.f, ch.f, mh.f
  DeskTopBar(top)
  rw = DeskW * 0.42
  If rw < S(560) : rw = S(560) : EndIf
  If rw > DeskW - S(400) : rw = DeskW - S(400) : EndIf
  lw = DeskW - rw - 3 * gap
  lx = gap : rx = lx + lw + gap
  y = top + gap
  ; the left: console, ladder, log
  DeskTab = Neon_TabStrip(10, lx, y, lw, S(30), "Console (DL11 177560)|Diagnostic ladder|Log", DeskTab)
  Select DeskTab
    Case 0 : DeskTerminal(lx, y + S(30), lw, DeskH - y - S(30) - gap - S(22))
    Case 1 : DeskLadderPane(lx, y + S(30), lw, DeskH - y - S(30) - gap - S(22))
    Case 2 : DeskLogPane(lx, y + S(30), lw, DeskH - y - S(30) - gap - S(22))
  EndSelect
  If ListSize(DeskLog())
    LastElement(DeskLog())
    Neon_Text(*Neon_FontSmall, lx + S(4), DeskH - gap - S(18), DeskLog(), Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  EndIf
  ; the right: front panel, registers, code, memory
  fh = S(170) : rh = S(216)
  mh = (DeskH - y - fh - rh - 4 * gap) * 0.36
  ch = DeskH - y - fh - rh - mh - 4 * gap
  DeskFrontPanel(rx, y, rw, fh)
  y + fh + gap
  DeskRegisters(rx, y, rw, rh)
  y + rh + gap
  DeskCode(rx, y, rw, ch)
  y + ch + gap
  DeskMemory(rx, y, rw, mh)
EndProcedure

; ---- the display scale (GlUIChrome.pbi, HOSTING item 8) ----------------------------------
Prototype.l ProtoDpiForWindow(hwnd.i)
Prototype.l ProtoDpiContext(ctx.i)
Procedure.f DeskScale(win.i)
  Protected lib.i, dpi.l, f.ProtoDpiForWindow
  lib = OpenLibrary(#PB_Any, "user32.dll")
  If lib
    f = GetFunction(lib, "GetDpiForWindow")
    If f : dpi = f(WindowID(win)) : EndIf
    CloseLibrary(lib)
  EndIf
  If dpi <= 0 : ProcedureReturn 1.0 : EndIf
  ProcedureReturn dpi / 96.0
EndProcedure

Procedure DeskFonts(sc.f)
  *Neon_FontUI = Neon_CreateFontPx("Segoe UI", Round(14 * sc, #PB_Round_Nearest))
  *Neon_FontSmall = Neon_CreateFontPx("Segoe UI", Round(12 * sc, #PB_Round_Nearest))
  *Neon_FontBold = Neon_CreateFontPx("Segoe UI", Round(15 * sc, #PB_Round_Nearest), #PB_Font_Bold)
  *Neon_FontMono = Neon_CreateFontPx("Consolas", Round(13 * sc, #PB_Round_Nearest))
  *DeskTermFont = Neon_CreateFontPx("Consolas", Round(16 * sc, #PB_Round_Nearest))
  GLFontSetSnapToPixel(*Neon_FontUI, #True)
  GLFontSetSnapToPixel(*Neon_FontSmall, #True)
  GLFontSetSnapToPixel(*Neon_FontBold, #True)
  GLFontSetSnapToPixel(*Neon_FontMono, #True)
  GLFontSetSnapToPixel(*DeskTermFont, #True)
EndProcedure

; ---- the program ----------------------------------------------------------------------
Define lib.i, fctx.ProtoDpiContext
lib = OpenLibrary(#PB_Any, "user32.dll")             ; per-monitor v2 before any window (HOSTING item 8)
If lib
  fctx = GetFunction(lib, "SetProcessDpiAwarenessContext")
  If fctx : fctx(-4) : EndIf
  CloseLibrary(lib)
EndIf

; The start size is LOGICAL (OpenWindow's units); the work area is PHYSICAL, so
; it is divided by the system's scale before the two are compared (HOSTING,
; item 7). A window made larger than its client can be leaves the GL gadget
; bigger than the client: the canvas then sits off its origin and every
; scissored widget (the tab strips) loses its contents.
Define startW.l = 1600, startH.l = 960, work.RECT, sysScale.f = 1.0, fsys.ProtoDpiForWindow
lib = OpenLibrary(#PB_Any, "user32.dll")
If lib
  fsys = GetFunction(lib, "GetDpiForSystem")
  If fsys : sysScale = fsys(0) / 96.0 : EndIf
  CloseLibrary(lib)
EndIf
If sysScale <= 0 : sysScale = 1.0 : EndIf
SystemParametersInfo_(#SPI_GETWORKAREA, 0, @work, 0)
If startW > (work\right - work\left) / sysScale * 0.94 : startW = (work\right - work\left) / sysScale * 0.94 : EndIf
If startH > (work\bottom - work\top) / sysScale * 0.88 : startH = (work\bottom - work\top) / sysScale * 0.88 : EndIf

DeskGl = OpenGLWindow("PDP-11 - the J-11 machine of the Pico, on the PC", startW, startH,
                      #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget |
                      #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
If DeskGl = 0
  MessageRequester("PDP-11", "Could not create an OpenGL window on this display driver.", #PB_MessageRequester_Error)
  End 1
EndIf
DeskWin = Util_MainWindowID
Neon_UIScale = DeskScale(DeskWin)
DeskFonts(Neon_UIScale)
GL_SetVSync(0)
SetActiveGadget(DeskGl)
TermClear()

Define img$
If CountProgramParameters() > 0
  img$ = ProgramParameter(0)
Else
  img$ = GetPathPart(ProgramFilename()) + "..\images\picoplus2-v7\combined.uf2"
EndIf
If FileSize(img$) > 0
  DeskLoad(img$)
  DeskBoot()
Else
  DeskSay("no image: Open... one (images/*/combined.uf2)")
EndIf

Define ev.i, r.RECT, cw.l, chh.l, pw.l, ph.l, mx.l, my.l, down.b, key.l, keyChar.l, mods.l
Define now.q, last.q = ElapsedMilliseconds(), dt.f, consoleKeys.l
Repeat
  key = 0 : keyChar = 0
  Repeat
    ev = WindowEvent()
    Select ev
      Case #PB_Event_CloseWindow
        DeskQuit = 1
      Case #PB_Event_SizeWindow
        ResizeGadget(DeskGl, 0, 0, WindowWidth(DeskWin), WindowHeight(DeskWin))
      Case #PB_Event_Menu
        If EventMenu() = 1001                    ; the engine traps Escape as a shortcut
          If DeskTab = 0 And Neon_FocusID = 0 : DeskType(27) : Else : key = #PB_Shortcut_Escape : EndIf
        EndIf
      Case #PB_Event_Gadget
        If EventGadget() = DeskGl
          consoleKeys = Bool(DeskTab = 0 And Neon_FocusID = 0)
          Select EventType()
            Case #PB_EventType_MouseWheel
              DeskWheel + GetGadgetAttribute(DeskGl, #PB_OpenGL_WheelDelta) * 40
            Case #PB_EventType_KeyDown
              key = GetGadgetAttribute(DeskGl, #PB_OpenGL_Key)
              mods = GetGadgetAttribute(DeskGl, #PB_OpenGL_Modifiers)
              If GetAsyncKeyState_(#VK_CONTROL) & $8000 : mods | #PB_OpenGL_Control : EndIf
              If consoleKeys
                If mods & #PB_OpenGL_Control
                  If key >= #PB_Shortcut_A And key <= #PB_Shortcut_Z
                    DeskType(key - #PB_Shortcut_A + 1)
                  ElseIf key = 220                 ; Ctrl+\ (VK_OEM_5): QUIT
                    DeskType(28)
                  EndIf
                Else
                  Select key
                    Case #PB_Shortcut_Return : DeskType(13)
                    Case #PB_Shortcut_Back : DeskType(8)
                    Case #PB_Shortcut_Tab : DeskType(9)
                    Case #PB_Shortcut_Delete : DeskType(127)   ; Unix's interrupt
                  EndSelect
                EndIf
                TermBack = 0
                key = 0
              EndIf
            Case #PB_EventType_Input
              keyChar = GetGadgetAttribute(DeskGl, #PB_OpenGL_Input)
              If consoleKeys
                If keyChar >= 32 And keyChar < 127 And (GetAsyncKeyState_(#VK_CONTROL) & $8000) = 0
                  DeskType(keyChar)
                EndIf
                keyChar = 0
              EndIf
          EndSelect
        EndIf
    EndSelect
  Until ev = 0
  If DeskQuit : Break : EndIf

  ; the machine's share of the frame
  If DeskLadderOn
    DeskLadderRun(14)
  ElseIf DeskRunning
    DeskRunFor(14)
  Else
    Delay(10)
  EndIf
  now = ElapsedMilliseconds()
  If now - DeskSpeedT >= 1000
    DeskSpeed = DeskSpeedN * 1000.0 / (now - DeskSpeedT)
    DeskSpeedN = 0 : DeskSpeedT = now
  EndIf
  dt = (now - last) / 1000.0 : last = now

  ; the frame (GlUIChrome.pbi, HOSTING items 4 and 5: a 1:1 canvas in physical pixels)
  SetGadgetAttribute(DeskGl, #PB_OpenGL_SetContext, #True)
  If GadgetWidth(DeskGl) <> WindowWidth(DeskWin) Or GadgetHeight(DeskGl) <> WindowHeight(DeskWin)
    ResizeGadget(DeskGl, 0, 0, WindowWidth(DeskWin), WindowHeight(DeskWin))   ; the gadget is the client, always
  EndIf
  cw = GadgetWidth(DeskGl) : chh = GadgetHeight(DeskGl)
  GetClientRect_(WindowID(DeskWin), @r)
  pw = r\right - r\left : ph = r\bottom - r\top
  If pw < 1 Or ph < 1 : Continue : EndIf
  Util_BaseWidth = pw : Util_BaseHeight = ph
  Util_WinWidth = cw : Util_WinHeight = chh
  GL_ViewportX = 0 : GL_ViewportY = 0 : GL_ViewportW = pw : GL_ViewportH = ph
  DeskW = pw : DeskH = ph
  mx = WindowMouseX(DeskWin) : my = WindowMouseY(DeskWin)
  down = #False
  If GetActiveWindow() = DeskWin
    down = Bool(GetAsyncKeyState_(#VK_LBUTTON) & $8000)
  EndIf
  Neon_ChromeBeginFrame(mx, my, down, 0, key, keyChar, dt)
  glBindFramebuffer(#GL_FRAMEBUFFER, 0)
  glDisable_(#GL_SCISSOR_TEST)
  glViewport_(0, 0, pw, ph)
  glClearColor_(Neon_C_BgR, Neon_C_BgG, Neon_C_BgB, 1.0)
  glClear_(#GL_COLOR_BUFFER_BIT)
  DeskDraw()
  DeskWheel = 0
  Neon_ChromeEndFrame()
  SetGadgetAttribute(DeskGl, #PB_OpenGL_FlipBuffers, #True)
ForEver
End
