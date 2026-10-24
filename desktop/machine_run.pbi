; desktop/machine_run.pbi - running the desktop PDP-11: loading the image files,
; BOOT, and core 1's jobs (the 60 Hz clock, the disk storage, the console) done
; between the processor's slices. Included after gen/core.pbi.

#MACH_SLICE = 10000                ; instructions a CpuRun: the board's #CORE0_SLICE

Global *MachFlash                  ; the board's flash, as a combined UF2 wrote it
Global MachFlashSize.l
Global MachTotal.q                 ; instructions run since the boot
Global MachBootDrive.l = -1
Global MachHdrAutoName$, MachHdrAutoThen$, MachHdrSwitches.l, MachHdrMemKb.l
Global MachWhy$                    ; the last load's complaint, for the window and the log

; ---- the image files --------------------------------------------------------
; A UF2 file into a picture of the board's flash: each 512-byte block carries
; 256 bytes for a target address from $10000000.
Procedure.l MachLoadUF2(file$)
  Protected f.i, size.q, *blk, n.l, addr.l, len.l, off.l   ; f: a #PB_Any handle is 64-bit
  f = ReadFile(#PB_Any, file$)
  If f = 0
    MachWhy$ = "cannot open " + file$
    ProcedureReturn 0
  EndIf
  size = Lof(f)
  If *MachFlash = 0
    MachFlashSize = $1000000
    *MachFlash = AllocateMemory(MachFlashSize)
  EndIf
  FillMemory(*MachFlash, MachFlashSize, $FF, #PB_Byte)
  *blk = AllocateMemory(512)
  While Not Eof(f)
    If ReadData(f, *blk, 512) <> 512 : Break : EndIf
    If PeekL(*blk) <> $0A324655 Or (PeekL(*blk + 4) & $FFFFFFFF) <> $9E5D5157   ; PeekL is signed: mask
      MachWhy$ = file$ + " is not a UF2 file (block " + Str(n) + ")"
      FreeMemory(*blk) : CloseFile(f)
      ProcedureReturn 0
    EndIf
    addr = PeekL(*blk + 12) - $10000000
    len = PeekL(*blk + 16)
    If addr >= 0 And addr + len <= MachFlashSize And len <= 476
      CopyMemory(*blk + 32, *MachFlash + addr, len)
    EndIf
    n + 1
  Wend
  FreeMemory(*blk) : CloseFile(f)
  ProcedureReturn n
EndProcedure

; An RK05 pack ("PDP11RK1") from the flash picture at region, into a new
; 4872-block pack. 0 if there is none there.
Procedure.i MachRkFromFlash(region.l)
  Protected *p, layout.l, stored.l, b.l, m.l, msec.l, dat.l
  If PeekS(*MachFlash + region, 8, #PB_Ascii) <> "PDP11RK1"
    ProcedureReturn 0
  EndIf
  layout = PeekL(*MachFlash + region + 12)
  stored = PeekL(*MachFlash + region + 16)
  *p = AllocateMemory(#MD_RK_BLOCKS * 512)
  If layout = 0
    If stored > #MD_RK_BLOCKS : stored = #MD_RK_BLOCKS : EndIf
    CopyMemory(*MachFlash + region + 4096, *p, stored * 512)
  Else
    msec = PeekL(*MachFlash + region + 24)
    dat = region + 4096 + msec * 4096
    For b = 0 To #MD_RK_BLOCKS - 1
      m = PeekU(*MachFlash + region + 4096 + b * 2)
      If m
        CopyMemory(*MachFlash + dat + (m - 1) * 512, *p + b * 512, 512)
      EndIf
    Next
  EndIf
  ProcedureReturn *p
EndProcedure

; The RP03's pack ("PDP11RP1") at region: 1 loaded (RpPresent, RpBlocks, RpFirst set).
Procedure.l MachRpFromFlash(region.l)
  Protected blocks.l, first.l, msec.l, dat.l, b.l, m.l
  If PeekS(*MachFlash + region, 8, #PB_Ascii) <> "PDP11RP1"
    ProcedureReturn 0
  EndIf
  blocks = PeekL(*MachFlash + region + 12)
  first = PeekL(*MachFlash + region + 16)
  msec = PeekL(*MachFlash + region + 20)
  dat = region + 4096 + msec * 4096
  If *MdRp : FreeMemory(*MdRp) : EndIf
  *MdRp = AllocateMemory(blocks * 512)
  For b = 0 To blocks - 1
    m = PeekU(*MachFlash + region + 4096 + b * 2)
    If m
      CopyMemory(*MachFlash + dat + (m - 1) * 512, *MdRp + b * 512, 512)
    EndIf
  Next
  MdRpBlocks = blocks
  MdRpLoaded = 1
  RpBlocks = blocks
  RpFirst = first
  RpPresent = 1
  RpReset()
  ProcedureReturn 1
EndProcedure

; The packs of a combined UF2: RK0, then RK1 or the RP03. The header's
; auto-boot settings are kept for the front end (+72 switches, +80 the
; kernel's name, +144 the memory, +148 the second step).
Procedure.l MachLoadImage(file$)
  Protected n.l
  n = MachLoadUF2(file$)
  If n = 0 : ProcedureReturn 0 : EndIf
  If *MdPack0 : FreeMemory(*MdPack0) : *MdPack0 = 0 : EndIf
  If *MdPack1 : FreeMemory(*MdPack1) : *MdPack1 = 0 : EndIf
  MdPresent = 0 : MdRpLoaded = 0 : RpPresent = 0
  *MdPack0 = MachRkFromFlash(#MD_FL_RK0)
  If *MdPack0 = 0
    MachWhy$ = file$ + ": no RK05 pack at $240000"
    ProcedureReturn 0
  EndIf
  MdPresent = 1
  MdWhat0$ = GetFilePart(file$) + " RK0"
  *MdPack1 = MachRkFromFlash(#MD_FL_RK1)
  If *MdPack1
    MdPresent | 2
    MdWhat1$ = GetFilePart(file$) + " RK1"
  ElseIf MachRpFromFlash(#MD_FL_RK1)
    MdWhatRp$ = GetFilePart(file$) + " RP03, blocks " + Str(RpFirst) + "-" + Str(RpFirst + RpBlocks - 1)
  EndIf
  MachHdrSwitches = PeekL(*MachFlash + #MD_FL_RK0 + 72)
  MachHdrAutoName$ = PeekS(*MachFlash + #MD_FL_RK0 + 80, 16, #PB_Ascii)
  MachHdrMemKb = PeekL(*MachFlash + #MD_FL_RK0 + 144)
  MemTop = #DESK_MEM_TOP                  ; as the board with its PSRAM found (psram_pdp11.pico2)...
  If MachHdrMemKb >= 56 And MachHdrMemKb * 1024 <= #DESK_MEM_TOP
    MemTop = MachHdrMemKb * 1024          ; ... or as the pack asks (diag.pico2, auto-boot): read at the BOOT
  EndIf
  MachHdrAutoThen$ = PeekS(*MachFlash + #MD_FL_RK0 + 148, 41, #PB_Ascii)
  ProcedureReturn 1
EndProcedure

; ---- BOOT RKd: the board's bootstrap at 157000 (diag.pico2, BootRkCpu) ------
#MACH_BOOT_AT = $DE00
Procedure MachBootRk(d.l, switches.l)
  Protected a.l
  CpuReset()
  SwitchReg = switches & $FFFF
  a = #MACH_BOOT_AT >> 1
  Mem(a) = $15DF : Mem(a + 1) = (d & 7) << 13 : Mem(a + 2) = $FF0A
  Mem(a + 3) = $0A1F : Mem(a + 4) = $FF08
  Mem(a + 5) = $15DF : Mem(a + 6) = $FF00 : Mem(a + 7) = $FF06
  Mem(a + 8) = $15DF : Mem(a + 9) = 5 : Mem(a + 10) = $FF04
  Mem(a + 11) = $8BDF : Mem(a + 12) = $FF04
  Mem(a + 13) = $80FD
  Mem(a + 14) = $0BDF : Mem(a + 15) = $FF04
  Mem(a + 16) = $8001
  Mem(a + 17) = 0
  Mem(a + 18) = $15C0 : Mem(a + 19) = d & 7
  Mem(a + 20) = $0A07
  Reg(6) = #MACH_BOOT_AT
  Reg(7) = #MACH_BOOT_AT
  MachTotal = 0
  ConInTail = ConInHead
  ConOutTail = ConOutHead
  KwNext = Micros() + #KW_PERIOD_US
  MachBootDrive = d
  DdReset()
EndProcedure

; ---- the console: what core 1 does with the DL11's two queues --------------
Procedure.l MachConPut(c.l)                 ; a typed character: 1 taken, 0 the queue is full
  If ConInHead - ConInTail >= #CON_SIZE
    ProcedureReturn 0
  EndIf
  ConIn(ConInHead & (#CON_SIZE - 1)) = c & $FF
  SmpBarrier()
  ConInHead = ConInHead + 1
  ProcedureReturn 1
EndProcedure

Procedure.l MachConGet()                    ; a character the PDP-11 sent, -1 none
  Protected c.l
  If ConOutTail = ConOutHead
    ProcedureReturn -1
  EndIf
  c = ConOut(ConOutTail & (#CON_SIZE - 1)) & $7F
  ConOutTail = ConOutTail + 1
  ProcedureReturn c
EndProcedure

; ---- one slice: the processor, then core 1's jobs ---------------------------
Procedure.l MachSlice()
  Protected n.l
  n = CpuRun(#MACH_SLICE)
  MachTotal + n
  KwTick()
  DdTick()
  DkServe()
  ProcedureReturn n
EndProcedure
