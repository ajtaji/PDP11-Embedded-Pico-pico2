; desktop/gen/core.pbi - WRITTEN BY desktop/tools/desktop_gen.py from the Pico 2's
; sources; do not edit (edit the board's files and run the tool again).
; cpu.pico2 (7 ASM blocks dropped); fp11.pico2 (6 ASM blocks dropped); instructions_mmu.pico2 (363 ASM blocks dropped); instructions.pico2 (194 ASM blocks dropped); kw11.pico2 (0 ASM blocks dropped); rk11.pico2 (0 ASM blocks dropped); rp11.pico2 (0 ASM blocks dropped)

Declare SmpBarrier()
Declare CpuEventIn(k.l)
Declare.l CpuNow()
Declare.l IntLevel()
Declare IntCheck()
Declare.l FlagN()
Declare.l FlagZ()
Declare SetNZ(n.l, z.l)
Declare.l PswGet()
Declare PswBanks(v.i)
Declare.l ModeSp(m.l)
Declare SetModeSp(m.l, v.l)
Declare PswSet(v.l)
Declare PswWrite(v.l)
Declare BusError()
Declare MmuMapEntry(e.i)
Declare MmuCharge(k.l)
Declare MmuRecompute()
Declare MmuMapStale(e.i)
Declare MmuRegChanged(r.i)
Declare MmuReset()
Declare.l MmuRegIndex(a.l)
Declare.l MmuIsReg(a.l)
Declare.i MmuRegRead(a.i)
Declare MmuRegWrite(a.l, v.l)
Declare.l UbRegRead(a.l)
Declare UbRegWrite(a.l, v.l)
Declare.l UbPhys(ba.l)
Declare.l IoRead(a.l)
Declare IoWrite(a.l, v.l)
Declare.i PdpReadWord(a.i)
Declare PdpWriteWord(a.i, v.i)
Declare.i PdpReadByte(a.i)
Declare PdpWriteByte(a.i, v.i)
Declare StackCheck()
Declare Push(v.l)
Declare.l Pop()
Declare.l FetchWord()
Declare.l EaWord(spec.l)
Declare.l EaByte(spec.l)
Declare MmuAbort(bits.i, e.i)
Declare MmuWindowWritten(e.i)
Declare.l MmuPhys(va.l, e.l, write.l)
Declare.l MmuIoAddr(pa.l)
Declare.i MmuReadWord(va.i, e.i)
Declare MmuWriteWord(va.i, e.i, v.i)
Declare.i MmuReadByte(va.i, e.i)
Declare MmuWriteByte(va.i, e.i, v.i)
Declare.l EaWordM(spec.l)
Declare.l EaByteM(spec.l)
Declare PushM(v.l)
Declare.l PopM()
Declare MmuFetchWindow(va.i)
Declare.l FetchWordM()
Declare TakeTrap(vector.l)
Declare TakeStackTrap()
Declare DevService()
Declare StartWindow()
Declare.l Dl11RxWanted()
Declare DevReset()
Declare CpuReset()
Declare FpInit()
Declare.l ULt(a.l, b.l)
Declare FpCopy(d.l, s.l)
Declare FpAdd(d.l, s.l)
Declare FpSub(d.l, s.l)
Declare.l FpLt(a.l, b.l)
Declare FpLsh(d.l, s.l, n.l)
Declare FpRsh(d.l, s.l, n.l)
Declare FpLsh1(d.l)
Declare FpRsh1(d.l)
Declare FpGetFrac(d.l, s.l)
Declare.l FpNoTrap(code.l)
Declare.l FpSetCc(old.l, rh.l, newv.l)
Declare.l FpRoundPack(p.l, ex.l, f.l, r.l)
Declare.l FpRound(p.l)
Declare.l FpNormalize(f.l, ex.l, big.l)
Declare.l FpAddOpRef()
Declare FpAddOpAsm()
Declare.l FpAddOp()
Declare FpFracMulRef()
Declare FpFracMulAsm()
Declare FpFracMul()
Declare FpDivQRef()
Declare FpDivQAsm()
Declare FpDivQ()
Declare.l FpMulOpRef()
Declare FpMulOpAsm()
Declare.l FpMulOp()
Declare.l FpModOp()
Declare.l FpDivOp()
Declare.l FpRdW(va.l, sp.l)
Declare FpWrW(va.l, sp.l, v.l)
Declare FpStackCheck(adr.l)
Declare FpRegChange(n.l, r.l)
Declare FpEa(spec.l, ln.l)
Declare.i FpReadF(p.i, spec.i, ln.i)
Declare FpWriteF(p.i, spec.i, ln.i)
Declare FpOpAsm()
Declare.l FpSrc(p.l, spec.l, ln.l)
Declare FpDst(p.l, spec.l, ln.l)
Declare.l FpReadI(spec.l, ln.l)
Declare FpWriteI(v.l, spec.l, ln.l)
Declare FpLoadAc(p.l, ac.l, qd.l)
Declare FpStoreAc(ac.l, p.l, qd.l)
Declare FpCpuCc()
Declare FpExecRef()
Declare FpExecAsm()
Declare FpExec()
Declare OpsM(from.l, count.l, target.i)
Declare.l CpuRunM(n.l)
Declare BuildOpcodeTableM()
Declare Ops(from.l, count.l, target.i)
Declare.l CpuRun(n.l)
Declare BuildOpcodeTable()
Declare KwAdvance()
Declare KwTick()
Declare KwPoll()
Declare.l KwRead()
Declare KwWrite(v.l)
Declare KwInit()
Declare.l RkIo(what.l)
Declare DkServe()
Declare.l RkMemRead(pa.l)
Declare.l RkMemWrite(pa.l, v.l)
Declare.l RkCsRead()
Declare.l RkDsRead()
Declare RkAsk()
Declare RkDone()
Declare RkFail(bits.l)
Declare RkIntTaken()
Declare RkSetDa(blk.l)
Declare RkGo()
Declare RkFinish()
Declare.l RkSector()
Declare RkStep()
Declare RkPoll()
Declare.l RkRead(a.l)
Declare RkWrite(a.l, v.l)
Declare RkInit()
Declare DevUpdate()
Declare DevPoll()
Declare DevWriteByte(a.l, v.l)
Declare.l RpCsRead()
Declare RpAsk()
Declare RpDone()
Declare RpReset()
Declare RpGo()
Declare.l RpSector()
Declare RpFinish()
Declare RpPoll()
Declare.l RpRead(a.l)
Declare RpWrite(a.l, v.l)
Declare RpInit()
Declare RpBanner()
Declare.l RpStoreRead(b.l)
Declare.i RpStoreWrite(b.i)
Declare.i RpOvPut(b.i, src.i)
Declare.i RpDirtyCount()
Declare.l RpOvAddr(b.l)
Declare RpSave()

; ======== cpu.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; ======================================================================
;  cpu.pico2 - the J-11 (KDJ11-BF, 18 MHz) machine state, memory, operand
;  addressing, traps and the reset, for the Raspberry Pi Pico 2.
;
;  Include order (flat, the main file lists them):
;      XIncludeFile "cpu.pico2"
;      XIncludeFile "instructions.pico2"
;  then call CpuReset() and CpuRun(n).
;
;  NUMBERS. The language has hex ($) and binary (%) literals but no octal,
;  and the PDP-11 is documented in octal. Every opcode, address and vector
;  below is written in hex with its octal in the comment beside it.
;
;  ------------------------------------------------------------------
;  HOW THIS IS BUILT FOR SPEED - measured, not assumed (2026-09-21,
;  the compiler's own cycle listing, RP2040 Cortex-M0+ at zero wait):
;
;    * a Global read or write costs 4 cycles: the address comes out of
;      the literal pool (ldr 2) and then the load or store (2). A field
;      of a Global Structure costs exactly the same - the compiler
;      resolves it to an absolute address too - so a structure buys no
;      speed today and the state is plain Globals.
;    * a Protected local costs MORE, about 5 cycles, because locals live
;      in the stack frame and each access rebuilds the frame offset. And a
;      procedure with locals zeroes its frame on entry. So the handlers
;      use Globals as their scratch registers (Src, Dst, Res, Ea) and
;      declare no locals.
;    * every procedure call costs about 13 cycles before it does anything
;      (bl/blx, push, frame set-up, pop). So:
;        - register mode (mode 0), the commonest operand, is handled INLINE
;          in every handler and never calls a helper;
;        - condition codes are never packed while the machine runs, and
;          all four are LAZY. V is bit 15 of FlagV and C is bit 16 of
;          FlagC; the other bits mean nothing and every reader masks. So
;          ADD stores its 17-bit sum as C unchanged, and V is the raw
;          sign-bit expression, with no shift or mask on the way in (SET:
;          FlagC = $10000, FlagV = $8000). N and Z are LAZY too: nearly
;          every instruction sets both from its result, so it stores the
;          result once in FlagNZ and nothing is decided until a branch or
;          the PSW asks (N = bit 15 or bit 16, Z = low 16 bits are zero;
;          a byte result is stored shifted up 8 so its sign lands on bit
;          15). One 4-cycle store replaces a compare, a branch and two
;          stores. The PSW word is only assembled when something reads it
;          (MFPS, a trap, an RTI, the PSW's bus address).
;    * THE PICO 2 GETS ONE TABLE ENTRY PER OPCODE: 65,536 entries, 256 KB of
;      its 520 KB of RAM, indexed by the whole instruction - no shift, no
;      sub-decode anywhere. And because an entry knows the instruction's
;      addressing modes, the commonest forms get handlers of their own:
;      a double-operand instruction with BOTH operands in registers
;      (MOV R1,R2) and a single-operand instruction on a register (INC R3)
;      go to *_RR / *_R handlers that never test a mode and never call an
;      operand helper, and OP #n,Rd to *_IR handlers that read the
;      immediate at the PC. Every other form, and any form naming R7,
;      goes to the general handler. The
;      entry is reached with one computed jump (threaded dispatch - see
;      instructions.pico2).
;      (The Pico keeps an 8192-entry table: 256 KB will not fit in its RAM,
;      and in flash it would miss the 16 KB XIP cache on almost every
;      instruction.)
;
;    * no handler is a procedure any more: they are labels in one
;      procedure, CpuRun, so running an instruction costs no call, no frame
;      and no return (instructions.pico2 has the measurements).
;
;    * the four hottest Globals live in CPU registers for the whole
;      program: ReserveRegister, under the machine state below, holds Op,
;      PC (the emulated R7), Res and RunLeft in r8-r11, which nothing else
;      in a compiled program touches. Each access is one mov instead of a
;      literal-pool load and a load or store. Needs a compiler from
;      2026-09-22 (main 1770a28d) or later; an older one refuses the line
;      with PM1100. Holding the PC means Reg(7) is only a copy between
;      instructions: see THE EMULATED PC in instructions.pico2.
;
;    * memory is read and written through MACROS (MReadWord and friends,
;      under MEMORY below): an even RAM address is handled inline and only
;      the I/O page or an odd address calls a procedure.
;
;  ------------------------------------------------------------------
;  WHAT IS MODELLED (first cut, stated so nothing is assumed):
;    * the J-11 base instruction set with EIS (MUL, DIV, ASH, ASHC, XOR,
;      SOB, SXT, MARK, MFPS, MTPS, MFPT, SPL). No floating point yet (the
;      FPJ11 is an option; 17xxxx traps as reserved). CSM, TSTSET and
;      WRTLCK trap as reserved for now.
;    * 16-bit physical addressing with the memory management unit OFF:
;      56 KB of RAM at 000000-157777, the I/O page at 160000-177777. In
;      the I/O page the PSW (177776), the console DL11 (177560-177566),
;      the switch register (177570), the RK11 disk controller
;      (177400-177416, rk11.pico2) and the KW11-L line clock (177546,
;      kw11.pico2) answer; everything else there is a bus error (trap to
;      4). See THE I/O PAGE below.
;    * kernel, supervisor and user mode with a stack pointer each, and the
;      two sets of R0-R5 (PSW bit 11) - see THE MODES below.
;    * the memory management unit: PAR/PDR sets for kernel, supervisor and
;      user, I and D space, 18- and 22-bit mapping, MMR0-3, aborts through
;      250 - see THE MEMORY MANAGEMENT UNIT. While it is off nothing of it is
;      on the path an instruction takes; while it is on, a second run loop
;      (instructions_mmu, generated from instructions by tools/mmu_gen.py)
;      runs instead. Physical memory is the 56 KB of RAM, on a board with
;      PSRAM the memory above it (up to 3812 KB with 22-bit mapping on, up
;      to 248 KB with it off), and the I/O page at the top of the 18- or
;      22-bit space: a mapped address past the memory fitted and below the
;      I/O page is a bus error (trap to 4).
;    * the Unibus map (the KDJ11-B with its Unibus adapter, the PDP-11/84
;      arrangement): 17770200-17770376, switched on by MMR3 bit 5. The
;      RK11's 18-bit bus addresses reach all of memory through it - see
;      THE UNIBUS MAP.
;    * a bus error or odd address found inside an instruction is taken
;      AFTER that instruction finishes (the real J-11 aborts it), but with
;      the PSW it had before the instruction (see BusError), so the
;      condition codes are right; registers an aborted instruction changed
;      stay changed, as on the J-11 (PDP-11 Architecture Handbook 1983,
;      model differences 28-30).
;    * the fixed kernel stack limit (yellow zone, 000400) and the T-bit
;      trace trap - see StackCheck and StartWindow.
;
;  COMMENTED OUT 2026-09-23: nothing reads ClockCycles - no line clock, throttle
;  or report uses it - so every update of it is commented out and r11 is free.
;  Restore it (and its ReserveRegister slot) when real J-11 timing is wanted.
;  CLOCK. The real module runs an 18 MHz clock. ClockCycles counts the
;  emulated machine's time; the per-instruction amounts are the #J11_T_*
;  constants below, which are PLACEHOLDERS (1 each - so ClockCycles counts
;  instructions) until the instruction timing tables of the KDJ11-B user's
;  guide are transcribed. They are in one place so that is one edit.
; ======================================================================

; ---- sizes -----------------------------------------------------------
; #RAM_BYTES is the memory in Mem(), from physical address 0. A 16-bit
; address - memory management off - reaches only #RAM16 of it (000000-157777;
; 160000 up is the I/O page), so the unmapped paths test against #RAM16 and
; the mapped ones (the MMU, its windows, the RK11's transfers) against
; #RAM_BYTES. With PSRAM, Mem() is the first #PSRAM_SRAM_KB (224 in diag.pico2:
; most of what an 18-bit machine has, so the kernels and their first processes
; run from SRAM; 2026-10-21) and the rest is in the PSRAM (PsMem); without it the program says how much SRAM to give
; (#SRAM_MEM_KB, set beside #PSRAM: 152 in diag.pico2, which gives the rest of
; the SRAM to the file-write overlay; 56 in the test programs; at most 248, all
; an 18-bit machine reaches below its I/O page).
CompilerIf #PSRAM = 1
#RAM_BYTES   = #PSRAM_SRAM_KB * 1024   ; the first #PSRAM_SRAM_KB in SRAM, the rest in the PSRAM
CompilerElse
#RAM_BYTES   = #SRAM_MEM_KB * 1024
CompilerEndIf
#RAM_WORDS   = #RAM_BYTES / 2
#RAM16       = $E000        ; what a 16-bit address reaches: 000000-157777
#IOPAGE      = $E000        ; 160000
#PSW_ADDR    = $FFFE        ; 177776

; ---- trap vectors ----------------------------------------------------
#VEC_BUS     = $04          ; 000004 odd address, bus error, illegal
#VEC_RESV    = $08          ; 000010 reserved instruction
#VEC_BPT     = $0C          ; 000014 BPT and the T bit
#VEC_IOT     = $10          ; 000020
#VEC_EMT     = $18          ; 000030
#VEC_TRAP    = $1C          ; 000034
#VEC_DL11_RX = $30          ; 000060 console receiver, BR4
#VEC_DL11_TX = $34          ; 000064 console transmitter, BR4
#TRAP_PSW_LATE = 1          ; not vectors: TrapVector's "see PswLate" (PswWrite)
#VEC_MMU     = $A8          ; 000250 memory management abort
#MMR0_ADDR   = $FF7A        ; 177572
#MMR1_ADDR   = $FF7C        ; 177574
#MMR2_ADDR   = $FF7E        ; 177576
#MMR3_ADDR   = $F54E        ; 172516
#UBMAP_ADDR  = $F080        ; 170200-170376: the Unibus map, 32 registers of two words
#UBMAP_END   = $F100
#UB_IOPAGE   = $3E000       ; 760000: the 18-bit bus's own I/O page
#UB_NONE     = $7FFFFFFF    ; UbPhys: no memory answers this bus address
#CPUERR_ADDR = $FFF6        ; 177766 CPU error register
#MAINT_ADDR  = $FFE8        ; 177750 maintenance register
#MAINT_FIXED = $0225        ; its fixed bits: 9 Unibus system, 7-4 module type 2 (KDJ11-BF), 2-1 power-up code 2, 0 BPOK
#CPUE_HALT   = $80          ; CPU error register bits: HALT in user or supervisor mode,
#CPUE_ODD    = $40          ; a word at an odd address,
#CPUE_NXM    = $20          ; a memory address nothing answers,
#CPUE_IO     = $10          ; an I/O page address nothing answers,
#CPUE_YELLOW = $08          ; the yellow stack trap
#MAP_NONE    = $10000       ; a fast window that holds nothing
#MAP_COST_ENTRY = 8         ; the run budget one map entry's rework costs (MmuCharge)
#MAP_COST_ALL   = 128       ; ... and the whole map's
#TRAP_STACK  = 3            ; and "see StackYellow" (StackCheck)
#STACK_LIMIT = $100         ; 000400, the J-11's fixed kernel stack limit

; ---- the I/O page devices (see THE I/O PAGE) --------------------------
#DL11_RCSR   = $FF70        ; 177560 receiver status
#DL11_RBUF   = $FF72        ; 177562 receiver data
#DL11_XCSR   = $FF74        ; 177564 transmitter status
#DL11_XBUF   = $FF76        ; 177566 transmitter data
#SWR_ADDR    = $FF78        ; 177570 switch register (read), display (write)
#DL11_TX_INSTRUCTIONS = 100 ; how long one character takes to send
#DL11_RX_INSTRUCTIONS = 2000 ; the least time between two characters received (THE RECEIVER'S PACE)
#CON_SIZE    = 256          ; each console queue, a power of two
#INT_DL11_RX = 1            ; IntReq bits: the console receiver ...
#INT_DL11_TX = 2            ; ... and transmitter (both BR4)
#INT_RK      = 4            ; the RK11 disk controller, BR5 (rk11.pico2)
#INT_KW      = 8            ; the KW11-L line clock, BR6 (kw11.pico2)
#INT_RP      = 16           ; the RP11 disk controller, BR5 (rp11.pico2)
#VEC_RK      = $90          ; 000220 RK11
#VEC_KW      = $40          ; 000100 KW11-L
#VEC_RP      = $AC          ; 000254 RP11
#RK_BASE     = $FF00        ; 177400-177416, the RK11's eight registers
#KW_CSR      = $FF66        ; 177546, the KW11-L's one register
#RP_BASE     = $FDC8        ; 176710-176736, the RP11's registers (rp11.pico2) ...
#RP_LAST     = $FDDE        ; ... the last; they answer only with an RP pack in the flash
CompilerIf #DEMO_DEV = 1     ; the demo's display and tone generator (demo_dev.pico2, tools/demo_build.py)
#DEMO_BASE   = $E800        ; 164000-164177
#INT_DEMO    = 32           ; its frame interrupt's IntReq bit, BR4
#VEC_DEMO    = $D0          ; 000320 (300/304 are kept for a second DL11, docs/TERMINALS.md)
CompilerEndIf
#MSER_ADDR   = $FFE4        ; 177744 memory system error   (the KDJ11-B's cache registers:
#CCR_ADDR    = $FFE6        ; 177746 cache control          no cache is modelled, see
#HMR_ADDR    = $FFEA        ; 177752 hit/miss               THE CACHE REGISTERS below)
#DEV_WINDOW  = 200          ; the longest window while the disk is busy (DevFast)
#DEV_WINDOW_CLOCK = 2000    ; ... while only the line clock needs a look (DevActive, not DevFast): a tick due
                            ; every 16.7 ms is taken within 2,000 instructions (about 0.2 ms) - at 200 the run
                            ; loop's end-of-window work was 3% of V7's time (2026-10-22)

; ---- timing placeholders (see CLOCK above) ---------------------------
#J11_T_DOUBLE = 1
#J11_T_SINGLE = 1
#J11_T_BRANCH = 1
#J11_T_JUMP   = 1
#J11_T_EIS    = 1
#J11_T_MISC   = 1
#J11_T_TRAP   = 1

; ---- machine state ---------------------------------------------------
; Compact CPU state: two register banks, hot scalar words, fetch window.
Global CurD.l
Global CurI.l
Global EaBase.l
Global Ea.l
Global Src.l
Global Dst.l
Global TrapVector.l
Global FlagC.l
Global FlagV.l
Global Mmr0.l
Global Mmr1.l
Global MmuPcRec.l
Global Tmp.l
Global Adr.l
Global EaSpec.l
Global EaStep.l
Global EaReg.l
Global Dim RegAlt.l(6)
Global Dim Fw.i(4)
Global Dim Reg.l(8)         ; R0-R7, R6 = SP, R7 = PC. 16-bit values.
Global GBase.i ; @Reg(0), held in r5 (ReserveRegister below): the mapped loop's assembly reaches
                            ; the globals it touches on every instruction from it (tools/mmu_gen.py, base_rel)
Global Dim Mem.u(#RAM_WORDS)
CompilerIf #DESK_MEM = 1                ; a board with PSRAM (psram_pdp11.pico2)
Global MemTop.l = #RAM_BYTES ; the end of physical memory: #RAM_BYTES, or 3812 KB with the PSRAM
Global MemLim.l = #RAM_BYTES ; ... as the mapping in force reaches it: MemTop with 22-bit mapping,
                                     ; no more than 248 KB (the 18-bit I/O page's start) without (MmuRecompute)
Global PsramOk.l ; the PSRAM is found, tested and in use (psram_pdp11.pico2)
Global PsDrives.l ; bit d: RK drive d lives in the PSRAM
CompilerEndIf

Global Op.l ; the instruction being executed
Global Res.l ; handler scratch - see SPEED
Global FlagNZ.l ; lazy N and Z - see SPEED
; EaWord/EaByte scratch (Globals: cheaper than locals)
; the address Push, Pop, FetchWord and EaWord work on
Global PswHigh.l ; PSW bits 15-5 (mode, register set, priority, T)
; Global ClockCycles.i   ; commented out: nothing ever reads it (see CLOCK)
; non-zero = a trap to take after this instruction
Global PswLate.l ; a PSW written through 177776, to re-apply at the end (PswWrite)
Global AbortPsw.l ; the PSW before an instruction a bus error aborted (BusError)
Global StackYellow.l ; the kernel stack went below 000400 (StackCheck)
Global TraceArm.l ; the T bit was set when this instruction began (StartWindow)
Global Dim StackBank.l(4)   ; the stack pointer of each mode not running (PswBanks)
Global TrapPsw.l, TrapPc.l ; TakeTrap's saved PSW and PC

; The memory management unit - see THE MEMORY MANAGEMENT UNIT. An ENTRY is
; mode * 16 + space * 8 + page: mode 0 kernel, 1 supervisor, 3 user; space
; 0 I, 1 D; page = the top three bits of the virtual address.
Global MmuOn.l ; MMR0 bit 0: the mapped run loop runs while it is 1
Global Mmr2.l, Mmr3.l
Global Dim Pdr.l(64)        ; the registers, by entry
Global Dim Par.l(64)
Global Dim MapReg.l(64)     ; the registers an entry uses (a D entry uses I's when D space is off)
Global Dim MapBase.l(64)    ; physical = virtual + MapBase, before the 18/22-bit mask
Global Dim MapLo.l(64)      ; the virtual bytes the page length allows: MapLo <= va < MapHi
Global Dim MapHi.l(64)
Global Dim MapAcf.l(64)     ; -1 stale, 0 not resident, 1 read-only, 3 read/write
; THE FAST WINDOWS, one entry's five words together (2026-10-25): MapF(e * 8 +
; 0-4) is MapRLo, MapRHi, MapWLo, MapWHi and MapHost, so the mapped loop's
; assembly reaches all five from one base (tools/mmu_gen.py, map_rows) instead
; of loading three or four array addresses on every access.
Global Dim MapF.i(64 * 8)
Macro MapRLo(mE)            ; readable and all in one memory (SRAM, or the PSRAM) ...
  MapF((mE) << 3)
EndMacro
Macro MapRHi(mE)
  MapF(((mE) << 3) + 1)
EndMacro
Macro MapWLo(mE)            ; ... and writable with W already set
  MapF(((mE) << 3) + 2)
EndMacro
Macro MapWHi(mE)
  MapF(((mE) << 3) + 3)
EndMacro
Macro MapHost(mE)           ; the fast windows' memory: virtual byte va is at host address va + MapHost
  MapF(((mE) << 3) + 4)
EndMacro
Global MapMask.l ; $3FFFF (18-bit) or $3FFFFF (22-bit)
Global Dim UbMap.l(32)      ; THE UNIBUS MAP: each register's 22-bit address (bit 0 always 0)
Global CpuErr.l ; the CPU error register (THE CPU ERROR AND MAINTENANCE REGISTERS)
Global MaintTrap.l ; the maintenance register's bit 3: a kernel HALT traps through 4
; the current mode's entry bases
Global PrvBase.l ; the previous mode's (mode * 16), for MFPI/MFPD/MTPI/MTPD
Global TrapHeld.l ; a trap a trap sequence left pending, across the mapped slow fetch
; where the last mapped operand address lies (EaWordM)
Global MmE.l ; the mapped memory macros' entry
Global RunSave.l ; CpuRun's RunFrom while the mapped loop runs
; THE FETCH WINDOW AND THE INSTRUCTION'S ADDRESS, in one array so that the
; mapped tails (assembly, #ASM_TAILS) reach all four through one base
; register: Fw(0) FetchLo, Fw(1) FetchHi, Fw(2) FetchBase (MmuFetchWindow),
; Fw(3) the address of the mapped instruction being run (MMR2). A literal
; index costs compiled code nothing: Fw(1) is the address of Fw plus 4.
; FwSave(m * 4 + 0..2): mode m's fetch window (Fw(0..2)) while another mode
; runs - PswBanks keeps it and gives it back, so a trap or an interrupt and
; its RTI do not find the window again each way (2026-10-21). Emptied with
; the map: MmuRecompute (every mode), MmuRegChanged (an I entry's mode).
Global Dim FwSave.i(16)
; The dispatch tails as assembly blocks (instructions.pico2, and the mapped
; ones tools/mmu_gen.py writes). They name the reserved registers through
; "ASM Uses", so they need PureMetal Forge main f408822d or later; 0 builds
; the compiled tails.
#ASM_TAILS = 0
; The mapped loop's MOV handlers by addressing mode with an assembly fast path
; in front of each (tools/mmu_gen.py, asm_mov; held to the plain handlers by
; asm_check.pico2). 0 builds the plain handlers alone.
#ASM_MOV = 0
; EaWordM's four commonest modes in assembly, called by the mapped handlers
; (tools/mmu_gen.py, ASM_EAW; held to EaWordM by asm_check.pico2). 0: they call EaWordM.
#ASM_EA = 0
; PushM and PopM's fast paths in assembly (__pushm, __popm), and JSR, RTS and DIV
; in assembly in front of their plain handlers (tools/mmu_gen.py, pico2_ops; held to
; the plain ones by asm_check.pico2). Needs #ASM_EA = 1. 0: the plain handlers alone.
#ASM_FAST = 0                          ; unmapped native branch/register forms
#ASM_MEM = 0                           ; unmapped native RAM access helpers
#ASM_IMX = 0                           ; unmapped immediate/indexed forms
#ASM_INDEXED = 0                       ; indexed CLR/TST/INC/DEC and byte CLR/TST
#ASM_OPS = 0
; The FPJ11 floating point unit (fp11.pico2, included after this file): 1
; executes 170000-177777; 0 leaves them reserved instructions (trap to 10).
#FP11 = 1
; Its fraction multiply and divide in assembly (fp11.pico2, FpFracMulAsm and
; FpDivQAsm; held to FpFracMulRef and FpDivQRef by asm_check.pico2). 0: the Basic.
#ASM_FP = 0
Global Fps.l, Fec.l, Fea.l ; its status, exception code and address (fp11.pico2)
Global Dim FrH.l(6)              ; its six accumulators, high and low halves
Global Dim FrL.l(6)
; Measured on a Pico 2 W, 2026-10-19 (V6 `time od /rkunix`, host-timed): 13.24 s
; before, 11.14 s with #ASM_MOV, 10.36 s with both; a Pico Plus 2 W 13.37 -> 10.44 s.
; the instruction MMR1 holds the changes of
Global MmuTouches.l ; reads and writes of the unit's registers, for tests
Global Halted.l, Waiting.l
Global PC.l ; the emulated PC between instructions; Reg(7) is its
                            ; stale copy then (see THE EMULATED PC in instructions)

; The run loop's countdown and the machine's clock - see THE RUN WINDOW.
Global RunLeft.l ; instructions left in this window
Global RunWindow.l ; how many the window started with
Global RunBank.l ; instructions this CpuRun still owes after the window
Global RunFrom.l ; InstrCount when this CpuRun began
Global InstrCount.l ; instructions finished before this window began

; The console DL11 and the switch register - see THE I/O PAGE.
Global Dl11RxDone.l, Dl11RxIe.l, Dl11RxBuf.l
Global Dl11RxPolled.l ; the program has looked at RCSR since the last character
Global Dl11RxDue.l ; InstrCount at which the receiver may take its next character
Global Dl11RxReads.l ; characters the program has read from RBUF (the stats block)
Global Dl11TxRdy.l, Dl11TxIe.l, Dl11TxChar.l, Dl11TxDue.l
Global SwitchReg.l, DisplayReg.l
Global IntReq.l ; interrupts asked for: #INT_DL11_RX | #INT_DL11_TX | #INT_RK | #INT_KW | #INT_RP
Global RpPresent.l, RpBusy.l, RpIoPosted.l ; the RP11 (rp11.pico2): an RP pack, a transfer, its request out
Global CacheCcr.l ; the cache control register's bits, kept (THE CACHE REGISTERS)
Global DevActive.l ; the disk or the clock needs a look every window (DevPoll, rk11/kw11)
Global DevFast.l ; the disk does: windows of #DEV_WINDOW, not #DEV_WINDOW_CLOCK
; The console's two byte queues - the ONLY things the firmware around the
; emulator touches. The emulator writes ConOut at its Head and reads ConIn
; at its Tail; the firmware does the opposite. Neither side calls the
; other, so the serial side can move to the second core unchanged.
Global Dim ConOut.u(#CON_SIZE)      ; characters the DL11 has sent
Global ConOutHead.l, ConOutTail.l
Global Dim ConIn.u(#CON_SIZE)       ; characters typed, for the DL11 to receive
Global ConInHead.l, ConInTail.l

; ---- THE TWO CORES --------------------------------------------------------
; Core 0 runs the processor and nothing else; core 1 runs USB, the console,
; the disk's storage and the clock's 60 Hz source (diag, Core1Main). What
; crosses between them is single-writer words and single-producer rings
; (ConOut: core 0 -> 1; ConIn: core 1 -> 0), each published with a barrier
; between the data and the index that announces it.
Global KwSeq.l ; line-clock ticks: written by core 1 only (kw11, KwTick)
Global DkReqSeq.l, DkReqOp.l, DkReqDrive.l, DkReqBlock.l ; a storage request: core 0 writes (rk11, RkIo)
Global DkDoneSeq.l, DkDoneResult.l ; its answer: core 1 writes (rk11, DkServe)

; A data memory barrier: every store before it is visible to the other core
; before any store after it (and the same for loads). The language has no
; expression for it, so it is one instruction, named. The Cortex-M33 needs
; it; on the RP2040's Cortex-M0+ it costs a few cycles and changes nothing.
Procedure SmpBarrier()
EndProcedure

; ---- Globals held in registers for the whole program (see SPEED) -----
; The A/B switch: 0 puts these four back in RAM and changes nothing else.
; Chosen by measurement, 2026-09-23, on the desk (arm_run; the report's
; bench and a mixed run of 19 diagnostic tapes), best on BOTH parts:
;   Op, PC, Res, RunLeft   1,315,682 / 1,694,760 bench, 693,207 / 852,525 mix
;   Op, Src, Res, PC       1,301,950 / 1,675,827 bench, 688,969 / 848,659 mix
;   Op, PC, Src, RunLeft   1,281,951 / 1,648,207 bench
; (Pico / Pico 2, instructions/s, before the immediate and CC fast paths.)
; Two 16-bit Globals in one register's halves (the Pico 2's r8.lo/r8.hi)
; were measured too - Op and PC sharing r8, Src, Res and RunLeft whole -
; and LOST: 1,395,256 against 1,492,426 at the time, the half reads and
; writes costing more than the fifth register saves.
#RESERVE_REGISTERS = 0
; #RESERVE_MORE = 1 adds FlagNZ in r4. (Src in r12 was worth a little more on
; the desk, but a core holding r12 may make no call between flash and SRAM,
; and the run loops now live in SRAM with some callees in flash - Micros(),
; the disk's procedures - so r12 stays free.) It needs a compiler with r12 and r4-r7 (branch
; regres-more, 6c9bfed6): that compiler proves, on the emitted code, that
; nothing core 0 runs writes r12 or uses r4 without saving it. Core 1 (diag,
; Core1Main) never names any of these Globals.
#RESERVE_MORE = 1
CompilerIf #RESERVE_REGISTERS = 1
  CompilerIf #RESERVE_MORE = 1

  CompilerElse

  CompilerEndIf
CompilerEndIf

; ======================================================================
;  THE RUN WINDOW - how the devices get a word in without costing the
;  instructions anything.
;
;  CpuRun(n) runs its n instructions as one or more WINDOWS. RunLeft is
;  the countdown every handler's tail already keeps; when it reaches zero
;  the loop leaves through RunEnd (instructions.pico2), which brings the
;  clock up to date, lets the devices act (DevService), and opens the next
;  window. So a device that needs the CPU's attention at a given moment -
;  a character finished, an interrupt requested - only has to SHORTEN the
;  current window: CpuEventIn(k) makes RunEnd come round after k more
;  instructions. Nothing is added to the path an instruction takes; the
;  only cost falls on the rare instruction that touches a device.
;
;  InstrCount + RunWindow - RunLeft is the number of instructions finished
;  so far (CpuNow), and it is the devices' clock.
; ======================================================================
Procedure CpuEventIn(k.l)
  If k < RunLeft
    RunBank = RunBank + RunLeft - k
    RunWindow = RunWindow - (RunLeft - k)
    RunLeft = k
  EndIf
EndProcedure

Procedure.l CpuNow()
  ProcedureReturn InstrCount + RunWindow - RunLeft
EndProcedure

; The bus request level of the highest interrupt asked for, as a PSW
; priority field: the line clock at BR6, the disk at BR5, the console at
; BR4. A request gets in when the PSW priority is BELOW it.
Procedure.l IntLevel()
  If IntReq & #INT_KW
    ProcedureReturn $C0
  EndIf
  If IntReq & (#INT_RK | #INT_RP)
    ProcedureReturn $A0
  EndIf
  ProcedureReturn $80
EndProcedure

; An interrupt is asked for and the priority would let it in. Called
; whenever the PSW changes, so a lowered priority lets a waiting request in
; at once.
Procedure IntCheck()
  If IntReq
    If (PswHigh & $E0) < IntLevel()
      CpuEventIn(1)
    EndIf
  EndIf
EndProcedure

; ======================================================================
;  PSW - assembled only when read
; ======================================================================
Procedure.l FlagN()
  If FlagNZ & $18000
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.l FlagZ()
  If (FlagNZ & $FFFF) = 0
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure

; Encode an explicit N and Z (from the PSW, MTPS, a condition-code op) in
; the lazy form. N=1 with Z=1 cannot come from a result, so it is $10000:
; low 16 bits zero (Z) and bit 16 set (N).
Procedure SetNZ(n.l, z.l)
  If z
    FlagNZ = n << 16
  ElseIf n
    FlagNZ = $8000
  Else
    FlagNZ = 1
  EndIf
EndProcedure

Procedure.l PswGet()
  ProcedureReturn (PswHigh & $FFF0) | (FlagN() << 3) | (FlagZ() << 2) | ((FlagV >> 14) & 2) | ((FlagC >> 16) & 1)
EndProcedure

; THE MODES AND THE TWO REGISTER SETS. The J-11 keeps a separate stack
; pointer for kernel (PSW 15-14 = 00), supervisor (01) and user (11) mode,
; and two sets of R0-R5 selected by PSW bit 11 (KDJ11-E user's guide
; EK-KDJ1E-UG-001, figure 1-1, the programming model: KSP/SSP/USP, R0-R5
; and R0'-R5'). R6 and R0-R5 always hold the ones in use; the others wait
; here and are swapped whenever the PSW changes mode or register set, so
; this costs nothing unless it happens. MAINDEC-11-DFKAA test 605 sets SP
; in user mode and expects the kernel's back on return.
Procedure PswBanks(v.i)
  Protected i.i, t.i
  If (v ! PswHigh) & $C000
    StackBank((PswHigh >> 14) & 3) = Reg(6)
    Reg(6) = StackBank((v >> 14) & 3)
    t = CurI >> 2                        ; the old mode's fetch window, kept for its return
    FwSave(t) = Fw(0)
    FwSave(t + 1) = Fw(1)
    FwSave(t + 2) = Fw(2)
  EndIf
  If (v ! PswHigh) & $0800
    For i = 0 To 5
      t = Reg(i)
      Reg(i) = RegAlt(i)
      RegAlt(i) = t
    Next
  EndIf
  CurI = ((v >> 14) & 3) << 4            ; the memory management unit's entry bases
  CurD = CurI + 8
  PrvBase = ((v >> 12) & 3) << 4
  If (v ! PswHigh) & $C000             ; a new mode: its own fetch window, as it left it (or
    t = CurI >> 2                        ; empty: FwSave, below). The register set and the
    Fw(0) = FwSave(t)                    ; previous mode do not touch the fetch, so they keep it
    Fw(1) = FwSave(t + 1)
    Fw(2) = FwSave(t + 2)
  EndIf
EndProcedure

; The stack pointer of mode m (0 kernel, 1 supervisor, 3 user), wherever
; it is kept - MFPI SP and MTPI SP name the PREVIOUS mode's.
Procedure.l ModeSp(m.l)
  If m = (PswHigh >> 14) & 3
    ProcedureReturn Reg(6)
  EndIf
  ProcedureReturn StackBank(m)
EndProcedure

Procedure SetModeSp(m.l, v.l)
  If m = (PswHigh >> 14) & 3
    Reg(6) = v & $FFFF
  Else
    StackBank(m) = v & $FFFF
  EndIf
EndProcedure

Procedure PswSet(v.l)
  If (v ! PswHigh) & $F800
    PswBanks(v)
  EndIf
  PswHigh = v & $FFF0
  SetNZ((v >> 3) & 1, (v >> 2) & 1)
  FlagV = v << 14
  FlagC = v << 16
  IntCheck()
  If v & $10                             ; T set: one instruction per window (StartWindow)
    CpuEventIn(1)
  EndIf
EndProcedure

; The PSW written THROUGH ITS ADDRESS, 177776, by an ordinary instruction
; (CLR @#177776, BIS #17,@#177776, MOVB R0,@#177776). Two J-11 rules:
;  * the written value wins: the condition codes the instruction itself
;    would set are NOT applied on top of it (MAINDEC-11-DFKAB, the 11/34
;    traps test, checks this after SCC / CLR PSW at 002032-002116);
;  * the T bit cannot be set this way - "The T-bit cannot be set by
;    explicitly writing to the PSW; it can only be changed by the RTI/RTT
;    instructions" (KDJ11-E user's guide EK-KDJ1E-UG-001, sec. 1.2.6).
; Every handler sets its condition codes AFTER its write, so the value is
; applied now and again at the end: PswLate carries it, and TrapVector =
; #TRAP_PSW_LATE sends the instruction through SlowTail (every handler that
; can write memory ends with NextSynced, which tests TrapVector), so the
; path an instruction normally takes is untouched.
Procedure PswWrite(v.l)
  v = (v & $FFEF) | (PswHigh & $10)
  PswSet(v)
  PswLate = v | $10000
  If TrapVector = 0
    TrapVector = #TRAP_PSW_LATE
  EndIf
EndProcedure

; A BUS ERROR - an odd address, or nothing at the address - ABORTS the
; instruction on the J-11: it traps through 4 with the PSW as it was
; before the instruction, so the condition codes the instruction would
; have set are never set (MAINDEC-11-DFKAB test 55: CLR PSW, CCC, then TST
; from an odd address must stack a PSW of 000000). The emulator still
; finishes the instruction and takes the trap after it, so the PSW is
; saved here, at the first failing access - every handler sets its
; condition codes after its memory accesses - and SlowTail puts it back
; before taking the trap.
Procedure BusError()
  If TrapVector <> #VEC_BUS
    AbortPsw = PswGet() | $10000
  EndIf
  TrapVector = #VEC_BUS
EndProcedure

; ======================================================================
;  THE MEMORY MANAGEMENT UNIT (KDJ11-E user's guide EK-KDJ1E-UG-001,
;  section 1.4 and chapter on memory management; the KT11 scheme of the
;  11/70 with the J-11's addresses):
;    MMR0 177572  15 non-resident, 14 page length, 13 read-only abort,
;                 8 maintenance, 6-5 mode, 4 D space, 3-1 page (all six
;                 filled by an abort, and frozen with it until 15-13 are
;                 cleared), 0 ENABLE
;    MMR1 177574  the register changes (auto-increment/decrement) the
;                 aborted instruction made: amount in 7-3, register in 2-0,
;                 a second change in the high byte
;    MMR2 177576  the virtual address of the instruction
;    MMR3 172516  5 the Unibus map relocates, 4 22-bit mapping, 3 (CSM
;                 enable: kept, CSM itself traps as reserved), 2-0 D space
;                 for kernel/supervisor/user
;    PDR/PAR      kernel 172300-172376, supervisor 172200-172276, user
;                 177600-177676: I PDRs, D PDRs, I PARs, D PARs, 8 each.
;                 PDR: 14-8 page length (64-byte blocks), 6 W (written), 3
;                 ED (grows down), 2-1 access (00 and 10 not resident, 01
;                 read-only, 11 read/write). A write to a PDR or its PAR
;                 clears W.
;  THE PRECOMPUTED MAP. Register writes invalidate the affected entries;
;  MmuPhys rebuilds each on first use, coalescing PAR/PDR writes and leaving
;  unused pages unbuilt. MmuRecompute handles MMR3 eagerly. The physical offset (MapBase), the
;  virtual bytes the length allows (MapLo/MapHi) and the access - and the
;  FAST WINDOWS: the virtual range that is readable (MapRLo/MapRHi), or
;  writable with W already set (MapWLo/MapWHi), and lies wholly in ONE of
;  the two memories: the 56 KB in SRAM (Mem), or, on a board with PSRAM,
;  the memory above it (psram_pdp11.pico2), which ends at MemLim: MemTop
;  with 22-bit mapping, 248 KB without (an 18-bit address from 760000 up is
;  the I/O page, whatever memory is fitted). MapHost is where that memory's
;  bytes are for the entry: virtual byte va is at host address va + MapHost.
;  Both memories hold a word low byte first, so one load or store serves
;  either, and a page in PSRAM is reached exactly as a page in SRAM is. A
;  mapped access in the window is two compares and a load (MMReadWordE and
;  friends, below); anything else - outside the window, odd, the I/O page,
;  an abort, the first write to a page, a page that lies across the end of
;  the SRAM - goes through MmuPhys.
; ======================================================================
; One entry of the map, from its registers (a D entry uses the I
; registers while its mode's D space is off).
Procedure MmuMapEntry(e.i)
  Protected m.i, s.i, p.i, r.i, dv.i, plf.i, pb.i, lo.i, hi.i, bs.i, acf.i, dm.i
  m = e >> 4
  s = (e >> 3) & 1
  p = e & 7
  r = e
  If s = 1                         ; D space off for this mode: the I registers
    If m = 0
      dm = 4
    ElseIf m = 1
      dm = 2
    Else
      dm = 1
    EndIf
    If (Mmr3 & dm) = 0
      r = e - 8
    EndIf
  EndIf
  MapReg(e) = r
  dv = Pdr(r)
  acf = (dv >> 1) & 3
  If acf = 2 Or m = 2              ; 10 is not resident; mode 10 does not exist
    acf = 0
  EndIf
  MapAcf(e) = acf
  plf = (dv >> 8) & $7F
  pb = p << 13
  If dv & 8                       ; the page grows down from its top
    lo = pb + (plf << 6)
    hi = pb + $2000
  Else
    lo = pb
    hi = pb + ((plf + 1) << 6)
  EndIf
  bs = (Par(r) << 6) - pb
  MapBase(e) = bs
  MapLo(e) = lo
  MapHi(e) = hi
  MapF((e << 3)) = #MAP_NONE
  MapF((e << 3) + 1) = 0
  MapF((e << 3) + 2) = #MAP_NONE
  MapF((e << 3) + 3) = 0
  MapF((e << 3) + 4) = @Mem(0) + bs
  If bs + lo < #RAM_BYTES          ; the page starts in the SRAM: what lies in it is fast
    If bs + hi > #RAM_BYTES
      hi = #RAM_BYTES - bs
    EndIf
  Else
    CompilerIf #DESK_MEM = 1          ; it starts in the PSRAM: what lies below MemLim is fast
      If bs + hi > MemLim          ; (MemLim is #RAM_BYTES when no PSRAM is in use: no window)
        hi = MemLim - bs
      EndIf
      MapF((e << 3) + 4) = PsMem + bs
    CompilerElse
      hi = lo                      ; no memory there
    CompilerEndIf
  EndIf
  If acf <> 0 And hi > lo And bs + lo >= 0 And ((Par(r) << 6) + $2000) <= MapMask
    MapF((e << 3)) = lo
    MapF((e << 3) + 1) = hi
    If acf = 3 And (dv & $40) <> 0
      MapF((e << 3) + 2) = lo
      MapF((e << 3) + 3) = hi
    EndIf
  EndIf
EndProcedure

; HOST TIME, NOT EMULATED TIME. Working the map out again costs the host
; far more than an instruction does (the I/O page path and the map code
; are both slow paths), and a program that rewrites its PARs in a loop
; (MAINDEC-11-DFKAB sets up all 48 PDR/PAR pairs over and over) would
; otherwise make one CpuRun(n) take many times its usual time - the
; firmware sizes n so that USB is served every millisecond. So the rework
; ends the run window after this instruction and takes k instructions'
; worth from the caller's budget: CpuRun returns sooner, having run fewer
; instructions. Nothing the program can see changes - the emulated clock
; (InstrCount) counts only the instructions run.
; When the window has room for k more, the k come out of the window itself
; (RunLeft and RunWindow both shrink, so CpuNow does not move): the same
; budget charged, and no window end - a context switch writes 32 PARs and
; PDRs, and each used to end a window (2026-10-23: 2.6% of a compile's time
; went to the window ends). Only a window with no room for them ends.
Procedure MmuCharge(k.l)
  If RunLeft > k + 1
    RunLeft = RunLeft - k
    RunWindow = RunWindow - k
  Else
    CpuEventIn(1)
    RunBank = RunBank - k
  EndIf
EndProcedure

; The whole map: after MMR3 changes (D space, 22-bit mapping) and at reset.
Procedure MmuRecompute()
  Protected e.i
  If Mmr3 & $10
    MapMask = $3FFFFF
  Else
    MapMask = $3FFFF
  EndIf
  CompilerIf #DESK_MEM = 1
    MemLim = MemTop                    ; the memory this mapping reaches
    If MemLim > MapMask - $1FFF
      MemLim = MapMask - $1FFF
    EndIf
  CompilerEndIf
  For e = 0 To 63
    MmuMapEntry(e)
  Next
  MmuCharge(#MAP_COST_ALL)
  CurI = ((PswHigh >> 14) & 3) << 4
  CurD = CurI + 8
  PrvBase = ((PswHigh >> 12) & 3) << 4
  Fw(0) = #MAP_NONE                    ; the fetch window is found again, every mode's
  Fw(1) = 0
  For e = 0 To 3
    FwSave(e * 4) = #MAP_NONE
    FwSave(e * 4 + 1) = 0
  Next
EndProcedure

; One register pair changed. Invalidate both fast windows before returning:
; no assembly reader can use stale translation or permissions. MapReg stays
; valid because only MMR3 changes borrowing, and MmuRecompute is eager.
; Keep the original host-time charge and all fetch-window invalidations.
Procedure MmuMapStale(e.i)
  MapAcf(e) = -1
  MapF(e << 3) = #MAP_NONE
  MapF((e << 3) + 2) = #MAP_NONE
EndProcedure

Procedure MmuRegChanged(r.i)
  MmuCharge(#MAP_COST_ENTRY)
  MmuMapStale(r)
  If (r & 8) = 0
    If MapReg(r + 8) = r
      MmuMapStale(r + 8)
    EndIf
    FwSave((r >> 4) * 4) = #MAP_NONE     ; an I entry: its mode's fetch window is found again
    FwSave((r >> 4) * 4 + 1) = 0         ; (a D entry is never fetched through)
    If (r & $30) = CurI
      Fw(0) = #MAP_NONE
      Fw(1) = 0
    EndIf
  EndIf
EndProcedure

Procedure MmuReset()                     ; power-up and the bus INIT: MMR0 and MMR3 cleared
  Mmr0 = 0
  Mmr3 = 0
  If MmuOn
    MmuOn = 0
    CpuEventIn(1)                        ; back to the unmapped run loop
  EndIf
  MmuRecompute()
EndProcedure

; The register an I/O page address names: entry | $100 for a PAR, the
; entry for a PDR, or -1 if it is not a PAR or PDR.
Procedure.l MmuRegIndex(a.l)
  Protected b.l, m.l, o.l
  If a >= $FF80 And a < $FFC0
    m = 3
    b = $FF80
  ElseIf a >= $F4C0 And a < $F500
    m = 0
    b = $F4C0
  ElseIf a >= $F480 And a < $F4C0
    m = 1
    b = $F480
  Else
    ProcedureReturn -1
  EndIf
  o = (a - b) >> 1                       ; 0-7 I PDR, 8-15 D PDR, 16-23 I PAR, 24-31 D PAR
  ProcedureReturn (m << 4) | (o & 15) | ((o >> 4) << 8)
EndProcedure

Procedure.l MmuIsReg(a.l)
  If a = #MMR0_ADDR Or a = #MMR1_ADDR Or a = #MMR2_ADDR Or a = #MMR3_ADDR
    ProcedureReturn 1
  EndIf
  If MmuRegIndex(a) >= 0
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i MmuRegRead(a.i)
  Protected r.i
  MmuTouches = MmuTouches + 1
  If a = #MMR0_ADDR
    ProcedureReturn Mmr0
  ElseIf a = #MMR1_ADDR
    If (Mmr0 & $E000) = 0 And MmuPcRec <> Fw(3)
      ProcedureReturn 0                  ; nothing recorded for this instruction yet
    EndIf
    ProcedureReturn Mmr1
  ElseIf a = #MMR2_ADDR
    If (Mmr0 & $E000) = 0
      ProcedureReturn Fw(3)
    EndIf
    ProcedureReturn Mmr2
  ElseIf a = #MMR3_ADDR
    ProcedureReturn Mmr3
  EndIf
  r = MmuRegIndex(a)
  If r & $100
    ProcedureReturn Par(r & $FF)
  EndIf
  ProcedureReturn Pdr(r)
EndProcedure

Procedure MmuRegWrite(a.l, v.l)
  Protected r.l
  MmuTouches = MmuTouches + 1
  If a = #MMR0_ADDR                      ; 15-13, 8 and 0 are writable
    v = (Mmr0 & $00FE) | (v & $E101)
    If (v ! Mmr0) & 1
      MmuOn = v & 1
      CpuEventIn(1)                      ; the other run loop, from the next instruction
    EndIf
    Mmr0 = v
  ElseIf a = #MMR3_ADDR
    Mmr3 = v & $3F
    MmuRecompute()
  ElseIf a = #MMR1_ADDR Or a = #MMR2_ADDR
    ProcedureReturn                      ; read-only
  Else
    r = MmuRegIndex(a)
    If r & $100
      r = r & $FF
      v = v & $FFFF
      If Par(r) = v And (Pdr(r) & $40) = 0
        MmuCharge(#MAP_COST_ENTRY)
        ProcedureReturn
      EndIf
      Par(r) = v
      Pdr(r) = Pdr(r) & ~$40
    Else
      v = v & $7F0E
      If Pdr(r) = v
        MmuCharge(#MAP_COST_ENTRY)
        ProcedureReturn
      EndIf
      Pdr(r) = v
    EndIf
    MmuRegChanged(r)
  EndIf
EndProcedure

; ======================================================================
;  THE UNIBUS MAP. The RK11 is a Unibus controller: it makes 18-bit bus
;  addresses (RKBA and the two MEX bits). On a 22-bit machine the bus
;  reaches memory through the map: 32 registers of two words at
;  17770200-17770376 (low word: address bits 15-1, bit 0 reads 0; high
;  word: bits 21-16 in its bits 5-0). Bus address bits 17-13 pick a
;  register and bits 12-0 are added to it; 760000-777777 is the bus's own
;  I/O page and no register maps it (the 32nd can be written and read and
;  maps nothing). MMR3 bit 5 switches the relocation on; while it is off a
;  bus address IS the physical address (the low 248 KB).
;  Unix V6 uses it exactly so (the pack's /usr/sys/conf/m45.s sets MMR3 to
;  000065 and takes the machine for an 11/70 if bit 5 stays set; main.c
;  then loads the registers one to one, UBMAP 0170200; dmr/bio.c mapalloc
;  points registers 16 up at a buffer above 248 KB for raw I/O and swap).
;  SOURCE: PDP-11/84 System Technical and Reference Manual,
;  EK-1184E-TM-001 (December 1987), section 2.13 "UNIBUS Mapping", pages
;  2-55 to 2-58: the 248 KB of bus addresses below the bus's I/O page go
;  through the map (figure 2-33); with relocation disabled "the UNIBUS map
;  appends four leading zeros"; with it enabled bus address bits 17-13
;  select one of 31 pairs and the pair's content is added to bits 12-0
;  (also 2.3.7, page 2-23, and figure 2-8); the high register holds bits
;  21-16 and the low register bits 15-01 (figures 2-34 and 2-35); table
;  2-26 gives the addresses, and of pair 37 says "Can be read or written
;  into, but not used for mapping". MMR3 bit 05 "enables the I/O map for
;  the UNIBUS adapter" (table 2-4, page 2-23). Page 2-61: with no memory
;  on the Unibus itself (the machine modelled), the processor sees its
;  memory in one run from 00000000, up to 17757777 if that much is fitted,
;  and "all UNIBUS DMA devices access PMI memory through the UNIBUS map".
;  The manual does not say what a RESET does to the map registers; they
;  are cleared at power-up only (CpuReset), as simh does (pdp11_cpu.c).
;  NOT MODELLED: memory on the Unibus itself and the adapter's memory
;  configuration register (17777734), and the adapter's DMA cache - the
;  manual's appendix B.2 says of those registers that they "are not
;  normally used by system-level software"; the boot ROM uses them, and
;  no boot ROM is modelled.
;
;  THE CPU ERROR AND MAINTENANCE REGISTERS (the same manual, 2.5.3 and
;  2.5.5, pages 2-35 to 2-39).
;    177766 CPU error: "identifies the source of any abort or trap that
;      caused a trap through location 4"; bit 7 illegal HALT (HALT in user
;      or supervisor mode), 6 address error (a word at an odd address), 5
;      nonexistent memory, 4 I/O bus timeout (the I/O page), 3 yellow stack
;      violation, 2 red stack violation (the red zone is not modelled: bit
;      2 is never set). "Cleared when it is written ... also cleared at
;      power-up or by console start. It is unaffected by a RESET".
;    177750 maintenance: bit 9 Unibus system (1), 8 FPA available (0: no
;      floating point is modelled), 7-4 module type 2 (KDJ11-BF), 3
;      halt/trap option (read/write: set, a kernel-mode HALT traps through
;      4 and does not halt; cleared at power-up), 2-1 power-up code 2,
;      0 BPOK (1).
;    The KDJ11-B CPU Module User's Guide EK-KDJ1B-UG-001 says the same of
;    both registers (1.2.7 and table 1-4, page 1-6; table 1-22, page
;    1-44), of HALT outside kernel mode ("the HALT instruction causes a
;    trap through location 4", 1.2.2, page 1-3; so does the KDJ11-E guide
;    EK-KDJ1E-UG-001, 1.2.2, page 1-4), and of MMR3 bit 5: read/write and
;    "not interpreted by the KDJ11-B" (table 1-11, page 1-22) - the Unibus
;    adapter is what uses it.
;  The 11/84 has no system size registers (17777760, 17777762), no system
;  ID register and no stack limit register (appendix B.3, page B-4): a
;  program finds the memory size by reading until a trap through 4.
; ======================================================================
Procedure.l UbRegRead(a.l)                  ; a is even, #UBMAP_ADDR <= a < #UBMAP_END
  Protected r.l
  r = (a - #UBMAP_ADDR) >> 2
  If a & 2
    ProcedureReturn (UbMap(r) >> 16) & $3F
  EndIf
  ProcedureReturn UbMap(r) & $FFFE
EndProcedure

Procedure UbRegWrite(a.l, v.l)
  Protected r.l
  r = (a - #UBMAP_ADDR) >> 2
  If a & 2
    UbMap(r) = (UbMap(r) & $FFFE) | ((v & $3F) << 16)
  Else
    UbMap(r) = (UbMap(r) & $3F0000) | (v & $FFFE)
  EndIf
EndProcedure

; The physical address a controller's 18-bit bus address reaches, or
; #UB_NONE when no memory answers there (the bus's I/O page).
Procedure.l UbPhys(ba.l)
  If ba >= #UB_IOPAGE
    ProcedureReturn #UB_NONE
  EndIf
  If Mmr3 & $20
    ProcedureReturn (UbMap(ba >> 13) + (ba & $1FFF)) & $3FFFFF
  EndIf
  ProcedureReturn ba
EndProcedure

; ======================================================================
;  THE I/O PAGE - reached only from the four procedures below, and only
;  for an address past the end of RAM, so none of it is on the path a RAM
;  access takes.
;
;  THE CONSOLE DL11 (DL11 / KL11 manuals; the KDJ11-B console is the same
;  four registers at the same addresses, vectors 60 and 64, BR4):
;    177560 RCSR  bit 7 DONE (a character is waiting; read-only),
;                 bit 6 INTERRUPT ENABLE
;    177562 RBUF  bits 7-0 the character; reading it clears DONE
;    177564 XCSR  bit 7 READY (read-only), bit 6 INTERRUPT ENABLE
;    177566 XBUF  bits 7-0: writing starts a character and clears READY;
;                 READY comes back #DL11_TX_INSTRUCTIONS instructions
;                 later, when the character has gone into ConOut
;  An interrupt is REQUESTED (a bit in IntReq) when DONE or READY rises
;  with its enable set, or the enable is set while DONE or READY already
;  is; the request is withdrawn when the enable is cleared, when RBUF is
;  read (receiver) or XBUF written (transmitter), and when the interrupt
;  is taken. IntReq is the one word the run loop looks at (DevService).
;  Characters leave through the ConOut queue and arrive through ConIn;
;  the firmware around the emulator moves them to and from the USB serial
;  port - and takes a character from the port only when the receiver is
;  empty and the program is waiting for one (Dl11RxWanted). A character
;  waiting in ConIn reaches RBUF at the next window
;  boundary after DONE is clear. If ConOut is full the transmitter just
;  stays busy until the firmware has drained it - nothing is lost.
;
;  THE CACHE REGISTERS (KDJ11-B, 177744-177752). The J-11 module has a
;  cache, and every operating system written for it touches these three:
;    177744 MSER  memory system error - reads 0 (no parity or cache error
;                 is ever recorded); a write (which clears it) does nothing
;    177746 CCR   cache control - the bits a program writes are kept and
;                 read back (bits 13-0); nothing else changes, there being
;                 no cache to force-miss, flush or disable
;    177752 HMR   hit/miss - reads 0; writes are ignored
;  Without them a write to the CCR bus-errors; V7's /boot does it after
;  finding MMR3's 22-bit bit, and loops in its own vector 4.
;
;  THE SWITCH REGISTER (177570): reads SwitchReg, which the firmware sets
;  (a diagnostic's options); a write goes to DisplayReg and is kept, not
;  shown. The KDJ11-B has no switches; the diagnostics read them anyway.
; ======================================================================
Procedure.l IoRead(a.l)                  ; a is even and past the end of RAM
  If (a & $FF80) = #DEMO_BASE : ProcedureReturn DdRead(a) : EndIf   ; desktop_gen: the demo devices
  CompilerIf #DEMO_DEV = 1
    If (a & $FF80) = #DEMO_BASE
      ProcedureReturn DdRead(a)
    EndIf
  CompilerEndIf
  If a = #PSW_ADDR
    ProcedureReturn PswGet()
  ElseIf a = #DL11_RCSR
    Dl11RxPolled = 1
    ProcedureReturn (Dl11RxDone << 7) | (Dl11RxIe << 6)
  ElseIf a = #DL11_RBUF
    Dl11RxReads = Dl11RxReads + Dl11RxDone
    Dl11RxDone = 0
    IntReq = IntReq & ~#INT_DL11_RX
    Dl11RxDue = CpuNow() + #DL11_RX_INSTRUCTIONS   ; THE RECEIVER'S PACE (DevService)
    If ConInHead <> ConInTail
      CpuEventIn(#DL11_RX_INSTRUCTIONS)  ; the next typed character's moment
    EndIf
    ProcedureReturn Dl11RxBuf
  ElseIf a = #DL11_XCSR
    ProcedureReturn (Dl11TxRdy << 7) | (Dl11TxIe << 6)
  ElseIf a = #DL11_XBUF
    ProcedureReturn 0
  ElseIf a = #SWR_ADDR
    ProcedureReturn SwitchReg
  ElseIf (a & $FFF0) = #RK_BASE          ; the RK11 (rk11.pico2)
    ProcedureReturn RkRead(a)
  ElseIf a >= #RP_BASE And a <= #RP_LAST And RpPresent   ; the RP11 (rp11.pico2)
    ProcedureReturn RpRead(a)
  ElseIf a = #CCR_ADDR                   ; THE CACHE REGISTERS
    ProcedureReturn CacheCcr
  ElseIf a = #MSER_ADDR Or a = #HMR_ADDR
    ProcedureReturn 0
  ElseIf a = #KW_CSR                     ; the KW11-L (kw11.pico2)
    ProcedureReturn KwRead()
  ElseIf MmuIsReg(a)
    ProcedureReturn MmuRegRead(a)
  ElseIf a >= #UBMAP_ADDR And a < #UBMAP_END   ; THE UNIBUS MAP
    ProcedureReturn UbRegRead(a)
  ElseIf a = #CPUERR_ADDR                ; THE CPU ERROR AND MAINTENANCE REGISTERS
    ProcedureReturn CpuErr
  ElseIf a = #MAINT_ADDR
    CompilerIf #FP11 = 1
    ProcedureReturn #MAINT_FIXED | $0100 | MaintTrap   ; bit 8: the FPA is fitted
    CompilerElse
    ProcedureReturn #MAINT_FIXED | MaintTrap
    CompilerEndIf
  EndIf
  CpuErr = CpuErr | #CPUE_IO
  BusError()
  ProcedureReturn 0
EndProcedure

; v's low byte is the new value of the register's low byte; the DL11 has
; nothing in its high bytes. The PSW is not handled here (see PdpWriteWord).
Procedure IoWrite(a.l, v.l)              ; a is even and past the end of RAM
  If (a & $FF80) = #DEMO_BASE : DdWrite(a, v) : ProcedureReturn : EndIf   ; desktop_gen: the demo devices
  CompilerIf #DEMO_DEV = 1
    If (a & $FF80) = #DEMO_BASE
      DdWrite(a, v)
      ProcedureReturn
    EndIf
  CompilerEndIf
  If a = #DL11_RCSR
    If v & $40
      If Dl11RxIe = 0 And Dl11RxDone = 1
        IntReq = IntReq | #INT_DL11_RX
        IntCheck()
      EndIf
      Dl11RxIe = 1
    Else
      Dl11RxIe = 0
      IntReq = IntReq & ~#INT_DL11_RX
    EndIf
  ElseIf a = #DL11_XCSR
    If v & $40
      If Dl11TxIe = 0 And Dl11TxRdy = 1
        IntReq = IntReq | #INT_DL11_TX
        IntCheck()
      EndIf
      Dl11TxIe = 1
    Else
      Dl11TxIe = 0
      IntReq = IntReq & ~#INT_DL11_TX
    EndIf
  ElseIf a = #DL11_XBUF
    Dl11TxChar = v & $FF
    Dl11TxRdy = 0
    IntReq = IntReq & ~#INT_DL11_TX
    Dl11TxDue = CpuNow() + #DL11_TX_INSTRUCTIONS
    CpuEventIn(#DL11_TX_INSTRUCTIONS)
  ElseIf a = #SWR_ADDR
    DisplayReg = v & $FFFF
  ElseIf (a & $FFF0) = #RK_BASE          ; the RK11 (rk11.pico2)
    RkWrite(a, v & $FFFF)
  ElseIf a >= #RP_BASE And a <= #RP_LAST And RpPresent   ; the RP11 (rp11.pico2)
    RpWrite(a, v & $FFFF)
  ElseIf a = #CCR_ADDR                   ; THE CACHE REGISTERS
    CacheCcr = v & $3FFF
  ElseIf a = #MSER_ADDR Or a = #HMR_ADDR
    ; a write clears the error register and is ignored by hit/miss: nothing is recorded
  ElseIf a = #KW_CSR                     ; the KW11-L (kw11.pico2)
    KwWrite(v)
  ElseIf MmuIsReg(a)
    MmuRegWrite(a, v)
  ElseIf a >= #UBMAP_ADDR And a < #UBMAP_END   ; THE UNIBUS MAP
    UbRegWrite(a, v & $FFFF)
  ElseIf a = #CPUERR_ADDR                ; any write clears it
    CpuErr = 0
  ElseIf a = #MAINT_ADDR                 ; only the halt/trap option can be written
    MaintTrap = v & 8
  ElseIf a <> #DL11_RBUF                 ; RBUF is read-only: a write is ignored
    CpuErr = CpuErr | #CPUE_IO
    BusError()
  EndIf
EndProcedure

; ======================================================================
;  MEMORY - the fast path is RAM; the I/O page and missing memory are slow
; ======================================================================
Procedure.i PdpReadWord(a.i)
  If a & 1
    CpuErr = CpuErr | #CPUE_ODD
    BusError()
    ProcedureReturn 0
  EndIf
  If a < #RAM16
    ProcedureReturn PeekU(@Mem(0) + a)
  EndIf
  ProcedureReturn IoRead(a)
EndProcedure

Procedure PdpWriteWord(a.i, v.i)
  If a & 1
    CpuErr = CpuErr | #CPUE_ODD
    BusError()
    ProcedureReturn
  EndIf
  If a < #RAM16
    PokeU(@Mem(0) + a, v)
    ProcedureReturn
  EndIf
  If a = #PSW_ADDR
    PswWrite(v & $FFFF)
    ProcedureReturn
  EndIf
  IoWrite(a, v)
EndProcedure

; A byte read of a device register is a word read (the bus has no other
; kind), so reading either half of RBUF clears DONE, as on the real bus.
Procedure.i PdpReadByte(a.i)
  If a < #RAM16
    ProcedureReturn PeekA(@Mem(0) + a) & $FF
  EndIf
  If a & 1
    ProcedureReturn (IoRead(a - 1) >> 8) & $FF
  EndIf
  ProcedureReturn IoRead(a) & $FF
EndProcedure

Procedure PdpWriteByte(a.i, v.i)
  If a < #RAM16
    PokeA(@Mem(0) + a, v)
    ProcedureReturn
  EndIf
  If (a & $FFFE) = #PSW_ADDR
    If a & 1
      PswWrite((PswGet() & $00FF) | ((v & $FF) << 8))
    Else
      PswWrite((PswGet() & $FF00) | (v & $FF))
    EndIf
    ProcedureReturn
  EndIf
  If (a & $FFFE) = #CCR_ADDR             ; a byte of the cache control register
    If a & 1
      CacheCcr = (CacheCcr & $00FF) | ((v & $3F) << 8)
    Else
      CacheCcr = (CacheCcr & $3F00) | (v & $FF)
    EndIf
    ProcedureReturn
  EndIf
  If (a & $FFFE) = #MSER_ADDR Or (a & $FFFE) = #HMR_ADDR
    ProcedureReturn
  EndIf
  If (a & $FFF0) = #RK_BASE Or (a & $FFFE) = #KW_CSR Or (a >= #RP_BASE And a <= #RP_LAST + 1 And RpPresent)   ; a byte of a full-word device register
    DevWriteByte(a, v & $FF)
    ProcedureReturn
  EndIf
  If MmuIsReg(a & $FFFE)                 ; a memory management register: one byte of it
    If a & 1
      MmuRegWrite(a & $FFFE, (MmuRegRead(a & $FFFE) & $00FF) | ((v & $FF) << 8))
    Else
      MmuRegWrite(a, (MmuRegRead(a) & $FF00) | (v & $FF))
    EndIf
    ProcedureReturn
  EndIf
  If a >= #UBMAP_ADDR And a < #UBMAP_END ; a Unibus map register: one byte of it
    If a & 1
      UbRegWrite(a & $FFFE, (UbRegRead(a & $FFFE) & $00FF) | ((v & $FF) << 8))
    Else
      UbRegWrite(a, (UbRegRead(a) & $FF00) | (v & $FF))
    EndIf
    ProcedureReturn
  EndIf
  If (a & $FFFE) = #CPUERR_ADDR          ; a write to either byte clears the CPU error register
    CpuErr = 0
    ProcedureReturn
  EndIf
  If a = #MAINT_ADDR + 1                 ; the maintenance register's high byte: nothing to write
    ProcedureReturn
  EndIf
  CompilerIf #DEMO_DEV = 1
    If (a & $FF80) = #DEMO_BASE
      DdWriteByte(a, v)
      ProcedureReturn
    EndIf
  CompilerEndIf
  If (a & $FF80) = #DEMO_BASE : DdWriteByte(a, v) : ProcedureReturn : EndIf   ; desktop_gen: the demo devices
  If a & 1                               ; a device's high byte: nothing there
    If (a & $FFFE) < #DL11_RCSR Or (a & $FFFE) > #SWR_ADDR
      CpuErr = CpuErr | #CPUE_IO
      BusError()
    EndIf
    ProcedureReturn
  EndIf
  IoWrite(a, v & $FF)
EndProcedure


; ---- the RAM fast path, INLINE (macros cost nothing at run time) ---------
; A handler reads and writes memory through these, so the commonest case -
; an even address in RAM - is a compare, a test and one load or store, with
; no call. Anything else (an odd address, the I/O page) calls the procedure
; above, which does exactly what it always did. mAdr is read several times:
; pass a Global or a register, never an expression with a side effect. (The
; parameters have names no caller uses: an argument spelled exactly like its
; own parameter - MWriteWord(Adr, v) with a parameter v - makes the compiler
; exit with no message, 2026-09-23.)
Macro MReadWord(mDest, mAdr)
  If mAdr < #RAM16
    If (mAdr & 1) = 0
      mDest = PeekU(@Mem(0) + (mAdr))
    Else
      mDest = PdpReadWord(mAdr)
    EndIf
  Else
    mDest = PdpReadWord(mAdr)
  EndIf
EndMacro

Macro MWriteWord(mAdr, mVal)                   ; Mem is .u: the store keeps the low 16 bits
  If mAdr < #RAM16
    If (mAdr & 1) = 0
      PokeU(@Mem(0) + (mAdr), mVal)
    Else
      PdpWriteWord(mAdr, mVal)
    EndIf
  Else
    PdpWriteWord(mAdr, mVal)
  EndIf
EndMacro

Macro MReadByte(mDest, mAdr)
  If mAdr < #RAM16
    mDest = PeekA(@Mem(0) + (mAdr)) & $FF
  Else
    mDest = PdpReadByte(mAdr)
  EndIf
EndMacro

Macro MWriteByte(mAdr, mVal)
  If mAdr < #RAM16
    PokeA(@Mem(0) + (mAdr), mVal)
  Else
    PdpWriteByte(mAdr, mVal)
  EndIf
EndMacro

; ---- the stack -------------------------------------------------------
; THE YELLOW ZONE. The J-11 has a FIXED kernel stack limit of 000400: a
; kernel-mode push - -(SP) or @-(SP) as an operand, JSR, MFPI/MFPD, a trap
; or interrupt - that leaves SP below 000400 still completes, and then the
; processor traps through 4 ("Yellow stack trap, internal, vector 4, CPU
; error register bit 3", KDJ11-E user's guide EK-KDJ1E-UG-001 table 1-6;
; simh pdp11_cpu.c set_stack_trap, the fixed-limit case). MAINDEC-11-DFKAB
; test 57 does TST -(SP) with SP = 000150 and expects the trap. The red
; zone (a push that itself fails) is not modelled.
Procedure StackCheck()
  If Reg(6) < #STACK_LIMIT
    If (PswHigh & $C000) = 0                 ; kernel mode only
      StackYellow = 1
      CpuErr = CpuErr | #CPUE_YELLOW
      If TrapVector = 0
        TrapVector = #TRAP_STACK             ; send the instruction through SlowTail
      EndIf
    EndIf
  EndIf
EndProcedure

; The test above, inline where the stack moves: almost every push leaves the
; stack above its limit, and the call cost more than the test (the speed pass
; of 2026-10-02). StackCheck itself runs only when the stack is below it.
Macro StackCheckFast()
  If Reg(6) < #STACK_LIMIT
    StackCheck()
  EndIf
EndMacro

Procedure Push(v.l)
  Adr = (Reg(6) - 2) & $FFFF
  Reg(6) = Adr
  StackCheckFast()
  MWriteWord(Adr, v)
EndProcedure

Procedure.l Pop()
  Adr = Reg(6)
  MReadWord(Tmp, Adr)
  Reg(6) = (Adr + 2) & $FFFF
  ProcedureReturn Tmp
EndProcedure

; ---- instruction stream ----------------------------------------------
Procedure.l FetchWord()
  Adr = Reg(7)
  MReadWord(Tmp, Adr)
  Reg(7) = (Adr + 2) & $FFFF
  ProcedureReturn Tmp
EndProcedure

; ======================================================================
;  OPERAND ADDRESSING - modes 1 to 7. Mode 0 never comes here: every
;  handler does register mode inline, because a call costs ~13 cycles.
;  spec = the six-bit mode/register field. Returns the operand's address.
; ======================================================================
Procedure.l EaWord(spec.l)
  EaReg = spec & 7
  Tmp = (spec >> 3) & 7
  ; The modes most used first (Mini-Unix and V6, desk profiles of 2026-10-02).
  If Tmp = 6                             ; X(R)   a when R = PC
    Adr = Reg(7)                             ; the index word (FetchWord, inline)
    Reg(7) = (Adr + 2) & $FFFF
    MReadWord(Tmp, Adr)
    ProcedureReturn (Tmp + Reg(EaReg)) & $FFFF
  ElseIf Tmp = 4                             ; -(R)
    Reg(EaReg) = (Reg(EaReg) - 2) & $FFFF
    If EaReg = 6
      StackCheckFast()
    EndIf
    ProcedureReturn Reg(EaReg)
  ElseIf Tmp = 2                             ; (R)+   #n when R = PC
    Tmp = Reg(EaReg)
    Reg(EaReg) = (Tmp + 2) & $FFFF
    ProcedureReturn Tmp
  ElseIf Tmp = 1                                 ; (R)
    ProcedureReturn Reg(EaReg)
  ElseIf Tmp = 3                             ; @(R)+  @#a when R = PC
    Adr = Reg(EaReg)
    Reg(EaReg) = (Adr + 2) & $FFFF
    MReadWord(Tmp, Adr)
    ProcedureReturn Tmp
  ElseIf Tmp = 5                             ; @-(R)
    Adr = (Reg(EaReg) - 2) & $FFFF
    Reg(EaReg) = Adr
    If EaReg = 6
      StackCheckFast()
    EndIf
    MReadWord(Tmp, Adr)
    ProcedureReturn Tmp
  ElseIf Tmp = 7                             ; @X(R)  @a when R = PC
    Adr = Reg(7)
    Reg(7) = (Adr + 2) & $FFFF
    MReadWord(Tmp, Adr)
    Adr = (Tmp + Reg(EaReg)) & $FFFF
    MReadWord(Tmp, Adr)
    ProcedureReturn Tmp
  EndIf
  ProcedureReturn Reg(EaReg)
EndProcedure

; Byte operands stepv (R)+ and -(R) by one, except through SP and PC, which
; always stepv by two so they stay even.
Procedure.l EaByte(spec.l)
  EaReg = spec & 7
  EaStep = 1
  If EaReg >= 6
    EaStep = 2
  EndIf
  Tmp = (spec >> 3) & 7
  If Tmp = 2
    Tmp = Reg(EaReg)
    Reg(EaReg) = (Tmp + EaStep) & $FFFF
    ProcedureReturn Tmp
  ElseIf Tmp = 4
    Reg(EaReg) = (Reg(EaReg) - EaStep) & $FFFF
    If EaReg = 6
      StackCheckFast()
    EndIf
    ProcedureReturn Reg(EaReg)
  EndIf
  ProcedureReturn EaWord(spec)
EndProcedure

; Source operands for the double-operand handlers, register mode inline:
; macros, so the commonest source - a register - costs no call at all.
Macro MSrcWord()
  If (Op & $0E00) = 0
    Src = Reg((Op >> 6) & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWord((Op >> 6) & $3F)
CompilerEndIf
    MReadWord(Src, Ea)
  EndIf
EndMacro

Macro MSrcByte()
  If (Op & $0E00) = 0
    Src = Reg((Op >> 6) & 7) & $FF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByte((Op >> 6) & $3F)
CompilerEndIf
    MReadByte(Src, Ea)
  EndIf
EndMacro

; The destination's address in the unmapped handlers: __eau / __eaub
; (instructions.pico2, the UNMAPPED ONLY block; #ASM_EA = 1), else EaWord /
; EaByte. tools/mmu_gen.py turns both back into the Ea lines they stand for
; when it writes the mapped loop, which has its own (__eaw, __eab).
Macro EaFast()
CompilerIf #ASM_EA = 1
CompilerElse
  Ea = EaWord(Op & $3F)
CompilerEndIf
EndMacro

Macro EaFastB()
CompilerIf #ASM_EA = 1
CompilerElse
  Ea = EaByte(Op & $3F)
CompilerEndIf
EndMacro

; ======================================================================
;  MAPPED ACCESS - what the mapped run loop (instructions_mmu) uses in
;  place of the unmapped macros and helpers above. e = an entry.
; ======================================================================
; An abort: MMR0 records it (unless an earlier one froze it) and the
; instruction traps through 250 with the PSW it started with (BusError).
; The space recorded is the register set the reference used: a D-space
; reference with D space off reports I (MAINDEC-11-DFKAB test 113).
Procedure MmuAbort(bits.i, e.i)
  Protected r.i
  r = MapReg(e)
  If (Mmr0 & $E000) = 0
    Mmr0 = (Mmr0 & $0101) | bits | ((r >> 4) << 5) | (((r >> 3) & 1) << 4) | ((r & 7) << 1)
    Mmr2 = Fw(3)                         ; frozen with MMR0
    If MmuPcRec <> Fw(3)
      Mmr1 = 0
    EndIf
  EndIf
  If TrapVector <> #VEC_BUS And TrapVector <> #VEC_MMU
    AbortPsw = PswGet() | $10000
  EndIf
  TrapVector = #VEC_MMU
EndProcedure

; Setting W changes only the writable window. Translation, read windows
; and instruction fetch remain valid; a stale alias rebuilds on first use.
Procedure MmuWindowWritten(e.i)
  If MapAcf(e) >= 0
    MapF((e << 3) + 2) = MapF(e << 3)
    MapF((e << 3) + 3) = MapF((e << 3) + 1)
  EndIf
EndProcedure

; The physical address of va in entry e, or -1 after an abort.
Procedure.l MmuPhys(va.l, e.l, write.l)
  Protected bits.l, r.l
  If MapAcf(e) < 0
    MmuMapEntry(e)
  EndIf
  bits = 0
  If MapAcf(e) = 0
    bits = $8000
  EndIf
  If va < MapLo(e) Or va >= MapHi(e)
    bits = bits | $4000
  EndIf
  If write <> 0 And MapAcf(e) = 1
    bits = bits | $2000
  EndIf
  If bits
    MmuAbort(bits, e)
    ProcedureReturn -1
  EndIf
  If write
    r = MapReg(e)
    If (Pdr(r) & $40) = 0                ; the first write: W, and a fast window
      Pdr(r) = Pdr(r) | $40
      MmuCharge(#MAP_COST_ENTRY)
      MmuWindowWritten(r)
      If (r & 8) = 0
        If MapReg(r + 8) = r
          MmuWindowWritten(r + 8)
        EndIf
      EndIf
    EndIf
  EndIf
  ProcedureReturn (va + MapBase(e)) & MapMask
EndProcedure

; A physical address past RAM: the I/O page (the top 8 KB of the 18- or
; 22-bit space), or nothing there - a bus error.
Procedure.l MmuIoAddr(pa.l)
  If pa >= MapMask - $1FFF
    ProcedureReturn $E000 | (pa & $1FFF)
  EndIf
  CpuErr = CpuErr | #CPUE_NXM
  BusError()
  ProcedureReturn -1
EndProcedure

Procedure.i MmuReadWord(va.i, e.i)
  Protected pa.i
  If va & 1
    CpuErr = CpuErr | #CPUE_ODD
    BusError()
    ProcedureReturn 0
  EndIf
  pa = MmuPhys(va, e, 0)
  If pa < 0
    ProcedureReturn 0
  EndIf
  If pa < #RAM_BYTES
    ProcedureReturn PeekU(@Mem(0) + pa)
  EndIf
  CompilerIf #DESK_MEM = 1
    If pa < MemLim                       ; the memory past 56 KB, in the PSRAM
      ProcedureReturn PeekU(PsMem + pa)
    EndIf
  CompilerEndIf
  pa = MmuIoAddr(pa)
  If pa < 0
    ProcedureReturn 0
  EndIf
  ProcedureReturn PdpReadWord(pa)
EndProcedure

Procedure MmuWriteWord(va.i, e.i, v.i)
  Protected pa.i
  If va & 1
    CpuErr = CpuErr | #CPUE_ODD
    BusError()
    ProcedureReturn
  EndIf
  pa = MmuPhys(va, e, 1)
  If pa < 0
    ProcedureReturn
  EndIf
  If pa < #RAM_BYTES
    PokeU(@Mem(0) + pa, v)
    ProcedureReturn
  EndIf
  CompilerIf #DESK_MEM = 1
    If pa < MemLim
      PokeU(PsMem + pa, v & $FFFF)
      ProcedureReturn
    EndIf
  CompilerEndIf
  pa = MmuIoAddr(pa)
  If pa >= 0
    PdpWriteWord(pa, v)
  EndIf
EndProcedure

Procedure.i MmuReadByte(va.i, e.i)
  Protected pa.i
  pa = MmuPhys(va, e, 0)
  If pa < 0
    ProcedureReturn 0
  EndIf
  If pa < #RAM_BYTES                     ; Mem itself: PdpReadByte reaches only #RAM16 of it
    ProcedureReturn PeekA(@Mem(0) + pa) & $FF
  EndIf
  CompilerIf #DESK_MEM = 1
    If pa < MemLim
      ProcedureReturn PeekA(PsMem + pa)
    EndIf
  CompilerEndIf
  pa = MmuIoAddr(pa)
  If pa < 0
    ProcedureReturn 0
  EndIf
  ProcedureReturn PdpReadByte(pa)
EndProcedure

Procedure MmuWriteByte(va.i, e.i, v.i)
  Protected pa.i
  pa = MmuPhys(va, e, 1)
  If pa < 0
    ProcedureReturn
  EndIf
  If pa >= #RAM_BYTES
    CompilerIf #DESK_MEM = 1
      If pa < MemLim
        PokeA(PsMem + pa, v & $FF)
        ProcedureReturn
      EndIf
    CompilerEndIf
    pa = MmuIoAddr(pa)
    If pa < 0
      ProcedureReturn
    EndIf
    PdpWriteByte(pa, v)
    ProcedureReturn
  EndIf
  PokeA(@Mem(0) + pa, v)
EndProcedure

; The fast path, INLINE: in the entry's fast window, a load or store; else
; the procedures above. mBase is an entry base (CurI, CurD, EaBase, ...).
Macro MMReadWordE(mDest, mAdr, mBase)
  MmE = (mBase) + (mAdr >> 13)
  If mAdr >= MapRLo(MmE)
    If mAdr < MapRHi(MmE)
      If (mAdr & 1) = 0
        mDest = PeekU(mAdr + MapHost(MmE))
      Else
        mDest = MmuReadWord(mAdr, MmE)
      EndIf
    Else
      mDest = MmuReadWord(mAdr, MmE)
    EndIf
  Else
    mDest = MmuReadWord(mAdr, MmE)
  EndIf
EndMacro

Macro MMWriteWordE(mAdr, mVal, mBase)
  MmE = (mBase) + (mAdr >> 13)
  If mAdr >= MapWLo(MmE)
    If mAdr < MapWHi(MmE)
      If (mAdr & 1) = 0
        PokeU(mAdr + MapHost(MmE), mVal)
      Else
        MmuWriteWord(mAdr, MmE, mVal)
      EndIf
    Else
      MmuWriteWord(mAdr, MmE, mVal)
    EndIf
  Else
    MmuWriteWord(mAdr, MmE, mVal)
  EndIf
EndMacro

Macro MMReadByteE(mDest, mAdr, mBase)
  MmE = (mBase) + (mAdr >> 13)
  If mAdr >= MapRLo(MmE)
    If mAdr < MapRHi(MmE)
      mDest = PeekA(mAdr + MapHost(MmE)) & $FF
    Else
      mDest = MmuReadByte(mAdr, MmE)
    EndIf
  Else
    mDest = MmuReadByte(mAdr, MmE)
  EndIf
EndMacro

Macro MMWriteByteE(mAdr, mVal, mBase)
  MmE = (mBase) + (mAdr >> 13)
  If mAdr >= MapWLo(MmE)
    If mAdr < MapWHi(MmE)
      PokeA(mAdr + MapHost(MmE), mVal & $FF)
    Else
      MmuWriteByte(mAdr, MmE, mVal)
    EndIf
  Else
    MmuWriteByte(mAdr, MmE, mVal)
  EndIf
EndMacro

; The operand macros the handlers use: in the space the last mapped operand
; address was formed in (EaWordM sets EaBase).
Macro MMReadWord(mDest, mAdr)
  MMReadWordE(mDest, mAdr, EaBase)
EndMacro

Macro MMWriteWord(mAdr, mVal)
  MMWriteWordE(mAdr, mVal, EaBase)
EndMacro

Macro MMReadByte(mDest, mAdr)
  MMReadByteE(mDest, mAdr, EaBase)
EndMacro

Macro MMWriteByte(mAdr, mVal)
  MMWriteByteE(mAdr, mVal, EaBase)
EndMacro

; MMR1: a register change an abort would leave behind (not while frozen).
; It is cleared lazily: the first change an instruction makes starts afresh.
; MMR1: the register changes of this instruction, for an abort to undo.
; A macro, expanded where the register changes - it runs on every autoincrement
; and autodecrement in the mapped loop, and a call cost more than the work
; (the speed pass of 2026-10-02: 5% of V6's cycles on the desk).
Macro MmrRecord(mR, mAmt)
  If (Mmr0 & $E000) = 0
    If MmuPcRec <> Fw(3)
      MmuPcRec = Fw(3)
      Mmr1 = (((mAmt) & $1F) << 3) | (mR)
    ElseIf (Mmr1 & $FF) = 0
      Mmr1 = (((mAmt) & $1F) << 3) | (mR)
    Else
      Mmr1 = (Mmr1 & $FF) | (((((mAmt) & $1F) << 3) | (mR)) << 8)
    EndIf
  EndIf
EndMacro

; The start of each mapped instruction: one store. MMR2 reads it while the
; unit is not frozen, an abort freezes it into Mmr2, and MMR1 starts afresh
; at an instruction's first register change (MmrRecord). (An instruction
; that loops on itself keeps adding to MMR1 - none of the diagnostics do.)
Macro MmuInstrStart(mPc)
  Fw(3) = mPc
EndMacro

; EaWord mapped: the index word and an immediate come from I space, every
; operand and pointer from D space, of the current mode. EaBase says where
; the operand itself lies.
; THE BODY IS A MACRO so that the same text is both EaWordM's slow path and,
; in asm_check.pico2 only, the plain procedure its assembly is held to
; (EaWordMRef there); a program that does not call EaWordMRef does not keep it.
; THE PC'S SPACE. With I and D space separate, every reference made through
; R7 by modes 1 to 5 is to I space - (PC), (PC)+ (an immediate), @(PC)+'s
; pointer (an absolute address), -(PC), @-(PC)'s pointer - as are the index
; words of modes 6 and 7; only the operands of X(PC) and @X(PC), and what an
; absolute address points to, are in D space (simh pdp11_cpu.c: ds = (reg ==
; 7) ? isenable : dsenable). Seventh Edition's kernel relies on it: its
; optimizer turns a constant shared with an index word into BITB (PC),1(R3)
; (swtch), and with (PC) read from D space V7 idled for ever after its first
; disk read (2026-10-21).
Macro EaWordMBody()
  EaReg = spec & 7
  EaBase = CurD
  Tmp = (spec >> 3) & 7
  ; The modes in the order V6 uses them (the desk profile of 2026-10-02):
  ; X(R) 44%, -(R) 28%, (R)+ 14%, (R) 10%, @(R)+ 4%, the rest under 1%.
  If Tmp = 6                             ; X(R)   a when R = PC
    Adr = Reg(7)
    Reg(7) = (Adr + 2) & $FFFF
    MMReadWordE(Tmp, Adr, CurI)
    ProcedureReturn (Tmp + Reg(EaReg)) & $FFFF
  ElseIf Tmp = 4                             ; -(R)
    Reg(EaReg) = (Reg(EaReg) - 2) & $FFFF
    MmrRecord(EaReg, -2)
    If EaReg = 6
      StackCheckFast()
    ElseIf EaReg = 7
      EaBase = CurI                      ; -(PC): I space (THE PC'S SPACE, below)
    EndIf
    ProcedureReturn Reg(EaReg)
  ElseIf Tmp = 2                             ; (R)+   #n when R = PC
    Tmp = Reg(EaReg)
    Reg(EaReg) = (Tmp + 2) & $FFFF
    If EaReg = 7
      EaBase = CurI
    Else
      MmrRecord(EaReg, 2)
    EndIf
    ProcedureReturn Tmp
  ElseIf Tmp = 1                                 ; (R)
    If EaReg = 7
      EaBase = CurI                      ; (PC): I space (THE PC'S SPACE, below)
    EndIf
    ProcedureReturn Reg(EaReg)
  ElseIf Tmp = 3                             ; @(R)+  @#a when R = PC
    Adr = Reg(EaReg)
    Reg(EaReg) = (Adr + 2) & $FFFF
    If EaReg = 7
      MMReadWordE(Tmp, Adr, CurI)
    Else
      MmrRecord(EaReg, 2)
      MMReadWordE(Tmp, Adr, CurD)
    EndIf
    ProcedureReturn Tmp
  ElseIf Tmp = 5                             ; @-(R)
    Adr = (Reg(EaReg) - 2) & $FFFF
    Reg(EaReg) = Adr
    MmrRecord(EaReg, -2)
    If EaReg = 6
      StackCheckFast()
    EndIf
    If EaReg = 7
      MMReadWordE(Tmp, Adr, CurI)        ; @-(PC): the pointer from I space
    Else
      MMReadWordE(Tmp, Adr, CurD)
    EndIf
    ProcedureReturn Tmp
  ElseIf Tmp = 7                             ; @X(R)  @a when R = PC
    Adr = Reg(7)
    Reg(7) = (Adr + 2) & $FFFF
    MMReadWordE(Tmp, Adr, CurI)
    Adr = (Tmp + Reg(EaReg)) & $FFFF
    MMReadWordE(Tmp, Adr, CurD)
    ProcedureReturn Tmp
  EndIf
  ProcedureReturn Reg(EaReg)
EndMacro

; The mapped loop's handlers do not call this for the four commonest modes:
; they call the assembly routine __eaw (tools/mmu_gen.py, ASM_EAW; #ASM_EA = 1),
; which does X(R), -(R), (R)+ and (R) itself and comes here for everything
; else. EaSpec is where __eaw leaves the spec on the way (asm_check.pico2
; counts the calls that came here by it).
Procedure.l EaWordM(spec.l)
  EaWordMBody()
EndProcedure

Procedure.l EaByteM(spec.l)
  EaReg = spec & 7
  EaStep = 1
  If EaReg >= 6
    EaStep = 2
  EndIf
  Tmp = (spec >> 3) & 7
  If Tmp = 2
    EaBase = CurD
    Tmp = Reg(EaReg)
    Reg(EaReg) = (Tmp + EaStep) & $FFFF
    If EaReg = 7
      EaBase = CurI
    Else
      MmrRecord(EaReg, EaStep)
    EndIf
    ProcedureReturn Tmp
  ElseIf Tmp = 4
    EaBase = CurD
    Reg(EaReg) = (Reg(EaReg) - EaStep) & $FFFF
    MmrRecord(EaReg, 0 - EaStep)
    If EaReg = 6
      StackCheckFast()
    ElseIf EaReg = 7
      EaBase = CurI                      ; -(PC): I space
    EndIf
    ProcedureReturn Reg(EaReg)
  EndIf
  ProcedureReturn EaWordM(spec)
EndProcedure

Procedure PushM(v.l)
  Adr = (Reg(6) - 2) & $FFFF
  Reg(6) = Adr
  StackCheckFast()
  MMWriteWordE(Adr, v, CurD)
EndProcedure

Procedure.l PopM()
  Adr = Reg(6)
  MMReadWordE(Tmp, Adr, CurD)
  Reg(6) = (Adr + 2) & $FFFF
  ProcedureReturn Tmp
EndProcedure

; THE FETCH WINDOW. The mapped loop fetches every instruction through three
; Globals: the word at PC in [FetchLo, FetchHi) is at host address PC +
; FetchBase. The window is the fast window of the page the PC is in, joined
; with its neighbours' while they touch and share the same host offset - so
; an identity-mapped kernel fetches from all of RAM through one window, and
; a program in PSRAM from all of its text through another. It is found again after a
; fetch outside it (FetchWordM) and emptied whenever the map or the mode
; changes.
Procedure MmuFetchWindow(va.i)
  Protected e.i, lo.i, hi.i, bs.i
  Fw(0) = #MAP_NONE
  Fw(1) = 0
  e = CurI + (va >> 13)
  If va < MapRLo(e) Or va >= MapRHi(e)
    ProcedureReturn
  EndIf
  lo = MapRLo(e)
  hi = MapRHi(e)
  bs = MapHost(e)
  While (e & 7) > 0 And MapRHi(e - 1) = lo And MapHost(e - 1) = bs
    e = e - 1
    lo = MapRLo(e)
  Wend
  e = CurI + (va >> 13)
  While (e & 7) < 7 And MapRLo(e + 1) = hi And MapHost(e + 1) = bs
    e = e + 1
    hi = MapRHi(e)
  Wend
  Fw(0) = lo
  Fw(1) = hi
  Fw(2) = bs
EndProcedure

Procedure.l FetchWordM()
  Adr = Reg(7)
  MMReadWordE(Tmp, Adr, CurI)
  Reg(7) = (Adr + 2) & $FFFF
  MmuFetchWindow(Adr)                    ; the window the next fetches use
  ProcedureReturn Tmp
EndProcedure

Macro MMSrcWord()
  If (Op & $0E00) = 0
    Src = Reg((Op >> 6) & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM((Op >> 6) & $3F)
CompilerEndIf
    MMReadWordE(Src, Ea, EaBase)
  EndIf
EndMacro

Macro MMSrcByte()
  If (Op & $0E00) = 0
    Src = Reg((Op >> 6) & 7) & $FF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByteM((Op >> 6) & $3F)
CompilerEndIf
    MMReadByteE(Src, Ea, EaBase)
  EndIf
EndMacro

; ======================================================================
;  TRAPS
; ======================================================================
; The trap sequence: the new PSW comes from the vector, its previous-mode
; bits (13-12) take the old current mode, and the old PSW and PC are pushed
; on the NEW mode's stack (normally the kernel's).
; With the memory management unit on, the vector is read from kernel D
; space and the pushes go through the new mode's mapping.
Procedure TakeTrap(vector.l)
  TrapPsw = PswGet()
  TrapPc = Reg(7)
  If MmuOn
    Reg(7) = MmuReadWord(vector, 8 + (vector >> 13))
    PswSet((MmuReadWord(vector + 2, 8 + (vector >> 13)) & $CFFF) | ((TrapPsw >> 2) & $3000))
    PushM(TrapPsw)
    PushM(TrapPc)
  Else
    Reg(7) = PdpReadWord(vector)
    PswSet((PdpReadWord(vector + 2) & $CFFF) | ((TrapPsw >> 2) & $3000))
    Push(TrapPsw)
    Push(TrapPc)
  EndIf
  If PswLate                             ; a push landed on the PSW (177776): PswWrite
    PswLate = 0                          ; has applied it, and it must not be applied
    If TrapVector = #TRAP_PSW_LATE       ; again at the end of the NEXT instruction,
      TrapVector = 0                     ; over that instruction's condition codes
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_TRAP
EndProcedure

; Take a pending yellow-zone trap. Called after an instruction, and after
; any trap or interrupt sequence (whose own pushes may have gone below the
; limit). The yellow trap's own pushes never trap again - simh does the
; same - or a handler run with a low SP would trap for ever. Works on
; Reg(7), as TakeTrap does.
Procedure TakeStackTrap()
  If StackYellow
    StackYellow = 0
    TakeTrap(#VEC_BUS)
    StackYellow = 0
    If TrapVector = #TRAP_STACK
      TrapVector = 0
    EndIf
  EndIf
EndProcedure

; ======================================================================
;  THE DEVICES' TURN - called by the run loop between windows (RunEnd in
;  instructions.pico2), when RunLeft is zero and CpuNow() = InstrCount.
; ======================================================================
Procedure DevService()
  ; the transmitter finishing its character
  If Dl11TxRdy = 0
    If InstrCount - Dl11TxDue >= 0
      If ConOutHead - ConOutTail < #CON_SIZE
        ConOut(ConOutHead & (#CON_SIZE - 1)) = Dl11TxChar
        SmpBarrier()                     ; the character, then the head core 1 reads
        ConOutHead = ConOutHead + 1
        Dl11TxRdy = 1
        If Dl11TxIe
          IntReq = IntReq | #INT_DL11_TX
        EndIf
      Else
        Dl11TxDue = InstrCount + 1000    ; ConOut is full: try again later
      EndIf
    EndIf
  EndIf
  ; the receiver taking a typed character - THE RECEIVER'S PACE. A real
  ; line delivers a character every bit-time times ten and no faster; a
  ; paste into the USB port arrives all at once. Unix takes each character
  ; at interrupt level whether or not the program reading the terminal has
  ; had time to run, and throws its whole input queue away at 256
  ; characters (V6 tty.c, ttyinput: TTYHOG), so characters handed over as
  ; fast as the kernel reads them are lost inside Unix. So the next
  ; character is given #DL11_RX_INSTRUCTIONS instructions after the last
  ; one was read - or at once when the processor is in a WAIT, which is
  ; Unix saying it has nothing left to do. The rest of a paste waits in
  ; ConIn, and behind that in the USB port (ReadPort stops reading it), so
  ; the host is held back and nothing is dropped.
  If Dl11RxDone = 0
    If ConInHead <> ConInTail
      If InstrCount - Dl11RxDue >= 0 Or Waiting <> 0
        SmpBarrier()                     ; core 1's head, then the character it announces
        Dl11RxBuf = ConIn(ConInTail & (#CON_SIZE - 1)) & $FF
        SmpBarrier()                     ; the character read, then the slot given back
        ConInTail = ConInTail + 1
        Dl11RxDone = 1
        Dl11RxPolled = 0
        If Dl11RxIe
          IntReq = IntReq | #INT_DL11_RX
        EndIf
      EndIf
    EndIf
  EndIf
  ; the disk and the line clock, while either needs a look (rk11, kw11)
  If DevActive
    DevPoll()
  EndIf
  CompilerIf #DEMO_DEV = 1
    DdPoll()                             ; the demo display's vertical blank and its interrupt
  CompilerEndIf
  DdPoll()                               ; desktop_gen: the demo display's frame and its interrupt
  ; an interrupt, if one is asked for and the priority lets it in: the
  ; highest bus request level first (clock BR6, disk BR5, console BR4),
  ; and on the console the receiver first, as it sits nearer the processor
  If IntReq
    If (PswHigh & $E0) < IntLevel()
      Waiting = 0
      If IntReq & #INT_KW
        IntReq = IntReq & ~#INT_KW
        TakeTrap(#VEC_KW)
        TakeStackTrap()
      ElseIf IntReq & #INT_RK
        IntReq = IntReq & ~#INT_RK
        RkIntTaken()
        TakeTrap(#VEC_RK)
        TakeStackTrap()
      ElseIf IntReq & #INT_RP
        IntReq = IntReq & ~#INT_RP
        TakeTrap(#VEC_RP)
        TakeStackTrap()
      ElseIf IntReq & #INT_DL11_RX
        IntReq = IntReq & ~#INT_DL11_RX
        TakeTrap(#VEC_DL11_RX)
        TakeStackTrap()
      Else
        IntReq = IntReq & ~#INT_DL11_TX
        TakeTrap(#VEC_DL11_TX)
        TakeStackTrap()
      EndIf
    EndIf
  EndIf
EndProcedure

; Open the next window: everything CpuRun still owes, but no further than
; the transmitter's next moment, and one instruction at a time while an
; interrupt that could be taken is still waiting (the one behind another).
Procedure StartWindow()
  RunLeft = RunBank
  If Dl11TxRdy = 0
    Tmp = Dl11TxDue - InstrCount
    If Tmp < 1
      Tmp = 1
    EndIf
    If Tmp < RunLeft
      RunLeft = Tmp
    EndIf
  EndIf
  If IntReq
    If (PswHigh & $E0) < IntLevel()
      RunLeft = 1
    EndIf
  EndIf
  If DevActive                           ; the disk or the clock: look again soon
    If DevFast
      If RunLeft > #DEV_WINDOW
        RunLeft = #DEV_WINDOW
      EndIf
    ElseIf RunLeft > #DEV_WINDOW_CLOCK
      RunLeft = #DEV_WINDOW_CLOCK
    EndIf
  EndIf
  ; THE T BIT. An instruction that BEGINS with the T bit set is followed by
  ; a trace trap through 14. While T is set the windows are one instruction
  ; long, TraceArm records T at the start of each, and RunEnd takes the
  ; trap. RTI that loads T traps straight after itself; RTT that loads T
  ; lets the next instruction run first, which this gives for free (T was
  ; clear when the RTT began) - PDP-11 Architecture Handbook 1983, model
  ; differences 10-11, and MAINDEC-11-DFKAB test 72. An instruction that
  ; traps (EMT, TRAP, BPT, IOT, a reserved or failing instruction) takes its
  ; own trap instead (SlowTail clears TraceArm), as simh's trap_clear table
  ; does. Nothing here is on the path an instruction takes while T is clear.
  TraceArm = 0
  If PswHigh & $10
    RunLeft = 1
    TraceArm = 1
  EndIf
  RunBank = RunBank - RunLeft
  RunWindow = RunLeft
EndProcedure

; The receiver is empty and the program is waiting for a character: it
; has the receiver interrupt enabled, or has looked at RCSR since the
; last character arrived. The firmware reads its serial port only then.
Procedure.l Dl11RxWanted()
  If Dl11RxDone = 0 And ConInHead = ConInTail
    If (Dl11RxIe | Dl11RxPolled) <> 0
      ProcedureReturn 1
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

; The bus INIT (the RESET instruction, and power-up): interrupt enables
; and requests off, the receiver empty. A character already on its way
; out still finishes. The disk controller and the line clock take their
; own INIT (rk11.pico2, kw11.pico2).
Procedure DevReset()
  Dl11RxIe = 0
  Dl11RxDone = 0
  Dl11TxIe = 0
  IntReq = 0
  RkInit()
  RpReset()
  KwInit()
  MmuReset()
EndProcedure

; ======================================================================
;  RESET. The run loop, CpuRun(n), is in instructions.pico2.
; ======================================================================
Procedure CpuReset()
  Protected i.i
  GBase = @Reg(0)
  For i = 0 To 7
    Reg(i) = 0
  Next
  DevReset()
  CacheCcr = 0                           ; power-up only: the RESET instruction leaves it
  For i = 0 To 31                        ; and the Unibus map,
    UbMap(i) = 0
  Next
  CpuErr = 0                             ; the CPU error register and the halt/trap option
  MaintTrap = 0
  Fps = 0                                ; the FPJ11: status, exception code and address
  Fec = 0
  Fea = 0
  Dl11TxRdy = 1
  PswSet($00E0)            ; kernel, priority 7
  TrapVector = 0
  Halted = 0
  Waiting = 0
  ; ClockCycles = 0
EndProcedure


; Read destinations in the compact state are array elements. Pass their
; addresses explicitly: a macro assignment target must be a plain name.






CompilerIf #DISK_BACKEND = 0
Global SingleHit.l                      ; successful indexed native entries, hardware test only
CompilerEndIf

; ======== fp11.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; ======================================================================
;  fp11.pico2 - the FPJ11 floating point unit of the J-11, for the
;  Raspberry Pi Pico 2. Include it after cpu.pico2 and before the two
;  instruction files; they send opcodes 170000-177777 here (FpExec).
;
;  WHAT IT IS. The FP11 instruction set as the J-11's FPJ11 runs it: six
;  accumulators of 64 bits, the status register FPS (error, interrupt
;  disable and the four interrupt enables, the D, L and T modes, N Z V C),
;  the exception code FEC and address FEA, F (32-bit) and D (64-bit)
;  operands in memory, word and long integers, and the trap through 244.
;
;  WHERE IT COMES FROM. This is a port, line for line, of SIMH's
;  pdp11_fp.c (Robert M Supnik, its "32b version", fetched 2026-10-21 from
;  github.com/simh/simh; the permission notice is below): the same 64-bit
;  numbers held as two 32-bit halves, the same three guard bits, the same
;  rounding, the same shift-and-add multiply that keeps the top 64 bits,
;  the same restoring divide, the same MODf, conversions, condition codes
;  and exceptions, and the J-11's way with register changes (a specifier's
;  register is changed only when the instruction completes; the PC at
;  once). What SIMH does on other models (the 11/44 and 11/70 register
;  tracking, the FIS instructions) is not here.
;    tools/fp11_model.py is the same port in Python, and the FP test
;    program (fp_check.pico2) holds this file to it on random operands.
;
;  THE NUMBERS. A 64-bit value is (h, l): h holds the sign (bit 31), the
;  exponent (bits 30-23, excess 128) and the high 23 fraction bits; l the
;  low 32. The fraction has a hidden 1 at bit 55 of the whole (bit 23 of
;  h). F format is the high half. An exponent of 0 is a zero; with the
;  sign set it is the "undefined variable".
;
;  SIMH's notice, as its terms require:
;    Copyright (c) 1993-2023, Robert M Supnik
;    Permission is hereby granted, free of charge, to any person obtaining
;    a copy of this software and associated documentation files (the
;    "Software"), to deal in the Software without restriction, including
;    without limitation the rights to use, copy, modify, merge, publish,
;    distribute, sublicense, and/or sell copies of the Software, and to
;    permit persons to whom the Software is furnished to do so, subject to
;    the following conditions: The above copyright notice and this
;    permission notice shall be included in all copies or substantial
;    portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
;    WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
;    THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;    NONINFRINGEMENT. IN NO EVENT SHALL ROBERT M SUPNIK BE LIABLE FOR ANY
;    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
;    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. Except as
;    contained in this notice, the name of Robert M Supnik shall not be
;    used in advertising or otherwise to promote the sale, use or other
;    dealings in this Software without prior written authorization from
;    Robert M Supnik.
; ======================================================================

; ---- FPS -----------------------------------------------------------------
#FPS_ER  = $8000
#FPS_ID  = $4000
#FPS_IUV = $0800
#FPS_IU  = $0400
#FPS_IV  = $0200
#FPS_IC  = $0100
#FPS_D   = $0080
#FPS_L   = $0040
#FPS_T   = $0020
#FPS_N   = $0008
#FPS_Z   = $0004
#FPS_V   = $0002
#FPS_C   = $0001
#FPS_CC  = $000F
#FPS_MM  = $0010                 ; FMM, maintenance mode: kept as written, no effect (2026-10-22)
#FPS_RW  = $CFFF                 ; ER ID IUV IU IV IC D L T MM and the codes. MM: DEC's JFPAA1 (the
                                 ; KDJ11 FPA diagnostic, XXDP+) tests 1 and 3 want bit 4 to read back as
                                 ; LDFPS and SETF/SETD/SETI/SETL leave it; simh's mask drops it
; ---- FEC -----------------------------------------------------------------
#FEC_OP    = 2
#FEC_DZRO  = 4
#FEC_ICVT  = 6
#FEC_OVFLO = 8
#FEC_UNFLO = 10
#FEC_UNDFV = 12
; ---- the format ----------------------------------------------------------
#FP_SIGN  = $80000000
#FP_EXP   = $7F800000
#FP_HB    = $00800000
#FP_FRACH = $007FFFFF
#FP_BIAS  = $80
#FP_GUARD = 3
#VEC_FPE  = $A4                  ; 000244
#FP_LONG  = 4
#FP_QUAD  = 8

; Fps, Fec, Fea and the accumulators FrH/FrL are declared in cpu.pico2 (CpuReset clears them).
Global FpBackupPc.l              ; the PC after the instruction word (FEA)
Global FpChgReg.l, FpChgVal.l, FpChgOn.l   ; the J-11's register change, made at the end
Global FpQuit.l                  ; the instruction is over: an abort, or an exception that NOPs it
Global FpSpace.l                 ; the last operand address's space: 0 D, 1 I
Global FpAdr.l                   ; ... and the address
; The 64-bit working values, as (h, l) pairs in two arrays (index #P_*)
#P_FAC = 0                       ; the packed accumulator operand
#P_SRC = 1                       ; the packed source operand
#P_MOD = 2                       ; MODf's fraction result
#P_FF  = 3                       ; fractions in the arithmetic
#P_SF  = 4
#P_Q   = 5
#P_T   = 6
#P_M   = 7
#P_R   = 8
#P_RND = 9                       ; the rounding constants (FpInit)
#P_FRG = 10
#P_DRG = 11
#P_FMK = 12
#P_ZERO = 13
Global Dim PH.l(14)
Global Dim PL.l(14)
Global Dim FpMask.l(33)          ; FpMask(n) = the low n bits
Global FpReady.l
; FpExec's and FpEa's working values (Globals: see FpCpuCc)
Global FxAc.l, FxDs.l, FxQd.l, FxLenf.l, FxLeni.l, FxDst.l, FxNewv.l, FxEx.l, FxSign.l, FxI.l, FxC.l, FxN.l, FxZ.l, FxV.l
Global FeR.l, FeAdr.l, FeSp.l

Procedure FpInit()
  Define i.l
  FpMask(0) = 0
  For i = 1 To 31
    FpMask(i) = (1 << i) - 1
  Next
  FpMask(32) = -1
  ; simh's constants are { l, h } (fpac_t): fround_fac rounds F at bit 31 of l,
  ; fround_guard_fac at bit 2 of h and dround_guard_fac at bit 2 of l (guarded)
  PH(#P_RND) = 0 : PL(#P_RND) = 1 << 31
  PH(#P_FRG) = 1 << 2 : PL(#P_FRG) = 0
  PH(#P_DRG) = 0 : PL(#P_DRG) = 1 << 2
  PH(#P_FMK) = (1 << (23 + #FP_GUARD + 1)) - 1 : PL(#P_FMK) = -1   ; fmask_fac
  PH(#P_ZERO) = 0 : PL(#P_ZERO) = 0
  FpReady = 1
EndProcedure

; ---- 64-bit helpers on the pairs ---------------------------------------
Procedure.l ULt(a.l, b.l)                     ; unsigned a < b
  Protected ua.q = a & $FFFFFFFF, ub.q = b & $FFFFFFFF : ProcedureReturn Bool(ua < ub)   ; desktop_gen: unsigned, in quads (a compare of .l operands is 32-bit even with a 64-bit mask in it)
EndProcedure

Procedure FpCopy(d.l, s.l)
  PH(d) = PH(s)
  PL(d) = PL(s)
EndProcedure

Procedure FpAdd(d.l, s.l)                     ; d = d + s (F_ADD(s, d, d))
  Define l.l
  l = PL(d) + PL(s)
  PH(d) = PH(d) + PH(s) + ULt(l, PL(s))
  PL(d) = l
EndProcedure

Procedure FpSub(d.l, s.l)                     ; d = d - s (F_SUB(s, d, d))
  PH(d) = PH(d) - PH(s) - ULt(PL(d), PL(s))
  PL(d) = PL(d) - PL(s)
EndProcedure

Procedure.l FpLt(a.l, b.l)                    ; F_LT: unsigned 64-bit a < b
  If PH(a) <> PH(b)
    ProcedureReturn ULt(PH(a), PH(b))
  EndIf
  ProcedureReturn ULt(PL(a), PL(b))
EndProcedure

Procedure FpLsh(d.l, s.l, n.l)                ; F_LSH_V, 0 <= n < 64
  Define h.l, l.l
  If n = 0
    h = PH(s) : l = PL(s)
  ElseIf n >= 32
    h = PL(s) << (n - 32) : l = 0
  Else
    h = (PH(s) << n) | ((PL(s) >> (32 - n)) & FpMask(n))
    l = PL(s) << n
  EndIf
  PH(d) = h : PL(d) = l
EndProcedure

Procedure FpRsh(d.l, s.l, n.l)                ; F_RSH_V, 0 <= n < 64
  Define h.l, l.l
  If n = 0
    h = PH(s) : l = PL(s)
  ElseIf n >= 32
    l = (PH(s) >> (n - 32)) & FpMask(64 - n) : h = 0
  Else
    l = ((PL(s) >> n) & FpMask(32 - n)) | (PH(s) << (32 - n))
    h = (PH(s) >> n) & FpMask(32 - n)
  EndIf
  PH(d) = h : PL(d) = l
EndProcedure

Procedure FpLsh1(d.l)
  PH(d) = (PH(d) << 1) | ((PL(d) >> 31) & 1)
  PL(d) = PL(d) << 1
EndProcedure

Procedure FpRsh1(d.l)
  PL(d) = ((PL(d) >> 1) & $7FFFFFFF) | ((PH(d) & 1) << 31)
  PH(d) = (PH(d) >> 1) & $7FFFFFFF
EndProcedure

Procedure FpGetFrac(d.l, s.l)                 ; F_GET_FRAC_P: the fraction with its hidden bit
  PL(d) = PL(s)
  PH(d) = (PH(s) & #FP_FRACH) | #FP_HB
EndProcedure

Macro FpExpOf(mH)
  (((mH) >> 23) & $FF)
EndMacro

; ---- exceptions ----------------------------------------------------------
; FpNoTrap(code): 1 if the exception is disabled (the instruction goes on),
; 0 if it is enabled: FER, FEC and FEA are set and, unless FID, the trap
; through 244 follows the instruction.
Procedure.l FpNoTrap(code.l)
  Define t.l
  If code >= #FEC_ICVT And code <= #FEC_UNDFV
    If code = #FEC_ICVT
      t = #FPS_IC
    ElseIf code = #FEC_OVFLO
      t = #FPS_IV
    ElseIf code = #FEC_UNFLO
      t = #FPS_IU
    Else
      t = #FPS_IUV
    EndIf
    If (Fps & t) = 0
      ProcedureReturn 1
    EndIf
  EndIf
  Fps = Fps | #FPS_ER
  Fec = code
  Fea = (FpBackupPc - 2) & $FFFF
  If (Fps & #FPS_ID) = 0
    If TrapVector = 0 Or TrapVector = #TRAP_STACK
      TrapVector = #VEC_FPE
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.l FpSetCc(old.l, rh.l, newv.l)     ; setfcc
  old = (old & ~#FPS_CC) | newv
  If rh & #FP_SIGN
    old = old | #FPS_N
  EndIf
  If FpExpOf(rh) = 0
    old = old | #FPS_Z
  EndIf
  ProcedureReturn old
EndProcedure

; ---- round and pack (the result into pair p, its sign already in PH(p)) --
Procedure.l FpRoundPack(p.l, ex.l, f.l, r.l)
  If r And (Fps & #FPS_T) = 0
    If Fps & #FPS_D
      FpAdd(f, #P_DRG)
    Else
      FpAdd(f, #P_FRG)
    EndIf
    If (PH(f) >> (23 + #FP_GUARD + 1)) & 1
      FpRsh1(f)
      ex = ex + 1
    EndIf
  EndIf
  FpRsh(f, f, #FP_GUARD)
  PL(p) = PL(f)
  PH(p) = (PH(p) & #FP_SIGN) | ((ex & $FF) << 23) | (PH(f) & #FP_FRACH)
  If ex > $FF
    If FpNoTrap(#FEC_OVFLO)
      FpCopy(p, #P_ZERO)
    EndIf
    ProcedureReturn #FPS_V
  EndIf
  If ex <= 0
    If FpNoTrap(#FEC_UNFLO)
      FpCopy(p, #P_ZERO)
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.l FpRound(p.l)                      ; roundfp11: to F, in place
  Define oh.l, ol.l
  oh = PH(p) : ol = PL(p)
  FpCopy(#P_T, p)
  FpAdd(#P_T, #P_RND)
  If (PH(#P_T) ! oh) & #FP_SIGN
    PH(#P_T) = PH(#P_T) ! #FP_SIGN
    If FpNoTrap(#FEC_OVFLO)
      FpCopy(p, #P_ZERO)
    Else
      FpCopy(p, #P_T)
    EndIf
    ProcedureReturn #FPS_V
  EndIf
  FpCopy(p, #P_T)
  ProcedureReturn 0
EndProcedure

; Big normalize (only for fractions that may have lost many bits), then one at a time
Procedure.l FpNormalize(f.l, ex.l, big.l)
  If big
    If (PH(f) & ($00FFFFFF << #FP_GUARD)) = 0
      FpLsh(f, f, 24) : ex = ex - 24
    EndIf
    If (PH(f) & ($00FFF000 << #FP_GUARD)) = 0
      FpLsh(f, f, 12) : ex = ex - 12
    EndIf
    If (PH(f) & ($00FC0000 << #FP_GUARD)) = 0
      FpLsh(f, f, 6) : ex = ex - 6
    EndIf
  EndIf
  While ((PH(f) >> (23 + #FP_GUARD)) & 1) = 0
    FpLsh1(f) : ex = ex - 1
  Wend
  ProcedureReturn ex
EndProcedure

; ---- the arithmetic (results in #P_FAC) ----------------------------------
Procedure.l FpAddOpRef()                      ; addfp11(fac, fsrc): the plain version (FpAddOpAsm)
  Define fe.l, se.l, ed.l, hf.l, hs.l
  hf = PH(#P_FAC) & ~#FP_SIGN : hs = PH(#P_SRC) & ~#FP_SIGN
  If ULt(hf, hs) Or (hf = hs And ULt(PL(#P_FAC), PL(#P_SRC)))   ; |fac| < |fsrc|: swap
    FpCopy(#P_T, #P_FAC) : FpCopy(#P_FAC, #P_SRC) : FpCopy(#P_SRC, #P_T)
  EndIf
  fe = FpExpOf(PH(#P_FAC))
  se = FpExpOf(PH(#P_SRC))
  If fe = 0
    If se
      FpCopy(#P_FAC, #P_SRC)
    Else
      FpCopy(#P_FAC, #P_ZERO)
    EndIf
    ProcedureReturn 0
  EndIf
  If se = 0
    ProcedureReturn 0
  EndIf
  ed = fe - se
  If ed >= 60
    ProcedureReturn 0
  EndIf
  FpGetFrac(#P_FF, #P_FAC)
  FpGetFrac(#P_SF, #P_SRC)
  FpLsh(#P_FF, #P_FF, #FP_GUARD)
  FpLsh(#P_SF, #P_SF, #FP_GUARD)
  If (PH(#P_FAC) ! PH(#P_SRC)) & #FP_SIGN    ; signs differ: subtract
    If ed
      FpRsh(#P_SF, #P_SF, ed)
    EndIf
    FpSub(#P_FF, #P_SF)
    If (PH(#P_FF) | PL(#P_FF)) = 0
      FpCopy(#P_FAC, #P_ZERO)
      ProcedureReturn 0
    EndIf
    fe = FpNormalize(#P_FF, fe, Bool(ed <= 1))
  Else
    If ed
      FpRsh(#P_SF, #P_SF, ed)
    EndIf
    FpAdd(#P_FF, #P_SF)
    If (PH(#P_FF) >> (23 + #FP_GUARD + 1)) & 1
      FpRsh1(#P_FF) : fe = fe + 1
    EndIf
  EndIf
  ProcedureReturn FpRoundPack(#P_FAC, fe, #P_FF, 1)
EndProcedure

; addfp11 in assembly (#ASM_FP = 1): FpAddOpRef's arithmetic with the two
; operands in registers - FF in r1:r0, SF in r3:r2, the exponent in r12, the
; alignment shift in lr, FAC's high word (its sign) at [sp] - instead of
; pairs reached through PH()/PL() by index. The same steps: |fac| < |fsrc|
; swaps them, a zero, an exponent difference of 60 or more, the guarded
; fractions, the aligning right shift, the add (and the carry's one-bit
; shift) or the subtract and the normalize - a count of leading zeros, which
; lands where FpNormalize's 24/12/6 steps and single shifts land, as each
; stepv only shifts while the fraction's top bit stays below bit 58 - then
; FpRoundPack's rounding (unless FPS T), the shift out of the guard bits and
; the pack. Overflow and underflow call FpNoTrap as FpRoundPack does. The
; result is #P_FAC and FaRet (#FPS_V or 0). FpAddOpRef leaves the swapped
; operand in #P_SRC and its working pairs in #P_T, #P_FF and #P_SF; nothing
; reads them after it, and this leaves them alone. asm_check.pico2 holds it
; to FpAddOpRef (ASMCHECK fpadd).
Global FaRet.l
Procedure FpAddOpAsm()
EndProcedure

Procedure.l FpAddOp()                         ; addfp11(fac, fsrc)
CompilerIf #ASM_FP = 1
  FpAddOpAsm()
  ProcedureReturn FaRet
CompilerElse
  ProcedureReturn FpAddOpRef()
CompilerEndIf
EndProcedure

; frac_mulfp11: #P_FF = the top 64 bits of #P_FF * (#P_SF guarded), shift and add.
; Each stepv adds before it shifts, so no bit is lost to the truncation and the
; result is exactly floor(ff * (sf << 3) / 2^56) - checked against this loop on
; 200,000 random pairs (tools/fp11_model.py's frac_mul), and the identity
; FpFracMulAsm computes.
Procedure FpFracMulRef()
  Define i.l
  FpCopy(#P_M, #P_FF)                         ; mpy
  FpLsh(#P_Q, #P_SF, #FP_GUARD)               ; mpc
  PH(#P_R) = 0 : PL(#P_R) = 0
  If (PL(#P_M) | PL(#P_Q)) = 0                ; 24 x 24
    For i = 0 To 23
      If PH(#P_M) & 1
        PH(#P_R) = PH(#P_R) + PH(#P_Q)
      EndIf
      FpRsh1(#P_R)
      PH(#P_M) = (PH(#P_M) >> 1) & $7FFFFFFF
    Next
  Else
    If PL(#P_M) <> 0
      For i = 0 To 31
        If PL(#P_M) & 1
          FpAdd(#P_R, #P_Q)
        EndIf
        FpRsh1(#P_R)
        PL(#P_M) = (PL(#P_M) >> 1) & $7FFFFFFF
      Next
    EndIf
    For i = 0 To 23
      If PH(#P_M) & 1
        FpAdd(#P_R, #P_Q)
      EndIf
      FpRsh1(#P_R)
      PH(#P_M) = (PH(#P_M) >> 1) & $7FFFFFFF
    Next
  EndIf
  FpCopy(#P_FF, #P_R)
EndProcedure

; ---- THE ASSEMBLY --------------------------------------------------------
; The pairs are reached at fixed offsets: PH(n) and PL(n) are words, #P_FF = 3
; (byte 12), #P_SF = 4 (16), #P_Q = 5 (20). Free here: r0-r3, r12, and r6
; saved (r4 and r5 are FlagNZ and FlagV, r7 the frame, r8-r11 the other
; reserved registers).
;
; The multiply: a = ff (56 bits, its hidden bit at 55), b = sf << 3 (59 bits);
; the product's bits 56-119 are the result. Schoolbook on 32-bit halves, the
; three UMAALs carrying into the next word (each is Rn*Rm + RdLo + RdHi, which
; cannot overflow 64 bits): p1:p0 = al*bl, p2:p1 += al*bh, p3:p1 += ah*bl,
; p3:p2 += ah*bh. 24 x 24 (both low words 0) needs nothing different.
Procedure FpFracMulAsm()
EndProcedure

Procedure FpFracMul()
CompilerIf #ASM_FP = 1
  FpFracMulAsm()
CompilerElse
  FpFracMulRef()
CompilerEndIf
EndProcedure

; divfp11's quotient: #P_Q from #P_FF / #P_SF (both guarded, ff < 2 sf), FqCount
; bits, into the low word for D (FqQd) and the high word for F - simh's loop.
; Its early way out (the remainder gone to 0) only saves the zero bits the
; final shift puts back, so the quotient is floor(ff * 2^(count-1) / sf)
; (tools/fp11_model.py checks the identity on 100,000 pairs) and the assembly
; runs all count steps.
Global FqCount.l, FqQd.l
Procedure FpDivQRef()
  Define i.l
  PH(#P_Q) = 0 : PL(#P_Q) = 0
  i = FqCount
  While i > 0 And (PH(#P_FF) | PL(#P_FF)) <> 0
    FpLsh1(#P_Q)
    If FpLt(#P_FF, #P_SF) = 0
      FpSub(#P_FF, #P_SF)
      If FqQd
        PL(#P_Q) = PL(#P_Q) | 1
      Else
        PH(#P_Q) = PH(#P_Q) | 1
      EndIf
    EndIf
    FpLsh1(#P_FF)
    i = i - 1
  Wend
  If i > 0
    FpLsh(#P_Q, #P_Q, i)
  EndIf
EndProcedure

; The restoring division in registers: ff in r0:r1, sf in r2:r3, the quotient
; in r5:r6, the count in r12. Each stepv subtracts; a borrow adds sf back and
; shifts in a 0, no borrow shifts in a 1; then ff doubles (ff < 2^61 - no
; overflow). The quotient builds in r5:r6 either way: F's 27 bits end in r6
; and move to the high word.
Procedure FpDivQAsm()
EndProcedure

Procedure FpDivQ()
CompilerIf #ASM_FP = 1
  FpDivQAsm()
CompilerElse
  FpDivQRef()
CompilerEndIf
EndProcedure

Procedure.l FpMulOpRef()                      ; mulfp11: the plain version (FpMulOpAsm)
  Define fe.l, se.l
  fe = FpExpOf(PH(#P_FAC))
  se = FpExpOf(PH(#P_SRC))
  If fe = 0 Or se = 0
    FpCopy(#P_FAC, #P_ZERO)
    ProcedureReturn 0
  EndIf
  FpGetFrac(#P_FF, #P_FAC)
  FpGetFrac(#P_SF, #P_SRC)
  fe = fe + se - #FP_BIAS
  PH(#P_FAC) = PH(#P_FAC) ! PH(#P_SRC)
  FpFracMul()
  If ((PH(#P_FF) >> (23 + #FP_GUARD)) & 1) = 0
    FpLsh1(#P_FF) : fe = fe - 1
  EndIf
  ProcedureReturn FpRoundPack(#P_FAC, fe, #P_FF, 1)
EndProcedure

; mulfp11 in assembly (#ASM_FP = 1): FpMulOpRef with the operands in
; registers - a zero exponent gives zero; the fractions with their hidden
; bits, the exponent fe + se - 128, the product's top 64 bits by FpFracMulAsm's
; three UMAALs (ff times sf << 3, bits 56-119), the one-bit normalize, then
; FpRoundPack's rounding, guard shift and pack as FpAddOpAsm does them, the
; sign the two signs' exclusive or. The result is #P_FAC and FaRet; the
; working pairs are left alone (nothing reads them after). asm_check.pico2
; holds it to FpMulOpRef (ASMCHECK fpmul).
Procedure FpMulOpAsm()
EndProcedure

Procedure.l FpMulOp()                         ; mulfp11
CompilerIf #ASM_FP = 1
  FpMulOpAsm()
  ProcedureReturn FaRet
CompilerElse
  ProcedureReturn FpMulOpRef()
CompilerEndIf
EndProcedure

Procedure.l FpModOp()                         ; modfp11: integer to #P_FAC, fraction to #P_MOD
  Define fe.l, se.l, v.l
  fe = FpExpOf(PH(#P_FAC))
  se = FpExpOf(PH(#P_SRC))
  If fe = 0 Or se = 0
    FpCopy(#P_MOD, #P_ZERO)
    FpCopy(#P_FAC, #P_ZERO)
    ProcedureReturn 0
  EndIf
  FpGetFrac(#P_FF, #P_FAC)
  FpGetFrac(#P_SF, #P_SRC)
  fe = fe + se - #FP_BIAS
  PH(#P_FAC) = PH(#P_FAC) ! PH(#P_SRC)
  PH(#P_MOD) = PH(#P_FAC)
  FpFracMul()
  If ((PH(#P_FF) >> (23 + #FP_GUARD)) & 1) = 0
    FpLsh1(#P_FF) : fe = fe - 1
  EndIf
  If fe <= #FP_BIAS                           ; all fraction
    FpCopy(#P_FAC, #P_ZERO)
    ProcedureReturn FpRoundPack(#P_MOD, fe, #P_FF, 1)
  EndIf
  If Fps & #FPS_D
    v = #FP_BIAS + 56
  Else
    v = #FP_BIAS + 24
  EndIf
  If fe > v                                   ; all integer
    FpCopy(#P_MOD, #P_ZERO)
    ProcedureReturn FpRoundPack(#P_FAC, fe, #P_FF, 0)
  EndIf
  FpRsh(#P_M, #P_FMK, fe - #FP_BIAS)          ; the fraction mask
  PL(#P_SF) = PL(#P_FF) & PL(#P_M)
  PH(#P_SF) = PH(#P_FF) & PH(#P_M)
  If (PH(#P_SF) | PL(#P_SF)) = 0
    FpCopy(#P_MOD, #P_ZERO)
  Else
    FpLsh(#P_SF, #P_SF, fe - #FP_BIAS)
    se = FpNormalize(#P_SF, #FP_BIAS, 1)
    FpRoundPack(#P_MOD, se, #P_SF, 1)
  EndIf
  PL(#P_FF) = PL(#P_FF) & ~PL(#P_M)
  PH(#P_FF) = PH(#P_FF) & ~PH(#P_M)
  ProcedureReturn FpRoundPack(#P_FAC, fe, #P_FF, 0)
EndProcedure

Procedure.l FpDivOp()                         ; divfp11 (the caller has refused a zero divisor)
  Define fe.l, se.l
  se = FpExpOf(PH(#P_SRC))
  fe = FpExpOf(PH(#P_FAC))
  If fe = 0
    FpCopy(#P_FAC, #P_ZERO)
    ProcedureReturn 0
  EndIf
  FpGetFrac(#P_FF, #P_FAC)
  FpGetFrac(#P_SF, #P_SRC)
  FpLsh(#P_FF, #P_FF, #FP_GUARD)
  FpLsh(#P_SF, #P_SF, #FP_GUARD)
  fe = fe - se + #FP_BIAS + 1
  PH(#P_FAC) = PH(#P_FAC) ! PH(#P_SRC)
  FqQd = Fps & #FPS_D
  If FqQd
    FqCount = 23 + #FP_GUARD + 33
  Else
    FqCount = 23 + #FP_GUARD + 1
  EndIf
  FpDivQ()
  If ((PH(#P_Q) >> (23 + #FP_GUARD)) & 1) = 0
    FpLsh1(#P_Q) : fe = fe - 1
  EndIf
  ProcedureReturn FpRoundPack(#P_FAC, fe, #P_Q, 1)
EndProcedure

; ---- operands ------------------------------------------------------------
; The space of a specifier through R7 is I, otherwise D (cpu.pico2, THE PC'S SPACE).
; Mapped, a word goes through the page's fast window when it is in one (the
; inline MMReadWordE / MMWriteWordE the CPU's own loads and stores use) and
; through MmuReadWord / MmuWriteWord - the checks, the aborts, the first
; write's W bit - when it is not. (Before the windows, these two were a
; quarter of the time givens spent, 2026-10-21.)
Global FrwA.i, FrwV.l                          ; Globals: MmuReadWord can reach FlagNZ (PM1126)
Global FrwE.l, FrwFast.l                       ; FpReadF / FpWriteF: the window entry, and whether it held
Procedure.l FpRdW(va.l, sp.l)                 ; a word of memory, through the MMU when it is on
  FrwA = va & $FFFF
  If MmuOn
    If sp
      MMReadWordE(FrwV, FrwA, CurI)
    Else
      MMReadWordE(FrwV, FrwA, CurD)
    EndIf
    ProcedureReturn FrwV
  EndIf
  ProcedureReturn PdpReadWord(FrwA)
EndProcedure

Procedure FpWrW(va.l, sp.l, v.l)
  FrwA = va & $FFFF
  FrwV = v & $FFFF
  If MmuOn
    If sp
      MMWriteWordE(FrwA, FrwV, CurI)
    Else
      MMWriteWordE(FrwA, FrwV, CurD)
    EndIf
  Else
    PdpWriteWord(FrwA, FrwV)
  EndIf
EndProcedure

; The yellow stack limit for an FP specifier's -(SP): the address the
; instruction will use, kernel mode only (simh set_stack_trap).
Procedure FpStackCheck(adr.l)
  If adr < #STACK_LIMIT
    If (PswHigh & $C000) = 0
      StackYellow = 1
      CpuErr = CpuErr | #CPUE_YELLOW
      If TrapVector = 0
        TrapVector = #TRAP_STACK
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure FpRegChange(n.l, r.l)               ; fp_reg_change, the J-11's way
  If r = 7
    Reg(7) = (Reg(7) + n) & $FFFF
  Else
    FpChgReg = r : FpChgVal = n : FpChgOn = 1
  EndIf
EndProcedure

; GeteaFW / GeteaFP: the operand's address into FpAdr and FpSpace. len 2 is
; the word form. Mode 0 never comes here for an integer; for a floating
; operand it names an accumulator and AC6/AC7 are an illegal-op exception.
Procedure FpEa(spec.l, ln.l)
  FeR = spec & 7
  FeSp = Bool(FeR = 7)
  Select (spec >> 3) & 7
    Case 0
      If FeR >= 6
        FpNoTrap(#FEC_OP)
        FpQuit = 1
      EndIf
      FpAdr = 0 : FpSpace = 0
    Case 1
      FpAdr = Reg(FeR) : FpSpace = FeSp
    Case 2
      FeAdr = Reg(FeR)
      If FeR = 7
        ln = 2
      EndIf
      FpRegChange(ln, FeR)
      FpAdr = FeAdr : FpSpace = FeSp
    Case 3
      FeAdr = Reg(FeR)
      FpRegChange(2, FeR)
      FpAdr = FpRdW(FeAdr, FeSp) : FpSpace = 0
    Case 4
      FeAdr = (Reg(FeR) - ln) & $FFFF
      FpRegChange(0 - ln, FeR)
      If FeR = 6
        FpStackCheck(FeAdr)
      EndIf
      FpAdr = FeAdr : FpSpace = FeSp
    Case 5
      FeAdr = (Reg(FeR) - 2) & $FFFF
      FpRegChange(-2, FeR)
      If FeR = 6
        FpStackCheck(FeAdr - 2)
      EndIf
      FpAdr = FpRdW(FeAdr, FeSp) : FpSpace = 0
    Case 6
      FeAdr = FpRdW(Reg(7), 1)
      Reg(7) = (Reg(7) + 2) & $FFFF
      FpAdr = (Reg(FeR) + FeAdr) & $FFFF : FpSpace = 0
    Case 7
      FeAdr = FpRdW(Reg(7), 1)
      Reg(7) = (Reg(7) + 2) & $FFFF
      FpAdr = FpRdW((Reg(FeR) + FeAdr) & $FFFF, 0) : FpSpace = 0
  EndSelect
  If TrapVector = #VEC_BUS Or TrapVector = #VEC_MMU
    FpQuit = 1                                ; the address could not be read: the instruction stops
  EndIf
EndProcedure

; ReadFP into pair p (1 = read; 0 = the instruction is NOP'd)
Procedure.i FpReadF(p.i, spec.i, ln.i)
  If spec <= 7
    PH(p) = FrH(spec)
    If ln = #FP_QUAD
      PL(p) = FrL(spec)
    Else
      PL(p) = 0
    EndIf
  ElseIf spec = $17                           ; 027, immediate: one word
    PH(p) = FpRdW(FpAdr, FpSpace) << 16
    PL(p) = 0
  Else
    FrwFast = 0
    If MmuOn And (FpAdr & 1) = 0              ; the whole operand in one window: plain loads
      If FpSpace
        FrwE = CurI + (FpAdr >> 13)
      Else
        FrwE = CurD + (FpAdr >> 13)
      EndIf
      If FpAdr >= MapRLo(FrwE) And FpAdr + ln - 2 < MapRHi(FrwE)
        FrwFast = 1
        FrwA = FpAdr + MapHost(FrwE)
        PH(p) = (PeekU(FrwA) << 16) | PeekU(FrwA + 2)
        If ln = #FP_QUAD
          PL(p) = (PeekU(FrwA + 4) << 16) | PeekU(FrwA + 6)
        Else
          PL(p) = 0
        EndIf
      EndIf
    EndIf
    If FrwFast = 0                            ; else word by word (a page edge, the I/O page, unmapped)
      PH(p) = (FpRdW(FpAdr, FpSpace) << 16) | (FpRdW(FpAdr + 2, FpSpace) & $FFFF)
      If ln = #FP_QUAD
        PL(p) = (FpRdW(FpAdr + 4, FpSpace) << 16) | (FpRdW(FpAdr + 6, FpSpace) & $FFFF)
      Else
        PL(p) = 0
      EndIf
    EndIf
  EndIf
  If TrapVector = #VEC_BUS Or TrapVector = #VEC_MMU
    FpQuit = 1
    ProcedureReturn 0
  EndIf
  If (PH(p) & #FP_SIGN) <> 0 And FpExpOf(PH(p)) = 0
    If FpNoTrap(#FEC_UNDFV) = 0
      ProcedureReturn 0
    EndIf
  EndIf
  ProcedureReturn 1
EndProcedure

Procedure FpWriteF(p.i, spec.i, ln.i)        ; WriteFP from pair p
  If FpQuit
    ProcedureReturn
  EndIf
  If spec <= 7
    FrH(spec) = PH(p)
    If ln = #FP_QUAD
      FrL(spec) = PL(p)
    EndIf
    ProcedureReturn
  EndIf
  If spec = $17
    FpWrW(FpAdr, FpSpace, (PH(p) >> 16) & $FFFF)
    ProcedureReturn
  EndIf
  If FpAdr & 1                                ; odd: the J-11 traps before writing
    CpuErr = CpuErr | #CPUE_ODD
    BusError()
    FpQuit = 1
    ProcedureReturn
  EndIf
  If MmuOn                                    ; the whole operand in one write window: plain stores
    If FpSpace
      FrwE = CurI + (FpAdr >> 13)
    Else
      FrwE = CurD + (FpAdr >> 13)
    EndIf
    If FpAdr >= MapWLo(FrwE) And FpAdr + ln - 2 < MapWHi(FrwE)
      FrwA = FpAdr + MapHost(FrwE)
      PokeU(FrwA, (PH(p) >> 16) & $FFFF)
      PokeU(FrwA + 2, PH(p) & $FFFF)
      If ln = #FP_QUAD
        PokeU(FrwA + 4, (PL(p) >> 16) & $FFFF)
        PokeU(FrwA + 6, PL(p) & $FFFF)
      EndIf
      ProcedureReturn
    EndIf
  EndIf
  FpWrW(FpAdr, FpSpace, (PH(p) >> 16) & $FFFF)
  FpWrW(FpAdr + 2, FpSpace, PH(p) & $FFFF)
  If ln = #FP_QUAD
    FpWrW(FpAdr + 4, FpSpace, (PL(p) >> 16) & $FFFF)
    FpWrW(FpAdr + 6, FpSpace, PL(p) & $FFFF)
  EndIf
  If TrapVector = #VEC_BUS Or TrapVector = #VEC_MMU
    FpQuit = 1
  EndIf
EndProcedure

; THE OPERAND IN ONE PASS (#ASM_FP = 1). FpOpAsm forms an F or D operand's
; address (modes 1-7; not mode 0, an accumulator, and not 027, an immediate)
; and reads the operand into pair FrP (FrWr = 0) or writes pair FrP to it
; (FrWr = 1), FrLn bytes (4 or 8; 2 is a word: PH(FrP) = the word << 16 and
; PL(FrP) = 0, or PH(FrP) >> 16 written, as FpRdW / FpWrW), all through the current mode's fast
; windows, with memory management on. It is FpEa followed by FpReadF or
; FpWriteF when every word it touches - an X(R)'s index word, a deferred
; mode's pointer, the operand - is in its window: the same address, the same
; space, the same register change (the PC's at once, any other's left in
; FpChgReg/FpChgVal/FpChgOn for the end of the instruction). Anything else -
; memory management off, an odd address, a word outside a window, -(R)/@-(R)
; of SP near the stack limit, -(R)/@-(R) of the PC - and it changes no
; register and nothing in FpChg*, sets FrwFast = 0, and the caller goes on to
; the plain procedures, which do it all again. FrwFast = 1: done. (Before it,
; FpEa, FpReadF, FpRdW and FpWriteF were 27% of Whetstone's time, 2026-10-25.)
; FpSrc and FpDst are what the instructions call; asm_check.pico2 holds them to
; FpEa with FpReadF / FpWriteF (ASMCHECK fpop). Free here: r0-r3, r12, and r6
; and lr saved. The PC's (R)+ (027) is FpEa's immediate: one word, in I
; space, the PC changed at once, whatever FrLn says, as FpReadF and FpWriteF
; take it.
Global FrDs.l, FrLn.l, FrP.l, FrWr.l
Procedure FpOpAsm()
EndProcedure

; A floating operand into pair p (FpEa then FpReadF); 0 = the instruction is NOP'd.
Procedure.l FpSrc(p.l, spec.l, ln.l)
CompilerIf #ASM_FP = 1
  If spec <= 5                                ; AC0-AC5: FpEa's mode 0 and FpReadF's copy
    FpAdr = 0 : FpSpace = 0
    PH(p) = FrH(spec)
    If ln = #FP_QUAD
      PL(p) = FrL(spec)
    Else
      PL(p) = 0
    EndIf
    If (PH(p) & #FP_SIGN) <> 0 And FpExpOf(PH(p)) = 0
      If FpNoTrap(#FEC_UNDFV) = 0
        ProcedureReturn 0
      EndIf
    EndIf
    ProcedureReturn 1
  ElseIf spec > 7
    FrDs = spec : FrLn = ln : FrP = p : FrWr = 0
    FpOpAsm()
    If FrwFast
      If (PH(p) & #FP_SIGN) <> 0 And FpExpOf(PH(p)) = 0
        If FpNoTrap(#FEC_UNDFV) = 0
          ProcedureReturn 0
        EndIf
      EndIf
      ProcedureReturn 1
    EndIf
  EndIf
CompilerEndIf
  FpEa(spec, ln)
  If FpQuit
    ProcedureReturn 0
  EndIf
  ProcedureReturn FpReadF(p, spec, ln)
EndProcedure

; Pair p to a floating operand (FpEa then FpWriteF).
Procedure FpDst(p.l, spec.l, ln.l)
CompilerIf #ASM_FP = 1
  If spec > 7 And FpQuit = 0
    FrDs = spec : FrLn = ln : FrP = p : FrWr = 1
    FpOpAsm()
    If FrwFast
      ProcedureReturn
    EndIf
  EndIf
CompilerEndIf
  FpEa(spec, ln)
  FpWriteF(p, spec, ln)
EndProcedure

Procedure.l FpReadI(spec.l, ln.l)             ; ReadI: the integer in the HIGH 16 or all 32 bits
  If ln = 2 Or spec = $17
    ProcedureReturn FpRdW(FpAdr, FpSpace) << 16
  EndIf
  ProcedureReturn (FpRdW(FpAdr, FpSpace) << 16) | (FpRdW(FpAdr + 2, FpSpace) & $FFFF)
EndProcedure

Procedure FpWriteI(v.l, spec.l, ln.l)
  If FpQuit
    ProcedureReturn
  EndIf
  If ln = 2 Or spec = $17
    FpWrW(FpAdr, FpSpace, (v >> 16) & $FFFF)
    ProcedureReturn
  EndIf
  If FpAdr & 1
    CpuErr = CpuErr | #CPUE_ODD
    BusError()
    FpQuit = 1
    ProcedureReturn
  EndIf
  FpWrW(FpAdr, FpSpace, (v >> 16) & $FFFF)
  FpWrW(FpAdr + 2, FpSpace, v & $FFFF)
EndProcedure

Procedure FpLoadAc(p.l, ac.l, qd.l)          ; F_LOAD
  PH(p) = FrH(ac)
  If qd
    PL(p) = FrL(ac)
  Else
    PL(p) = 0
  EndIf
EndProcedure

Procedure FpStoreAc(ac.l, p.l, qd.l)         ; F_STORE
  FrH(ac) = PH(p)
  If qd
    FrL(ac) = PL(p)
  EndIf
EndProcedure

; The processor's condition codes from FxN FxZ FxV FxC (no parameters and no
; locals: FlagNZ is in r4 - cpu.pico2 - and a procedure on the way to it may
; keep nothing of its own there).
Procedure FpCpuCc()
  SetNZ(FxN, FxZ)
  FlagV = FxV << 15
  FlagC = FxC << 16
EndProcedure

; ---- the instruction -----------------------------------------------------
; Op is the instruction, Reg(7) the PC after it (the handler synced it).
; FpExecRef is all of it in Basic; FpExec (below) tries FpExecAsm first.
Procedure FpExecRef()
  If FpReady = 0
    FpInit()
  EndIf
  FpBackupPc = Reg(7)
  FpChgOn = 0
  FpQuit = 0
  FxAc = (Op >> 6) & 3
  FxDs = Op & $3F
  FxQd = Fps & #FPS_D
  If FxQd
    FxLenf = #FP_QUAD
  Else
    FxLenf = #FP_LONG
  EndIf
  Select (Op >> 8) & $F
    Case 0
      Select FxAc
        Case 0
          If Op = $F000                       ; CFCC
            FxN = (Fps >> 3) & 1 : FxZ = (Fps >> 2) & 1 : FxV = (Fps >> 1) & 1 : FxC = Fps & 1
            FpCpuCc()
          ElseIf Op = $F001                   ; SETF
            Fps = Fps & ~#FPS_D
          ElseIf Op = $F002                   ; SETI
            Fps = Fps & ~#FPS_L
          ElseIf Op = $F009                   ; SETD
            Fps = Fps | #FPS_D
          ElseIf Op = $F00A                   ; SETL
            Fps = Fps | #FPS_L
          Else
            FpNoTrap(#FEC_OP)
          EndIf
        Case 1                                ; LDFPS
          If FxDs <= 7
            FxDst = Reg(FxDs)
          Else
            FpEa(FxDs, 2)
            FxDst = FpRdW(FpAdr, FpSpace)
          EndIf
          If FpQuit = 0
            Fps = FxDst & #FPS_RW
          EndIf
        Case 2                                ; STFPS
          Fps = Fps & #FPS_RW
          If FxDs <= 7
            Reg(FxDs) = Fps
          Else
            FpEa(FxDs, 2)
            If FpQuit = 0
              FpWrW(FpAdr, FpSpace, Fps)
            EndIf
          EndIf
        Case 3                                ; STST
          If FxDs <= 7
            Reg(FxDs) = Fec
          Else
            FpEa(FxDs, #FP_LONG)
            FpWriteI((Fec << 16) | Fea, FxDs, #FP_LONG)
          EndIf
      EndSelect
    Case 1
      Select FxAc
        Case 0                                ; CLRf
          FpDst(#P_ZERO, FxDs, FxLenf)
          If FpQuit = 0
            Fps = (Fps & ~#FPS_CC) | #FPS_Z
          EndIf
        Case 1                                ; TSTf
          If FpSrc(#P_SRC, FxDs, FxLenf)
            Fps = FpSetCc(Fps, PH(#P_SRC), 0)
          ElseIf FpQuit = 0 And Fec = #FEC_UNDFV
            Fps = FpSetCc(Fps, PH(#P_SRC), 0)     ; -0 with FIUV: the FPA sets N Z (V C clear) as it flags
          EndIf                                   ; it - DEC's JFPBA0 test 32 (simh leaves the codes)
        Default                               ; 2 ABSf, 3 NEGf
          If FpSrc(#P_SRC, FxDs, FxLenf)
            If FpExpOf(PH(#P_SRC)) = 0
              FpCopy(#P_SRC, #P_ZERO)
            ElseIf FxAc = 2
              PH(#P_SRC) = PH(#P_SRC) & ~#FP_SIGN
            Else
              PH(#P_SRC) = PH(#P_SRC) ! #FP_SIGN
            EndIf
            FpWriteF(#P_SRC, FxDs, FxLenf)
            If FpQuit = 0
              Fps = FpSetCc(Fps, PH(#P_SRC), 0)
            EndIf
          EndIf
      EndSelect
    Case 5                                    ; LDf
      If FpSrc(#P_SRC, FxDs, FxLenf)
        FpStoreAc(FxAc, #P_SRC, FxQd)
        Fps = FpSetCc(Fps, PH(#P_SRC), 0)
      EndIf
    Case 8                                    ; STf
      FpLoadAc(#P_FAC, FxAc, FxQd)
      FpDst(#P_FAC, FxDs, FxLenf)
    Case $F                                   ; LDCff'
      If FpSrc(#P_SRC, FxDs, 12 - FxLenf)
        If FpExpOf(PH(#P_SRC)) = 0
          FpCopy(#P_SRC, #P_ZERO)
        EndIf
        FxNewv = 0
        If (Fps & (#FPS_D | #FPS_T)) = 0
          FxNewv = FpRound(#P_SRC)
        EndIf
        FpStoreAc(FxAc, #P_SRC, FxQd)
        Fps = FpSetCc(Fps, PH(#P_SRC), FxNewv)
      EndIf
    Case $C                                   ; STCff'
      FpLoadAc(#P_FAC, FxAc, FxQd)
      If FpExpOf(PH(#P_FAC)) = 0
        FpCopy(#P_FAC, #P_ZERO)
      EndIf
      FxNewv = 0
      If (Fps & (#FPS_D | #FPS_T)) = #FPS_D
        FxNewv = FpRound(#P_FAC)
      EndIf
      FpDst(#P_FAC, FxDs, 12 - FxLenf)
      If FpQuit = 0
        Fps = FpSetCc(Fps, PH(#P_FAC), FxNewv)
      EndIf
    Case 7                                    ; CMPf
      If FpSrc(#P_SRC, FxDs, FxLenf)
        FpLoadAc(#P_FAC, FxAc, FxQd)
        If FpExpOf(PH(#P_SRC)) = 0
          FpCopy(#P_SRC, #P_ZERO)
        EndIf
        If FpExpOf(PH(#P_FAC)) = 0
          FpCopy(#P_FAC, #P_ZERO)
        EndIf
        If PH(#P_SRC) = PH(#P_FAC) And PL(#P_SRC) = PL(#P_FAC)
          Fps = (Fps & ~#FPS_CC) | #FPS_Z
          If (PH(#P_SRC) | PL(#P_SRC)) = 0
            FpStoreAc(FxAc, #P_ZERO, FxQd)
          EndIf
        Else
          Fps = (Fps & ~#FPS_CC) | ((PH(#P_SRC) >> 28) & #FPS_N)
          If ((PH(#P_SRC) ! PH(#P_FAC)) & #FP_SIGN) = 0 And PH(#P_FAC) <> 0 And FpLt(#P_SRC, #P_FAC)
            Fps = Fps ! #FPS_N
          EndIf
        EndIf
      EndIf
    Case $D                                   ; LDEXP
      If FxDs <= 7
        FxDst = Reg(FxDs)
      Else
        FpEa(FxDs, 2)
        FxDst = FpRdW(FpAdr, FpSpace)
      EndIf
      If FpQuit = 0
        FpLoadAc(#P_FAC, FxAc, FxQd)
        PH(#P_FAC) = (PH(#P_FAC) & ~#FP_EXP) | (((FxDst + #FP_BIAS) & $FF) << 23)
        FxNewv = 0
        If FxDst > $7F And FxDst <= $FF80         ; 0177 < dst <= 0177600
          If FxDst < $8000
            If FpNoTrap(#FEC_OVFLO)
              FpCopy(#P_FAC, #P_ZERO)
            EndIf
            FxNewv = #FPS_V
          Else
            If FpNoTrap(#FEC_UNFLO)
              FpCopy(#P_FAC, #P_ZERO)
            EndIf
          EndIf
        EndIf
        FpStoreAc(FxAc, #P_FAC, FxQd)
        Fps = FpSetCc(Fps, PH(#P_FAC), FxNewv)
      EndIf
    Case $A                                   ; STEXP
      FxDst = (FpExpOf(FrH(FxAc)) - #FP_BIAS) & $FFFF
      FxN = (FxDst >> 15) & 1
      FxZ = Bool(FxDst = 0) : FxV = 0 : FxC = 0
      FpCpuCc()
      Fps = (Fps & ~#FPS_CC) | (FxN << 3) | (Bool(FxDst = 0) << 2)
      If FxDs <= 7
        Reg(FxDs) = FxDst
      Else
        FpEa(FxDs, 2)
        If FpQuit = 0
          FpWrW(FpAdr, FpSpace, FxDst)
        EndIf
      EndIf
    Case $E                                   ; LDCif
      If Fps & #FPS_L
        FxLeni = #FP_LONG
      Else
        FxLeni = 2
      EndIf
      If FxDs <= 7
        PL(#P_FAC) = Reg(FxDs) << 16
      Else
        FpEa(FxDs, FxLeni)
        PL(#P_FAC) = FpReadI(FxDs, FxLeni)
      EndIf
      If FpQuit = 0
        PH(#P_FAC) = 0
        If PL(#P_FAC)
          FxSign = (PL(#P_FAC) >> 31) & 1
          If FxSign
            PL(#P_FAC) = (PL(#P_FAC) ! -1) + 1
          EndIf
          FxI = 0
          While ((PL(#P_FAC) >> 31) & 1) = 0
            PL(#P_FAC) = PL(#P_FAC) << 1
            FxI = FxI + 1
          Wend
          If Fps & #FPS_L
            FxEx = #FP_BIAS + 32 - FxI
          Else
            FxEx = #FP_BIAS + 16 - FxI
          EndIf
          PH(#P_FAC) = (FxSign << 31) | (FxEx << 23) | ((PL(#P_FAC) >> 8) & #FP_FRACH)
          PL(#P_FAC) = PL(#P_FAC) << 24
          If (Fps & (#FPS_D | #FPS_T)) = 0
            FpRound(#P_FAC)
          EndIf
        EndIf
        FpStoreAc(FxAc, #P_FAC, FxQd)
        Fps = FpSetCc(Fps, PH(#P_FAC), 0)
      EndIf
    Case $B                                   ; STCfi
      FxSign = (FrH(FxAc) >> 31) & 1
      FxEx = FpExpOf(FrH(FxAc))
      PH(#P_FAC) = (FrH(FxAc) & #FP_FRACH) | #FP_HB       ; F_LOAD_FRAC
      If FxQd
        PL(#P_FAC) = FrL(FxAc)
      Else
        PL(#P_FAC) = 0
      EndIf
      If Fps & #FPS_L
        FxLeni = #FP_LONG : FxI = #FP_BIAS + 32
      Else
        FxLeni = 2 : FxI = #FP_BIAS + 16
      EndIf
      FxC = 0
      If FxEx <= #FP_BIAS
        FxDst = 0
      ElseIf FxEx > FxI
        FxDst = 0 : FxC = 1
      Else
        FpRsh(#P_SRC, #P_FAC, 23 + 1 + FxI - FxEx)
        If FxLeni = 2
          PL(#P_SRC) = PL(#P_SRC) & ~$FFFF
        EndIf
        ; i_limit[leni == LONG][sign]: word $80000000 / $80010000, long $80000000 / $80000001
        If FxLeni = #FP_LONG
          If FxSign
            FxN = $80000001
          Else
            FxN = $80000000
          EndIf
        Else
          If FxSign
            FxN = $80010000
          Else
            FxN = $80000000
          EndIf
        EndIf
        If ULt(PL(#P_SRC), FxN) = 0
          FxDst = 0 : FxC = 1
        Else
          FxDst = PL(#P_SRC)
          If FxSign
            FxDst = 0 - FxDst
          EndIf
        EndIf
      EndIf
      FxN = (FxDst >> 31) & 1
      FxZ = Bool(FxDst = 0) : FxV = 0
      FpCpuCc()
      If FxC
        FpNoTrap(#FEC_ICVT)
      EndIf
      Fps = (Fps & ~#FPS_CC) | (FxN << 3) | (Bool(FxDst = 0) << 2) | FxC
      If FxDs <= 7
        Reg(FxDs) = (FxDst >> 16) & $FFFF
      Else
        FpEa(FxDs, FxLeni)
        FpWriteI(FxDst, FxDs, FxLeni)
      EndIf
    Default                                   ; 2 MULf, 3 MODf, 4 ADDf, 6 SUBf, 9 DIVf (every other code has its Case)
      If FpSrc(#P_SRC, FxDs, FxLenf)
        FpLoadAc(#P_FAC, FxAc, FxQd)
        FxC = (Op >> 8) & $F
        If FxC = 2
          FxNewv = FpMulOp()
          FpStoreAc(FxAc, #P_FAC, FxQd)
          Fps = FpSetCc(Fps, PH(#P_FAC), FxNewv)
        ElseIf FxC = 3
          FxNewv = FpModOp()
          FpStoreAc(FxAc | 1, #P_FAC, FxQd)
          FpStoreAc(FxAc, #P_MOD, FxQd)
          Fps = FpSetCc(Fps, PH(#P_MOD), FxNewv)
        ElseIf FxC = 9
          If FpExpOf(PH(#P_SRC)) = 0
            FpNoTrap(#FEC_DZRO)
          Else
            FxNewv = FpDivOp()
            FpStoreAc(FxAc, #P_FAC, FxQd)
            Fps = FpSetCc(Fps, PH(#P_FAC), FxNewv)
          EndIf
        Else
          If FxC = 6 And FpExpOf(PH(#P_SRC)) <> 0
            PH(#P_SRC) = PH(#P_SRC) ! #FP_SIGN
          EndIf
          FxNewv = FpAddOp()
          FpStoreAc(FxAc, #P_FAC, FxQd)
          Fps = FpSetCc(Fps, PH(#P_FAC), FxNewv)
        EndIf
      EndIf
  EndSelect
  If FpChgOn And FpQuit = 0                    ; the specifier's register change, at the end
    Reg(FpChgReg) = (Reg(FpChgReg) + FpChgVal) & $FFFF
  EndIf
EndProcedure

; ---- the common instructions in assembly (#ASM_FP = 1) ---------------------
; FpExecAsm does CFCC, SETF, SETI, SETD, SETL, LDFPS and STFPS (the word
; through FpOpAsm, FrLn = 2), CLRf, TSTf, ABSf, NEGf, MULf, ADDf, LDf, SUBf,
; STf and DIVf - every 17xxxx whose bits 11-8 are 0 (but STST), 1, 2, 4, 5,
; 6, 8 or 9 - the way FpExecRef's cases do them: the same prologue (FpBackupPc, FpChgOn,
; FpQuit, FxAc, FxDs, FxQd, FxLenf), the operand through FpSrc / FpDst (a
; memory operand through FpOpAsm directly, as they would, and through them
; only when it says no), the
; accumulator into #P_FAC, the arithmetic procedure (FpMulOp, FpAddOp,
; FpDivOp; a SUBf flips a nonzero source's sign first, a DIVf by a zero
; exponent is FpNoTrap(#FEC_DZRO) and nothing more), the accumulator back, the
; condition codes as FpSetCc sets them, and the register change at the end.
; Op is r8, which every procedure leaves alone. Any other instruction, or the
; unit not yet set up, and it sets FxDone = 0 and FpExec goes on to
; FpExecRef. asm_check.pico2 holds FpExec to FpExecRef (ASMCHECK fpx).
Global FxDone.l
Procedure FpExecAsm()
EndProcedure

Procedure FpExec()
CompilerIf #ASM_FP = 1
  FpExecAsm()
  If FxDone = 0
    FpExecRef()
  EndIf
CompilerElse
  FpExecRef()
CompilerEndIf
EndProcedure

; ======== instructions_mmu.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; ======================================================================
;  instructions_mmu.pico2 - GENERATED by PureMetal/tools/mmu_gen.py from pico/instructions.pico.
;  DO NOT EDIT: change pico/instructions.pico and run the tool again
;  (--check tells whether this file is current).
;
;  The J-11's MAPPED run loop: CpuRunM, the same handlers as CpuRun with
;  every memory access going through the memory management unit (cpu,
;  THE MEMORY MANAGEMENT UNIT). CpuRun hands over to it at a window's end
;  while MMR0 bit 0 is set, and it hands back as soon as the bit is clear,
;  so the unmapped loop is untouched and costs nothing when the unit is off.
;  Include it after cpu and before instructions.
; ======================================================================
Global Dim OpTableM.i(8192)
CompilerIf #DISK_BACKEND = 0
Global Dim OpAsmM.i(65)                 ; JSR, RTS, DIV: the assembly entry ...
CompilerEndIf
CompilerIf #DISK_BACKEND = 0
Global Dim OpRefM.i(65)                 ; ... and the plain one (tools/mmu_gen.py, pico2_ops)
CompilerEndIf
CompilerIf #DISK_BACKEND = 0
Global Dim MovAsmM.i(7)                ; the MOV handlers by mode: the assembly entry ...
CompilerEndIf
CompilerIf #DISK_BACKEND = 0
Global Dim MovRefM.i(7)                ; ... and the plain one (tools/mmu_gen.py, asm_mov)
CompilerEndIf
Global OpTableReadyM.l                    ; 0 until the first CpuRun fills OpTable
Global FillFromM.l, FillCountM.l           ; Ops() - Globals, cheaper than locals

; OpTable(from) .. OpTable(from + count - 1) = target. A '.i' can only
; be taken with ?Name inside the procedure that owns the label, so CpuRun
; itself passes its labels in; this only stores them.
Procedure OpsM(from.l, count.l, target.i)
  FillFromM = from
  FillCountM = count
  While FillCountM > 0
    OpTableM(FillFromM) = target
    FillFromM = FillFromM + 1
    FillCountM = FillCountM - 1
  Wend
EndProcedure

; Execute up to n instructions. Returns how many ran.
Procedure.l CpuRunM(n.l)
; ---- THE EMULATED PC (see PC in cpu) ----------------------------------
; Between instructions the emulated PC lives in PC, a register; Reg(7)
; is a stale copy. A handler that reaches Reg(7) through a variable
; register number, or calls a helper that does (EaWord, FetchWord, Push,
; Pop, TakeTrap, PswSet is fine), starts with PcOut() and ends with
; NextSynced(), which takes the PC back. Every other handler - the
; branches, SOB, and the register forms whose register cannot be R7 -
; works on PC directly and ends with NextNative().
Macro PcOutM()
  Reg(7) = PC
EndMacro

; THE TAIL (see the top of this file), written once as macros and
; expanded in place at the end of every handler - a macro costs nothing
; at run time, so every handler still has its own copy of these lines.
; After a synced handler: take the PC back, take any trap, count, fetch.
CompilerIf #ASM_TAILS = 1
Macro NextSyncedM()
EndMacro
CompilerElse
Macro NextSyncedM()
  PC = Reg(7)
  If TrapVector
    Goto SlowTailM
  EndIf
  RunLeft = RunLeft - 1
  If RunLeft = 0
    Goto RunEndM
  EndIf
  If PC >= Fw(0)                       ; the fetch, through the fetch window (cpu)
    If PC < Fw(1)
      If (PC & 1) = 0
        MmuInstrStart(PC)
        Op = PeekU(PC + Fw(2))
        PC = PC + 2
        ! goto *(void*)((integer*)a_optablem.a)[g_op >> 3];
      EndIf
    EndIf
  EndIf
  Goto SlowFetchM
EndMacro
CompilerEndIf

; After a native handler: it cannot trap and the PC it leaves is even (it
; was even when fetched, and a branch moves it by an even amount), so the
; only test left is whether it is still in RAM.
CompilerIf #ASM_TAILS = 1
Macro NextNativeM()
EndMacro
CompilerElse
Macro NextNativeM()
  RunLeft = RunLeft - 1
  If RunLeft = 0
    Goto RunEndM
  EndIf
  If PC >= Fw(0)                       ; the fetch, through the fetch window (cpu)
    If PC < Fw(1)
      MmuInstrStart(PC)
      Op = PeekU(PC + Fw(2))
      PC = PC + 2
      ! goto *(void*)((integer*)a_optablem.a)[g_op >> 3];
    EndIf
  EndIf
  Goto SlowFetchM
EndMacro
CompilerEndIf

; After a native handler that read memory (an immediate operand): that
; read can leave a trap (the I/O page), so take it; otherwise as above.
Macro NextNativeTrapM()
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
EndMacro

; A branch taken: the low byte of the instruction, signed, in words.
; Op << 24 puts the offset's sign in bit 31, and the arithmetic >> 23
; brings it back down already doubled and sign-extended.
Macro BranchToM()
  PC = (PC + ((Op << 56) >> 55)) & $FFFF
EndMacro

  GBase = @Reg(0)                        ; r5, the base of the globals above (cpu.pico2)
  If OpTableReadyM = 0
    Goto BuildTableM
  EndIf
RunStartM:
  If n <= 0 Or Halted <> 0
    ProcedureReturn 0
  EndIf
  PC = Reg(7)                            ; the caller may have set Reg(7)
  RunFrom = InstrCount
  RunBank = n
  RunLeft = 0
  RunWindow = 0
  Goto RunEndM                            ; which lets the devices act, then opens a window
FetchM:
  If PC >= Fw(0)                       ; the fetch, through the fetch window (cpu)
    If PC < Fw(1)
      If (PC & 1) = 0
        MmuInstrStart(PC)
        Op = PeekU(PC + Fw(2))
        PC = PC + 2
        ! goto *(void*)((integer*)a_optablem.a)[g_op >> 3];
      EndIf
    EndIf
  EndIf
SlowFetchM:                               ; the I/O page, an odd PC, past the end of RAM
  Reg(7) = PC
  MmuInstrStart(PC)
  TrapHeld = TrapVector
  TrapVector = 0
  Op = FetchWordM()
  PC = Reg(7)
  If TrapVector                          ; the fetch itself failed (odd PC, nothing there):
    Goto SlowTailM                        ; trap through 4 and execute nothing - it read as
  EndIf                                  ; 0, a HALT (MAINDEC-11-DFKAB test 100). The PC stays
                                         ; incremented, as on the J-11 (Architecture Handbook
                                         ; 1983, model differences 28 and 30)
  TrapVector = TrapHeld
  ! goto *(void*)((integer*)a_optablem.a)[g_op >> 3];
CompilerIf #ASM_EA = 1
CompilerEndIf
CompilerIf #ASM_OPS = 1
CompilerEndIf
CompilerIf #ASM_EA = 1
CompilerEndIf

;-MOV-------------------------------------------------------------------
; ---- INDEXED HANDLERS ----
; ---- IMX HANDLERS ----
; ---- MEMORY HELPERS ----
InstructionIX_CLR_0050M:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionCLR_0050RefM

InstructionIX_TST_0057M:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionTST_0057RefM

InstructionIX_INC_0052M:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionINC_0052RefM

InstructionIX_DEC_0053M:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionDEC_0053RefM

InstructionIX_CLRB_1050M:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionCLRB_1050RefM

InstructionIX_TSTB_1057M:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionTSTB_1057RefM

InstructionIMX_MOVB_11M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionMOVB_11RefM

InstructionIMX_MOV_01M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionMOV_01RefM

InstructionIMX_CMP_02M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionCMP_02RefM

InstructionIMX_ADD_06M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionADD_06RefM

InstructionIMX_SUB_16M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionSUB_16RefM

InstructionIMX_BIT_03M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionBIT_03RefM

InstructionIMX_BIC_04M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionBIC_04RefM

InstructionIMX_BIS_05M:
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
  Goto InstructionBIS_05RefM

InstructionMOV_01M:            ; 01SSDD   entries $0200-$03FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionMOV_01RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "MOV"
  MMSrcWord()
  If (Op & $38) = 0
    Reg(Op & 7) = Src
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMWriteWord(Ea, Src)
  EndIf
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOV " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOVB_11M:           ; 11SSDD   entries $1200-$13FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionMOVB_11RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "MOVB"
  MMSrcByte()
  If (Op & $38) = 0
    Reg(Op & 7) = (Src | (0 - (Src & $80))) & $FFFF   ; to a register it is sign-extended
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMWriteByte(Ea, Src)
  EndIf
  FlagNZ = Src << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOVB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-CMP-------------------------------------------------------------------
InstructionCMP_02M:            ; 02SSDD   entries $0400-$05FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionCMP_02RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "CMP"
  MMSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
  EndIf
  Res = Src - Dst                        ; src - dst, the other way round from SUB
  FlagC = Res
  FlagV = (Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMP " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionCMPB_12M:           ; 12SSDD   entries $1400-$15FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionCMPB_12RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "CMPB"
  MMSrcByte()
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
  EndIf
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMPB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-BIT-------------------------------------------------------------------
InstructionBIT_03M:            ; 03SSDD   entries $0600-$07FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionBIT_03RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "BIT"
  MMSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
  EndIf
  FlagNZ = Src & Dst
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIT " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBITB_13M:           ; 13SSDD   entries $1600-$17FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionBITB_13RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "BITB"
  MMSrcByte()
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
  EndIf
  FlagNZ = (Src & Dst) << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BITB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-BIC-------------------------------------------------------------------
InstructionBIC_04M:            ; 04SSDD   entries $0800-$09FF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionBIC_04RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "BIC"
  MMSrcWord()
  If (Op & $38) = 0
    Res = Reg(Op & 7) & ~Src & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Res, Ea)
    Res = Res & ~Src & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBICB_14M:           ; 14SSDD   entries $1800-$19FF
  PcOutM()
  ;name = "BICB"
  MMSrcByte()
  If (Op & $38) = 0
    Res = Reg(Op & 7) & ~Src & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Res, Ea)
    Res = Res & ~Src & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BICB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-BIS-------------------------------------------------------------------
InstructionBIS_05M:            ; 05SSDD   entries $0A00-$0BFF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionBIS_05RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "BIS"
  MMSrcWord()
  If (Op & $38) = 0
    Res = Reg(Op & 7) | Src
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Res, Ea)
    Res = Res | Src
    MMWriteWord(Ea, Res)
  EndIf
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBISB_15M:           ; 15SSDD   entries $1A00-$1BFF
  PcOutM()
  ;name = "BISB"
  MMSrcByte()
  If (Op & $38) = 0
    Res = (Reg(Op & 7) | Src) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Res, Ea)
    Res = Res | Src
    MMWriteByte(Ea, Res)
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BISB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ADD-------------------------------------------------------------------
InstructionADD_06M:            ; 06SSDD   entries $0C00-$0DFF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionADD_06RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "ADD"
  MMSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = Src + Dst
    Reg(Op & 7) = Res & $FFFF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = Src + Dst
    MMWriteWord(Ea, Res)
  EndIf
  FlagC = Res
  FlagV = ~(Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("ADD " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-SUB-------------------------------------------------------------------
InstructionSUB_16M:            ; 16SSDD   entries $1C00-$1DFF
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionSUB_16RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "SUB"
  MMSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = Dst - Src
    Reg(Op & 7) = Res & $FFFF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = Dst - Src
    MMWriteWord(Ea, Res)
  EndIf
  FlagC = Res                ; borrow
  FlagV = (Src ! Dst) & (Dst ! Res)
  FlagNZ = Res & $FFFF
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("SUB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  SINGLE-OPERAND. The destination is fetched at the top and stored at
;  the bottom, each with register mode inline.
; ======================================================================

;-CLR-------------------------------------------------------------------
InstructionCLR_0050M:          ; 0050DD   entries $0140-$0147
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionCLR_0050RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "CLR"
  If (Op & $38) = 0
    Reg(Op & 7) = 0
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMWriteWord(Ea, 0)
  EndIf
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionCLRB_1050M:         ; 1050DD   entries $1140-$1147
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionCLRB_1050RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "CLRB"
  If (Op & $38) = 0
    Reg(Op & 7) = Reg(Op & 7) & $FF00
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMWriteByte(Ea, 0)
  EndIf
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLRB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-COM-------------------------------------------------------------------
InstructionCOM_0051M:          ; 0051DD   entries $0148-$014F
  PcOutM()
  ;name = "COM"
  If (Op & $38) = 0
    Res = Reg(Op & 7) ! $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Res, Ea)
    Res = Res ! $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagNZ = Res
  FlagV = 0
  FlagC = $10000
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("COM " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionCOMB_1051M:         ; 1051DD   entries $1148-$114F
  PcOutM()
  ;name = "COMB"
  If (Op & $38) = 0
    Res = (Reg(Op & 7) ! $FF) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Res, Ea)
    Res = Res ! $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  FlagC = $10000
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("COMB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-INC-------------------------------------------------------------------
InstructionINC_0052M:          ; 0052DD   entries $0150-$0157   C unaffected
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionINC_0052RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "INC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst + 1) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst + 1) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $7FFF
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionINCB_1052M:         ; 1052DD   entries $1150-$1157
  PcOutM()
  ;name = "INCB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst + 1) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst + 1) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $7F
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INCB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-DEC-------------------------------------------------------------------
InstructionDEC_0053M:          ; 0053DD   entries $0158-$015F   C unaffected
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionDEC_0053RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "DEC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst - 1) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst - 1) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $8000
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DEC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionDECB_1053M:         ; 1053DD   entries $1158-$115F
  PcOutM()
  ;name = "DECB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst - 1) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst - 1) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $80
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DECB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-NEG-------------------------------------------------------------------
InstructionNEG_0054M:          ; 0054DD   entries $0160-$0167
  PcOutM()
  ;name = "NEG"
  If (Op & $38) = 0
    Res = (0 - Reg(Op & 7)) & $FFFF      ; 100000 negates to itself
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Res, Ea)
    Res = (0 - Res) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagV = 0
  If Res = $8000
    FlagV = $8000
  EndIf
  FlagC = $10000
  If Res = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("NEG " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionNEGB_1054M:         ; 1054DD   entries $1160-$1167
  PcOutM()
  ;name = "NEGB"
  If (Op & $38) = 0
    Res = (0 - Reg(Op & 7)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Res, Ea)
    Res = (0 - Res) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagV = 0
  If Res = $80
    FlagV = $8000
  EndIf
  FlagC = $10000
  If Res = 0
    FlagC = 0
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("NEGB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ADC-------------------------------------------------------------------
InstructionADC_0055M:          ; 0055DD   entries $0168-$016F
  PcOutM()
  ;name = "ADC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst + ((FlagC >> 16) & 1)) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst + ((FlagC >> 16) & 1)) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $7FFF And (FlagC & $10000) <> 0
    FlagV = $8000
  EndIf
  If Dst <> $FFFF Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ADC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionADCB_1055M:         ; 1055DD   entries $1168-$116F
  PcOutM()
  ;name = "ADCB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst + ((FlagC >> 16) & 1)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst + ((FlagC >> 16) & 1)) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $7F And (FlagC & $10000) <> 0
    FlagV = $8000
  EndIf
  If Dst <> $FF Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ADCB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-SBC-------------------------------------------------------------------
; C: set if the destination was 0 and C was 1, cleared otherwise (the
; processor handbook's rule; the C core in this repository leaves C set
; when C was clear - worth checking against a real machine or a test).
InstructionSBC_0056M:          ; 0056DD   entries $0170-$0177
  PcOutM()
  ;name = "SBC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst - ((FlagC >> 16) & 1)) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst - ((FlagC >> 16) & 1)) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $8000
    FlagV = $8000
  EndIf
  If Dst <> 0 Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SBC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionSBCB_1056M:         ; 1056DD   entries $1170-$1177
  PcOutM()
  ;name = "SBCB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst - ((FlagC >> 16) & 1)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst - ((FlagC >> 16) & 1)) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagV = 0
  If Dst = $80
    FlagV = $8000
  EndIf
  If Dst <> 0 Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SBCB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-TST-------------------------------------------------------------------
InstructionTST_0057M:          ; 0057DD   entries $0178-$017F
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionTST_0057RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "TST"
  If (Op & $38) = 0
    FlagNZ = Reg(Op & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(FlagNZ, Ea)
  EndIf
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TST " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionTSTB_1057M:         ; 1057DD   entries $1178-$117F
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionTSTB_1057RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "TSTB"
  If (Op & $38) = 0
    FlagNZ = (Reg(Op & 7) & $FF) << 8
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(FlagNZ, Ea)
    FlagNZ = FlagNZ << 8
  EndIf
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TSTB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  SHIFTS AND ROTATES. V is N xor C after the operation.
; ======================================================================

;-ROR-------------------------------------------------------------------
InstructionROR_0060M:          ; 0060DD   entries $0180-$0187
  PcOutM()
  ;name = "ROR"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst >> 1) | ((FlagC >> 1) & $8000)
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst >> 1) | ((FlagC >> 1) & $8000)
    MMWriteWord(Ea, Res)
  EndIf
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionRORB_1060M:         ; 1060DD   entries $1180-$1187
  PcOutM()
  ;name = "RORB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst >> 1) | ((FlagC >> 9) & $80)
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst >> 1) | ((FlagC >> 9) & $80)
    MMWriteByte(Ea, Res)
  EndIf
  FlagC = Dst << 16
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("RORB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ROL-------------------------------------------------------------------
InstructionROL_0061M:          ; 0061DD   entries $0188-$018F
  PcOutM()
  ;name = "ROL"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROL " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionROLB_1061M:         ; 1061DD   entries $1188-$118F
  PcOutM()
  ;name = "ROLB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagC = Dst << 9
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROLB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ASR-------------------------------------------------------------------
InstructionASR_0062M:          ; 0062DD   entries $0190-$0197
  PcOutM()
  ;name = "ASR"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst >> 1) | (Dst & $8000)
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst >> 1) | (Dst & $8000)
    MMWriteWord(Ea, Res)
  EndIf
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionASRB_1062M:         ; 1062DD   entries $1190-$1197
  PcOutM()
  ;name = "ASRB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst >> 1) | (Dst & $80)
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst >> 1) | (Dst & $80)
    MMWriteByte(Ea, Res)
  EndIf
  FlagC = Dst << 16
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASRB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ASL-------------------------------------------------------------------
InstructionASL_0063M:          ; 0063DD   entries $0198-$019F
  PcOutM()
  ;name = "ASL"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst << 1) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = (Dst << 1) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASL " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionASLB_1063M:         ; 1063DD   entries $1198-$119F
  PcOutM()
  ;name = "ASLB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst << 1) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Dst, Ea)
    Res = (Dst << 1) & $FF
    MMWriteByte(Ea, Res)
  EndIf
  FlagC = Dst << 9
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASLB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-SWAB------------------------------------------------------------------
InstructionSWAB_0003M:         ; 0003DD   entries $0018-$001F
  PcOutM()
  ;name = "SWAB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = ((Dst >> 8) | (Dst << 8)) & $FFFF
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Dst, Ea)
    Res = ((Dst >> 8) | (Dst << 8)) & $FFFF
    MMWriteWord(Ea, Res)
  EndIf
  FlagNZ = (Res & $FF) << 8              ; N and Z come from the low byte
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SWAB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-SXT-------------------------------------------------------------------
InstructionSXT_0067M:          ; 0067DD   entries $01B8-$01BF   N unaffected
CompilerIf #ASM_OPS = 1
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionSXT_0067RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "SXT"
  Res = 0
  If FlagN()
    Res = $FFFF
  EndIf
  If (Op & $38) = 0
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMWriteWord(Ea, Res)
  EndIf
  SetNZ(FlagN(), 1 - FlagN())
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SXT " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-MFPS / MTPS ----------------------------------------------------------
InstructionMFPS_1067M:         ; 1067DD   entries $11B8-$11BF
  PcOutM()
  ;name = "MFPS"
  Res = PswGet() & $FF
  If (Op & $38) = 0
    Reg(Op & 7) = (Res | (0 - (Res & $80))) & $FFFF   ; sign-extended into a register
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMWriteByte(Ea, Res)
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MFPS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMTPS_1064M:         ; 1064SS   entries $11A0-$11A7   the T bit is not written
  PcOutM()
  ;name = "MTPS"
  If (Op & $38) = 0
    Src = Reg(Op & 7) & $FF
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaByteM(Op & $3F)
CompilerEndIf
    MMReadByte(Src, Ea)
  EndIf
  If PswHigh & $C000                     ; outside kernel mode only the condition codes
    PswSet((PswGet() & $FFF0) | (Src & $0F))
  Else
    PswSet((PswGet() & $FF10) | (Src & $EF))
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MTPS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-MFPI / MTPI / MFPD / MTPD -------------------------------------------
; One address space until the memory management unit is modelled, so the
; "previous" space is this one.
InstructionMFPI_0065M:         ; 0065SS   entries $01A8-$01AF
CompilerIf #ASM_OPS = 1
  PcOutM()
  If (Op & $38) = 0
    Src = Reg(Op & 7)
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      Src = ModeSp((PswHigh >> 12) & 3)
    EndIf
    PushM(Src)
  Else
  EndIf
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionMFPI_0065RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "MFPI"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      Src = ModeSp((PswHigh >> 12) & 3)
    EndIf
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWordE(Src, Ea, PrvBase + ((Op >> 12) & 8))
  EndIf
  If TrapVector = 0                      ; a read that failed (bus error, MMU abort) aborts
    PushM(Src)                            ; the instruction: nothing is pushed (the J-11 stops
  EndIf                                  ; at the fault; V6's fuword relies on it)
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MFPI " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMTPI_0066M:         ; 0066DD   entries $01B0-$01B7
CompilerIf #ASM_OPS = 1
  PcOutM()
  If (Op & $38) = 0
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      SetModeSp((PswHigh >> 12) & 3, Src)
    Else
      Reg(Op & 7) = Src
    EndIf
  Else
  EndIf
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionMTPI_0066RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "MTPI"
  Src = PopM()
  If (Op & $38) = 0
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      SetModeSp((PswHigh >> 12) & 3, Src)
    Else
      Reg(Op & 7) = Src
    EndIf
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMWriteWordE(Ea, Src, PrvBase + ((Op >> 12) & 8))
  EndIf
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MTPI " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMFPD_1065M:         ; 1065SS   entries $11A8-$11AF
  ;name = "MFPD"
  Goto InstructionMFPI_0065M
  ;disassembly("MFPD " + ;name)

InstructionMTPD_1066M:         ; 1066DD   entries $11B0-$11B7
  ;name = "MTPD"
  Goto InstructionMTPI_0066M
  ;disassembly("MTPD " + ;name)

; ======================================================================
;  BRANCHES. The offset is the low byte, signed, in words:
;      PC = PC + 2 * offset
;  written without a branch as ((Op & $FF) << 1) - ((Op & $80) << 2).
;  Each branch owns 32 table entries (its offset spills into bits 7-3).
; ======================================================================

;-BR--------------------------------------------------------------------
InstructionBR_0004M:           ; 000400   entries $0020-$003F
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBR_0004RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BR"
  BranchToM()
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBNE_0010M:          ; 001000   entries $0040-$005F   Z = 0
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBNE_0010RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BNE"
  If FlagNZ & $FFFF
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BNE " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBEQ_0014M:          ; 001400   entries $0060-$007F   Z = 1
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBEQ_0014RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BEQ"
  If (FlagNZ & $FFFF) = 0
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BEQ " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBGE_0020M:          ; 002000   entries $0080-$009F   N xor V = 0
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBGE_0020RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BGE"
  If (((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000) = 0     ; N xor V = 0 (N: bit 15, or bit 16 with Z)
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BGE " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBLT_0024M:          ; 002400   entries $00A0-$00BF   N xor V = 1
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBLT_0024RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BLT"
  If ((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BLT " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBGT_0030M:          ; 003000   entries $00C0-$00DF   Z or (N xor V) = 0
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBGT_0030RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BGT"
  If FlagNZ & $FFFF                      ; nested, not And: no truth values built
    If (((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000) = 0     ; N xor V = 0 (N: bit 15, or bit 16 with Z)
      BranchToM()
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BGT " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBLE_0034M:          ; 003400   entries $00E0-$00FF   Z or (N xor V) = 1
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBLE_0034RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BLE"
  If (FlagNZ & $FFFF) = 0
    BranchToM()
  ElseIf ((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BLE " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBPL_1000M:          ; 100000   entries $1000-$101F   N = 0
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBPL_1000RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BPL"
  If (FlagNZ & $18000) = 0
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BPL " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBMI_1004M:          ; 100400   entries $1020-$103F   N = 1
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBMI_1004RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BMI"
  If FlagNZ & $18000
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BMI " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBHI_1010M:          ; 101000   entries $1040-$105F   C = 0 and Z = 0
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBHI_1010RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BHI"
  If (FlagC & $10000) = 0
    If FlagNZ & $FFFF
      BranchToM()
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BHI " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBLOS_1014M:         ; 101400   entries $1060-$107F   C = 1 or Z = 1
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBLOS_1014RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BLOS"
  If FlagC & $10000
    BranchToM()
  ElseIf (FlagNZ & $FFFF) = 0
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BLOS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBVC_1020M:          ; 102000   entries $1080-$109F   V = 0
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBVC_1020RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BVC"
  If (FlagV & $8000) = 0
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BVC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBVS_1024M:          ; 102400   entries $10A0-$10BF   V = 1
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBVS_1024RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BVS"
  If FlagV & $8000
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BVS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBCC_1030M:          ; 103000   entries $10C0-$10DF   C = 0 (also BHIS)
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBCC_1030RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BCC"
  If (FlagC & $10000) = 0
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BCC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBCS_1034M:          ; 103400   entries $10E0-$10FF   C = 1 (also BLO)
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionBCS_1034RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BCS"
  If FlagC & $10000
    BranchToM()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BCS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

; ======================================================================
;  JUMPS AND SUBROUTINES
; ======================================================================

;-JMP-------------------------------------------------------------------
InstructionJMP_0001M:          ; 0001DD   entries $0008-$000F
  PcOutM()
  ;name = "JMP"
  If (Op & $38) = 0
    TrapVector = #VEC_BUS                ; JMP to a register is illegal
  Else
CompilerIf #ASM_EA = 1
CompilerElse
    Reg(7) = EaWordM(Op & $3F)
CompilerEndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("JMP " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-JSR-------------------------------------------------------------------
InstructionJSR_004M:           ; 004RDD   entries $0100-$013F
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
  PcOutM()
  If (Op & $38) = 0
    TrapVector = #VEC_BUS                ; JSR to a register is illegal
  Else
  EndIf
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionJSR_004RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "JSR"
  If (Op & $38) = 0
    TrapVector = #VEC_BUS                ; JSR to a register is illegal
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    PushM(Reg((Op >> 6) & 7))
    Reg((Op >> 6) & 7) = Reg(7)
    Reg(7) = Ea
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("JSR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-RTS-------------------------------------------------------------------
InstructionRTS_00020M:         ; 00020R   entry $0010
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
  PcOutM()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionRTS_00020RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "RTS"
  Reg(7) = Reg(Op & 7)
  Reg(Op & 7) = PopM()
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("RTS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-MARK------------------------------------------------------------------
InstructionMARK_0064M:         ; 0064NN   entries $01A0-$01A7
  PcOutM()
  ;name = "MARK"
  Reg(6) = (Reg(7) + ((Op & $3F) << 1)) & $FFFF
  Reg(7) = Reg(5)
  Reg(5) = PopM()
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("MARK " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-SOB-------------------------------------------------------------------
InstructionSOB_077M:           ; 077RNN   entries $0FC0-$0FFF
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionSOB_077RefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "SOB"                          ; R0-R6 only: SOB R7 is below
  Res = (Reg((Op >> 6) & 7) - 1) & $FFFF
  Reg((Op >> 6) & 7) = Res
  If Res
    PC = (PC - ((Op & $3F) << 1)) & $FFFF
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("SOB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionSOB_077_PCM:        ; 0777NN   SOB R7 - legal, if strange: it counts the PC down
  PcOutM()
  Reg(7) = (Reg(7) - 1) & $FFFF
  If Reg(7)
    Reg(7) = (Reg(7) - ((Op & $3F) << 1)) & $FFFF
  EndIf
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  EIS - MUL, DIV, ASH, ASHC, XOR. Register in bits 8-6, operand in 5-0.
; ======================================================================

;-MUL-------------------------------------------------------------------
InstructionMUL_070M:           ; 070RSS   entries $0E00-$0E3F
  PcOutM()
  ;name = "MUL"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Src, Ea)
  EndIf
  Src = Src - ((Src & $8000) << 1)                        ; signed 16
  Dst = Reg((Op >> 6) & 7)
  Dst = Dst - ((Dst & $8000) << 1)
  Res = Src * Dst                                          ; fits in 32 bits
  If Op & $40                                              ; odd register: low word only
    Reg((Op >> 6) & 7) = Res & $FFFF
  Else
    Reg((Op >> 6) & 7) = (Res >> 16) & $FFFF
    Reg(((Op >> 6) & 7) | 1) = Res & $FFFF
  EndIf
  SetNZ(Bool(Res < 0), Bool(Res = 0))
  FlagV = 0
  FlagC = 0
  If Res < -32768 Or Res > 32767
    FlagC = $10000
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("MUL " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-DIV-------------------------------------------------------------------
InstructionDIV_071M:           ; 071RSS   entries $0E40-$0E7F
CompilerIf #ASM_OPS = 1
  PcOutM()
  ;name = "DIV"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Src, Ea)
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("DIV " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf
InstructionDIV_071RefM:         ; the plain version: the reference (asm_check.pico2)
  PcOutM()
  ;name = "DIV"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Src, Ea)
  EndIf
  Src = Src - ((Src & $8000) << 1)
  Dst = (Reg((Op >> 6) & 7) << 16) | Reg(((Op >> 6) & 7) | 1)   ; the 32-bit dividend
  If Src = 0
    FlagV = $8000
    FlagC = $10000
  ElseIf Src = -1 And Dst = $80000000
    FlagV = $8000
    FlagC = 0
  Else
    Res = Dst / Src
    If Res < -32768 Or Res > 32767
      FlagV = $8000                                            ; registers unchanged
      FlagC = 0
    Else
      Reg((Op >> 6) & 7) = Res & $FFFF
      Reg(((Op >> 6) & 7) | 1) = (Dst - Res * Src) & $FFFF
      SetNZ(Bool(Res < 0), Bool(Res = 0))
      FlagV = 0
      FlagC = 0
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("DIV " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ASH-------------------------------------------------------------------
; Shift count is the low six bits of the source, signed: positive shifts
; left, negative shifts right. A loop - rare instruction, correct first.
InstructionASH_072M:           ; 072RSS   entries $0E80-$0EBF
  PcOutM()
  ;name = "ASH"
  If (Op & $38) = 0
    Src = Reg(Op & 7) & $3F
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Src, Ea)
    Src = Src & $3F
  EndIf
  Res = Reg((Op >> 6) & 7)
  FlagV = 0
  If Src & $20
    Src = 64 - Src                                         ; right by this many
    While Src > 0
      FlagC = Res << 16
      Res = (Res >> 1) | (Res & $8000)
      Src = Src - 1
    Wend
  Else
    While Src > 0
      FlagC = Res << 1
      Tmp = (Res << 1) & $FFFF
      If (Tmp ! Res) & $8000
        FlagV = $8000                                          ; the sign changed
      EndIf
      Res = Tmp
      Src = Src - 1
    Wend
  EndIf
  Reg((Op >> 6) & 7) = Res
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("ASH " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-ASHC------------------------------------------------------------------
InstructionASHC_073M:          ; 073RSS   entries $0EC0-$0EFF
  PcOutM()
  ;name = "ASHC"
  If (Op & $38) = 0
    Src = Reg(Op & 7) & $3F
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Src, Ea)
    Src = Src & $3F
  EndIf
  Res = (Reg((Op >> 6) & 7) << 16) | Reg(((Op >> 6) & 7) | 1)
  FlagV = 0
  If Src & $20
    Src = 64 - Src
    While Src > 0
      FlagC = Res << 16
      Res = Res >> 1                                       ; arithmetic on a 32-bit .i
      Src = Src - 1
    Wend
  Else
    While Src > 0
      FlagC = Res >> 15
      Tmp = Res << 1
      If (Tmp ! Res) & $80000000
        FlagV = $8000
      EndIf
      Res = Tmp
      Src = Src - 1
    Wend
  EndIf
  Reg((Op >> 6) & 7) = (Res >> 16) & $FFFF
  Reg(((Op >> 6) & 7) | 1) = Res & $FFFF
  SetNZ(Bool(Res < 0), Bool(Res = 0))
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("ASHC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

;-XOR-------------------------------------------------------------------
InstructionXOR_074M:           ; 074RDD   entries $0F00-$0F3F
  PcOutM()
  ;name = "XOR"
  If (Op & $38) = 0
    Res = Reg(Op & 7) ! Reg((Op >> 6) & 7)
    Reg(Op & 7) = Res
  Else
CompilerIf #ASM_EA = 1
CompilerElse
      Ea = EaWordM(Op & $3F)
CompilerEndIf
    MMReadWord(Res, Ea)
    Res = Res ! Reg((Op >> 6) & 7)
    MMWriteWord(Ea, Res)
  EndIf
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("XOR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  TRAPS AND MACHINE CONTROL
; ======================================================================
InstructionEMT_104M:           ; 104000-104377   entries $1100-$111F
  PcOutM()
  ;name = "EMT"
  TrapVector = #VEC_EMT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("EMT " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionTRAP_1044M:         ; 104400-104777   entries $1120-$113F
  PcOutM()
  ;name = "TRAP"
  TrapVector = #VEC_TRAP
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("TRAP " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionHALT_000000M:       ; entry $0000, sub-decoded
  PcOutM()
  ;name = "HALT"
  If (PswHigh & $C000) <> 0 Or MaintTrap <> 0   ; HALT outside kernel mode (or with the maintenance
    CpuErr = CpuErr | #CPUE_HALT                ; register's trap option) does not halt: it traps
    TrapVector = #VEC_BUS                       ; through 4, CPU error register bit 7 (cpu.pico,
    Goto SlowTailM                               ; THE CPU ERROR AND MAINTENANCE REGISTERS)
  EndIf
  Halted = 1
  Reg(7) = (Reg(7) - 2) & $FFFF          ; PC stays on the HALT, as on the console
  PC = Reg(7)
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("HALT")
  Goto SlowTailM                         ; Halted is only looked at there

InstructionWAIT_000001M:       ; entry $0000, sub-decoded
  ;name = "WAIT"
  Waiting = 1                            ; RunEnd holds the processor until an interrupt
  CpuEventIn(1)
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("WAIT")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionRTI_000002M:        ; entry $0000, sub-decoded
  PcOutM()
  ;name = "RTI"
  Reg(7) = PopM()
  Src = PopM()
  If PswHigh & $C000                     ; outside kernel: bits 15-11 can only be set,
    Src = (Src & $F81F) | (PswHigh & $F8E0)   ; and the priority stays
  EndIf
  PswSet(Src)
  If PswHigh & $10                       ; RTI loading T: trace straight after it
    TraceArm = 1
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("RTI")
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBPT_000003M:        ; entry $0000, sub-decoded
  PcOutM()
  ;name = "BPT"
  TrapVector = #VEC_BPT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("BPT")
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionIOT_000004M:        ; entry $0000, sub-decoded
  PcOutM()
  ;name = "IOT"
  TrapVector = #VEC_IOT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("IOT")
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionRESET_000005M:      ; entry $0000, sub-decoded
  ;name = "RESET"
  DevReset()                             ; the bus INIT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("RESET")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionRTT_000006M:        ; entry $0000, sub-decoded (the T bit: StartWindow in cpu)
  PcOutM()
  ;name = "RTT"
  Reg(7) = PopM()
  Src = PopM()
  If PswHigh & $C000                     ; outside kernel: bits 15-11 can only be set,
    Src = (Src & $F81F) | (PswHigh & $F8E0)   ; and the priority stays
  EndIf
  PswSet(Src)
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("RTT")
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMFPT_000007M:       ; entry $0000, sub-decoded
  ;name = "MFPT"
  Reg(0) = 5                             ; processor type 5 = J-11
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("MFPT")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionSPL_00023M:         ; 00023N   entry $0013
  ;name = "SPL"
  If (PswHigh & $C000) = 0                ; kernel only; a no-op in other modes
    PswHigh = (PswHigh & $FF1F) | ((Op & 7) << 5)
    IntCheck()                           ; a lower priority may let a request in
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("SPL")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

; 000240-000277: bit 4 = set (1) or clear (0), bits 3-0 = N Z V C.
; 000240 is NOP, 000257 CCC, 000277 SCC.
InstructionCC_00024M:          ; 00024x-00027x   entries $0014-$0017
  ;name = "CLx/SEx"
  ; Each named flag is set or cleared where it lives (see SPEED in cpu),
  ; with no PswGet/PswSet round trip: these are frequent (CLC, SEC, NOP,
  ; CCC...). The priority is untouched, so the only part of PswSet that
  ; could matter - IntCheck - is still called whenever a request waits.
  If Op & 1
    If Op & $10
      FlagC = $10000
    Else
      FlagC = 0
    EndIf
  EndIf
  If Op & 2
    If Op & $10
      FlagV = $8000
    Else
      FlagV = 0
    EndIf
  EndIf
  If Op & $C                             ; N or Z named: rebuild the lazy pair
    Tmp = 0
    If FlagNZ & $18000
      Tmp = 8
    EndIf
    If (FlagNZ & $FFFF) = 0
      Tmp = Tmp | 4
    EndIf
    If Op & $10
      Tmp = Tmp | (Op & $C)
    Else
      Tmp = Tmp & ~(Op & $C)
    EndIf
    SetNZ((Tmp >> 3) & 1, (Tmp >> 2) & 1)
  EndIf
  If IntReq
    IntCheck()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("CC")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

CompilerIf #FP11 = 1
InstructionFPM:                ; 17xxxx: the FPJ11 (pico2/fp11.pico2, FpExec; #FP11 is 0 on the Pico)
  PcOutM()
  FpExec()
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf
CompilerEndIf

InstructionReservedM:          ; every opcode this model does not execute
  PcOutM()
  ;name = "reserved"
  TrapVector = #VEC_RESV
  ; ClockCycles = ClockCycles + #J11_T_TRAP
  ;disassembly(".WORD")
  ; ---- next instruction (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  000000-000007 - the one entry that still holds several instructions.
;  HALT, WAIT, RTI, BPT, IOT, RESET, RTT and MFPT differ only in the low
;  three bits, below the table's index. They are rare, so a short If chain
;  tells them apart - no second table.
; ======================================================================
InstructionGroup0_0000M:       ; 000000-000007   entry $0000
  Tmp = Op & 7
  If Tmp = 0
    Goto InstructionHALT_000000M
  ElseIf Tmp = 1
    Goto InstructionWAIT_000001M
  ElseIf Tmp = 2
    Goto InstructionRTI_000002M
  ElseIf Tmp = 3
    Goto InstructionBPT_000003M
  ElseIf Tmp = 4
    Goto InstructionIOT_000004M
  ElseIf Tmp = 5
    Goto InstructionRESET_000005M
  ElseIf Tmp = 6
    Goto InstructionRTT_000006M
  Else
    Goto InstructionMFPT_000007M
  EndIf


; ======================================================================
;  REGISTER FAST PATHS. The commonest forms - both operands in registers,
;  or a single operand in a register - get handlers with no mode test, no
;  operand-helper call and no Reg(7) traffic. The Pico's table is indexed
;  by Op >> 3, so an entry knows both addressing modes and the source
;  register but NOT the destination register: each fast path first sends
;  a destination of R7 back to the general handler, which keeps the PC
;  right. The table sends a source of R7 there too. (The Pico 2 has one
;  entry per opcode and needs no such test.) Anything not listed here
;  (ADC, SBC, the byte rotates...) is correct through its general handler.
; ======================================================================

InstructionMOV_01_RRM:               ; 01SD, both operands in registers
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionMOV_01_RRRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOV_01M       ; the general handler
  EndIf
  ;name = "MOV Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOV " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionCMP_02_RRM:               ; 02SD, both operands in registers
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionCMP_02_RRRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMP_02M       ; the general handler
  EndIf
  ;name = "CMP Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Res = Src - Reg(Op & 7)
  FlagC = Res                            ; the borrow is bit 16
  FlagNZ = Res & $FFFF
  FlagV = (Src ! (Src - Res)) & (Src ! Res)   ; bit 15; Src - Res is Rd
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMP " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBIT_03_RRM:               ; 03SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIT_03M       ; the general handler
  EndIf
  ;name = "BIT Rs,Rd"
  FlagNZ = Reg((Op >> 6) & 7) & Reg(Op & 7)
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIT " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBIC_04_RRM:               ; 04SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIC_04M       ; the general handler
  EndIf
  ;name = "BIC Rs,Rd"
  Res = Reg(Op & 7) & ~Reg((Op >> 6) & 7) & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBIS_05_RRM:               ; 05SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIS_05M       ; the general handler
  EndIf
  ;name = "BIS Rs,Rd"
  Res = Reg(Op & 7) | Reg((Op >> 6) & 7)
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionADD_06_RRM:               ; 06SD, both operands in registers
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionADD_06_RRRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionADD_06M       ; the general handler
  EndIf
  ;name = "ADD Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Res = Src + Reg(Op & 7)
  FlagC = Res                            ; C is bit 16 of the sum
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! Res) & ((Res - Src) ! Res)   ; bit 15; Res - Src is the old Rd
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("ADD " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionMOVB_11_RRM:              ; 11SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOVB_11M      ; the general handler
  EndIf
  ;name = "MOVB Rs,Rd"
  Src = Reg((Op >> 6) & 7) & $FF
  Reg(Op & 7) = (Src | (0 - (Src & $80))) & $FFFF
  FlagNZ = Src << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOVB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionCMPB_12_RRM:              ; 12SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMPB_12M      ; the general handler
  EndIf
  ;name = "CMPB Rs,Rd"
  Src = Reg((Op >> 6) & 7) & $FF
  Dst = Reg(Op & 7) & $FF
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMPB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBITB_13_RRM:              ; 13SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBITB_13M      ; the general handler
  EndIf
  ;name = "BITB Rs,Rd"
  FlagNZ = (Reg((Op >> 6) & 7) & Reg(Op & 7) & $FF) << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BITB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBICB_14_RRM:              ; 14SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBICB_14M      ; the general handler
  EndIf
  ;name = "BICB Rs,Rd"
  Res = Reg(Op & 7) & ~Reg((Op >> 6) & 7) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BICB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionBISB_15_RRM:              ; 15SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBISB_15M      ; the general handler
  EndIf
  ;name = "BISB Rs,Rd"
  Res = (Reg(Op & 7) | Reg((Op >> 6) & 7)) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BISB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionSUB_16_RRM:               ; 16SD, both operands in registers
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionSUB_16_RRRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionSUB_16M       ; the general handler
  EndIf
  ;name = "SUB Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Res = Reg(Op & 7) - Src
  FlagC = Res                            ; the borrow is bit 16
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! (Res + Src)) & ((Res + Src) ! Res)   ; bit 15; Res + Src is the old Rd
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("SUB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionCLR_0050_RM:              ; 0050R, operand in a register
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionCLR_0050_RRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCLR_0050M     ; the general handler
  EndIf
  ;name = "CLR Rd"
  Reg(Op & 7) = 0
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionCOM_0051_RM:              ; 0051R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCOM_0051M     ; the general handler
  EndIf
  ;name = "COM Rd"
  Res = Reg(Op & 7) ! $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  FlagC = $10000
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("COM " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionINC_0052_RM:              ; 0052R, operand in a register
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionINC_0052_RRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionINC_0052M     ; the general handler
  EndIf
  ;name = "INC Rd"
  Dst = Reg(Op & 7)
  Res = (Dst + 1) & $FFFF
  Reg(Op & 7) = Res
  FlagV = 0
  If Dst = $7FFF
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionDEC_0053_RM:              ; 0053R, operand in a register
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionDEC_0053_RRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionDEC_0053M     ; the general handler
  EndIf
  ;name = "DEC Rd"
  Dst = Reg(Op & 7)
  Res = (Dst - 1) & $FFFF
  Reg(Op & 7) = Res
  FlagV = 0
  If Dst = $8000
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DEC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionNEG_0054_RM:              ; 0054R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionNEG_0054M     ; the general handler
  EndIf
  ;name = "NEG Rd"
  Res = (0 - Reg(Op & 7)) & $FFFF
  Reg(Op & 7) = Res
  FlagV = 0
  If Res = $8000
    FlagV = $8000
  EndIf
  FlagC = $10000
  If Res = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("NEG " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionTST_0057_RM:              ; 0057R, operand in a register
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf
CompilerEndIf
InstructionTST_0057_RRefM:         ; the plain version: the reference (asm_check.pico2)
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionTST_0057M     ; the general handler
  EndIf
  ;name = "TST Rd"
  FlagNZ = Reg(Op & 7)
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TST " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionROR_0060_RM:              ; 0060R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionROR_0060M     ; the general handler
  EndIf
  ;name = "ROR Rd"
  Dst = Reg(Op & 7)
  Res = (Dst >> 1) | ((FlagC >> 1) & $8000)
  Reg(Op & 7) = Res
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionROL_0061_RM:              ; 0061R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionROL_0061M     ; the general handler
  EndIf
  ;name = "ROL Rd"
  Dst = Reg(Op & 7)
  Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FFFF
  Reg(Op & 7) = Res
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROL " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionASR_0062_RM:              ; 0062R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionASR_0062M     ; the general handler
  EndIf
  ;name = "ASR Rd"
  Dst = Reg(Op & 7)
  Res = (Dst >> 1) | (Dst & $8000)
  Reg(Op & 7) = Res
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionASL_0063_RM:              ; 0063R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionASL_0063M     ; the general handler
  EndIf
  ;name = "ASL Rd"
  Dst = Reg(Op & 7)
  Res = (Dst << 1) & $FFFF
  Reg(Op & 7) = Res
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASL " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionSWAB_0003_RM:             ; 0003R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionSWAB_0003M    ; the general handler
  EndIf
  ;name = "SWAB Rd"
  Dst = Reg(Op & 7)
  Res = ((Dst >> 8) | (Dst << 8)) & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = (Res & $FF) << 8
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SWAB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionCLRB_1050_RM:             ; 1050R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCLRB_1050M    ; the general handler
  EndIf
  ;name = "CLRB Rd"
  Reg(Op & 7) = Reg(Op & 7) & $FF00
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLRB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionINCB_1052_RM:             ; 1052R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionINCB_1052M    ; the general handler
  EndIf
  ;name = "INCB Rd"
  Dst = Reg(Op & 7) & $FF
  Res = (Dst + 1) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagV = 0
  If Dst = $7F
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INCB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionDECB_1053_RM:             ; 1053R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionDECB_1053M    ; the general handler
  EndIf
  ;name = "DECB Rd"
  Dst = Reg(Op & 7) & $FF
  Res = (Dst - 1) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagV = 0
  If Dst = $80
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DECB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf

InstructionTSTB_1057_RM:             ; 1057R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionTSTB_1057M    ; the general handler
  EndIf
  ;name = "TSTB Rd"
  FlagNZ = (Reg(Op & 7) & $FF) << 8
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TSTB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextNativeM()
CompilerEndIf


; ======================================================================
;  IMMEDIATE FAST PATHS: OP #n,Rd - the source is the word after the
;  instruction (mode 2 on R7) and the destination a register other than
;  R7. The immediate is read straight at the PC, which stays in its
;  register: no PcOut, no EaWord, no call. A destination of R7 goes back to
;  the general handler, as in the register fast paths.
; ======================================================================

InstructionMOV_01_IRM:            ; 0127DD  MOV #n,Rd, the source an immediate
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf
CompilerEndIf
InstructionMOV_01_IRRefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "MOV #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOV_01M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionCMP_02_IRM:            ; 0227DD  CMP #n,Rd, the source an immediate
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf
CompilerEndIf
InstructionCMP_02_IRRefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "CMP #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMP_02M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  Res = Src - Reg(Op & 7)
  FlagC = Res                            ; the borrow is bit 16
  FlagNZ = Res & $FFFF
  FlagV = (Src ! (Src - Res)) & (Src ! Res)   ; bit 15; Src - Res is Rd
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionBIT_03_IRM:            ; 0327DD  BIT #n,Rd, the source an immediate
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf
CompilerEndIf
InstructionBIT_03_IRRefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "BIT #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIT_03M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  FlagNZ = Src & Reg(Op & 7)
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionBIC_04_IRM:            ; 0427DD  BIC #n,Rd, the source an immediate
  ;name = "BIC #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIC_04M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  Res = Reg(Op & 7) & ~Src & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionBIS_05_IRM:            ; 0527DD  BIS #n,Rd, the source an immediate
  ;name = "BIS #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIS_05M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  Res = Reg(Op & 7) | Src
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionADD_06_IRM:            ; 0627DD  ADD #n,Rd, the source an immediate
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf
CompilerEndIf
InstructionADD_06_IRRefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "ADD #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionADD_06M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  Res = Src + Reg(Op & 7)
  FlagC = Res                            ; C is bit 16 of the sum
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! Res) & ((Res - Src) ! Res)   ; bit 15; Res - Src is the old Rd
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionSUB_16_IRM:            ; 1627DD  SUB #n,Rd, the source an immediate
CompilerIf #ASM_OPS = 1
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf
CompilerEndIf
InstructionSUB_16_IRRefM:         ; the plain version: the reference (asm_check.pico2)
  ;name = "SUB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionSUB_16M                  ; the general handler
  EndIf
  MMReadWordE(Src, PC, CurI)                     ; the word after the instruction
  PC = (PC + 2) & $FFFF
  Res = Reg(Op & 7) - Src
  FlagC = Res                            ; the borrow is bit 16
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! (Res + Src)) & ((Res + Src) ! Res)   ; bit 15; Res + Src is the old Rd
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionMOVB_11_IRM:           ; 1127DD  MOVB #n,Rd, the source an immediate
  ;name = "MOVB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOVB_11M                 ; the general handler
  EndIf
  MMReadByteE(Src, PC, CurI)                     ; the low byte of the word after the instruction
  PC = (PC + 2) & $FFFF                  ; (R7 always steps by two)
  Reg(Op & 7) = (Src | (0 - (Src & $80))) & $FFFF   ; to a register it is sign-extended
  FlagNZ = Src << 8
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionCMPB_12_IRM:           ; 1227DD  CMPB #n,Rd, the source an immediate
  ;name = "CMPB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMPB_12M                 ; the general handler
  EndIf
  MMReadByteE(Src, PC, CurI)                     ; the low byte of the word after the instruction
  PC = (PC + 2) & $FFFF                  ; (R7 always steps by two)
  Dst = Reg(Op & 7) & $FF
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

InstructionBITB_13_IRM:           ; 1327DD  BITB #n,Rd, the source an immediate
  ;name = "BITB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBITB_13M                 ; the general handler
  EndIf
  MMReadByteE(Src, PC, CurI)                     ; the low byte of the word after the instruction
  PC = (PC + 2) & $FFFF                  ; (R7 always steps by two)
  FlagNZ = (Src & Reg(Op & 7) & $FF) << 8
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
CompilerIf #ASM_TAILS = 1
  If TrapVector
    Goto SlowTailM
  EndIf
CompilerElse
  NextNativeTrapM()
CompilerEndIf

; ======================================================================
;  REGISTER SOURCE, MEMORY DESTINATION - OP Rs,(Rd)  OP Rs,(Rd)+  OP Rs,X(Rd)
;  and every other form whose source is a register and whose destination
;  is not. On the J-11 the source register is read AFTER the destination's
;  address has been worked out, so:
;    OP R,(R)+  OP R,-(R)  OP R,@(R)+  OP R,@-(R)   the source is R already
;                                                   stepped by the destination
;    OP PC,X(R)  OP PC,@X(R)  OP PC,A  OP PC,@A     the source is the address
;                                                   of the instruction + 4
;  (KDJ11-A CPU Module User's Guide EK-KDJ1A-UG-002, appendix B, table B-1,
;  items 1, 2 and 3, page B-2: the KDJ11-A is in the 11/23's row, not the
;  11/44's or the 11/70's. The DCF11-AA CPU diagnostic CJKDBD0 tests the
;  same row in its tests 264 to 267 and 271 to 274.) The general handlers
;  above read the source first, which is the same thing for every other
;  pair of modes, so the table sends these forms here and the general
;  handlers never see them. Everything else is the general handler's, line
;  for line; with neither mode to test, these are also the shorter path.
; ======================================================================
InstructionMOV_01_RMM:            ; 010SDD  MOV Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMWriteWord(Ea, Src)
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionCMP_02_RMM:            ; 020SDD  CMP Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMReadWord(Dst, Ea)
  Res = Src - Dst
  FlagC = Res
  FlagV = (Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBIT_03_RMM:            ; 030SDD  BIT Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMReadWord(Dst, Ea)
  FlagNZ = Src & Dst
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBIC_04_RMM:            ; 040SDD  BIC Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMReadWord(Res, Ea)
  Res = Res & ~Src & $FFFF
  MMWriteWord(Ea, Res)
  FlagNZ = Res
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBIS_05_RMM:            ; 050SDD  BIS Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMReadWord(Res, Ea)
  Res = Res | Src
  MMWriteWord(Ea, Res)
  FlagNZ = Res
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionADD_06_RMM:            ; 060SDD  ADD Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMReadWord(Dst, Ea)
  Res = Src + Dst
  MMWriteWord(Ea, Res)
  FlagC = Res
  FlagV = ~(Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionSUB_16_RMM:            ; 160SDD  SUB Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaWordM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7)
  MMReadWord(Dst, Ea)
  Res = Dst - Src
  MMWriteWord(Ea, Res)
  FlagC = Res                ; borrow
  FlagV = (Src ! Dst) & (Dst ! Res)
  FlagNZ = Res & $FFFF
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOVB_11_RMM:           ; 110SDD  MOVB Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByteM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7) & $FF
  MMWriteByte(Ea, Src)
  FlagNZ = Src << 8
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionCMPB_12_RMM:           ; 120SDD  CMPB Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByteM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7) & $FF
  MMReadByte(Dst, Ea)
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBITB_13_RMM:           ; 130SDD  BITB Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByteM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7) & $FF
  MMReadByte(Dst, Ea)
  FlagNZ = (Src & Dst) << 8
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBICB_14_RMM:           ; 140SDD  BICB Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByteM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7) & $FF
  MMReadByte(Res, Ea)
  Res = Res & ~Src & $FF
  MMWriteByte(Ea, Res)
  FlagNZ = Res << 8
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionBISB_15_RMM:           ; 150SDD  BISB Rs,memory
  PcOutM()
CompilerIf #ASM_EA = 1
CompilerElse
    Ea = EaByteM(Op & $3F)
CompilerEndIf
  Src = Reg((Op >> 6) & 7) & $FF
  MMReadByte(Res, Ea)
  Res = Res | Src
  MMWriteByte(Ea, Res)
  FlagNZ = Res << 8
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  THE SLOW WAY OUT OF AN INSTRUCTION - a trap to take, or a HALT. The
;  handlers' own tails send any instruction that left TrapVector set here,
;  and HALT comes here always, because this is the only place that looks
;  at Halted (nothing else sets it).
; ======================================================================
SlowTailM:
  If PswLate                             ; the PSW written through 177776 wins (PswWrite)
    PswSet(PswLate & $FFFF)
    PswLate = 0
    If TrapVector = #TRAP_PSW_LATE
      TrapVector = 0
    EndIf
  EndIf
  If AbortPsw                            ; a bus error aborted the instruction (BusError)
    PswSet(AbortPsw & $FFFF)
    AbortPsw = 0
  EndIf
  If TrapVector = #TRAP_STACK            ; only a marker: StackYellow says what
    TrapVector = 0
  EndIf
  Reg(7) = PC
  If TrapVector
    Tmp = TrapVector
    TrapVector = 0
    TraceArm = 0                         ; a trapping instruction is not traced
    TakeTrap(Tmp)
    If TrapVector = #TRAP_STACK
      TrapVector = 0
    EndIf
  EndIf
  TakeStackTrap()
  PC = Reg(7)
  RunLeft = RunLeft - 1
  If RunLeft > 0 And Halted = 0
    Goto FetchM
  EndIf
; ======================================================================
;  RUNEND - every window ends here (THE RUN WINDOW in cpu.pico): the clock
;  is brought up to date, the devices act, and the next window opens -
;  until CpuRun has run its n, the processor halts, or it WAITs with
;  nothing inside the emulator left to wake it (a typed character comes
;  from the firmware, between runs).
; ======================================================================
RunEndM:
  Reg(7) = PC                            ; the devices' traps work on Reg(7)
  InstrCount = InstrCount + RunWindow - RunLeft
  RunBank = RunBank + RunLeft
  RunLeft = 0
  RunWindow = 0
  ; ---- MMU HANDOVER: the unit is off - back to the unmapped loop ----
  If MmuOn = 0                           ; CpuRun (instructions) takes the rest
    ProcedureReturn InstrCount - RunFrom
  EndIf
  ; ---- END MMU HANDOVER ----
  If Halted = 0
    If TraceArm                          ; the T bit (StartWindow in cpu): trace trap
      TraceArm = 0
      TakeTrap(#VEC_BPT)
      TakeStackTrap()
    EndIf
    DevService()
    While Waiting <> 0 And RunBank > 0 And Dl11TxRdy = 0
      Tmp = Dl11TxDue - InstrCount           ; WAIT: let time pass to the
      If Tmp < 1                             ; transmitter's next moment
        Tmp = 1
      EndIf
      If Tmp > RunBank
        Tmp = RunBank
      EndIf
      InstrCount = InstrCount + Tmp
      RunBank = RunBank - Tmp
      DevService()
    Wend
    If Waiting = 0 And RunBank > 0
      StartWindow()
      PC = Reg(7)
      Goto FetchM
    EndIf
  EndIf
  RunBank = 0
  ProcedureReturn InstrCount - RunFrom


InstructionMOV_01_M04M:            ; MOV, source mode 0, destination mode 4
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M04RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = Op & 7
  Ea = (Reg(EaReg) - 2) & $FFFF
  Reg(EaReg) = Ea
  MmrRecord(EaReg, -2)
  If EaReg = 6
    StackCheckFast()
  EndIf
  Src = Reg((Op >> 6) & 7)
  MMWriteWordE(Ea, Src, CurD)
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOV_01_M40M:            ; MOV, source mode 4, destination mode 0
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M40RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = (Op >> 6) & 7
  Ea = (Reg(EaReg) - 2) & $FFFF
  Reg(EaReg) = Ea
  MmrRecord(EaReg, -2)
  If EaReg = 6
    StackCheckFast()
  EndIf
  MMReadWordE(Src, Ea, CurD)
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOV_01_M60M:            ; MOV, source mode 6, destination mode 0
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M60RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = (Op >> 6) & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
  MMReadWordE(Tmp, Adr, CurI)
  Ea = (Tmp + Reg(EaReg)) & $FFFF
  MMReadWordE(Src, Ea, CurD)
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOV_01_M64M:            ; MOV, source mode 6, destination mode 4
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M64RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = (Op >> 6) & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
  MMReadWordE(Tmp, Adr, CurI)
  Ea = (Tmp + Reg(EaReg)) & $FFFF
  MMReadWordE(Src, Ea, CurD)
  EaReg = Op & 7
  Ea = (Reg(EaReg) - 2) & $FFFF
  Reg(EaReg) = Ea
  MmrRecord(EaReg, -2)
  If EaReg = 6
    StackCheckFast()
  EndIf
  MMWriteWordE(Ea, Src, CurD)
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOV_01_M20M:            ; MOV, source mode 2, destination mode 0
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M20RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = (Op >> 6) & 7
  Ea = Reg(EaReg)
  Reg(EaReg) = (Ea + 2) & $FFFF
  MmrRecord(EaReg, 2)
  MMReadWordE(Src, Ea, CurD)
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOV_01_M61M:            ; MOV, source mode 6, destination mode 1
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M61RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = (Op >> 6) & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
  MMReadWordE(Tmp, Adr, CurI)
  Ea = (Tmp + Reg(EaReg)) & $FFFF
  MMReadWordE(Src, Ea, CurD)
  EaReg = Op & 7
  Ea = Reg(EaReg)
  MMWriteWordE(Ea, Src, CurD)
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

InstructionMOV_01_M06M:            ; MOV, source mode 0, destination mode 6
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M06RefM:         ; the plain version: the fast path's slow path and its reference
  PcOutM()
  EaReg = Op & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
  MMReadWordE(Tmp, Adr, CurI)
  Ea = (Tmp + Reg(EaReg)) & $FFFF
  Src = Reg((Op >> 6) & 7)
  MMWriteWordE(Ea, Src, CurD)
  FlagNZ = Src
  FlagV = 0
CompilerIf #ASM_TAILS = 1
CompilerElse
  NextSyncedM()
CompilerEndIf

; ======================================================================
;  THE TABLE - filled the first time CpuRun runs. A '.i' is taken
;  with ?Name only inside the procedure that owns the label, so this is
;  part of CpuRun; BuildOpcodeTable() at the foot just calls CpuRun(0).
; ======================================================================
BuildTableM:
  OpsM(0, 8192, ?InstructionReservedM)

  ; ---- 0000xx - 0003xx ----
  OpTableM($0000) = ?InstructionGroup0_0000M        ; 000000-000007
  OpsM($0008, 8, ?InstructionJMP_0001M)             ; 000100-000177
  OpTableM($0010) = ?InstructionRTS_00020M          ; 000200-000207
  OpTableM($0013) = ?InstructionSPL_00023M          ; 000230-000237
  OpsM($0014, 4, ?InstructionCC_00024M)             ; 000240-000277
  OpsM($0018, 8, ?InstructionSWAB_0003M)            ; 000300-000377

  ; ---- branches, JSR, single operand ----
  OpsM($0020, 32, ?InstructionBR_0004M)
  OpsM($0040, 32, ?InstructionBNE_0010M)
  OpsM($0060, 32, ?InstructionBEQ_0014M)
  OpsM($0080, 32, ?InstructionBGE_0020M)
  OpsM($00A0, 32, ?InstructionBLT_0024M)
  OpsM($00C0, 32, ?InstructionBGT_0030M)
  OpsM($00E0, 32, ?InstructionBLE_0034M)
  OpsM($0100, 64, ?InstructionJSR_004M)
  OpsM($0140, 8, ?InstructionCLR_0050M)
  OpsM($0148, 8, ?InstructionCOM_0051M)
  OpsM($0150, 8, ?InstructionINC_0052M)
  OpsM($0158, 8, ?InstructionDEC_0053M)
  OpsM($0160, 8, ?InstructionNEG_0054M)
  OpsM($0168, 8, ?InstructionADC_0055M)
  OpsM($0170, 8, ?InstructionSBC_0056M)
  OpsM($0178, 8, ?InstructionTST_0057M)
  OpsM($0180, 8, ?InstructionROR_0060M)
  OpsM($0188, 8, ?InstructionROL_0061M)
  OpsM($0190, 8, ?InstructionASR_0062M)
  OpsM($0198, 8, ?InstructionASL_0063M)
  OpsM($01A0, 8, ?InstructionMARK_0064M)
  OpsM($01A8, 8, ?InstructionMFPI_0065M)
  OpsM($01B0, 8, ?InstructionMTPI_0066M)
  OpsM($01B8, 8, ?InstructionSXT_0067M)

  ; ---- double operand, word ----
  OpsM($0200, 512, ?InstructionMOV_01M)
  OpsM($0400, 512, ?InstructionCMP_02M)
  OpsM($0600, 512, ?InstructionBIT_03M)
  OpsM($0800, 512, ?InstructionBIC_04M)
  OpsM($0A00, 512, ?InstructionBIS_05M)
  OpsM($0C00, 512, ?InstructionADD_06M)

  ; ---- EIS ----
  OpsM($0E00, 64, ?InstructionMUL_070M)
  OpsM($0E40, 64, ?InstructionDIV_071M)
  OpsM($0E80, 64, ?InstructionASH_072M)
  OpsM($0EC0, 64, ?InstructionASHC_073M)
  OpsM($0F00, 64, ?InstructionXOR_074M)
  OpsM($0FC0, 64, ?InstructionSOB_077M)
  OpsM($0FF8, 8, ?InstructionSOB_077_PCM)              ; SOB R7

  ; ---- 10xxxx ----
  OpsM($1000, 32, ?InstructionBPL_1000M)
  OpsM($1020, 32, ?InstructionBMI_1004M)
  OpsM($1040, 32, ?InstructionBHI_1010M)
  OpsM($1060, 32, ?InstructionBLOS_1014M)
  OpsM($1080, 32, ?InstructionBVC_1020M)
  OpsM($10A0, 32, ?InstructionBVS_1024M)
  OpsM($10C0, 32, ?InstructionBCC_1030M)
  OpsM($10E0, 32, ?InstructionBCS_1034M)
  OpsM($1100, 32, ?InstructionEMT_104M)
  OpsM($1120, 32, ?InstructionTRAP_1044M)
  OpsM($1140, 8, ?InstructionCLRB_1050M)
  OpsM($1148, 8, ?InstructionCOMB_1051M)
  OpsM($1150, 8, ?InstructionINCB_1052M)
  OpsM($1158, 8, ?InstructionDECB_1053M)
  OpsM($1160, 8, ?InstructionNEGB_1054M)
  OpsM($1168, 8, ?InstructionADCB_1055M)
  OpsM($1170, 8, ?InstructionSBCB_1056M)
  OpsM($1178, 8, ?InstructionTSTB_1057M)
  OpsM($1180, 8, ?InstructionRORB_1060M)
  OpsM($1188, 8, ?InstructionROLB_1061M)
  OpsM($1190, 8, ?InstructionASRB_1062M)
  OpsM($1198, 8, ?InstructionASLB_1063M)
  OpsM($11A0, 8, ?InstructionMTPS_1064M)
  OpsM($11A8, 8, ?InstructionMFPD_1065M)
  OpsM($11B0, 8, ?InstructionMTPD_1066M)
  OpsM($11B8, 8, ?InstructionMFPS_1067M)

  ; ---- double operand, byte, and SUB ----
  OpsM($1200, 512, ?InstructionMOVB_11M)
  OpsM($1400, 512, ?InstructionCMPB_12M)
  OpsM($1600, 512, ?InstructionBITB_13M)
  OpsM($1800, 512, ?InstructionBICB_14M)
  OpsM($1A00, 512, ?InstructionBISB_15M)
  OpsM($1C00, 512, ?InstructionSUB_16M)

  CompilerIf #FP11 = 1
  OpsM($1E00, 512, ?InstructionFPM)        ; 17xxxx: the FPJ11 (pico2/fp11.pico2; #FP11 is 0 on the Pico)
  CompilerEndIf
  ; ---- register fast paths: overlay the general entries (Op >> 3 keeps
  ; the source register in bits 5-3 and both modes; R7 as the source stays
  ; general, R7 as the destination is sent back by the handler) ----
  For FillFromM = 0 To 6
    OpTableM($0200 | (FillFromM << 3)) = ?InstructionMOV_01_RRM
    OpTableM($0400 | (FillFromM << 3)) = ?InstructionCMP_02_RRM
    OpTableM($0600 | (FillFromM << 3)) = ?InstructionBIT_03_RRM
    OpTableM($0800 | (FillFromM << 3)) = ?InstructionBIC_04_RRM
    OpTableM($0A00 | (FillFromM << 3)) = ?InstructionBIS_05_RRM
    OpTableM($0C00 | (FillFromM << 3)) = ?InstructionADD_06_RRM
    OpTableM($1200 | (FillFromM << 3)) = ?InstructionMOVB_11_RRM
    OpTableM($1400 | (FillFromM << 3)) = ?InstructionCMPB_12_RRM
    OpTableM($1600 | (FillFromM << 3)) = ?InstructionBITB_13_RRM
    OpTableM($1800 | (FillFromM << 3)) = ?InstructionBICB_14_RRM
    OpTableM($1A00 | (FillFromM << 3)) = ?InstructionBISB_15_RRM
    OpTableM($1C00 | (FillFromM << 3)) = ?InstructionSUB_16_RRM
  Next
  OpTableM($0140) = ?InstructionCLR_0050_RM
  OpTableM($0148) = ?InstructionCOM_0051_RM
  OpTableM($0150) = ?InstructionINC_0052_RM
  OpTableM($0158) = ?InstructionDEC_0053_RM
  OpTableM($0160) = ?InstructionNEG_0054_RM
  OpTableM($0178) = ?InstructionTST_0057_RM
  OpTableM($0180) = ?InstructionROR_0060_RM
  OpTableM($0188) = ?InstructionROL_0061_RM
  OpTableM($0190) = ?InstructionASR_0062_RM
  OpTableM($0198) = ?InstructionASL_0063_RM
  OpTableM($0018) = ?InstructionSWAB_0003_RM
  OpTableM($1140) = ?InstructionCLRB_1050_RM
  OpTableM($1150) = ?InstructionINCB_1052_RM
  OpTableM($1158) = ?InstructionDECB_1053_RM
  OpTableM($1178) = ?InstructionTSTB_1057_RM
  ; ---- immediate fast paths: OP #n,Rd (the handler sends Rd = R7 back) ----
  OpTableM($02B8) = ?InstructionMOV_01_IRM
  OpTableM($04B8) = ?InstructionCMP_02_IRM
  OpTableM($06B8) = ?InstructionBIT_03_IRM
  OpTableM($08B8) = ?InstructionBIC_04_IRM
  OpTableM($0AB8) = ?InstructionBIS_05_IRM
  OpTableM($0CB8) = ?InstructionADD_06_IRM
  OpTableM($1CB8) = ?InstructionSUB_16_IRM
  OpTableM($12B8) = ?InstructionMOVB_11_IRM
  OpTableM($14B8) = ?InstructionCMPB_12_IRM
  OpTableM($16B8) = ?InstructionBITB_13_IRM
  ; ---- register source, memory destination (the handlers' header says why):
  ; every source register, R7 too, and destination modes 1 to 7 ----
  For FillFromM = 0 To 7
    For FillCountM = 1 To 7
      OpTableM($0200 | (FillFromM << 3) | FillCountM) = ?InstructionMOV_01_RMM
      OpTableM($0400 | (FillFromM << 3) | FillCountM) = ?InstructionCMP_02_RMM
      OpTableM($0600 | (FillFromM << 3) | FillCountM) = ?InstructionBIT_03_RMM
      OpTableM($0800 | (FillFromM << 3) | FillCountM) = ?InstructionBIC_04_RMM
      OpTableM($0A00 | (FillFromM << 3) | FillCountM) = ?InstructionBIS_05_RMM
      OpTableM($0C00 | (FillFromM << 3) | FillCountM) = ?InstructionADD_06_RMM
      OpTableM($1200 | (FillFromM << 3) | FillCountM) = ?InstructionMOVB_11_RMM
      OpTableM($1400 | (FillFromM << 3) | FillCountM) = ?InstructionCMPB_12_RMM
      OpTableM($1600 | (FillFromM << 3) | FillCountM) = ?InstructionBITB_13_RMM
      OpTableM($1800 | (FillFromM << 3) | FillCountM) = ?InstructionBICB_14_RMM
      OpTableM($1A00 | (FillFromM << 3) | FillCountM) = ?InstructionBISB_15_RMM
      OpTableM($1C00 | (FillFromM << 3) | FillCountM) = ?InstructionSUB_16_RMM
    Next
  Next
; ---- INDEXED ENTRY POINTS ----
; ---- IMX ENTRY POINTS ----
; ---- FAST ENTRY POINTS ----
  ; ---- MOV by addressing mode (tools/mmu_gen.py, MOV_PAIRS) ----
  OpTableM($0204) = ?InstructionMOV_01_M04M
  OpTableM($020C) = ?InstructionMOV_01_M04M
  OpTableM($0214) = ?InstructionMOV_01_M04M
  OpTableM($021C) = ?InstructionMOV_01_M04M
  OpTableM($0224) = ?InstructionMOV_01_M04M
  OpTableM($022C) = ?InstructionMOV_01_M04M
  OpTableM($0234) = ?InstructionMOV_01_M04M
  OpTableM($023C) = ?InstructionMOV_01_M04M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(0) = ?InstructionMOV_01_M04M
  MovRefM(0) = ?InstructionMOV_01_M04RefM
CompilerEndIf
  OpTableM($0300) = ?InstructionMOV_01_M40M
  OpTableM($0308) = ?InstructionMOV_01_M40M
  OpTableM($0310) = ?InstructionMOV_01_M40M
  OpTableM($0318) = ?InstructionMOV_01_M40M
  OpTableM($0320) = ?InstructionMOV_01_M40M
  OpTableM($0328) = ?InstructionMOV_01_M40M
  OpTableM($0330) = ?InstructionMOV_01_M40M
  OpTableM($0338) = ?InstructionMOV_01_M40M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(1) = ?InstructionMOV_01_M40M
  MovRefM(1) = ?InstructionMOV_01_M40RefM
CompilerEndIf
  OpTableM($0380) = ?InstructionMOV_01_M60M
  OpTableM($0388) = ?InstructionMOV_01_M60M
  OpTableM($0390) = ?InstructionMOV_01_M60M
  OpTableM($0398) = ?InstructionMOV_01_M60M
  OpTableM($03A0) = ?InstructionMOV_01_M60M
  OpTableM($03A8) = ?InstructionMOV_01_M60M
  OpTableM($03B0) = ?InstructionMOV_01_M60M
  OpTableM($03B8) = ?InstructionMOV_01_M60M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(2) = ?InstructionMOV_01_M60M
  MovRefM(2) = ?InstructionMOV_01_M60RefM
CompilerEndIf
  OpTableM($0384) = ?InstructionMOV_01_M64M
  OpTableM($038C) = ?InstructionMOV_01_M64M
  OpTableM($0394) = ?InstructionMOV_01_M64M
  OpTableM($039C) = ?InstructionMOV_01_M64M
  OpTableM($03A4) = ?InstructionMOV_01_M64M
  OpTableM($03AC) = ?InstructionMOV_01_M64M
  OpTableM($03B4) = ?InstructionMOV_01_M64M
  OpTableM($03BC) = ?InstructionMOV_01_M64M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(3) = ?InstructionMOV_01_M64M
  MovRefM(3) = ?InstructionMOV_01_M64RefM
CompilerEndIf
  OpTableM($0280) = ?InstructionMOV_01_M20M
  OpTableM($0288) = ?InstructionMOV_01_M20M
  OpTableM($0290) = ?InstructionMOV_01_M20M
  OpTableM($0298) = ?InstructionMOV_01_M20M
  OpTableM($02A0) = ?InstructionMOV_01_M20M
  OpTableM($02A8) = ?InstructionMOV_01_M20M
  OpTableM($02B0) = ?InstructionMOV_01_M20M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(4) = ?InstructionMOV_01_M20M
  MovRefM(4) = ?InstructionMOV_01_M20RefM
CompilerEndIf
  OpTableM($0381) = ?InstructionMOV_01_M61M
  OpTableM($0389) = ?InstructionMOV_01_M61M
  OpTableM($0391) = ?InstructionMOV_01_M61M
  OpTableM($0399) = ?InstructionMOV_01_M61M
  OpTableM($03A1) = ?InstructionMOV_01_M61M
  OpTableM($03A9) = ?InstructionMOV_01_M61M
  OpTableM($03B1) = ?InstructionMOV_01_M61M
  OpTableM($03B9) = ?InstructionMOV_01_M61M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(5) = ?InstructionMOV_01_M61M
  MovRefM(5) = ?InstructionMOV_01_M61RefM
CompilerEndIf
  OpTableM($0206) = ?InstructionMOV_01_M06M
  OpTableM($020E) = ?InstructionMOV_01_M06M
  OpTableM($0216) = ?InstructionMOV_01_M06M
  OpTableM($021E) = ?InstructionMOV_01_M06M
  OpTableM($0226) = ?InstructionMOV_01_M06M
  OpTableM($022E) = ?InstructionMOV_01_M06M
  OpTableM($0236) = ?InstructionMOV_01_M06M
  OpTableM($023E) = ?InstructionMOV_01_M06M
CompilerIf #DISK_BACKEND = 0
  MovAsmM(6) = ?InstructionMOV_01_M06M
  MovRefM(6) = ?InstructionMOV_01_M06RefM
  OpAsmM(0) = ?InstructionJSR_004M
  OpRefM(0) = ?InstructionJSR_004RefM
  OpAsmM(1) = ?InstructionRTS_00020M
  OpRefM(1) = ?InstructionRTS_00020RefM
  OpAsmM(2) = ?InstructionDIV_071M
  OpRefM(2) = ?InstructionDIV_071RefM
  OpAsmM(3) = ?InstructionCMP_02M
  OpRefM(3) = ?InstructionCMP_02RefM
  OpAsmM(4) = ?InstructionTST_0057M
  OpRefM(4) = ?InstructionTST_0057RefM
  OpAsmM(5) = ?InstructionINC_0052M
  OpRefM(5) = ?InstructionINC_0052RefM
  OpAsmM(6) = ?InstructionDEC_0053M
  OpRefM(6) = ?InstructionDEC_0053RefM
  OpAsmM(7) = ?InstructionSXT_0067M
  OpRefM(7) = ?InstructionSXT_0067RefM
  OpAsmM(8) = ?InstructionMFPI_0065M
  OpRefM(8) = ?InstructionMFPI_0065RefM
  OpAsmM(9) = ?InstructionMTPI_0066M
  OpRefM(9) = ?InstructionMTPI_0066RefM
  OpAsmM(10) = ?InstructionMOV_01M
  OpRefM(10) = ?InstructionMOV_01RefM
  OpAsmM(11) = ?InstructionADD_06M
  OpRefM(11) = ?InstructionADD_06RefM
  OpAsmM(12) = ?InstructionSUB_16M
  OpRefM(12) = ?InstructionSUB_16RefM
  OpAsmM(13) = ?InstructionBIT_03M
  OpRefM(13) = ?InstructionBIT_03RefM
  OpAsmM(14) = ?InstructionBIC_04M
  OpRefM(14) = ?InstructionBIC_04RefM
  OpAsmM(15) = ?InstructionBIS_05M
  OpRefM(15) = ?InstructionBIS_05RefM
  OpAsmM(16) = ?InstructionMOVB_11M
  OpRefM(16) = ?InstructionMOVB_11RefM
  OpAsmM(17) = ?InstructionCMPB_12M
  OpRefM(17) = ?InstructionCMPB_12RefM
  OpAsmM(18) = ?InstructionBITB_13M
  OpRefM(18) = ?InstructionBITB_13RefM
  OpAsmM(19) = ?InstructionCLR_0050M
  OpRefM(19) = ?InstructionCLR_0050RefM
  OpAsmM(20) = ?InstructionCLRB_1050M
  OpRefM(20) = ?InstructionCLRB_1050RefM
  OpAsmM(21) = ?InstructionTSTB_1057M
  OpRefM(21) = ?InstructionTSTB_1057RefM
  OpAsmM(22) = ?InstructionBR_0004M
  OpRefM(22) = ?InstructionBR_0004RefM
  OpAsmM(23) = ?InstructionBNE_0010M
  OpRefM(23) = ?InstructionBNE_0010RefM
  OpAsmM(24) = ?InstructionBEQ_0014M
  OpRefM(24) = ?InstructionBEQ_0014RefM
  OpAsmM(25) = ?InstructionBGE_0020M
  OpRefM(25) = ?InstructionBGE_0020RefM
  OpAsmM(26) = ?InstructionBLT_0024M
  OpRefM(26) = ?InstructionBLT_0024RefM
  OpAsmM(27) = ?InstructionBGT_0030M
  OpRefM(27) = ?InstructionBGT_0030RefM
  OpAsmM(28) = ?InstructionBLE_0034M
  OpRefM(28) = ?InstructionBLE_0034RefM
  OpAsmM(29) = ?InstructionBPL_1000M
  OpRefM(29) = ?InstructionBPL_1000RefM
  OpAsmM(30) = ?InstructionBMI_1004M
  OpRefM(30) = ?InstructionBMI_1004RefM
  OpAsmM(31) = ?InstructionBHI_1010M
  OpRefM(31) = ?InstructionBHI_1010RefM
  OpAsmM(32) = ?InstructionBLOS_1014M
  OpRefM(32) = ?InstructionBLOS_1014RefM
  OpAsmM(33) = ?InstructionBVC_1020M
  OpRefM(33) = ?InstructionBVC_1020RefM
  OpAsmM(34) = ?InstructionBVS_1024M
  OpRefM(34) = ?InstructionBVS_1024RefM
  OpAsmM(35) = ?InstructionBCC_1030M
  OpRefM(35) = ?InstructionBCC_1030RefM
  OpAsmM(36) = ?InstructionBCS_1034M
  OpRefM(36) = ?InstructionBCS_1034RefM
  OpAsmM(37) = ?InstructionMOV_01_RRM
  OpRefM(37) = ?InstructionMOV_01_RRRefM
  OpAsmM(38) = ?InstructionCMP_02_RRM
  OpRefM(38) = ?InstructionCMP_02_RRRefM
  OpAsmM(39) = ?InstructionADD_06_RRM
  OpRefM(39) = ?InstructionADD_06_RRRefM
  OpAsmM(40) = ?InstructionSUB_16_RRM
  OpRefM(40) = ?InstructionSUB_16_RRRefM
  OpAsmM(41) = ?InstructionCLR_0050_RM
  OpRefM(41) = ?InstructionCLR_0050_RRefM
  OpAsmM(42) = ?InstructionINC_0052_RM
  OpRefM(42) = ?InstructionINC_0052_RRefM
  OpAsmM(43) = ?InstructionDEC_0053_RM
  OpRefM(43) = ?InstructionDEC_0053_RRefM
  OpAsmM(44) = ?InstructionTST_0057_RM
  OpRefM(44) = ?InstructionTST_0057_RRefM
  OpAsmM(45) = ?InstructionMOV_01_IRM
  OpRefM(45) = ?InstructionMOV_01_IRRefM
  OpAsmM(46) = ?InstructionCMP_02_IRM
  OpRefM(46) = ?InstructionCMP_02_IRRefM
  OpAsmM(47) = ?InstructionBIT_03_IRM
  OpRefM(47) = ?InstructionBIT_03_IRRefM
  OpAsmM(48) = ?InstructionADD_06_IRM
  OpRefM(48) = ?InstructionADD_06_IRRefM
  OpAsmM(49) = ?InstructionSUB_16_IRM
  OpRefM(49) = ?InstructionSUB_16_IRRefM
  OpAsmM(50) = ?InstructionSOB_077M
  OpRefM(50) = ?InstructionSOB_077RefM
CompilerEndIf
  OpTableM($12BE) = ?InstructionIMX_MOVB_11M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(51) = ?InstructionIMX_MOVB_11M
  OpRefM(51) = ?InstructionMOVB_11RefM
CompilerEndIf
  OpTableM($2BE) = ?InstructionIMX_MOV_01M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(52) = ?InstructionIMX_MOV_01M
  OpRefM(52) = ?InstructionMOV_01RefM
CompilerEndIf
  OpTableM($4BE) = ?InstructionIMX_CMP_02M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(53) = ?InstructionIMX_CMP_02M
  OpRefM(53) = ?InstructionCMP_02RefM
CompilerEndIf
  OpTableM($CBE) = ?InstructionIMX_ADD_06M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(54) = ?InstructionIMX_ADD_06M
  OpRefM(54) = ?InstructionADD_06RefM
CompilerEndIf
  OpTableM($1CBE) = ?InstructionIMX_SUB_16M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(55) = ?InstructionIMX_SUB_16M
  OpRefM(55) = ?InstructionSUB_16RefM
CompilerEndIf
  OpTableM($6BE) = ?InstructionIMX_BIT_03M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(56) = ?InstructionIMX_BIT_03M
  OpRefM(56) = ?InstructionBIT_03RefM
CompilerEndIf
  OpTableM($8BE) = ?InstructionIMX_BIC_04M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(57) = ?InstructionIMX_BIC_04M
  OpRefM(57) = ?InstructionBIC_04RefM
CompilerEndIf
  OpTableM($ABE) = ?InstructionIMX_BIS_05M
CompilerIf #DISK_BACKEND = 0
  OpAsmM(58) = ?InstructionIMX_BIS_05M
  OpRefM(58) = ?InstructionBIS_05RefM
CompilerEndIf
CompilerIf #ASM_INDEXED = 1
  OpTableM($146) = ?InstructionIX_CLR_0050M
  OpTableM($17E) = ?InstructionIX_TST_0057M
  OpTableM($156) = ?InstructionIX_INC_0052M
  OpTableM($15E) = ?InstructionIX_DEC_0053M
  OpTableM($1146) = ?InstructionIX_CLRB_1050M
  OpTableM($117E) = ?InstructionIX_TSTB_1057M
CompilerEndIf
CompilerIf #DISK_BACKEND = 0
  OpAsmM(59) = ?InstructionIX_CLR_0050M
  OpRefM(59) = ?InstructionCLR_0050RefM
  OpAsmM(60) = ?InstructionIX_TST_0057M
  OpRefM(60) = ?InstructionTST_0057RefM
  OpAsmM(61) = ?InstructionIX_INC_0052M
  OpRefM(61) = ?InstructionINC_0052RefM
  OpAsmM(62) = ?InstructionIX_DEC_0053M
  OpRefM(62) = ?InstructionDEC_0053RefM
  OpAsmM(63) = ?InstructionIX_CLRB_1050M
  OpRefM(63) = ?InstructionCLRB_1050RefM
  OpAsmM(64) = ?InstructionIX_TSTB_1057M
  OpRefM(64) = ?InstructionTSTB_1057RefM
CompilerEndIf
  OpTableReadyM = 1
  Goto RunStartM
EndProcedure

; Fills the table. CpuRun does this itself the first time it runs; calling
; this first only moves the cost out of the first timed run.
Procedure BuildOpcodeTableM()
  CpuRunM(0)
EndProcedure

; ======== instructions.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; GENERATED by tools/unmapped_gen.py from pico/instructions.pico.
; RP2350: Thumb-2 tails, fixed CPU-state offsets, native instruction paths.
CompilerIf #DISK_BACKEND = 0
Global Dim MovAsm.i(7)
Global Dim MovRef.i(7)
Global Dim FastAsm.i(42)
Global Dim FastRef.i(42)
CompilerEndIf
Global Dim OpTable.i(8192)
Global OpTableReady.l                    ; 0 until the first CpuRun fills OpTable
Global FillFrom.l, FillCount.l           ; Ops() - Globals, cheaper than locals

; OpTable(from) .. OpTable(from + count - 1) = target. A '.i' can only
; be taken with ?Name inside the procedure that owns the label, so CpuRun
; itself passes its labels in; this only stores them.
Procedure Ops(from.l, count.l, target.i)
  FillFrom = from
  FillCount = count
  While FillCount > 0
    OpTable(FillFrom) = target
    FillFrom = FillFrom + 1
    FillCount = FillCount - 1
  Wend
EndProcedure

; Execute up to n instructions. Returns how many ran.
Procedure.l CpuRun(n.l)
; ---- THE EMULATED PC (see PC in cpu) ----------------------------------
; Between instructions the emulated PC lives in PC, a register; Reg(7)
; is a stale copy. A handler that reaches Reg(7) through a variable
; register number, or calls a helper that does (EaWord, FetchWord, Push,
; Pop, TakeTrap, PswSet is fine), starts with PcOut() and ends with
; NextSynced(), which takes the PC back. Every other handler - the
; branches, SOB, and the register forms whose register cannot be R7 -
; works on PC directly and ends with NextNative().
Macro PcOut()
  Reg(7) = PC
EndMacro

; ---- UNMAPPED ONLY: the tails in assembly (tools/mmu_gen.py leaves this block out) ----
; THE TAILS IN ASSEMBLY (#ASM_TAILS = 1). The same steps as the macros in
; the Else branch below, written for the Cortex-M0+ with Op, PC and RunLeft
; used where they live (r8, r9, r11). It needs a compiler with "ASM Uses"
; (an assembly block that declares the reserved Globals it reads and
; writes: PureMetal Forge main f408822d or later); with #ASM_TAILS = 0 the
; file builds with an older compiler too. r0-r2 are free at a tail: every
; handler starts at a label, and nothing is held in a register across one.
; PC is always 0-$FFFF, so the unsigned compare is the signed one; a far
; branch is the assembler's own long form.
; Measured on a Pico W, 2026-10-03, compiler f408822d: see images/README.md.
#ASM_TAILS = 0
CompilerIf #ASM_TAILS = 1
CompilerIf #ASM_TAILS = 1
Macro NextSynced()
EndMacro
CompilerElse
Macro NextSynced()
EndMacro
CompilerEndIf

CompilerIf #ASM_TAILS = 1
Macro NextNative()
EndMacro
CompilerElse
Macro NextNative()
EndMacro
CompilerEndIf

CompilerIf #ASM_TAILS = 1
Macro NextNativeTrap()
EndMacro
CompilerElse
Macro NextNativeTrap()
  If TrapVector
    Goto SlowTail
  EndIf
  NextNative()
EndMacro
CompilerEndIf
CompilerElse
; ---- END UNMAPPED ONLY ----
; THE TAIL (see the top of this file), written once as macros and
; expanded in place at the end of every handler - a macro costs nothing
; at run time, so every handler still has its own copy of these lines.
; After a synced handler: take the PC back, take any trap, count, fetch.
Macro NextSynced()
  PC = Reg(7)
  If TrapVector
    Goto SlowTail
  EndIf
  RunLeft = RunLeft - 1
  If RunLeft = 0
    Goto RunEnd
  EndIf
  If PC < #RAM16
    If (PC & 1) = 0
      Op = Mem(PC >> 1)
      PC = PC + 2
      ! goto *(void*)((integer*)a_optable.a)[g_op >> 3];
    EndIf
  EndIf
  Goto SlowFetch
EndMacro

; After a native handler: it cannot trap and the PC it leaves is even (it
; was even when fetched, and a branch moves it by an even amount), so the
; only test left is whether it is still in RAM.
Macro NextNative()
  RunLeft = RunLeft - 1
  If RunLeft = 0
    Goto RunEnd
  EndIf
  If PC < #RAM16
    Op = Mem(PC >> 1)
    PC = PC + 2
    ! goto *(void*)((integer*)a_optable.a)[g_op >> 3];
  EndIf
  Goto SlowFetch
EndMacro

; After a native handler that read memory (an immediate operand): that
; read can leave a trap (the I/O page), so take it; otherwise as above.
Macro NextNativeTrap()
  If TrapVector
    Goto SlowTail
  EndIf
  NextNative()
EndMacro
; ---- UNMAPPED ONLY: the tails in assembly (tools/mmu_gen.py leaves this block out) ----
CompilerEndIf
; ---- END UNMAPPED ONLY ----

; A branch taken: the low byte of the instruction, signed, in words.
; Op << 24 puts the offset's sign in bit 31, and the arithmetic >> 23
; brings it back down already doubled and sign-extended.
Macro BranchTo()
  PC = (PC + ((Op << 56) >> 55)) & $FFFF
EndMacro

  GBase = @Reg(0)                        ; r5, the CPU state base
  If OpTableReady = 0
    Goto BuildTable
  EndIf
RunStart:
  If n <= 0 Or Halted <> 0
    ProcedureReturn 0
  EndIf
  PC = Reg(7)                            ; the caller may have set Reg(7)
  RunFrom = InstrCount
  RunBank = n
  RunLeft = 0
  RunWindow = 0
  Goto RunEnd                            ; which lets the devices act, then opens a window
Fetch:
  If PC < #RAM16
    If (PC & 1) = 0
      Op = Mem(PC >> 1)                  ; fast fetch, straight from RAM
      PC = PC + 2
      ! goto *(void*)((integer*)a_optable.a)[g_op >> 3];
    EndIf
  EndIf
SlowFetch:                               ; the I/O page, an odd PC, past the end of RAM
  Reg(7) = PC
  Op = FetchWord()
  PC = Reg(7)
  If TrapVector                          ; the fetch itself failed (odd PC, nothing there):
    Goto SlowTail                        ; trap through 4 and execute nothing - it read as
  EndIf                                  ; 0, a HALT (MAINDEC-11-DFKAB test 100). The PC stays
                                         ; incremented, as on the J-11 (Architecture Handbook
                                         ; 1983, model differences 28 and 30)
  ! goto *(void*)((integer*)a_optable.a)[g_op >> 3];
; Input template for tools/unmapped_gen.py; CPU field aliases are resolved there.
; ---- UNMAPPED ONLY: the operand address in assembly (tools/mmu_gen.py leaves this block out) ----
; __eau, what the unmapped handlers reach with "bl" instead of calling EaWord
; (cpu.pico2, EaFast and MSrcWord; #ASM_EA = 1): the call, the frame and the
; return of a Basic procedure cost more than the work - EaWord was 52% of the
; time of a program running with memory management off (the PDP-11 demo,
; profiled on a Pico 2 W, 2026-10-24). In: r0 = the 6-bit mode and register.
; Out: r0 = the address, with EaReg, Tmp, Adr and the register left exactly as
; EaWord leaves them. All seven modes are done here when every access is in
; RAM below 160000 and even and -(SP) or @-(SP) leaves SP at or above 000400;
; anything else goes on to EaWord itself with the spec, nothing changed, and lr
; still the handler's, so EaWord returns straight to the handler. It clobbers
; r0-r3, r12 and lr only. asm_check.pico2 holds it to EaWord.
; __eaub is the byte form (EaByte): (R)+ and -(R) stepv by one, by two through
; SP and PC; the other modes are EaWord's, so it goes on to __eau.
CompilerIf #ASM_EA = 1
CompilerEndIf
; ---- END UNMAPPED ONLY ----

;-MOV-------------------------------------------------------------------
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- INDEXED SINGLE NATIVE ----
InstructionIX_CLR_0050:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerEndIf
  Goto InstructionCLR_0050

InstructionIX_TST_0057:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerEndIf
  Goto InstructionTST_0057

InstructionIX_INC_0052:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerEndIf
  Goto InstructionINC_0052

InstructionIX_DEC_0053:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerEndIf
  Goto InstructionDEC_0053

InstructionIX_CLRB_1050:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerEndIf
  Goto InstructionCLRB_1050

InstructionIX_TSTB_1057:
CompilerIf #ASM_INDEXED = 1
CompilerIf #DISK_BACKEND = 0
  SingleHit = SingleHit + 1
CompilerEndIf
CompilerEndIf
  Goto InstructionTSTB_1057

; ---- END INDEXED SINGLE NATIVE ----
; ---- END UNMAPPED ONLY ----
; ---- INDEXED HANDLERS ----
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- IMMEDIATE INDEXED THUMB1 ----
InstructionIMX_MOVB_11:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionMOVB_11

InstructionIMX_MOV_01:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionMOV_01

InstructionIMX_CMP_02:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionCMP_02

InstructionIMX_ADD_06:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionADD_06

InstructionIMX_SUB_16:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionSUB_16

InstructionIMX_BIT_03:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionBIT_03

InstructionIMX_BIC_04:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionBIC_04

InstructionIMX_BIS_05:
CompilerIf #ASM_IMX = 1
CompilerEndIf
  Goto InstructionBIS_05

; ---- END IMMEDIATE INDEXED THUMB1 ----
; ---- END UNMAPPED ONLY ----
; ---- IMX HANDLERS ----
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
; ---- MEMORY HELPERS ----
InstructionMOV_01:            ; 01SSDD   entries $0200-$03FF
  PcOut()
  ;name = "MOV"
  MSrcWord()
  If (Op & $38) = 0
    Reg(Op & 7) = Src
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOV " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionMOVB_11:           ; 11SSDD   entries $1200-$13FF
  PcOut()
  ;name = "MOVB"
  MSrcByte()
  If (Op & $38) = 0
    Reg(Op & 7) = (Src | (0 - (Src & $80))) & $FFFF   ; to a register it is sign-extended
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Src << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOVB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-CMP-------------------------------------------------------------------
InstructionCMP_02:            ; 02SSDD   entries $0400-$05FF
  PcOut()
  ;name = "CMP"
  MSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  Res = Src - Dst                        ; src - dst, the other way round from SUB
  FlagC = Res
  FlagV = (Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMP " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionCMPB_12:           ; 12SSDD   entries $1400-$15FF
  PcOut()
  ;name = "CMPB"
  MSrcByte()
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMPB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-BIT-------------------------------------------------------------------
InstructionBIT_03:            ; 03SSDD   entries $0600-$07FF
  PcOut()
  ;name = "BIT"
  MSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Src & Dst
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIT " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionBITB_13:           ; 13SSDD   entries $1600-$17FF
  PcOut()
  ;name = "BITB"
  MSrcByte()
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = (Src & Dst) << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BITB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-BIC-------------------------------------------------------------------
InstructionBIC_04:            ; 04SSDD   entries $0800-$09FF
  PcOut()
  ;name = "BIC"
  MSrcWord()
  If (Op & $38) = 0
    Res = Reg(Op & 7) & ~Src & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res & ~Src & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionBICB_14:           ; 14SSDD   entries $1800-$19FF
  PcOut()
  ;name = "BICB"
  MSrcByte()
  If (Op & $38) = 0
    Res = Reg(Op & 7) & ~Src & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res & ~Src & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BICB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-BIS-------------------------------------------------------------------
InstructionBIS_05:            ; 05SSDD   entries $0A00-$0BFF
  PcOut()
  ;name = "BIS"
  MSrcWord()
  If (Op & $38) = 0
    Res = Reg(Op & 7) | Src
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res | Src
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionBISB_15:           ; 15SSDD   entries $1A00-$1BFF
  PcOut()
  ;name = "BISB"
  MSrcByte()
  If (Op & $38) = 0
    Res = (Reg(Op & 7) | Src) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res | Src
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BISB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ADD-------------------------------------------------------------------
InstructionADD_06:            ; 06SSDD   entries $0C00-$0DFF
  PcOut()
  ;name = "ADD"
  MSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = Src + Dst
    Reg(Op & 7) = Res & $FFFF
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Src + Dst
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Res
  FlagV = ~(Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("ADD " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-SUB-------------------------------------------------------------------
InstructionSUB_16:            ; 16SSDD   entries $1C00-$1DFF
  PcOut()
  ;name = "SUB"
  MSrcWord()
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = Dst - Src
    Reg(Op & 7) = Res & $FFFF
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Dst - Src
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Res                ; borrow
  FlagV = (Src ! Dst) & (Dst ! Res)
  FlagNZ = Res & $FFFF
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("SUB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

; ======================================================================
;  SINGLE-OPERAND. The destination is fetched at the top and stored at
;  the bottom, each with register mode inline.
; ======================================================================

;-CLR-------------------------------------------------------------------
InstructionCLR_0050:          ; 0050DD   entries $0140-$0147
  PcOut()
  ;name = "CLR"
  If (Op & $38) = 0
    Reg(Op & 7) = 0
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, 0)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionCLRB_1050:         ; 1050DD   entries $1140-$1147
  PcOut()
  ;name = "CLRB"
  If (Op & $38) = 0
    Reg(Op & 7) = Reg(Op & 7) & $FF00
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, 0)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLRB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-COM-------------------------------------------------------------------
InstructionCOM_0051:          ; 0051DD   entries $0148-$014F
  PcOut()
  ;name = "COM"
  If (Op & $38) = 0
    Res = Reg(Op & 7) ! $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res ! $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res
  FlagV = 0
  FlagC = $10000
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("COM " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionCOMB_1051:         ; 1051DD   entries $1148-$114F
  PcOut()
  ;name = "COMB"
  If (Op & $38) = 0
    Res = (Reg(Op & 7) ! $FF) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res ! $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  FlagC = $10000
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("COMB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-INC-------------------------------------------------------------------
InstructionINC_0052:          ; 0052DD   entries $0150-$0157   C unaffected
  PcOut()
  ;name = "INC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst + 1) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst + 1) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $7FFF
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionINCB_1052:         ; 1052DD   entries $1150-$1157
  PcOut()
  ;name = "INCB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst + 1) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst + 1) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $7F
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INCB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-DEC-------------------------------------------------------------------
InstructionDEC_0053:          ; 0053DD   entries $0158-$015F   C unaffected
  PcOut()
  ;name = "DEC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst - 1) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst - 1) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $8000
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DEC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionDECB_1053:         ; 1053DD   entries $1158-$115F
  PcOut()
  ;name = "DECB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst - 1) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst - 1) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $80
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DECB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-NEG-------------------------------------------------------------------
InstructionNEG_0054:          ; 0054DD   entries $0160-$0167
  PcOut()
  ;name = "NEG"
  If (Op & $38) = 0
    Res = (0 - Reg(Op & 7)) & $FFFF      ; 100000 negates to itself
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (0 - Res) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Res = $8000
    FlagV = $8000
  EndIf
  FlagC = $10000
  If Res = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("NEG " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionNEGB_1054:         ; 1054DD   entries $1160-$1167
  PcOut()
  ;name = "NEGB"
  If (Op & $38) = 0
    Res = (0 - Reg(Op & 7)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (0 - Res) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Res = $80
    FlagV = $8000
  EndIf
  FlagC = $10000
  If Res = 0
    FlagC = 0
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("NEGB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ADC-------------------------------------------------------------------
InstructionADC_0055:          ; 0055DD   entries $0168-$016F
  PcOut()
  ;name = "ADC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst + ((FlagC >> 16) & 1)) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst + ((FlagC >> 16) & 1)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $7FFF And (FlagC & $10000) <> 0
    FlagV = $8000
  EndIf
  If Dst <> $FFFF Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ADC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionADCB_1055:         ; 1055DD   entries $1168-$116F
  PcOut()
  ;name = "ADCB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst + ((FlagC >> 16) & 1)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst + ((FlagC >> 16) & 1)) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $7F And (FlagC & $10000) <> 0
    FlagV = $8000
  EndIf
  If Dst <> $FF Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ADCB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-SBC-------------------------------------------------------------------
; C: set if the destination was 0 and C was 1, cleared otherwise (the
; processor handbook's rule; the C core in this repository leaves C set
; when C was clear - worth checking against a real machine or a test).
InstructionSBC_0056:          ; 0056DD   entries $0170-$0177
  PcOut()
  ;name = "SBC"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst - ((FlagC >> 16) & 1)) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst - ((FlagC >> 16) & 1)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $8000
    FlagV = $8000
  EndIf
  If Dst <> 0 Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SBC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionSBCB_1056:         ; 1056DD   entries $1170-$1177
  PcOut()
  ;name = "SBCB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst - ((FlagC >> 16) & 1)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst - ((FlagC >> 16) & 1)) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  If Dst = $80
    FlagV = $8000
  EndIf
  If Dst <> 0 Or FlagC = 0
    FlagC = 0
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SBCB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-TST-------------------------------------------------------------------
InstructionTST_0057:          ; 0057DD   entries $0178-$017F
  PcOut()
  ;name = "TST"
  If (Op & $38) = 0
    FlagNZ = Reg(Op & 7)
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(FlagNZ, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TST " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionTSTB_1057:         ; 1057DD   entries $1178-$117F
  PcOut()
  ;name = "TSTB"
  If (Op & $38) = 0
    FlagNZ = (Reg(Op & 7) & $FF) << 8
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(FlagNZ, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    FlagNZ = FlagNZ << 8
  EndIf
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TSTB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

; ======================================================================
;  SHIFTS AND ROTATES. V is N xor C after the operation.
; ======================================================================

;-ROR-------------------------------------------------------------------
InstructionROR_0060:          ; 0060DD   entries $0180-$0187
  PcOut()
  ;name = "ROR"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst >> 1) | ((FlagC >> 1) & $8000)
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst >> 1) | ((FlagC >> 1) & $8000)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionRORB_1060:         ; 1060DD   entries $1180-$1187
  PcOut()
  ;name = "RORB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst >> 1) | ((FlagC >> 9) & $80)
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst >> 1) | ((FlagC >> 9) & $80)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 16
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("RORB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ROL-------------------------------------------------------------------
InstructionROL_0061:          ; 0061DD   entries $0188-$018F
  PcOut()
  ;name = "ROL"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROL " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionROLB_1061:         ; 1061DD   entries $1188-$118F
  PcOut()
  ;name = "ROLB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 9
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROLB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ASR-------------------------------------------------------------------
InstructionASR_0062:          ; 0062DD   entries $0190-$0197
  PcOut()
  ;name = "ASR"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst >> 1) | (Dst & $8000)
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst >> 1) | (Dst & $8000)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionASRB_1062:         ; 1062DD   entries $1190-$1197
  PcOut()
  ;name = "ASRB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst >> 1) | (Dst & $80)
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst >> 1) | (Dst & $80)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 16
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASRB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ASL-------------------------------------------------------------------
InstructionASL_0063:          ; 0063DD   entries $0198-$019F
  PcOut()
  ;name = "ASL"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = (Dst << 1) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst << 1) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASL " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionASLB_1063:         ; 1063DD   entries $1198-$119F
  PcOut()
  ;name = "ASLB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7) & $FF
    Res = (Dst << 1) & $FF
    Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = (Dst << 1) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagC = Dst << 9
  FlagV = (Res << 8) ! (FlagC >> 1)
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASLB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-SWAB------------------------------------------------------------------
InstructionSWAB_0003:         ; 0003DD   entries $0018-$001F
  PcOut()
  ;name = "SWAB"
  If (Op & $38) = 0
    Dst = Reg(Op & 7)
    Res = ((Dst >> 8) | (Dst << 8)) & $FFFF
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = ((Dst >> 8) | (Dst << 8)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = (Res & $FF) << 8              ; N and Z come from the low byte
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SWAB " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-SXT-------------------------------------------------------------------
InstructionSXT_0067:          ; 0067DD   entries $01B8-$01BF   N unaffected
  PcOut()
  ;name = "SXT"
  Res = 0
  If FlagN()
    Res = $FFFF
  EndIf
  If (Op & $38) = 0
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  SetNZ(FlagN(), 1 - FlagN())
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SXT " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-MFPS / MTPS ----------------------------------------------------------
InstructionMFPS_1067:         ; 1067DD   entries $11B8-$11BF
  PcOut()
  ;name = "MFPS"
  Res = PswGet() & $FF
  If (Op & $38) = 0
    Reg(Op & 7) = (Res | (0 - (Res & $80))) & $FFFF   ; sign-extended into a register
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MFPS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionMTPS_1064:         ; 1064SS   entries $11A0-$11A7   the T bit is not written
  PcOut()
  ;name = "MTPS"
  If (Op & $38) = 0
    Src = Reg(Op & 7) & $FF
  Else
    EaFastB()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadByte(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  If PswHigh & $C000                     ; outside kernel mode only the condition codes
    PswSet((PswGet() & $FFF0) | (Src & $0F))
  Else
    PswSet((PswGet() & $FF10) | (Src & $EF))
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MTPS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-MFPI / MTPI / MFPD / MTPD -------------------------------------------
; One address space until the memory management unit is modelled, so the
; "previous" space is this one.
InstructionMFPI_0065:         ; 0065SS   entries $01A8-$01AF
  PcOut()
  ;name = "MFPI"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      Src = ModeSp((PswHigh >> 12) & 3)
    EndIf
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  If TrapVector = 0                      ; a read that failed (bus error, MMU abort) aborts
    Push(Src)                            ; the instruction: nothing is pushed (the J-11 stops
  EndIf                                  ; at the fault; V6's fuword relies on it)
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MFPI " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionMTPI_0066:         ; 0066DD   entries $01B0-$01B7
  PcOut()
  ;name = "MTPI"
  Src = Pop()
  If (Op & $38) = 0
    If (Op & 7) = 6                      ; SP: the PREVIOUS mode's (PSW 13-12)
      SetModeSp((PswHigh >> 12) & 3, Src)
    Else
      Reg(Op & 7) = Src
    EndIf
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("MTPI " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionMFPD_1065:         ; 1065SS   entries $11A8-$11AF
  ;name = "MFPD"
  Goto InstructionMFPI_0065
  ;disassembly("MFPD " + ;name)

InstructionMTPD_1066:         ; 1066DD   entries $11B0-$11B7
  ;name = "MTPD"
  Goto InstructionMTPI_0066
  ;disassembly("MTPD " + ;name)

; ======================================================================
;  BRANCHES. The offset is the low byte, signed, in words:
;      PC = PC + 2 * offset
;  written without a branch as ((Op & $FF) << 1) - ((Op & $80) << 2).
;  Each branch owns 32 table entries (its offset spills into bits 7-3).
; ======================================================================

;-BR--------------------------------------------------------------------
InstructionBR_0004:           ; 000400   entries $0020-$003F
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBR_0004Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BR"
  BranchTo()
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBNE_0010:          ; 001000   entries $0040-$005F   Z = 0
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBNE_0010Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BNE"
  If FlagNZ & $FFFF
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BNE " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBEQ_0014:          ; 001400   entries $0060-$007F   Z = 1
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBEQ_0014Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BEQ"
  If (FlagNZ & $FFFF) = 0
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BEQ " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBGE_0020:          ; 002000   entries $0080-$009F   N xor V = 0
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBGE_0020Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BGE"
  If (((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000) = 0     ; N xor V = 0 (N: bit 15, or bit 16 with Z)
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BGE " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBLT_0024:          ; 002400   entries $00A0-$00BF   N xor V = 1
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBLT_0024Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BLT"
  If ((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BLT " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBGT_0030:          ; 003000   entries $00C0-$00DF   Z or (N xor V) = 0
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBGT_0030Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BGT"
  If FlagNZ & $FFFF                      ; nested, not And: no truth values built
    If (((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000) = 0     ; N xor V = 0 (N: bit 15, or bit 16 with Z)
      BranchTo()
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BGT " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBLE_0034:          ; 003400   entries $00E0-$00FF   Z or (N xor V) = 1
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBLE_0034Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BLE"
  If (FlagNZ & $FFFF) = 0
    BranchTo()
  ElseIf ((FlagNZ | (FlagNZ >> 1)) ! FlagV) & $8000
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BLE " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBPL_1000:          ; 100000   entries $1000-$101F   N = 0
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBPL_1000Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BPL"
  If (FlagNZ & $18000) = 0
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BPL " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBMI_1004:          ; 100400   entries $1020-$103F   N = 1
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBMI_1004Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BMI"
  If FlagNZ & $18000
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BMI " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBHI_1010:          ; 101000   entries $1040-$105F   C = 0 and Z = 0
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBHI_1010Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BHI"
  If (FlagC & $10000) = 0
    If FlagNZ & $FFFF
      BranchTo()
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BHI " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBLOS_1014:         ; 101400   entries $1060-$107F   C = 1 or Z = 1
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBLOS_1014Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BLOS"
  If FlagC & $10000
    BranchTo()
  ElseIf (FlagNZ & $FFFF) = 0
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BLOS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBVC_1020:          ; 102000   entries $1080-$109F   V = 0
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBVC_1020Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BVC"
  If (FlagV & $8000) = 0
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BVC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBVS_1024:          ; 102400   entries $10A0-$10BF   V = 1
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBVS_1024Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BVS"
  If FlagV & $8000
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BVS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBCC_1030:          ; 103000   entries $10C0-$10DF   C = 0 (also BHIS)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBCC_1030Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BCC"
  If (FlagC & $10000) = 0
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BCC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBCS_1034:          ; 103400   entries $10E0-$10FF   C = 1 (also BLO)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBCS_1034Ref:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  ;name = "BCS"
  If FlagC & $10000
    BranchTo()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("BCS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ======================================================================
;  JUMPS AND SUBROUTINES
; ======================================================================

;-JMP-------------------------------------------------------------------
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionJMP_0001:          ; 0001DD   entries $0008-$000F
  PcOut()
  ;name = "JMP"
  If (Op & $38) = 0
    TrapVector = #VEC_BUS                ; JMP to a register is illegal
  Else
    Reg(7) = EaWord(Op & $3F)
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("JMP " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-JSR-------------------------------------------------------------------
InstructionJSR_004:           ; 004RDD   entries $0100-$013F
; ---- UNMAPPED ONLY: native calls (tools/asm_call_gen.py) ----
CompilerIf #ASM_FAST = 1
  NextSynced()
CompilerEndIf
InstructionJSR_004Ref:
; ---- END UNMAPPED ONLY ----
  PcOut()
  ;name = "JSR"
  If (Op & $38) = 0
    TrapVector = #VEC_BUS                ; JSR to a register is illegal
  Else
    EaFast()
    Push(Reg((Op >> 6) & 7))
    Reg((Op >> 6) & 7) = Reg(7)
    Reg(7) = Ea
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("JSR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-RTS-------------------------------------------------------------------
InstructionRTS_00020:         ; 00020R   entry $0010
; ---- UNMAPPED ONLY: native calls (tools/asm_call_gen.py) ----
CompilerIf #ASM_FAST = 1
  NextSynced()
CompilerEndIf
InstructionRTS_00020Ref:
; ---- END UNMAPPED ONLY ----
  PcOut()
  ;name = "RTS"
  Reg(7) = Reg(Op & 7)
  Reg(Op & 7) = Pop()
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("RTS " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-MARK------------------------------------------------------------------
InstructionMARK_0064:         ; 0064NN   entries $01A0-$01A7
  PcOut()
  ;name = "MARK"
  Reg(6) = (Reg(7) + ((Op & $3F) << 1)) & $FFFF
  Reg(7) = Reg(5)
  Reg(5) = Pop()
  ; ClockCycles = ClockCycles + #J11_T_JUMP
  ;disassembly("MARK " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-SOB-------------------------------------------------------------------
InstructionSOB_077:           ; 077RNN   entries $0FC0-$0FFF
  ;name = "SOB"                          ; R0-R6 only: SOB R7 is below
  Res = (Reg((Op >> 6) & 7) - 1) & $FFFF
  Reg((Op >> 6) & 7) = Res
  If Res
    PC = (PC - ((Op & $3F) << 1)) & $FFFF
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_BRANCH
  ;disassembly("SOB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionSOB_077_PC:        ; 0777NN   SOB R7 - legal, if strange: it counts the PC down
  PcOut()
  Reg(7) = (Reg(7) - 1) & $FFFF
  If Reg(7)
    Reg(7) = (Reg(7) - ((Op & $3F) << 1)) & $FFFF
  EndIf
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

; ======================================================================
;  EIS - MUL, DIV, ASH, ASHC, XOR. Register in bits 8-6, operand in 5-0.
; ======================================================================

;-MUL-------------------------------------------------------------------
InstructionMUL_070:           ; 070RSS   entries $0E00-$0E3F
  PcOut()
  ;name = "MUL"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  Src = Src - ((Src & $8000) << 1)                        ; signed 16
  Dst = Reg((Op >> 6) & 7)
  Dst = Dst - ((Dst & $8000) << 1)
  Res = Src * Dst                                          ; fits in 32 bits
  If Op & $40                                              ; odd register: low word only
    Reg((Op >> 6) & 7) = Res & $FFFF
  Else
    Reg((Op >> 6) & 7) = (Res >> 16) & $FFFF
    Reg(((Op >> 6) & 7) | 1) = Res & $FFFF
  EndIf
  SetNZ(Bool(Res < 0), Bool(Res = 0))
  FlagV = 0
  FlagC = 0
  If Res < -32768 Or Res > 32767
    FlagC = $10000
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("MUL " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-DIV-------------------------------------------------------------------
InstructionDIV_071:           ; 071RSS   entries $0E40-$0E7F
  PcOut()
  ;name = "DIV"
  If (Op & $38) = 0
    Src = Reg(Op & 7)
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  Src = Src - ((Src & $8000) << 1)
  Dst = (Reg((Op >> 6) & 7) << 16) | Reg(((Op >> 6) & 7) | 1)   ; the 32-bit dividend
  If Src = 0
    FlagV = $8000
    FlagC = $10000
  ElseIf Src = -1 And Dst = $80000000
    FlagV = $8000
    FlagC = 0
  Else
    Res = Dst / Src
    If Res < -32768 Or Res > 32767
      FlagV = $8000                                            ; registers unchanged
      FlagC = 0
    Else
      Reg((Op >> 6) & 7) = Res & $FFFF
      Reg(((Op >> 6) & 7) | 1) = (Dst - Res * Src) & $FFFF
      SetNZ(Bool(Res < 0), Bool(Res = 0))
      FlagV = 0
      FlagC = 0
    EndIf
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("DIV " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ASH-------------------------------------------------------------------
; Shift count is the low six bits of the source, signed: positive shifts
; left, negative shifts right. A loop - rare instruction, correct first.
InstructionASH_072:           ; 072RSS   entries $0E80-$0EBF
  PcOut()
  ;name = "ASH"
  If (Op & $38) = 0
    Src = Reg(Op & 7) & $3F
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Src = Src & $3F
  EndIf
  Res = Reg((Op >> 6) & 7)
  FlagV = 0
  If Src & $20
    Src = 64 - Src                                         ; right by this many
    While Src > 0
      FlagC = Res << 16
      Res = (Res >> 1) | (Res & $8000)
      Src = Src - 1
    Wend
  Else
    While Src > 0
      FlagC = Res << 1
      Tmp = (Res << 1) & $FFFF
      If (Tmp ! Res) & $8000
        FlagV = $8000                                          ; the sign changed
      EndIf
      Res = Tmp
      Src = Src - 1
    Wend
  EndIf
  Reg((Op >> 6) & 7) = Res
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("ASH " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-ASHC------------------------------------------------------------------
InstructionASHC_073:          ; 073RSS   entries $0EC0-$0EFF
  PcOut()
  ;name = "ASHC"
  If (Op & $38) = 0
    Src = Reg(Op & 7) & $3F
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Src = Src & $3F
  EndIf
  Res = (Reg((Op >> 6) & 7) << 16) | Reg(((Op >> 6) & 7) | 1)
  FlagV = 0
  If Src & $20
    Src = 64 - Src
    While Src > 0
      FlagC = Res << 16
      Res = Res >> 1                                       ; arithmetic on a 32-bit .i
      Src = Src - 1
    Wend
  Else
    While Src > 0
      FlagC = Res >> 15
      Tmp = Res << 1
      If (Tmp ! Res) & $80000000
        FlagV = $8000
      EndIf
      Res = Tmp
      Src = Src - 1
    Wend
  EndIf
  Reg((Op >> 6) & 7) = (Res >> 16) & $FFFF
  Reg(((Op >> 6) & 7) | 1) = Res & $FFFF
  SetNZ(Bool(Res < 0), Bool(Res = 0))
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("ASHC " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

;-XOR-------------------------------------------------------------------
InstructionXOR_074:           ; 074RDD   entries $0F00-$0F3F
  PcOut()
  ;name = "XOR"
  If (Op & $38) = 0
    Res = Reg(Op & 7) ! Reg((Op >> 6) & 7)
    Reg(Op & 7) = Res
  Else
    EaFast()
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    Res = Res ! Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
    MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EndIf
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_EIS
  ;disassembly("XOR " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

; ======================================================================
;  TRAPS AND MACHINE CONTROL
; ======================================================================
InstructionEMT_104:           ; 104000-104377   entries $1100-$111F
  PcOut()
  ;name = "EMT"
  TrapVector = #VEC_EMT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("EMT " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionTRAP_1044:         ; 104400-104777   entries $1120-$113F
  PcOut()
  ;name = "TRAP"
  TrapVector = #VEC_TRAP
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("TRAP " + ;name)
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionHALT_000000:       ; entry $0000, sub-decoded
  PcOut()
  ;name = "HALT"
  If (PswHigh & $C000) <> 0 Or MaintTrap <> 0   ; HALT outside kernel mode (or with the maintenance
    CpuErr = CpuErr | #CPUE_HALT                ; register's trap option) does not halt: it traps
    TrapVector = #VEC_BUS                       ; through 4, CPU error register bit 7 (cpu.pico,
    Goto SlowTail                               ; THE CPU ERROR AND MAINTENANCE REGISTERS)
  EndIf
  Halted = 1
  Reg(7) = (Reg(7) - 2) & $FFFF          ; PC stays on the HALT, as on the console
  PC = Reg(7)
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("HALT")
  Goto SlowTail                         ; Halted is only looked at there

InstructionWAIT_000001:       ; entry $0000, sub-decoded
  ;name = "WAIT"
  Waiting = 1                            ; RunEnd holds the processor until an interrupt
  CpuEventIn(1)
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("WAIT")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionRTI_000002:        ; entry $0000, sub-decoded
  PcOut()
  ;name = "RTI"
  Reg(7) = Pop()
  Src = Pop()
  If PswHigh & $C000                     ; outside kernel: bits 15-11 can only be set,
    Src = (Src & $F81F) | (PswHigh & $F8E0)   ; and the priority stays
  EndIf
  PswSet(Src)
  If PswHigh & $10                       ; RTI loading T: trace straight after it
    TraceArm = 1
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("RTI")
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionBPT_000003:        ; entry $0000, sub-decoded
  PcOut()
  ;name = "BPT"
  TrapVector = #VEC_BPT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("BPT")
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionIOT_000004:        ; entry $0000, sub-decoded
  PcOut()
  ;name = "IOT"
  TrapVector = #VEC_IOT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("IOT")
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionRESET_000005:      ; entry $0000, sub-decoded
  ;name = "RESET"
  DevReset()                             ; the bus INIT
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("RESET")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionRTT_000006:        ; entry $0000, sub-decoded (the T bit: StartWindow in cpu)
  PcOut()
  ;name = "RTT"
  Reg(7) = Pop()
  Src = Pop()
  If PswHigh & $C000                     ; outside kernel: bits 15-11 can only be set,
    Src = (Src & $F81F) | (PswHigh & $F8E0)   ; and the priority stays
  EndIf
  PswSet(Src)
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("RTT")
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

InstructionMFPT_000007:       ; entry $0000, sub-decoded
  ;name = "MFPT"
  Reg(0) = 5                             ; processor type 5 = J-11
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("MFPT")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionSPL_00023:         ; 00023N   entry $0013
  ;name = "SPL"
  If (PswHigh & $C000) = 0                ; kernel only; a no-op in other modes
    PswHigh = (PswHigh & $FF1F) | ((Op & 7) << 5)
    IntCheck()                           ; a lower priority may let a request in
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("SPL")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; 000240-000277: bit 4 = set (1) or clear (0), bits 3-0 = N Z V C.
; 000240 is NOP, 000257 CCC, 000277 SCC.
InstructionCC_00024:          ; 00024x-00027x   entries $0014-$0017
  ;name = "CLx/SEx"
  ; Each named flag is set or cleared where it lives (see SPEED in cpu),
  ; with no PswGet/PswSet round trip: these are frequent (CLC, SEC, NOP,
  ; CCC...). The priority is untouched, so the only part of PswSet that
  ; could matter - IntCheck - is still called whenever a request waits.
  If Op & 1
    If Op & $10
      FlagC = $10000
    Else
      FlagC = 0
    EndIf
  EndIf
  If Op & 2
    If Op & $10
      FlagV = $8000
    Else
      FlagV = 0
    EndIf
  EndIf
  If Op & $C                             ; N or Z named: rebuild the lazy pair
    Tmp = 0
    If FlagNZ & $18000
      Tmp = 8
    EndIf
    If (FlagNZ & $FFFF) = 0
      Tmp = Tmp | 4
    EndIf
    If Op & $10
      Tmp = Tmp | (Op & $C)
    Else
      Tmp = Tmp & ~(Op & $C)
    EndIf
    SetNZ((Tmp >> 3) & 1, (Tmp >> 2) & 1)
  EndIf
  If IntReq
    IntCheck()
  EndIf
  ; ClockCycles = ClockCycles + #J11_T_MISC
  ;disassembly("CC")
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

CompilerIf #FP11 = 1
InstructionFP:                ; 17xxxx: the FPJ11 (pico2/fp11.pico2, FpExec; #FP11 is 0 on the Pico)
  PcOut()
  FpExec()
  NextSynced()
CompilerEndIf

InstructionReserved:          ; every opcode this model does not execute
  PcOut()
  ;name = "reserved"
  TrapVector = #VEC_RESV
  ; ClockCycles = ClockCycles + #J11_T_TRAP
  ;disassembly(".WORD")
  ; ---- next instruction (THE TAIL, top of file) ----
  NextSynced()

; ======================================================================
;  000000-000007 - the one entry that still holds several instructions.
;  HALT, WAIT, RTI, BPT, IOT, RESET, RTT and MFPT differ only in the low
;  three bits, below the table's index. They are rare, so a short If chain
;  tells them apart - no second table.
; ======================================================================
InstructionGroup0_0000:       ; 000000-000007   entry $0000
  Tmp = Op & 7
  If Tmp = 0
    Goto InstructionHALT_000000
  ElseIf Tmp = 1
    Goto InstructionWAIT_000001
  ElseIf Tmp = 2
    Goto InstructionRTI_000002
  ElseIf Tmp = 3
    Goto InstructionBPT_000003
  ElseIf Tmp = 4
    Goto InstructionIOT_000004
  ElseIf Tmp = 5
    Goto InstructionRESET_000005
  ElseIf Tmp = 6
    Goto InstructionRTT_000006
  Else
    Goto InstructionMFPT_000007
  EndIf


; ======================================================================
;  REGISTER FAST PATHS. The commonest forms - both operands in registers,
;  or a single operand in a register - get handlers with no mode test, no
;  operand-helper call and no Reg(7) traffic. The Pico's table is indexed
;  by Op >> 3, so an entry knows both addressing modes and the source
;  register but NOT the destination register: each fast path first sends
;  a destination of R7 back to the general handler, which keeps the PC
;  right. The table sends a source of R7 there too. (The Pico 2 has one
;  entry per opcode and needs no such test.) Anything not listed here
;  (ADC, SBC, the byte rotates...) is correct through its general handler.
; ======================================================================

InstructionMOV_01_RR:               ; 01SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionMOV_01_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOV_01       ; the general handler
  EndIf
  ;name = "MOV Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOV " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionCMP_02_RR:               ; 02SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionCMP_02_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMP_02       ; the general handler
  EndIf
  ;name = "CMP Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Res = Src - Reg(Op & 7)
  FlagC = Res                            ; the borrow is bit 16
  FlagNZ = Res & $FFFF
  FlagV = (Src ! (Src - Res)) & (Src ! Res)   ; bit 15; Src - Res is Rd
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMP " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBIT_03_RR:               ; 03SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBIT_03_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIT_03       ; the general handler
  EndIf
  ;name = "BIT Rs,Rd"
  FlagNZ = Reg((Op >> 6) & 7) & Reg(Op & 7)
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIT " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBIC_04_RR:               ; 04SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBIC_04_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIC_04       ; the general handler
  EndIf
  ;name = "BIC Rs,Rd"
  Res = Reg(Op & 7) & ~Reg((Op >> 6) & 7) & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionBIS_05_RR:               ; 05SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionBIS_05_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIS_05       ; the general handler
  EndIf
  ;name = "BIS Rs,Rd"
  Res = Reg(Op & 7) | Reg((Op >> 6) & 7)
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BIS " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionADD_06_RR:               ; 06SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionADD_06_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionADD_06       ; the general handler
  EndIf
  ;name = "ADD Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Res = Src + Reg(Op & 7)
  FlagC = Res                            ; C is bit 16 of the sum
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! Res) & ((Res - Src) ! Res)   ; bit 15; Res - Src is the old Rd
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("ADD " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionMOVB_11_RR:              ; 11SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOVB_11      ; the general handler
  EndIf
  ;name = "MOVB Rs,Rd"
  Src = Reg((Op >> 6) & 7) & $FF
  Reg(Op & 7) = (Src | (0 - (Src & $80))) & $FFFF
  FlagNZ = Src << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("MOVB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionCMPB_12_RR:              ; 12SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMPB_12      ; the general handler
  EndIf
  ;name = "CMPB Rs,Rd"
  Src = Reg((Op >> 6) & 7) & $FF
  Dst = Reg(Op & 7) & $FF
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("CMPB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionBITB_13_RR:              ; 13SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBITB_13      ; the general handler
  EndIf
  ;name = "BITB Rs,Rd"
  FlagNZ = (Reg((Op >> 6) & 7) & Reg(Op & 7) & $FF) << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BITB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionBICB_14_RR:              ; 14SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBICB_14      ; the general handler
  EndIf
  ;name = "BICB Rs,Rd"
  Res = Reg(Op & 7) & ~Reg((Op >> 6) & 7) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BICB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionBISB_15_RR:              ; 15SD, both operands in registers
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBISB_15      ; the general handler
  EndIf
  ;name = "BISB Rs,Rd"
  Res = (Reg(Op & 7) | Reg((Op >> 6) & 7)) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagNZ = Res << 8
  FlagV = 0
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("BISB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionSUB_16_RR:               ; 16SD, both operands in registers
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionSUB_16_RRRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionSUB_16       ; the general handler
  EndIf
  ;name = "SUB Rs,Rd"
  Src = Reg((Op >> 6) & 7)
  Res = Reg(Op & 7) - Src
  FlagC = Res                            ; the borrow is bit 16
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! (Res + Src)) & ((Res + Src) ! Res)   ; bit 15; Res + Src is the old Rd
  ; ClockCycles = ClockCycles + #J11_T_DOUBLE
  ;disassembly("SUB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionCLR_0050_R:              ; 0050R, operand in a register
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionCLR_0050_RRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCLR_0050     ; the general handler
  EndIf
  ;name = "CLR Rd"
  Reg(Op & 7) = 0
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionCOM_0051_R:              ; 0051R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCOM_0051     ; the general handler
  EndIf
  ;name = "COM Rd"
  Res = Reg(Op & 7) ! $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  FlagC = $10000
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("COM " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionINC_0052_R:              ; 0052R, operand in a register
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionINC_0052_RRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionINC_0052     ; the general handler
  EndIf
  ;name = "INC Rd"
  Dst = Reg(Op & 7)
  Res = (Dst + 1) & $FFFF
  Reg(Op & 7) = Res
  FlagV = 0
  If Dst = $7FFF
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionDEC_0053_R:              ; 0053R, operand in a register
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionDEC_0053_RRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionDEC_0053     ; the general handler
  EndIf
  ;name = "DEC Rd"
  Dst = Reg(Op & 7)
  Res = (Dst - 1) & $FFFF
  Reg(Op & 7) = Res
  FlagV = 0
  If Dst = $8000
    FlagV = $8000
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DEC " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionNEG_0054_R:              ; 0054R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionNEG_0054     ; the general handler
  EndIf
  ;name = "NEG Rd"
  Res = (0 - Reg(Op & 7)) & $FFFF
  Reg(Op & 7) = Res
  FlagV = 0
  If Res = $8000
    FlagV = $8000
  EndIf
  FlagC = $10000
  If Res = 0
    FlagC = 0
  EndIf
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("NEG " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionTST_0057_R:              ; 0057R, operand in a register
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #ASM_FAST = 1
CompilerEndIf
CompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0
InstructionTST_0057_RRef:
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionTST_0057     ; the general handler
  EndIf
  ;name = "TST Rd"
  FlagNZ = Reg(Op & 7)
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TST " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
InstructionROR_0060_R:              ; 0060R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionROR_0060     ; the general handler
  EndIf
  ;name = "ROR Rd"
  Dst = Reg(Op & 7)
  Res = (Dst >> 1) | ((FlagC >> 1) & $8000)
  Reg(Op & 7) = Res
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionROL_0061_R:              ; 0061R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionROL_0061     ; the general handler
  EndIf
  ;name = "ROL Rd"
  Dst = Reg(Op & 7)
  Res = ((Dst << 1) | ((FlagC >> 16) & 1)) & $FFFF
  Reg(Op & 7) = Res
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ROL " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionASR_0062_R:              ; 0062R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionASR_0062     ; the general handler
  EndIf
  ;name = "ASR Rd"
  Dst = Reg(Op & 7)
  Res = (Dst >> 1) | (Dst & $8000)
  Reg(Op & 7) = Res
  FlagC = Dst << 16
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASR " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionASL_0063_R:              ; 0063R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionASL_0063     ; the general handler
  EndIf
  ;name = "ASL Rd"
  Dst = Reg(Op & 7)
  Res = (Dst << 1) & $FFFF
  Reg(Op & 7) = Res
  FlagC = Dst << 1
  FlagV = Res ! (FlagC >> 1)
  FlagNZ = Res
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("ASL " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionSWAB_0003_R:             ; 0003R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionSWAB_0003    ; the general handler
  EndIf
  ;name = "SWAB Rd"
  Dst = Reg(Op & 7)
  Res = ((Dst >> 8) | (Dst << 8)) & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = (Res & $FF) << 8
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("SWAB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionCLRB_1050_R:             ; 1050R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCLRB_1050    ; the general handler
  EndIf
  ;name = "CLRB Rd"
  Reg(Op & 7) = Reg(Op & 7) & $FF00
  FlagNZ = 0
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("CLRB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionINCB_1052_R:             ; 1052R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionINCB_1052    ; the general handler
  EndIf
  ;name = "INCB Rd"
  Dst = Reg(Op & 7) & $FF
  Res = (Dst + 1) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagV = 0
  If Dst = $7F
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("INCB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionDECB_1053_R:             ; 1053R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionDECB_1053    ; the general handler
  EndIf
  ;name = "DECB Rd"
  Dst = Reg(Op & 7) & $FF
  Res = (Dst - 1) & $FF
  Reg(Op & 7) = (Reg(Op & 7) & $FF00) | Res
  FlagV = 0
  If Dst = $80
    FlagV = $8000
  EndIf
  FlagNZ = Res << 8
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("DECB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()

InstructionTSTB_1057_R:             ; 1057R, operand in a register
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionTSTB_1057    ; the general handler
  EndIf
  ;name = "TSTB Rd"
  FlagNZ = (Reg(Op & 7) & $FF) << 8
  FlagV = 0
  FlagC = 0
  ; ClockCycles = ClockCycles + #J11_T_SINGLE
  ;disassembly("TSTB " + ;name)
  ; ---- next instruction - this one cannot trap (THE TAIL, top of file) ----
  NextNative()


; ======================================================================
;  IMMEDIATE FAST PATHS: OP #n,Rd - the source is the word after the
;  instruction (mode 2 on R7) and the destination a register other than
;  R7. The immediate is read straight at the PC, which stays in its
;  register: no PcOut, no EaWord, no call. A destination of R7 goes back to
;  the general handler, as in the register fast paths.
; ======================================================================

InstructionMOV_01_IR:            ; 0127DD  MOV #n,Rd, the source an immediate
  ;name = "MOV #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOV_01                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionCMP_02_IR:            ; 0227DD  CMP #n,Rd, the source an immediate
  ;name = "CMP #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMP_02                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  Res = Src - Reg(Op & 7)
  FlagC = Res                            ; the borrow is bit 16
  FlagNZ = Res & $FFFF
  FlagV = (Src ! (Src - Res)) & (Src ! Res)   ; bit 15; Src - Res is Rd
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionBIT_03_IR:            ; 0327DD  BIT #n,Rd, the source an immediate
  ;name = "BIT #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIT_03                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  FlagNZ = Src & Reg(Op & 7)
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionBIC_04_IR:            ; 0427DD  BIC #n,Rd, the source an immediate
  ;name = "BIC #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIC_04                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  Res = Reg(Op & 7) & ~Src & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionBIS_05_IR:            ; 0527DD  BIS #n,Rd, the source an immediate
  ;name = "BIS #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBIS_05                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  Res = Reg(Op & 7) | Src
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionADD_06_IR:            ; 0627DD  ADD #n,Rd, the source an immediate
  ;name = "ADD #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionADD_06                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  Res = Src + Reg(Op & 7)
  FlagC = Res                            ; C is bit 16 of the sum
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! Res) & ((Res - Src) ! Res)   ; bit 15; Res - Src is the old Rd
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionSUB_16_IR:            ; 1627DD  SUB #n,Rd, the source an immediate
  ;name = "SUB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionSUB_16                  ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, PC)                     ; the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF
  Res = Reg(Op & 7) - Src
  FlagC = Res                            ; the borrow is bit 16
  Res = Res & $FFFF
  Reg(Op & 7) = Res
  FlagNZ = Res
  FlagV = (Src ! (Res + Src)) & ((Res + Src) ! Res)   ; bit 15; Res + Src is the old Rd
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionMOVB_11_IR:           ; 1127DD  MOVB #n,Rd, the source an immediate
  ;name = "MOVB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionMOVB_11                 ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Src, PC)                     ; the low byte of the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF                  ; (R7 always steps by two)
  Reg(Op & 7) = (Src | (0 - (Src & $80))) & $FFFF   ; to a register it is sign-extended
  FlagNZ = Src << 8
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionCMPB_12_IR:           ; 1227DD  CMPB #n,Rd, the source an immediate
  ;name = "CMPB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionCMPB_12                 ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Src, PC)                     ; the low byte of the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF                  ; (R7 always steps by two)
  Dst = Reg(Op & 7) & $FF
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

InstructionBITB_13_IR:           ; 1327DD  BITB #n,Rd, the source an immediate
  ;name = "BITB #n,Rd"
  If (Op & 7) = 7                        ; the destination is the PC:
    Goto InstructionBITB_13                 ; the general handler
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Src, PC)                     ; the low byte of the word after the instruction
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  PC = (PC + 2) & $FFFF                  ; (R7 always steps by two)
  FlagNZ = (Src & Reg(Op & 7) & $FF) << 8
  FlagV = 0
  ; ---- next instruction - the read can trap (THE TAIL, top of file) ----
  NextNativeTrap()

; ======================================================================
;  REGISTER SOURCE, MEMORY DESTINATION - OP Rs,(Rd)  OP Rs,(Rd)+  OP Rs,X(Rd)
;  and every other form whose source is a register and whose destination
;  is not. On the J-11 the source register is read AFTER the destination's
;  address has been worked out, so:
;    OP R,(R)+  OP R,-(R)  OP R,@(R)+  OP R,@-(R)   the source is R already
;                                                   stepped by the destination
;    OP PC,X(R)  OP PC,@X(R)  OP PC,A  OP PC,@A     the source is the address
;                                                   of the instruction + 4
;  (KDJ11-A CPU Module User's Guide EK-KDJ1A-UG-002, appendix B, table B-1,
;  items 1, 2 and 3, page B-2: the KDJ11-A is in the 11/23's row, not the
;  11/44's or the 11/70's. The DCF11-AA CPU diagnostic CJKDBD0 tests the
;  same row in its tests 264 to 267 and 271 to 274.) The general handlers
;  above read the source first, which is the same thing for every other
;  pair of modes, so the table sends these forms here and the general
;  handlers never see them. Everything else is the general handler's, line
;  for line; with neither mode to test, these are also the shorter path.
; ======================================================================
InstructionMOV_01_RM:            ; 010SDD  MOV Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionCMP_02_RM:            ; 020SDD  CMP Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Src - Dst
  FlagC = Res
  FlagV = (Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
  NextSynced()

InstructionBIT_03_RM:            ; 030SDD  BIT Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src & Dst
  FlagV = 0
  NextSynced()

InstructionBIC_04_RM:            ; 040SDD  BIC Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Res & ~Src & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Res
  FlagV = 0
  NextSynced()

InstructionBIS_05_RM:            ; 050SDD  BIS Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Res | Src
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Res
  FlagV = 0
  NextSynced()

InstructionADD_06_RM:            ; 060SDD  ADD Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Src + Dst
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagC = Res
  FlagV = ~(Src ! Dst) & (Src ! Res)
  FlagNZ = Res & $FFFF
  NextSynced()

InstructionSUB_16_RM:            ; 160SDD  SUB Rs,memory
  PcOut()
  EaFast()
  Src = Reg((Op >> 6) & 7)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Dst - Src
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagC = Res                ; borrow
  FlagV = (Src ! Dst) & (Dst ! Res)
  FlagNZ = Res & $FFFF
  NextSynced()

InstructionMOVB_11_RM:           ; 110SDD  MOVB Rs,memory
  PcOut()
  EaFastB()
  Src = Reg((Op >> 6) & 7) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteByte(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src << 8
  FlagV = 0
  NextSynced()

InstructionCMPB_12_RM:           ; 120SDD  CMPB Rs,memory
  PcOut()
  EaFastB()
  Src = Reg((Op >> 6) & 7) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Src - Dst
  FlagC = Res << 8
  FlagV = ((Src ! Dst) & (Src ! Res)) << 8
  FlagNZ = (Res & $FF) << 8
  NextSynced()

InstructionBITB_13_RM:           ; 130SDD  BITB Rs,memory
  PcOut()
  EaFastB()
  Src = Reg((Op >> 6) & 7) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Dst, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = (Src & Dst) << 8
  FlagV = 0
  NextSynced()

InstructionBICB_14_RM:           ; 140SDD  BICB Rs,memory
  PcOut()
  EaFastB()
  Src = Reg((Op >> 6) & 7) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Res & ~Src & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Res << 8
  FlagV = 0
  NextSynced()

InstructionBISB_15_RM:           ; 150SDD  BISB Rs,memory
  PcOut()
  EaFastB()
  Src = Reg((Op >> 6) & 7) & $FF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadByte(Res, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Res = Res | Src
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteByte(Ea, Res)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Res << 8
  FlagV = 0
  NextSynced()

; ======================================================================
;  THE SLOW WAY OUT OF AN INSTRUCTION - a trap to take, or a HALT. The
;  handlers' own tails send any instruction that left TrapVector set here,
;  and HALT comes here always, because this is the only place that looks
;  at Halted (nothing else sets it).
; ======================================================================
SlowTail:
  If PswLate                             ; the PSW written through 177776 wins (PswWrite)
    PswSet(PswLate & $FFFF)
    PswLate = 0
    If TrapVector = #TRAP_PSW_LATE
      TrapVector = 0
    EndIf
  EndIf
  If AbortPsw                            ; a bus error aborted the instruction (BusError)
    PswSet(AbortPsw & $FFFF)
    AbortPsw = 0
  EndIf
  If TrapVector = #TRAP_STACK            ; only a marker: StackYellow says what
    TrapVector = 0
  EndIf
  Reg(7) = PC
  If TrapVector
    Tmp = TrapVector
    TrapVector = 0
    TraceArm = 0                         ; a trapping instruction is not traced
    TakeTrap(Tmp)
    If TrapVector = #TRAP_STACK
      TrapVector = 0
    EndIf
  EndIf
  TakeStackTrap()
  PC = Reg(7)
  RunLeft = RunLeft - 1
  If RunLeft > 0 And Halted = 0
    Goto Fetch
  EndIf
; ======================================================================
;  RUNEND - every window ends here (THE RUN WINDOW in cpu.pico): the clock
;  is brought up to date, the devices act, and the next window opens -
;  until CpuRun has run its n, the processor halts, or it WAITs with
;  nothing inside the emulator left to wake it (a typed character comes
;  from the firmware, between runs).
; ======================================================================
RunEnd:
  Reg(7) = PC                            ; the devices' traps work on Reg(7)
  InstrCount = InstrCount + RunWindow - RunLeft
  RunBank = RunBank + RunLeft
  RunLeft = 0
  RunWindow = 0
  ; ---- MMU HANDOVER (the mapped side is written by tools/mmu_gen.py) ----
  If MmuOn                               ; the memory management unit is on: the
    RunSave = RunFrom                    ; mapped run loop (instructions_mmu) runs
    CpuRunM(RunBank)                     ; the rest, and comes back with what it did
    RunFrom = RunSave                    ; not run when the unit goes off again
    PC = Reg(7)
  EndIf
  ; ---- END MMU HANDOVER ----
  If Halted = 0
    If TraceArm                          ; the T bit (StartWindow in cpu): trace trap
      TraceArm = 0
      TakeTrap(#VEC_BPT)
      TakeStackTrap()
    EndIf
    DevService()
    While Waiting <> 0 And RunBank > 0 And Dl11TxRdy = 0
      Tmp = Dl11TxDue - InstrCount           ; WAIT: let time pass to the
      If Tmp < 1                             ; transmitter's next moment
        Tmp = 1
      EndIf
      If Tmp > RunBank
        Tmp = RunBank
      EndIf
      InstrCount = InstrCount + Tmp
      RunBank = RunBank - Tmp
      DevService()
    Wend
    If Waiting = 0 And RunBank > 0
      StartWindow()
      PC = Reg(7)
      Goto Fetch
    EndIf
  EndIf
  RunBank = 0
  ProcedureReturn InstrCount - RunFrom

; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; The table is indexed by Op >> 3, which holds the source mode, the source
; register and the destination mode. Each MOV form Unix uses most has a
; handler of its own here, with the lines EaWord would run for those two
; modes written in place: no call and no test of the mode. Everything else
; is InstructionMOV_01's, line for line. The mapped loop gets its own from
; the generator (the Pico 2 only), which is why this block is left out there.
InstructionMOV_01_M04:            ; MOV, source mode 0, destination mode 4
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M04Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = Op & 7
  Ea = (Reg(EaReg) - 2) & $FFFF
  Reg(EaReg) = Ea
  If EaReg = 6
    StackCheckFast()
  EndIf
  Src = Reg((Op >> 6) & 7)               ; read after the destination's address: REGISTER SOURCE, MEMORY DESTINATION
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionMOV_01_M40:            ; MOV, source mode 4, destination mode 0
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M40Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = (Op >> 6) & 7
  Ea = (Reg(EaReg) - 2) & $FFFF
  Reg(EaReg) = Ea
  If EaReg = 6
    StackCheckFast()
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionMOV_01_M60:            ; MOV, source mode 6, destination mode 0
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M60Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = (Op >> 6) & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Tmp, Adr)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Ea = (Tmp + Reg(EaReg)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionMOV_01_M64:            ; MOV, source mode 6, destination mode 4
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M64Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = (Op >> 6) & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Tmp, Adr)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Ea = (Tmp + Reg(EaReg)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EaReg = Op & 7
  Ea = (Reg(EaReg) - 2) & $FFFF
  Reg(EaReg) = Ea
  If EaReg = 6
    StackCheckFast()
  EndIf
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionMOV_01_M20:            ; MOV, source mode 2, destination mode 0
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M20Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = (Op >> 6) & 7
  Ea = Reg(EaReg)
  Reg(EaReg) = (Ea + 2) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Reg(Op & 7) = Src
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionMOV_01_M61:            ; MOV, source mode 6, destination mode 1
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M61Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = (Op >> 6) & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Tmp, Adr)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Ea = (Tmp + Reg(EaReg)) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Src, Ea)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  EaReg = Op & 7
  Ea = Reg(EaReg)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src
  FlagV = 0
  NextSynced()

InstructionMOV_01_M06:            ; MOV, source mode 0, destination mode 6
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #ASM_MOV = 1
CompilerEndIf
InstructionMOV_01_M06Ref:         ; the plain version: the fast path's slow path and its reference
; ---- END ASM ----
  PcOut()
  EaReg = Op & 7
  Adr = Reg(7)
  Reg(7) = (Adr + 2) & $FFFF
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MReadWord(Tmp, Adr)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  Ea = (Tmp + Reg(EaReg)) & $FFFF
  Src = Reg((Op >> 6) & 7)               ; read after the destination's address: REGISTER SOURCE, MEMORY DESTINATION
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerIf #ASM_MEM = 1
CompilerElse
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  MWriteWord(Ea, Src)
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- MEMORY THUMB1 ----
CompilerEndIf
; ---- END MEMORY THUMB1 ----
; ---- END UNMAPPED ONLY ----
  FlagNZ = Src
  FlagV = 0
  NextSynced()

; ---- END UNMAPPED ONLY ----

; ======================================================================
;  THE TABLE - filled the first time CpuRun runs. A '.i' is taken
;  with ?Name only inside the procedure that owns the label, so this is
;  part of CpuRun; BuildOpcodeTable() at the foot just calls CpuRun(0).
; ======================================================================
BuildTable:
  Ops(0, 8192, ?InstructionReserved)

  ; ---- 0000xx - 0003xx ----
  OpTable($0000) = ?InstructionGroup0_0000        ; 000000-000007
  Ops($0008, 8, ?InstructionJMP_0001)             ; 000100-000177
  OpTable($0010) = ?InstructionRTS_00020          ; 000200-000207
  OpTable($0013) = ?InstructionSPL_00023          ; 000230-000237
  Ops($0014, 4, ?InstructionCC_00024)             ; 000240-000277
  Ops($0018, 8, ?InstructionSWAB_0003)            ; 000300-000377

  ; ---- branches, JSR, single operand ----
  Ops($0020, 32, ?InstructionBR_0004)
  Ops($0040, 32, ?InstructionBNE_0010)
  Ops($0060, 32, ?InstructionBEQ_0014)
  Ops($0080, 32, ?InstructionBGE_0020)
  Ops($00A0, 32, ?InstructionBLT_0024)
  Ops($00C0, 32, ?InstructionBGT_0030)
  Ops($00E0, 32, ?InstructionBLE_0034)
  Ops($0100, 64, ?InstructionJSR_004)
  Ops($0140, 8, ?InstructionCLR_0050)
  Ops($0148, 8, ?InstructionCOM_0051)
  Ops($0150, 8, ?InstructionINC_0052)
  Ops($0158, 8, ?InstructionDEC_0053)
  Ops($0160, 8, ?InstructionNEG_0054)
  Ops($0168, 8, ?InstructionADC_0055)
  Ops($0170, 8, ?InstructionSBC_0056)
  Ops($0178, 8, ?InstructionTST_0057)
  Ops($0180, 8, ?InstructionROR_0060)
  Ops($0188, 8, ?InstructionROL_0061)
  Ops($0190, 8, ?InstructionASR_0062)
  Ops($0198, 8, ?InstructionASL_0063)
  Ops($01A0, 8, ?InstructionMARK_0064)
  Ops($01A8, 8, ?InstructionMFPI_0065)
  Ops($01B0, 8, ?InstructionMTPI_0066)
  Ops($01B8, 8, ?InstructionSXT_0067)

  ; ---- double operand, word ----
  Ops($0200, 512, ?InstructionMOV_01)
  Ops($0400, 512, ?InstructionCMP_02)
  Ops($0600, 512, ?InstructionBIT_03)
  Ops($0800, 512, ?InstructionBIC_04)
  Ops($0A00, 512, ?InstructionBIS_05)
  Ops($0C00, 512, ?InstructionADD_06)

  ; ---- EIS ----
  Ops($0E00, 64, ?InstructionMUL_070)
  Ops($0E40, 64, ?InstructionDIV_071)
  Ops($0E80, 64, ?InstructionASH_072)
  Ops($0EC0, 64, ?InstructionASHC_073)
  Ops($0F00, 64, ?InstructionXOR_074)
  Ops($0FC0, 64, ?InstructionSOB_077)
  Ops($0FF8, 8, ?InstructionSOB_077_PC)              ; SOB R7

  ; ---- 10xxxx ----
  Ops($1000, 32, ?InstructionBPL_1000)
  Ops($1020, 32, ?InstructionBMI_1004)
  Ops($1040, 32, ?InstructionBHI_1010)
  Ops($1060, 32, ?InstructionBLOS_1014)
  Ops($1080, 32, ?InstructionBVC_1020)
  Ops($10A0, 32, ?InstructionBVS_1024)
  Ops($10C0, 32, ?InstructionBCC_1030)
  Ops($10E0, 32, ?InstructionBCS_1034)
  Ops($1100, 32, ?InstructionEMT_104)
  Ops($1120, 32, ?InstructionTRAP_1044)
  Ops($1140, 8, ?InstructionCLRB_1050)
  Ops($1148, 8, ?InstructionCOMB_1051)
  Ops($1150, 8, ?InstructionINCB_1052)
  Ops($1158, 8, ?InstructionDECB_1053)
  Ops($1160, 8, ?InstructionNEGB_1054)
  Ops($1168, 8, ?InstructionADCB_1055)
  Ops($1170, 8, ?InstructionSBCB_1056)
  Ops($1178, 8, ?InstructionTSTB_1057)
  Ops($1180, 8, ?InstructionRORB_1060)
  Ops($1188, 8, ?InstructionROLB_1061)
  Ops($1190, 8, ?InstructionASRB_1062)
  Ops($1198, 8, ?InstructionASLB_1063)
  Ops($11A0, 8, ?InstructionMTPS_1064)
  Ops($11A8, 8, ?InstructionMFPD_1065)
  Ops($11B0, 8, ?InstructionMTPD_1066)
  Ops($11B8, 8, ?InstructionMFPS_1067)

  ; ---- double operand, byte, and SUB ----
  Ops($1200, 512, ?InstructionMOVB_11)
  Ops($1400, 512, ?InstructionCMPB_12)
  Ops($1600, 512, ?InstructionBITB_13)
  Ops($1800, 512, ?InstructionBICB_14)
  Ops($1A00, 512, ?InstructionBISB_15)
  Ops($1C00, 512, ?InstructionSUB_16)

  CompilerIf #FP11 = 1
  Ops($1E00, 512, ?InstructionFP)        ; 17xxxx: the FPJ11 (pico2/fp11.pico2; #FP11 is 0 on the Pico)
  CompilerEndIf
  ; ---- register fast paths: overlay the general entries (Op >> 3 keeps
  ; the source register in bits 5-3 and both modes; R7 as the source stays
  ; general, R7 as the destination is sent back by the handler) ----
  For FillFrom = 0 To 6
    OpTable($0200 | (FillFrom << 3)) = ?InstructionMOV_01_RR
    OpTable($0400 | (FillFrom << 3)) = ?InstructionCMP_02_RR
    OpTable($0600 | (FillFrom << 3)) = ?InstructionBIT_03_RR
    OpTable($0800 | (FillFrom << 3)) = ?InstructionBIC_04_RR
    OpTable($0A00 | (FillFrom << 3)) = ?InstructionBIS_05_RR
    OpTable($0C00 | (FillFrom << 3)) = ?InstructionADD_06_RR
    OpTable($1200 | (FillFrom << 3)) = ?InstructionMOVB_11_RR
    OpTable($1400 | (FillFrom << 3)) = ?InstructionCMPB_12_RR
    OpTable($1600 | (FillFrom << 3)) = ?InstructionBITB_13_RR
    OpTable($1800 | (FillFrom << 3)) = ?InstructionBICB_14_RR
    OpTable($1A00 | (FillFrom << 3)) = ?InstructionBISB_15_RR
    OpTable($1C00 | (FillFrom << 3)) = ?InstructionSUB_16_RR
  Next
  OpTable($0140) = ?InstructionCLR_0050_R
  OpTable($0148) = ?InstructionCOM_0051_R
  OpTable($0150) = ?InstructionINC_0052_R
  OpTable($0158) = ?InstructionDEC_0053_R
  OpTable($0160) = ?InstructionNEG_0054_R
  OpTable($0178) = ?InstructionTST_0057_R
  OpTable($0180) = ?InstructionROR_0060_R
  OpTable($0188) = ?InstructionROL_0061_R
  OpTable($0190) = ?InstructionASR_0062_R
  OpTable($0198) = ?InstructionASL_0063_R
  OpTable($0018) = ?InstructionSWAB_0003_R
  OpTable($1140) = ?InstructionCLRB_1050_R
  OpTable($1150) = ?InstructionINCB_1052_R
  OpTable($1158) = ?InstructionDECB_1053_R
  OpTable($1178) = ?InstructionTSTB_1057_R
  ; ---- immediate fast paths: OP #n,Rd (the handler sends Rd = R7 back) ----
  OpTable($02B8) = ?InstructionMOV_01_IR
  OpTable($04B8) = ?InstructionCMP_02_IR
  OpTable($06B8) = ?InstructionBIT_03_IR
  OpTable($08B8) = ?InstructionBIC_04_IR
  OpTable($0AB8) = ?InstructionBIS_05_IR
  OpTable($0CB8) = ?InstructionADD_06_IR
  OpTable($1CB8) = ?InstructionSUB_16_IR
  OpTable($12B8) = ?InstructionMOVB_11_IR
  OpTable($14B8) = ?InstructionCMPB_12_IR
  OpTable($16B8) = ?InstructionBITB_13_IR
  ; ---- register source, memory destination (the handlers' header says why):
  ; every source register, R7 too, and destination modes 1 to 7 ----
  For FillFrom = 0 To 7
    For FillCount = 1 To 7
      OpTable($0200 | (FillFrom << 3) | FillCount) = ?InstructionMOV_01_RM
      OpTable($0400 | (FillFrom << 3) | FillCount) = ?InstructionCMP_02_RM
      OpTable($0600 | (FillFrom << 3) | FillCount) = ?InstructionBIT_03_RM
      OpTable($0800 | (FillFrom << 3) | FillCount) = ?InstructionBIC_04_RM
      OpTable($0A00 | (FillFrom << 3) | FillCount) = ?InstructionBIS_05_RM
      OpTable($0C00 | (FillFrom << 3) | FillCount) = ?InstructionADD_06_RM
      OpTable($1200 | (FillFrom << 3) | FillCount) = ?InstructionMOVB_11_RM
      OpTable($1400 | (FillFrom << 3) | FillCount) = ?InstructionCMPB_12_RM
      OpTable($1600 | (FillFrom << 3) | FillCount) = ?InstructionBITB_13_RM
      OpTable($1800 | (FillFrom << 3) | FillCount) = ?InstructionBICB_14_RM
      OpTable($1A00 | (FillFrom << 3) | FillCount) = ?InstructionBISB_15_RM
      OpTable($1C00 | (FillFrom << 3) | FillCount) = ?InstructionSUB_16_RM
    Next
  Next
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
  OpTable($0204) = ?InstructionMOV_01_M04
  OpTable($020C) = ?InstructionMOV_01_M04
  OpTable($0214) = ?InstructionMOV_01_M04
  OpTable($021C) = ?InstructionMOV_01_M04
  OpTable($0224) = ?InstructionMOV_01_M04
  OpTable($022C) = ?InstructionMOV_01_M04
  OpTable($0234) = ?InstructionMOV_01_M04
  OpTable($023C) = ?InstructionMOV_01_M04
  OpTable($0300) = ?InstructionMOV_01_M40
  OpTable($0308) = ?InstructionMOV_01_M40
  OpTable($0310) = ?InstructionMOV_01_M40
  OpTable($0318) = ?InstructionMOV_01_M40
  OpTable($0320) = ?InstructionMOV_01_M40
  OpTable($0328) = ?InstructionMOV_01_M40
  OpTable($0330) = ?InstructionMOV_01_M40
  OpTable($0338) = ?InstructionMOV_01_M40
  OpTable($0380) = ?InstructionMOV_01_M60
  OpTable($0388) = ?InstructionMOV_01_M60
  OpTable($0390) = ?InstructionMOV_01_M60
  OpTable($0398) = ?InstructionMOV_01_M60
  OpTable($03A0) = ?InstructionMOV_01_M60
  OpTable($03A8) = ?InstructionMOV_01_M60
  OpTable($03B0) = ?InstructionMOV_01_M60
  OpTable($03B8) = ?InstructionMOV_01_M60
  OpTable($0384) = ?InstructionMOV_01_M64
  OpTable($038C) = ?InstructionMOV_01_M64
  OpTable($0394) = ?InstructionMOV_01_M64
  OpTable($039C) = ?InstructionMOV_01_M64
  OpTable($03A4) = ?InstructionMOV_01_M64
  OpTable($03AC) = ?InstructionMOV_01_M64
  OpTable($03B4) = ?InstructionMOV_01_M64
  OpTable($03BC) = ?InstructionMOV_01_M64
  OpTable($0280) = ?InstructionMOV_01_M20
  OpTable($0288) = ?InstructionMOV_01_M20
  OpTable($0290) = ?InstructionMOV_01_M20
  OpTable($0298) = ?InstructionMOV_01_M20
  OpTable($02A0) = ?InstructionMOV_01_M20
  OpTable($02A8) = ?InstructionMOV_01_M20
  OpTable($02B0) = ?InstructionMOV_01_M20
  OpTable($0381) = ?InstructionMOV_01_M61
  OpTable($0389) = ?InstructionMOV_01_M61
  OpTable($0391) = ?InstructionMOV_01_M61
  OpTable($0399) = ?InstructionMOV_01_M61
  OpTable($03A1) = ?InstructionMOV_01_M61
  OpTable($03A9) = ?InstructionMOV_01_M61
  OpTable($03B1) = ?InstructionMOV_01_M61
  OpTable($03B9) = ?InstructionMOV_01_M61
  OpTable($0206) = ?InstructionMOV_01_M06
  OpTable($020E) = ?InstructionMOV_01_M06
  OpTable($0216) = ?InstructionMOV_01_M06
  OpTable($021E) = ?InstructionMOV_01_M06
  OpTable($0226) = ?InstructionMOV_01_M06
  OpTable($022E) = ?InstructionMOV_01_M06
  OpTable($0236) = ?InstructionMOV_01_M06
  OpTable($023E) = ?InstructionMOV_01_M06
; ---- ASM (tools/asm_mov_gen.py) ----
CompilerIf #DISK_BACKEND = 0
  MovAsm(0) = ?InstructionMOV_01_M04
  MovRef(0) = ?InstructionMOV_01_M04Ref
  MovAsm(1) = ?InstructionMOV_01_M40
  MovRef(1) = ?InstructionMOV_01_M40Ref
  MovAsm(2) = ?InstructionMOV_01_M60
  MovRef(2) = ?InstructionMOV_01_M60Ref
  MovAsm(3) = ?InstructionMOV_01_M64
  MovRef(3) = ?InstructionMOV_01_M64Ref
  MovAsm(4) = ?InstructionMOV_01_M20
  MovRef(4) = ?InstructionMOV_01_M20Ref
  MovAsm(5) = ?InstructionMOV_01_M61
  MovRef(5) = ?InstructionMOV_01_M61Ref
  MovAsm(6) = ?InstructionMOV_01_M06
  MovRef(6) = ?InstructionMOV_01_M06Ref
CompilerEndIf
; ---- END ASM ----
; ---- MOV ENTRY POINTS ----
; ---- END UNMAPPED ONLY ----
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- INDEXED SINGLE NATIVE ----
CompilerIf #ASM_INDEXED = 1
  OpTable($146) = ?InstructionIX_CLR_0050
  OpTable($17E) = ?InstructionIX_TST_0057
  OpTable($156) = ?InstructionIX_INC_0052
  OpTable($15E) = ?InstructionIX_DEC_0053
  OpTable($1146) = ?InstructionIX_CLRB_1050
  OpTable($117E) = ?InstructionIX_TSTB_1057
CompilerEndIf
CompilerIf #DISK_BACKEND = 0
  FastAsm(34) = ?InstructionIX_CLR_0050
  FastRef(34) = ?InstructionCLR_0050
  FastAsm(35) = ?InstructionIX_TST_0057
  FastRef(35) = ?InstructionTST_0057
  FastAsm(36) = ?InstructionIX_INC_0052
  FastRef(36) = ?InstructionINC_0052
  FastAsm(37) = ?InstructionIX_DEC_0053
  FastRef(37) = ?InstructionDEC_0053
  FastAsm(38) = ?InstructionIX_CLRB_1050
  FastRef(38) = ?InstructionCLRB_1050
  FastAsm(39) = ?InstructionIX_TSTB_1057
  FastRef(39) = ?InstructionTSTB_1057
CompilerEndIf
; ---- END INDEXED SINGLE NATIVE ----
; ---- END UNMAPPED ONLY ----
; ---- INDEXED ENTRY POINTS ----
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- IMMEDIATE INDEXED THUMB1 ----
  OpTable($12BE) = ?InstructionIMX_MOVB_11
  OpTable($2BE) = ?InstructionIMX_MOV_01
  OpTable($4BE) = ?InstructionIMX_CMP_02
  OpTable($CBE) = ?InstructionIMX_ADD_06
  OpTable($1CBE) = ?InstructionIMX_SUB_16
  OpTable($6BE) = ?InstructionIMX_BIT_03
  OpTable($8BE) = ?InstructionIMX_BIC_04
  OpTable($ABE) = ?InstructionIMX_BIS_05
CompilerIf #DISK_BACKEND = 0
  FastAsm(26) = ?InstructionIMX_MOVB_11
  FastRef(26) = ?InstructionMOVB_11
  FastAsm(27) = ?InstructionIMX_MOV_01
  FastRef(27) = ?InstructionMOV_01
  FastAsm(28) = ?InstructionIMX_CMP_02
  FastRef(28) = ?InstructionCMP_02
  FastAsm(29) = ?InstructionIMX_ADD_06
  FastRef(29) = ?InstructionADD_06
  FastAsm(30) = ?InstructionIMX_SUB_16
  FastRef(30) = ?InstructionSUB_16
  FastAsm(31) = ?InstructionIMX_BIT_03
  FastRef(31) = ?InstructionBIT_03
  FastAsm(32) = ?InstructionIMX_BIC_04
  FastRef(32) = ?InstructionBIC_04
  FastAsm(33) = ?InstructionIMX_BIS_05
  FastRef(33) = ?InstructionBIS_05
CompilerEndIf
; ---- END IMMEDIATE INDEXED THUMB1 ----
; ---- END UNMAPPED ONLY ----
; ---- IMX ENTRY POINTS ----
; ---- UNMAPPED ONLY: MOV by addressing mode (tools/mmu_gen.py leaves this block out) ----
; ---- FAST THUMB1 ----
CompilerIf #DISK_BACKEND = 0
  FastAsm(0) = ?InstructionBR_0004
  FastRef(0) = ?InstructionBR_0004Ref
  FastAsm(1) = ?InstructionBNE_0010
  FastRef(1) = ?InstructionBNE_0010Ref
  FastAsm(2) = ?InstructionBEQ_0014
  FastRef(2) = ?InstructionBEQ_0014Ref
  FastAsm(3) = ?InstructionBGE_0020
  FastRef(3) = ?InstructionBGE_0020Ref
  FastAsm(4) = ?InstructionBLT_0024
  FastRef(4) = ?InstructionBLT_0024Ref
  FastAsm(5) = ?InstructionBGT_0030
  FastRef(5) = ?InstructionBGT_0030Ref
  FastAsm(6) = ?InstructionBLE_0034
  FastRef(6) = ?InstructionBLE_0034Ref
  FastAsm(7) = ?InstructionBPL_1000
  FastRef(7) = ?InstructionBPL_1000Ref
  FastAsm(8) = ?InstructionBMI_1004
  FastRef(8) = ?InstructionBMI_1004Ref
  FastAsm(9) = ?InstructionBHI_1010
  FastRef(9) = ?InstructionBHI_1010Ref
  FastAsm(10) = ?InstructionBLOS_1014
  FastRef(10) = ?InstructionBLOS_1014Ref
  FastAsm(11) = ?InstructionBVC_1020
  FastRef(11) = ?InstructionBVC_1020Ref
  FastAsm(12) = ?InstructionBVS_1024
  FastRef(12) = ?InstructionBVS_1024Ref
  FastAsm(13) = ?InstructionBCC_1030
  FastRef(13) = ?InstructionBCC_1030Ref
  FastAsm(14) = ?InstructionBCS_1034
  FastRef(14) = ?InstructionBCS_1034Ref
  FastAsm(15) = ?InstructionMOV_01_RR
  FastRef(15) = ?InstructionMOV_01_RRRef
  FastAsm(16) = ?InstructionCMP_02_RR
  FastRef(16) = ?InstructionCMP_02_RRRef
  FastAsm(17) = ?InstructionADD_06_RR
  FastRef(17) = ?InstructionADD_06_RRRef
  FastAsm(18) = ?InstructionSUB_16_RR
  FastRef(18) = ?InstructionSUB_16_RRRef
  FastAsm(19) = ?InstructionBIT_03_RR
  FastRef(19) = ?InstructionBIT_03_RRRef
  FastAsm(20) = ?InstructionBIC_04_RR
  FastRef(20) = ?InstructionBIC_04_RRRef
  FastAsm(21) = ?InstructionBIS_05_RR
  FastRef(21) = ?InstructionBIS_05_RRRef
  FastAsm(22) = ?InstructionCLR_0050_R
  FastRef(22) = ?InstructionCLR_0050_RRef
  FastAsm(23) = ?InstructionTST_0057_R
  FastRef(23) = ?InstructionTST_0057_RRef
  FastAsm(24) = ?InstructionINC_0052_R
  FastRef(24) = ?InstructionINC_0052_RRef
  FastAsm(25) = ?InstructionDEC_0053_R
  FastRef(25) = ?InstructionDEC_0053_RRef
CompilerEndIf
; ---- END FAST THUMB1 ----
; ---- END UNMAPPED ONLY ----
; ---- FAST ENTRY POINTS ----
; ---- UNMAPPED ONLY: native calls (tools/asm_call_gen.py) ----
CompilerIf #DISK_BACKEND = 0
  FastAsm(40) = ?InstructionJSR_004
  FastRef(40) = ?InstructionJSR_004Ref
  FastAsm(41) = ?InstructionRTS_00020
  FastRef(41) = ?InstructionRTS_00020Ref
CompilerEndIf
; ---- END UNMAPPED ONLY ----
  OpTableReady = 1
  Goto RunStart
EndProcedure

; Fills the table. CpuRun does this itself the first time it runs; calling
; this first only moves the cost out of the first timed run.
Procedure BuildOpcodeTable()
  CpuRun(0)
EndProcedure

XIncludeFile "../machine_disk.pbi"      ; the desktop's disk storage (disk.pico2's place)
XIncludeFile "../machine_demo.pbi"      ; the demo display and tone generator (desktop only)
; ======== kw11.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; ======================================================================
;  kw11.pico2 - the KW11-L line clock at 177546, vector 100, BR6, for the
;  J-11 emulator on the Raspberry Pi Pico 2.
;
;  Include after cpu.pico2 and instructions.pico2 (the main file lists it).
;
;  THE REGISTER (LKS, 177546; the J-11 systems' line clock is the KW11-L's
;  one register; simh pdp11_stddev.c clk_rd/clk_wr/clk_svc/clk_reset):
;    bit 7  MONITOR - set by every tick of the line and by the bus INIT;
;           cleared only by the program writing a 0 there. Writing a 1
;           does nothing.
;    bit 6  INTERRUPT ENABLE - read/write. With it set, every tick asks
;           for an interrupt through 000100 at BR6. Clearing it withdraws
;           a request not yet taken. Taking the interrupt ends the request
;           and leaves MONITOR as it is.
;    the rest reads 0.
;
;  60 HZ FROM THE BOARD'S TIMER. The line is Micros() (RP2350/Lib/timer):
;  a tick is due every 1/60 s of the board's own time - 16,667, 16,667 and
;  16,666 us in turn, exactly 50,000 us every three ticks. Under arm_run
;  that is emulated time, so a desk run sees 60 Hz of emulated time.
;
;  HOW THE PROCESSOR SEES IT: at an instruction boundary, through the same
;  road as the console - the tick sets a bit in IntReq and DevService
;  takes the trap between windows (cpu.pico2). While the interrupt is
;  enabled DevActive is set, so the run loop's windows are at most
;  #DEV_WINDOW_CLOCK instructions long (#DEV_WINDOW while the disk is busy) and the clock is looked at every window;
;  with it off nothing is looked at unless the program reads the register,
;  and then the tick is worked out there. Nothing is added to the path an
;  instruction takes.
;
;  A TICK THAT CANNOT BE DELIVERED (the processor's priority is 6 or 7,
;  or the firmware was busy for more than a period) is not queued: one
;  request stands for any number of ticks, as on the real line clock, and
;  when the board falls more than a period behind the phase is taken up
;  again from now. KwLost counts the ticks let go that way.
; ======================================================================

#KW_PERIOD_US = 16667        ; 1/60 s, rounded; KwPhase makes three of them 50,000 us

Global KwIe.l                ; bit 6
Global KwMon.l               ; bit 7
Global KwNext.l              ; Micros() when the next tick is due
Global KwPhase.l             ; 0, 1, 2: which of the three periods comes next
Global KwTicks.l             ; ticks since power-up (for the desk proof and the status line)
Global KwLost.l              ; ticks let go because the board fell behind

; The period that follows the tick just taken: 16,667, 16,667, 16,666.
Procedure KwAdvance()
  If KwPhase = 2
    KwNext = KwNext + #KW_PERIOD_US - 1
    KwPhase = 0
  Else
    KwNext = KwNext + #KW_PERIOD_US
    KwPhase = KwPhase + 1
  EndIf
EndProcedure

; Has the line ticked? Micros() is a 32-bit count that wraps every 71
; minutes; the difference is taken, never the values, so the wrap is safe.
; THE TWO CORES: core 1 keeps the 60 Hz time (KwTick, every pass of its
; loop) and counts the ticks in KwSeq; core 0 looks at KwSeq (KwPoll, from
; the run loop's device look) and does what the line does to the register:
; MONITOR set, and the interrupt when it is enabled. Ticks core 0 had no
; chance to see one at a time are merged, as on a real KW11-L (KwMissed).
Global KwSeen.l                 ; core 0: the last KwSeq acted on
Global KwMissed.l               ; core 0: ticks merged because two or more arrived between looks

Procedure KwTick()                       ; core 1
  Define now.l
  now = Micros()
  If now - KwNext >= 0
    KwAdvance()
    If now - KwNext >= 0                 ; more than a period behind: resume from now
      KwLost = KwLost + 1
      KwNext = now + #KW_PERIOD_US
      KwPhase = 0
    EndIf
    KwSeq = KwSeq + 1
  EndIf
EndProcedure

Procedure KwPoll()                       ; core 0
  Define d.l
  d = KwSeq - KwSeen
  If d <> 0
    If d > 1 And KwIe <> 0               ; while interrupts are off MONITOR just stays set
      KwMissed = KwMissed + d - 1
    EndIf
    KwSeen = KwSeen + d
    KwMon = 1
    KwTicks = KwTicks + 1
    If KwIe
      IntReq = IntReq | #INT_KW
      IntCheck()
    EndIf
  EndIf
EndProcedure

Procedure.l KwRead()
  KwPoll()
  ProcedureReturn (KwMon << 7) | (KwIe << 6)
EndProcedure

Procedure KwWrite(v.l)
  KwPoll()
  If (v & $80) = 0
    KwMon = 0
  EndIf
  If v & $40
    KwIe = 1
  Else
    KwIe = 0
    IntReq = IntReq & ~#INT_KW
  EndIf
  DevUpdate()
EndProcedure

; The bus INIT and power-up: interrupt off, MONITOR set (simh clk_reset
; does the same), the next tick a full period away.
Procedure KwInit()
  KwIe = 0
  KwMon = 1
  KwSeen = KwSeq                         ; the 60 Hz time itself is core 1's (KwTick)
  IntReq = IntReq & ~#INT_KW
  DevUpdate()
EndProcedure

; ======== rk11.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; ======================================================================
;  rk11.pico2 - the RK11-D disk controller with RK05 drives, at 177400-
;  177416, vector 220, BR5, for the J-11 emulator on the Raspberry Pi Pico 2.
;
;  Include after cpu.pico2, instructions.pico2 and disk.pico2 (the main file
;  lists them). The drives' contents live behind disk.pico2's small
;  interface - DiskRead and DiskWrite of one 512-byte block through DkBuf -
;  so this file does not know whether a pack is in RAM or in flash.
;
;  THE AUTHORITY is DEC's RK11-D and RK11-E Moving Head Disk Drive
;  Controller User's Manual, EK-RK11D-OP-001 (1976), in this repository
;  as PureMetal/EK-RK11D-OP-001.pdf: chapter 1.3 for the functions, 3.2
;  for the registers, 3.4 for the interrupts. Where the manual leaves a
;  choice open, simh's PDP11/pdp11_rk.c was read as a cross-check and is
;  named at the line.
;
;  THE GEOMETRY. An RK05 pack: 203 cylinders (0-312 octal), 2 surfaces,
;  12 sectors of 256 words - 4872 blocks, 2,494,464 bytes. Block number =
;  (cylinder * 2 + surface) * 12 + sector, which is how every PDP-11
;  system numbers an RK05. Up to #RK_DRIVES drives (2; the boards use 1).
;
;  THE REGISTERS (manual 3.2)
;    177400 RKDS  read-only. 15-13 the drive that last interrupted,
;                 11 RK05, 8 sector counter OK, 7 drive ready, 6 read/
;                 write/seek ready (not seeking), 5 write-protected,
;                 4 SC = SA, 3-0 the sector counter. Status is for the
;                 drive RKDA selects; a drive that does not exist reads 0.
;                 The sector counter reads the sector RKDA names, with
;                 SC = SA always set: the emulated disk is always on the
;                 sector wanted, and a program that waits for SC = SA
;                 (none of the Unix drivers does) never waits.
;    177402 RKER  read-only. 0 WCE, 1 CSE (soft, cleared when a function
;                 starts); 5 NXS, 6 NXC, 7 NXD, 8 TE, 9 DLT, 10 NXM,
;                 11 PGE, 12 SKE, 13 WLO, 14 OVR, 15 DRE (hard, cleared
;                 only by INIT or a control reset).
;    177404 RKCS  0 GO (write-only), 3-1 function, 5-4 MEX (bus address
;                 17-16), 6 IDE, 7 RDY (read-only), 8 SSE, 10 FMT, 11 IBA,
;                 13 SCP (read-only), 14 HE and 15 ERR (read-only, from
;                 RKER). The writable bits are simh's RKCS_RW, 006576.
;    177406 RKWC  two's complement of the words to transfer; counts up.
;    177410 RKBA  bus address, bits 15-0; carries into MEX.
;    177412 RKDA  15-13 drive, 12-5 cylinder, 4 surface, 3-0 sector;
;                 advanced past the last sector transferred. Written only
;                 while the controller is ready (manual: "will not respond
;                 to commands while the controller is busy").
;    177414 RKMR  unused on the RK11-D: reads 0, writes ignored.
;    177416 RKDB  read-only: the last word through the controller.
;  While a transfer is in progress (RDY clear) RKWC, RKBA and RKDA ignore
;  writes and RKCS takes only its IDE bit; GO is honoured only when RDY.
;
;  THE FUNCTIONS (manual 1.3.2)
;    0 control reset  every register cleared except RDY, which is set;
;                     no interrupt.
;    1 write          2 read          3 write check        5 read check
;                     A transfer of -RKWC words, sector after sector, from
;                     the block RKDA names, to or from the 18-bit address
;                     MEX:RKBA (IBA holds it still). A short last sector
;                     is filled with zeros on a write (manual 3.3). Write
;                     check compares memory with the disk and sets WCE;
;                     with SSE it stops at the end of that sector. Read
;                     check reads and moves nothing. FMT with a read
;                     moves one header word (the cylinder << 5) per sector
;                     (manual, RKCS 10); FMT with a write writes as usual.
;                     Past the last block of the pack: OVR.
;    4 seek           6 drive reset (a seek to cylinder 0)
;                     The controller is free at once and interrupts then
;                     (IDE); when the heads arrive, #RK_SEEK_INSTRUCTIONS
;                     later, the hardware poll sets SCP, puts the drive in
;                     RKDS 15-13 and interrupts again (manual 1.3.2.9 and
;                     3.4 items d and f).
;    7 write lock     the drive refuses writes (WLO) until power-up or
;                     INIT (simh rk_reset clears it at INIT too).
;  ERRORS AT GO, first match wins (simh rk_go's order): a drive that does
;  not exist - NXD; FMT with anything but read or write - PGE; a write to
;  a locked drive - WLO; sector 12 or more - NXS; cylinder over 312 - NXC.
;  A block the storage cannot serve (disk.pico2 returns -1: a block past a
;  truncated pack that was never written, say) is DRE, drive error, and
;  the firmware says which block.
;
;  THE BUS. The controller makes 18-bit bus addresses (RKBA plus MEX), as
;  the RK11-D/E do. DMA goes through RkMemRead and RkMemWrite, which turn
;  the bus address into a physical one through the Unibus map (cpu.pico2,
;  UbPhys: one to one while MMR3 bit 5 is clear) and reach Mem below
;  #RAM_BYTES and, on a board with PSRAM, the memory above it up to MemTop.
;  Anything else - the bus's I/O page, a map register pointing past the
;  memory fitted - is nonexistent memory (NXM, the transfer stops there -
;  simh does the same).
;
;  THE INTERRUPT goes through IntReq (#INT_RK, BR5, vector 220) and is
;  taken at an instruction boundary by DevService (cpu.pico2), exactly as
;  the console's are. It is asked for, when IDE is set, by: the end of a
;  function (errors included), IDE being set while the controller is
;  ready (manual 3.2, RKCS 06 item d), and a seek completing. Clearing
;  IDE or setting GO withdraws a request not yet taken.
;
;  TIMING. A transfer ends #RK_XFER_INSTRUCTIONS after GO at the earliest
;  (the processor gets to run between GO and the interrupt, as on the
;  real controller; simh's rk_rwait is 10), and moves one sector each time
;  the run loop looks, and no sooner than #RK_SECTOR_US of the board's time
;  and #RK_SECTOR_INSTRUCTIONS of the processor's after the last - up to 2,000 sectors (1 MB) a second, some seven times
;  a real RK05 (300), and never more than one sector's work (a few hundred
;  microseconds, measured by the desk probe) between two USB services.
;  While the processor is in a WAIT, instructions are taken to have passed
;  and only the board-time spacing applies.
; ======================================================================

#RK_DRIVES           = 2
#RK_BLOCKS           = 4872     ; 203 * 2 * 12
#RK_LAST_CYL         = 202      ; 312 octal
#RK_XFER_INSTRUCTIONS = 20
#RK_SEEK_INSTRUCTIONS = 50
#RK_SECTORS_PER_POLL = 1
#RK_SECTOR_US        = 500      ; and no sooner than this after the last one (board time)
#RK_SECTOR_INSTRUCTIONS = 256    ; nor this many instructions (more than the firmware's slice)

; RKER
#RKER_WCE = $0001
#RKER_CSE = $0002
#RKER_NXS = $0020
#RKER_NXC = $0040
#RKER_NXD = $0080
#RKER_NXM = $0400
#RKER_PGE = $0800
#RKER_WLO = $2000
#RKER_OVR = $4000
#RKER_DRE = $8000
#RKER_HARD = $FFE0
; RKCS
#RKCS_RW  = $0D7E               ; 006576: function, MEX, IDE, SSE, FMT, IBA
#RKCS_IDE = $0040
#RKCS_RDY = $0080
#RKCS_SSE = $0100
#RKCS_FMT = $0400
#RKCS_IBA = $0800
#RKCS_SCP = $2000

Global RkCs.l                   ; the stored bits of RKCS (HE and ERR are made from RkEr)
Global RkEr.l, RkWc.l, RkBa.l, RkDa.l, RkDb.l
Global RkBusy.l                 ; a transfer is in progress (RDY clear)
Global RkDue.l                  ; CpuNow() before which it does not end
Global RkIntDrive.l             ; RKDS 15-13
Global RkSeekMask.l             ; drives whose heads are still moving (bit per drive)
Global RkSeekDone.l             ; drives arrived, their poll interrupt not yet given
Global Dim RkSeekAt.l(#RK_DRIVES)
Global Dim RkCyl.l(#RK_DRIVES)  ; where each drive's heads are
Global Dim RkLock.l(#RK_DRIVES) ; write-locked by function 7
; the transfer in progress
Global RkXFunc.l, RkXDrive.l, RkXBlock.l, RkXLeft.l, RkXDone.l, RkXMa.l, RkXStop.l
; counters for the firmware's status line and the desk proof
Global RkReads.l, RkWrites.l    ; blocks read and written since power-up
Global RkLastUs.l, RkLastAt.l     ; Micros() and CpuNow() of the last sector moved (RkStep)
Global RkBadBlock.l = -1        ; the last block the storage refused (-1 none)

; ---- the bus: physical memory for the controller's DMA ------------------
; Return -1 for nonexistent memory (see THE BUS above).

; ---- THE STORAGE, ON CORE 1 ---------------------------------------------
; The controller, its registers and the copy to and from memory stay on
; core 0; the storage itself (DiskRead / DiskWrite: the flash through XIP,
; the RAM overlay) is core 1's. One request at a time: core 0 fills the
; request and publishes DkReqSeq; core 1 (DkServe) does it and publishes
; DkDoneSeq. DkBuf belongs to whichever side the two numbers say.
Global RkIoPosted.l             ; core 0: the request for this sector is out
Global RkIoN.l, RkIoMa.l                  ; core 0: words a posted WRITE moves (found before posting)

; 1 done, -1 refused, 0 not yet (posted now, or still out).
Procedure.l RkIo(what.l)
  If RkIoPosted = 0
    If DkReqSeq <> DkDoneSeq Or RpIoPosted   ; an abandoned request (a RESET) is still out, or the RP11's
      ProcedureReturn 0
    EndIf
    DkReqOp = what
    DkReqDrive = RkXDrive
    DkReqBlock = RkXBlock
    SmpBarrier()                         ; the request, then its number
    DkReqSeq = DkReqSeq + 1
    RkIoPosted = 1
    ProcedureReturn 0
  EndIf
  If DkDoneSeq <> DkReqSeq
    ProcedureReturn 0
  EndIf
  SmpBarrier()                           ; the number, then DkBuf and the result
  RkIoPosted = 0
  ProcedureReturn DkDoneResult
EndProcedure

; Core 1: the posted request, if there is one. A storage that is not ready
; (0) is simply asked again on the next pass; core 0 sees only the answer.
Procedure DkServe()
  Define r.l
  If DkReqSeq <> DkDoneSeq
    SmpBarrier()                         ; the number, then the request
    If DkReqOp = 1
      r = DiskWrite(DkReqDrive, DkReqBlock)
    Else
      r = DiskRead(DkReqDrive, DkReqBlock)
    EndIf
    If r <> 0
      DkDoneResult = r
      SmpBarrier()                       ; DkBuf and the result, then the number
      DkDoneSeq = DkReqSeq
    EndIf
  EndIf
EndProcedure

Procedure.l RkMemRead(pa.l)               ; pa arrives as the 18-bit bus address
  pa = UbPhys(pa)
  If pa < #RAM_BYTES
    ProcedureReturn Mem(pa >> 1)
  EndIf
  CompilerIf #DESK_MEM = 1                  ; the memory past 56 KB, in the PSRAM (psram.pico2)
    If pa < MemTop
      ProcedureReturn PeekU(PsMem + (pa & ~1))
    EndIf
  CompilerEndIf
  ProcedureReturn -1
EndProcedure

Procedure.l RkMemWrite(pa.l, v.l)
  pa = UbPhys(pa)
  If pa < #RAM_BYTES
    Mem(pa >> 1) = v
    ProcedureReturn 1
  EndIf
  CompilerIf #DESK_MEM = 1
    If pa < MemTop
      PokeU(PsMem + (pa & ~1), v & $FFFF)
      ProcedureReturn 1
    EndIf
  CompilerEndIf
  ProcedureReturn 0
EndProcedure

; ---- status ------------------------------------------------------------
Procedure.l RkCsRead()
  Define v.l
  v = RkCs
  If RkEr
    v = v | $8000
    If RkEr & #RKER_HARD
      v = v | $4000
    EndIf
  EndIf
  ProcedureReturn v
EndProcedure

Procedure.l RkDsRead()
  Define d.l
  Define v.l
  d = (RkDa >> 13) & 7
  v = RkIntDrive << 13
  If d < #RK_DRIVES
    If DiskPresent(d)
      v = v | $0800 | $0100 | $0080 | $0010    ; RK05, SOK, DRY, SC=SA
      If (RkSeekMask & (1 << d)) = 0
        v = v | $0040                          ; R/W/S ready: not seeking
      EndIf
      If RkLock(d) <> 0 Or DiskWritable(d) = 0
        v = v | $0020                          ; write-protected
      EndIf
      If (RkDa & 15) < 12
        v = v | (RkDa & 15)
      EndIf
    EndIf
  EndIf
  ProcedureReturn v
EndProcedure

; ---- the end of a function, and the interrupt --------------------------
Procedure RkAsk()                       ; an interrupt, if IDE
  If RkCs & #RKCS_IDE
    IntReq = IntReq | #INT_RK
    IntCheck()
  EndIf
EndProcedure

Procedure RkDone()
  RkCs = RkCs | #RKCS_RDY
  RkBusy = 0
  RkAsk()
  DevUpdate()
EndProcedure

Procedure RkFail(bits.l)                ; an error found at GO
  RkEr = RkEr | bits
  RkDone()
EndProcedure

; DevService takes the interrupt: the request is over. A drive that
; arrived meanwhile gets its own poll interrupt next (RkPoll).
Procedure RkIntTaken()
  If RkSeekDone
    DevUpdate()
  EndIf
EndProcedure

; The block's disk address back into RKDA, keeping the drive bits.
Procedure RkSetDa(blk.l)
  RkDa = (RkDa & $E000) | ((blk / 24) << 5) | (((blk / 12) & 1) << 4) | (blk % 12)
EndProcedure

; ---- GO ----------------------------------------------------------------
Procedure RkGo()
  Define f.l
  Define d.l
  Define cyl.l
  f = (RkCs >> 1) & 7
  d = (RkDa >> 13) & 7
  RkCs = RkCs & ~(#RKCS_RDY | #RKCS_SCP)
  IntReq = IntReq & ~#INT_RK
  RkEr = RkEr & ~(#RKER_WCE | #RKER_CSE)
  RkIntDrive = d
  If f = 0                               ; control reset
    RkCs = #RKCS_RDY
    RkEr = 0
    RkWc = 0
    RkBa = 0
    RkDa = 0
    RkDb = 0
    RkBusy = 0
    RkIntDrive = 0
    DevUpdate()
    ProcedureReturn
  EndIf
  If d >= #RK_DRIVES
    RkFail(#RKER_NXD)
    ProcedureReturn
  EndIf
  If DiskPresent(d) = 0
    RkFail(#RKER_NXD)
    ProcedureReturn
  EndIf
  If (RkCs & #RKCS_FMT) <> 0 And f <> 1 And f <> 2
    RkFail(#RKER_PGE)
    ProcedureReturn
  EndIf
  If f = 7                               ; write lock
    RkLock(d) = 1
    RkDone()
    ProcedureReturn
  EndIf
  cyl = (RkDa >> 5) & $FF
  If f = 4 Or f = 6                      ; seek, drive reset
    If f = 6
      cyl = 0
    ElseIf cyl > #RK_LAST_CYL
      RkFail(#RKER_NXC)
      ProcedureReturn
    EndIf
    RkCyl(d) = cyl
    RkSeekMask = RkSeekMask | (1 << d)
    RkSeekAt(d) = CpuNow() + #RK_SEEK_INSTRUCTIONS
    RkDone()                             ; the controller is free at once
    ProcedureReturn
  EndIf
  If f = 1
    If RkLock(d) <> 0 Or DiskWritable(d) = 0
      RkFail(#RKER_WLO)
      ProcedureReturn
    EndIf
  EndIf
  If (RkDa & 15) >= 12
    RkFail(#RKER_NXS)
    ProcedureReturn
  EndIf
  If cyl > #RK_LAST_CYL
    RkFail(#RKER_NXC)
    ProcedureReturn
  EndIf
  RkCyl(d) = cyl
  RkXFunc = f
  RkXDrive = d
  RkXBlock = (cyl * 2 + ((RkDa >> 4) & 1)) * 12 + (RkDa & 15)
  RkXLeft = (65536 - RkWc) & $FFFF
  If RkXLeft = 0
    RkXLeft = 65536
  EndIf
  RkXDone = 0
  RkXStop = 0
  RkXMa = ((RkCs & $30) << 12) | RkBa
  RkBusy = 1
  RkDue = CpuNow() + #RK_XFER_INSTRUCTIONS
  CpuEventIn(#RK_XFER_INSTRUCTIONS)
  DevUpdate()
EndProcedure

; ---- the transfer ------------------------------------------------------
; Registers after the transfer: RKWC counts the words moved, RKBA and MEX
; hold the next bus address, RKDA the next sector (simh rk_svc).
Procedure RkFinish()
  RkWc = (RkWc + RkXDone) & $FFFF
  RkBa = RkXMa & $FFFF
  RkCs = (RkCs & ~$30) | ((RkXMa >> 12) & $30)
  RkSetDa(RkXBlock)
  RkDone()
EndProcedure

; One sector. Returns 1 when it was done, 0 when the storage is not ready
; yet (nothing has moved, the sector is tried again at the next look).
Procedure.l RkSector()
  Define n.l
  Define i.l
  Define w.l
  Define r.l
  Define ma.l
  Define stepv.l
  n = RkXLeft
  If n > 256
    n = 256
  EndIf
  stepv = 2
  If RkCs & #RKCS_IBA
    stepv = 0
  EndIf
  ma = RkXMa
  If RkXFunc = 1                         ; WRITE: memory into the buffer, zeros after
    If RkIoPosted = 0
      If DkReqSeq <> DkDoneSeq Or RpIoPosted   ; DkBuf is still core 1's (an abandoned request), or the RP11's
        ProcedureReturn 0
      EndIf
      For i = 0 To n - 1
        w = RkMemRead(ma)
        If w < 0
          RkEr = RkEr | #RKER_NXM
          n = i                          ; the words before it still go
          RkXStop = 1
          Break
        EndIf
        DkBuf(i) = w
        RkDb = w
        ma = (ma + stepv) & $3FFFF
      Next
      If n = 0                           ; nothing to write: the sector is not touched (simh)
        ProcedureReturn 1
      EndIf
      For i = n To 255
        DkBuf(i) = 0
      Next
      RkIoN = n
      RkIoMa = ma
    Else
      n = RkIoN                          ; posted on an earlier look: what it found stands
      ma = RkIoMa
    EndIf
    r = RkIo(1)
    If r = 0
      ProcedureReturn 0                  ; out on core 1: collected at a later look
    EndIf
    If r < 0
      RkEr = RkEr | #RKER_DRE
      RkBadBlock = RkXBlock
      RkXStop = 1
      ProcedureReturn 1
    EndIf
    RkWrites = RkWrites + 1
  Else                                   ; READ, WRITE CHECK, READ CHECK
    If RkXFunc = 2 And (RkCs & #RKCS_FMT) <> 0
      DkBuf(0) = (RkXBlock / 24) << 5    ; FORMAT READ: the header word only
      n = 1
    Else
      r = RkIo(2)
      If r = 0
        ProcedureReturn 0                ; out on core 1: collected at a later look
      EndIf
      If r < 0
        RkEr = RkEr | #RKER_DRE
        RkBadBlock = RkXBlock
        RkXStop = 1
        ProcedureReturn 1
      EndIf
      RkReads = RkReads + 1
    EndIf
    If RkXFunc = 2                       ; READ: into memory
      For i = 0 To n - 1
        RkDb = DkBuf(i)
        If RkMemWrite(ma, RkDb) = 0
          RkEr = RkEr | #RKER_NXM
          n = i
          RkXStop = 1
          Break
        EndIf
        ma = (ma + stepv) & $3FFFF
      Next
    ElseIf RkXFunc = 3                   ; WRITE CHECK: compare
      For i = 0 To n - 1
        w = RkMemRead(ma)
        If w < 0
          RkEr = RkEr | #RKER_NXM
          n = i
          RkXStop = 1
          Break
        EndIf
        RkDb = w
        If w <> DkBuf(i)
          RkEr = RkEr | #RKER_WCE
        EndIf
        ma = (ma + stepv) & $3FFFF
      Next
      If (RkEr & #RKER_WCE) <> 0 And (RkCs & #RKCS_SSE) <> 0
        RkXStop = 1                      ; stop on soft error, at the end of this sector
      EndIf
    EndIf                                ; READ CHECK moves nothing, and neither does the address
    If n = 0                             ; stopped before its first word: RKDA stays (simh
      ProcedureReturn 1                  ; advances it by the words moved, rounded up)
    EndIf
  EndIf
  If RkXFunc <> 5
    RkXMa = ma
  EndIf
  RkXDone = RkXDone + n
  RkXLeft = RkXLeft - n
  RkXBlock = RkXBlock + 1
  ProcedureReturn 1
EndProcedure

Procedure RkStep()
  Define k.l
  If Micros() - RkLastUs < #RK_SECTOR_US   ; a sector at most every #RK_SECTOR_US of board time,
    ProcedureReturn                        ; and every #RK_SECTOR_INSTRUCTIONS of the processor's
  EndIf                                    ; (unless it WAITs): one per CpuRun slice
  If Waiting = 0 And CpuNow() - RkLastAt < #RK_SECTOR_INSTRUCTIONS
    ProcedureReturn
  EndIf
  k = 0
  While RkXLeft > 0 And RkXStop = 0 And k < #RK_SECTORS_PER_POLL
    If RkXBlock >= #RK_BLOCKS            ; past sector 13, surface 1, cylinder 312
      RkEr = RkEr | #RKER_OVR
      RkXStop = 1
      Break
    EndIf
    If RkSector() = 0
      ProcedureReturn                    ; the storage (core 1) has not answered: look again next window
    EndIf
    k = k + 1
  Wend
  RkLastUs = Micros()                    ; the spacing runs from the END of this sector's work
  RkLastAt = CpuNow()
  If RkXLeft = 0 Or RkXStop <> 0
    RkFinish()
  EndIf
EndProcedure

; ---- the run loop's look (DevPoll) -------------------------------------
Procedure RkPoll()
  Define d.l
  Define now.l
  now = CpuNow()
  If RkBusy
    If Waiting <> 0 Or now - RkDue >= 0
      RkStep()
    EndIf
  EndIf
  If RkSeekMask
    For d = 0 To #RK_DRIVES - 1
      If RkSeekMask & (1 << d)
        If Waiting <> 0 Or now - RkSeekAt(d) >= 0
          RkSeekMask = RkSeekMask & ~(1 << d)
          RkSeekDone = RkSeekDone | (1 << d)
        EndIf
      EndIf
    Next
  EndIf
  ; the hardware poll: one arrived drive at a time, when the controller is
  ; ready and has no interrupt of its own waiting (manual 1.3.2.9)
  If RkSeekDone
    If RkBusy = 0 And (IntReq & #INT_RK) = 0
      For d = 0 To #RK_DRIVES - 1
        If RkSeekDone & (1 << d)
          RkSeekDone = RkSeekDone & ~(1 << d)
          If RkCs & #RKCS_IDE
            RkCs = RkCs | #RKCS_SCP
            RkIntDrive = d
            RkAsk()
          EndIf
          Break
        EndIf
      Next
    EndIf
  EndIf
  DevUpdate()
EndProcedure

; ---- the registers from the bus ----------------------------------------
Procedure.l RkRead(a.l)
  Define r.l
  r = (a >> 1) & 7
  If r = 0
    ProcedureReturn RkDsRead()
  ElseIf r = 1
    ProcedureReturn RkEr
  ElseIf r = 2
    ProcedureReturn RkCsRead()
  ElseIf r = 3
    ProcedureReturn RkWc
  ElseIf r = 4
    ProcedureReturn RkBa
  ElseIf r = 5
    ProcedureReturn RkDa
  ElseIf r = 7
    ProcedureReturn RkDb
  EndIf
  ProcedureReturn 0                      ; 177414, unused
EndProcedure

Procedure RkWrite(a.l, v.l)
  Define r.l
  Define oldie.l
  r = (a >> 1) & 7
  If r = 2                               ; RKCS
    oldie = RkCs & #RKCS_IDE
    If RkBusy
      RkCs = (RkCs & ~#RKCS_IDE) | (v & #RKCS_IDE)
    Else
      RkCs = (RkCs & ~#RKCS_RW) | (v & #RKCS_RW)
    EndIf
    If (v & #RKCS_IDE) = 0
      IntReq = IntReq & ~#INT_RK
    ElseIf oldie = 0 And (RkCs & #RKCS_RDY) <> 0 And (v & 1) = 0
      RkAsk()                            ; IDE set while ready, no GO: interrupt (RKCS 06 d)
    EndIf
    If (v & 1) <> 0 And (RkCs & #RKCS_RDY) <> 0
      RkGo()
    EndIf
  ElseIf RkBusy = 0
    If r = 3
      RkWc = v
    ElseIf r = 4
      RkBa = v & $FFFE                   ; the bus moves words
    ElseIf r = 5
      RkDa = v
    EndIf
  EndIf                                  ; RKDS, RKER, RKDB read-only; RKMR unused
EndProcedure

; The bus INIT (and power-up): every register clear but RDY; drives
; stop seeking, write locks come off; a transfer in progress is dropped.
Procedure RkInit()
  Define d.l
  RkCs = #RKCS_RDY
  RkEr = 0
  RkWc = 0
  RkBa = 0
  RkDa = 0
  RkDb = 0
  RkBusy = 0
  RkIntDrive = 0
  RkSeekMask = 0
  RkSeekDone = 0
  RkIoPosted = 0                         ; a request still out is abandoned (RkIo waits it out)
  For d = 0 To #RK_DRIVES - 1
    RkLock(d) = 0
  Next
  IntReq = IntReq & ~#INT_RK
  DevUpdate()
EndProcedure

; ======================================================================
;  THE DEVICES' SHARED PROCEDURES (called from cpu.pico2)
; ======================================================================
; DevActive says whether the run loop must look at the devices every
; window: only while the clock may interrupt or the disk is busy.
Procedure DevUpdate()
  DevActive = KwIe | RkBusy | RkSeekMask | RkSeekDone | RpBusy
  DevFast = RkBusy | RkSeekMask | RkSeekDone | RpBusy
EndProcedure

; Called by DevService at the end of a window while DevActive is set.
; The desk probe build (#DESK_PROBE = 1) times it: DevPollMax, in us.
Global DevPollMax.l
Procedure DevPoll()
  CompilerIf #DESK_PROBE = 1
    Define t.l
    t = Micros()
  CompilerEndIf
  If KwIe                                ; KwPoll acts only on a new tick
    If KwSeq <> KwSeen
      KwPoll()
    EndIf
  EndIf
  If RkBusy | RkSeekMask | RkSeekDone
    RkPoll()
  EndIf
  If RpBusy
    RpPoll()
  EndIf
  DevActive = KwIe | RkBusy | RkSeekMask | RkSeekDone | RpBusy   ; DevUpdate, inline: once a window
  DevFast = RkBusy | RkSeekMask | RkSeekDone | RpBusy
  CompilerIf #DESK_PROBE = 1
    If Micros() - t > DevPollMax
      DevPollMax = Micros() - t
    EndIf
  CompilerEndIf
EndProcedure

; A byte written into one of these full-word registers (MOVB, BISB ...):
; the other byte keeps what the register reads, and the word goes in.
Procedure DevWriteByte(a.l, v.l)
  Define w.l
  If (a & $FFFE) = #KW_CSR
    w = KwRead()
  ElseIf (a & $FF00) = (#RP_BASE & $FF00)
    w = RpRead(a & $FFFE)
    If (a & $FFFE) = #RP_BASE + 4
      w = w & ~1                         ; GO reads 0 and is not written back
    EndIf
  Else
    w = RkRead(a & $FFFE)
    If ((a >> 1) & 7) = 2
      w = w & ~1                         ; GO reads 0 and is not written back
    EndIf
  EndIf
  If a & 1
    w = (w & $00FF) | (v << 8)
  Else
    w = (w & $FF00) | v
  EndIf
  If (a & $FFFE) = #KW_CSR
    KwWrite(w)
  ElseIf (a & $FF00) = (#RP_BASE & $FF00)
    RpWrite(a & $FFFE, w)
  Else
    RkWrite(a & $FFFE, w)
  EndIf
EndProcedure

; ======== rp11.pico2 (J11_18MHz_KDJ11_BF/pico2) ========
; ======================================================================
;  rp11.pico2 - the RP11-C disk controller with one RP03 drive, at 176710-
;  176736, vector 254, BR5 (2026-10-22). For V7's /usr on /dev/rp3, where
;  the distribution has it, on the boards with PSRAM (the Pico Plus 2 W):
;  the pack lives in the flash where RK1's would, and what Unix writes is
;  held in RK1's part of the PSRAM until Ctrl-] w saves it.
;
;  Include after rk11.pico2 and psram_pdp11.pico2. RpPresent, RpBusy and
;  RpIoPosted are declared in cpu.pico2, which reads them first. Without
;  an RP pack in the flash (RpPresent = 0) the registers do not answer:
;  the bus times out there, as on a machine with no RP11.
;
;  WHY AN RP03. V7's whole /usr is 15,218 blocks; /usr/src/cmd alone is
;  5,890, more than an RK05 holds, and a mount is a whole file system. V7
;  shipped with /usr on the RP03's partition 3 (/etc/rc: /etc/mount
;  /dev/rp3 /usr), and its kernel here is linked from a configuration
;  built on the board (media/unix/v7: mkconf with rk, rp and ht), so V7's
;  own driver, /usr/sys/dev/rp.c, is the program this is written for.
;
;  THE CONTROLLER, as rp.c drives it. Only what rp.c reads is modelled; the
;  registers it never touches (176726-176736) read 0 and ignore writes.
;    176710 RPDS  drive status: $0080 (ready) for drive 0, 0 for any other.
;                 Never seeking (SUSU, 02000, clear), never unsafe.
;    176712 RPER  $0080 nonexistent drive, $0040 a block past the pack or
;                 one the storage refused (the overlay full: see WRITES).
;    176714 RPCS  0 GO, 3-1 function, 5-4 bus address 17-16, 6 IE, 7 READY
;                 (read only), 10-8 drive, 14 hard error and 15 error (read
;                 only, from RPER).
;    176716 RPWC  two's complement of the words to move; counts up.
;    176720 RPBA  bus address 15-0.
;    176722 RPCA  cylinder, 0-405.
;    176724 RPDA  12-8 track (0-19), 3-0 sector (0-9).
;  Functions: 0 reset, 1 write, 2 read, 3 write check, 4 seek, 5 write
;  without seek, 6 home seek, 7 read without seek. Seeks finish at once.
;  A transfer moves a sector a look, spaced as the RK11's (rk11.pico2,
;  #RK_SECTOR_US and #RK_SECTOR_INSTRUCTIONS), through the same storage
;  channel to core 1 and the same Unibus DMA (RkMemRead, RkMemWrite). The
;  two controllers take turns with the channel: neither posts while the
;  other's request is out (RkIoPosted, RpIoPosted), so DkBuf is never
;  filled under the other's answer. Block = (cylinder * 20 + track) * 10 +
;  sector; the pack holds the blocks from its header's first block (rp3:
;  cylinder 35, block 7000), and reads zeros outside them.
;
;  THE PACK IN FLASH (tools/rk_image.py --rp), at #FL_RK1:
;    +0     "PDP11RP1", then u32s: version 1, blocks, first block, map
;           sectors; a name (16 bytes) at +32
;    +4 KB  the map: a u16 per block, 0 = never written (reads as zeros),
;           n = data slot n - 1
;    then   the data: 512-byte slots, from the 4 KB after the map
;  How many slots are in use is worked out from the map at start-up, not
;  kept in the header: a save writes the data first and the map after, so
;  the map is what is true if a save is cut short.
;
;  WRITES go to the overlay at #PS_RK1 in the PSRAM (RK1 is absent when an
;  RP pack is in its place): a u16 per block (overlay slot + 1), a u16 per
;  overlay slot (its block), then #RP_OV_SLOTS 512-byte slots. The overlay
;  holds every block changed since the pack was flashed or last folded; a
;  byte per slot (#SW_RPDIRTY) says it changed since the last save. Saves
;  put those into the store (store.pico2), which copies them back into the
;  overlay at power-up. FOLDING (PsFold -> RpSave) writes every overlay
;  block into the pack itself - into its slot if it has one (the 4 KB
;  sector rewritten with the neighbours that changed too), else into a new
;  slot after the last - then the map sectors that changed, and empties the
;  overlay. It happens when the store is full and when the overlay is: the
;  write of a new block then asks for the save itself and waits for it
;  (core 1 answers "not yet", DkServe asks again after it), so Unix sees a
;  slow write, never an error. Only if a fold cannot empty the overlay (the
;  flash refusing) is a write refused: a drive error, and Unix's "err on
;  dev" message.
;
;  THE FLASH NEVER FILLS: a block gets a slot the first time it is folded
;  and keeps it, and rk_image.py --rp refuses a file system with more
;  blocks than RK1's place has slots (20,896 in the Pico Plus 2's 16 MB, up
;  to the store in its top 1 MB), so every block can always have one.
; ======================================================================

#RP_CYLS   = 406
#RP_TRACKS = 20
#RP_SECT   = 10
#RPCS_GO   = $0001
#RPCS_IE   = $0040
#RPCS_RDY  = $0080
#RPCS_RW   = $077E                ; function, MEX, IE, drive
#RPER_NXB  = $0040
#RPER_NXD  = $0080
#RP_OV_MAP   = $C000              ; overlay: the block map's bytes (up to 24,576 blocks) ...
#RP_OV_LIST  = $2000              ; ... the slots' blocks (up to 4,096) ...
#RP_OV_SLOTS = 3888               ; ... and the slots: to the end of the chip ($1F4000 - $E000) / 512

Global RpBlocks.l, RpFirst.l, RpMapSectors.l, RpData.l, RpSlots.l, RpRoom.l
Global RpCs.l, RpEr.l, RpWc.l, RpBa.l, RpCa.l, RpDa.l
Global RpDue.l, RpXFunc.l, RpXBlock.l, RpXLeft.l, RpXMa.l, RpXStop.l, RpIoN.l
Global RpLastUs.l, RpLastAt.l
Global RpReads.l, RpWrites.l, RpOvUsed.l, RpOvFull.l, RpOvStuck.l
Global RpAutoSaves.l                     ; saves a full overlay asked for since power-up (RpAutoSave: psram_pdp11.pico2)
Global RpSaveNew.l, RpSaveOld.l, RpSaveMap.l   ; the last fold (RpSaveFail: psram_pdp11.pico2)

; ---- the registers ------------------------------------------------------
Procedure.l RpCsRead()
  If RpEr
    ProcedureReturn RpCs | $C000
  EndIf
  ProcedureReturn RpCs
EndProcedure

Procedure RpAsk()
  If RpCs & #RPCS_IE
    IntReq = IntReq | #INT_RP
    IntCheck()
  EndIf
EndProcedure

Procedure RpDone()
  RpCs = RpCs | #RPCS_RDY
  RpBusy = 0
  RpAsk()
  DevUpdate()
EndProcedure

Procedure RpReset()                      ; the bus INIT (DevReset), and function 0
  RpCs = #RPCS_RDY
  RpEr = 0
  RpWc = 0
  RpBa = 0
  RpCa = 0
  RpDa = 0
  RpBusy = 0
  RpIoPosted = 0                         ; a request still out is waited out (RpSector)
  IntReq = IntReq & ~#INT_RP
  DevUpdate()
EndProcedure

Procedure RpGo()
  Define f.l
  f = (RpCs >> 1) & 7
  RpCs = RpCs & ~#RPCS_RDY
  RpEr = 0
  IntReq = IntReq & ~#INT_RP
  If f = 0
    RpReset()
    ProcedureReturn
  EndIf
  If ((RpCs >> 8) & 7) <> 0
    RpEr = #RPER_NXD
    RpDone()
    ProcedureReturn
  EndIf
  If f = 4 Or f = 6                      ; seek, home seek: there at once
    If f = 6
      RpCa = 0
    EndIf
    RpDone()
    ProcedureReturn
  EndIf
  If RpCa >= #RP_CYLS Or ((RpDa >> 8) & $1F) >= #RP_TRACKS Or (RpDa & $F) >= #RP_SECT
    RpEr = #RPER_NXB
    RpDone()
    ProcedureReturn
  EndIf
  RpXFunc = f
  RpXBlock = (RpCa * #RP_TRACKS + ((RpDa >> 8) & $1F)) * #RP_SECT + (RpDa & $F)
  RpXLeft = (65536 - RpWc) & $FFFF
  If RpXLeft = 0
    RpXLeft = 65536
  EndIf
  RpXMa = ((RpCs & $30) << 12) | RpBa
  RpXStop = 0
  RpBusy = 1
  RpDue = CpuNow() + #RK_XFER_INSTRUCTIONS
  CpuEventIn(#RK_XFER_INSTRUCTIONS)
  DevUpdate()
EndProcedure

; ---- the transfer -------------------------------------------------------
; One sector: 1 done, 0 the channel is busy or core 1 has not answered.
Procedure.l RpSector()
  Define n.l, i.l, w.l, r.l, ma.l
  n = RpXLeft
  If n > 256
    n = 256
  EndIf
  ma = RpXMa
  If RpIoPosted = 0
    If DkReqSeq <> DkDoneSeq Or RkIoPosted   ; the channel is still out, or the RK11's answer is not collected
      ProcedureReturn 0
    EndIf
    DkReqOp = 2
    If RpXFunc = 1 Or RpXFunc = 5        ; WRITE: memory into the buffer, zeros after
      For i = 0 To n - 1
        w = RkMemRead(ma)
        If w < 0
          n = i
          RpEr = RpEr | #RPER_NXB
          RpXStop = 1
          Break
        EndIf
        DkBuf(i) = w
        ma = (ma + 2) & $3FFFF
      Next
      If n = 0
        ProcedureReturn 1
      EndIf
      For i = n To 255
        DkBuf(i) = 0
      Next
      DkReqOp = 1
    EndIf
    RpIoN = n
    DkReqDrive = 8
    DkReqBlock = RpXBlock - RpFirst
    SmpBarrier()                         ; the request, then its number
    DkReqSeq = DkReqSeq + 1
    RpIoPosted = 1
    ProcedureReturn 0
  EndIf
  If DkDoneSeq <> DkReqSeq
    ProcedureReturn 0
  EndIf
  SmpBarrier()                           ; the number, then DkBuf and the result
  RpIoPosted = 0
  r = DkDoneResult
  n = RpIoN
  If r < 0
    RpEr = RpEr | #RPER_NXB
    RpXStop = 1
    ProcedureReturn 1
  EndIf
  If RpXFunc = 2 Or RpXFunc = 7          ; READ: into memory
    For i = 0 To n - 1
      If RkMemWrite(ma, DkBuf(i)) = 0
        n = i
        RpEr = RpEr | #RPER_NXB
        RpXStop = 1
        Break
      EndIf
      ma = (ma + 2) & $3FFFF
    Next
    RpReads = RpReads + 1
  ElseIf RpXFunc = 3                     ; WRITE CHECK
    For i = 0 To n - 1
      If RkMemRead(ma) <> DkBuf(i)
        RpEr = RpEr | #RPER_NXB
        RpXStop = 1
      EndIf
      ma = (ma + 2) & $3FFFF
    Next
  Else
    ma = (RpXMa + n * 2) & $3FFFF
    RpWrites = RpWrites + 1
  EndIf
  RpXMa = ma
  RpXLeft = RpXLeft - n
  RpXBlock = RpXBlock + 1
  ProcedureReturn 1
EndProcedure

; Registers after the transfer: RPWC the words not moved, RPBA and MEX the
; next bus address, RPCA and RPDA the next sector.
Procedure RpFinish()
  RpWc = (65536 - RpXLeft) & $FFFF
  RpBa = RpXMa & $FFFE
  RpCs = (RpCs & ~$30) | ((RpXMa >> 12) & $30)
  RpCa = RpXBlock / (#RP_TRACKS * #RP_SECT)
  RpDa = (((RpXBlock / #RP_SECT) % #RP_TRACKS) << 8) | (RpXBlock % #RP_SECT)
  RpDone()
EndProcedure

; The run loop's look (DevPoll), while busy.
Procedure RpPoll()
  If Waiting = 0 And CpuNow() - RpDue < 0
    ProcedureReturn
  EndIf
  If Micros() - RpLastUs < #RK_SECTOR_US
    ProcedureReturn
  EndIf
  If Waiting = 0 And CpuNow() - RpLastAt < #RK_SECTOR_INSTRUCTIONS
    ProcedureReturn
  EndIf
  If RpXLeft > 0 And RpXStop = 0
    If RpXBlock >= #RP_CYLS * #RP_TRACKS * #RP_SECT
      RpEr = RpEr | #RPER_NXB
      RpXStop = 1
    ElseIf RpSector() = 0
      ProcedureReturn
    EndIf
  EndIf
  RpLastUs = Micros()
  RpLastAt = CpuNow()
  If RpXLeft <= 0 Or RpXStop
    RpFinish()
  EndIf
EndProcedure

Procedure.l RpRead(a.l)
  Select (a >> 1) & 15
    Case 4                               ; 176710 RPDS
      If (RpCs & $0700) = 0
        ProcedureReturn $0080
      EndIf
    Case 5
      ProcedureReturn RpEr
    Case 6
      ProcedureReturn RpCsRead()
    Case 7
      ProcedureReturn RpWc
    Case 8
      ProcedureReturn RpBa
    Case 9
      ProcedureReturn RpCa
    Case 10
      ProcedureReturn RpDa
  EndSelect
  ProcedureReturn 0
EndProcedure

Procedure RpWrite(a.l, v.l)
  Define r.l, oldie.l
  r = (a >> 1) & 15
  If r = 6                               ; RPCS
    If RpBusy                            ; only IE while a transfer runs
      RpCs = (RpCs & ~#RPCS_IE) | (v & #RPCS_IE)
    Else
      oldie = RpCs & #RPCS_IE
      RpCs = (RpCs & ~#RPCS_RW) | (v & #RPCS_RW)
      If (v & #RPCS_IE) <> 0 And oldie = 0 And (v & #RPCS_GO) = 0
        RpAsk()                          ; IE set while ready, no GO
      EndIf
    EndIf
    If (v & #RPCS_IE) = 0
      IntReq = IntReq & ~#INT_RP
    EndIf
    If (v & #RPCS_GO) <> 0 And RpBusy = 0
      RpGo()
    EndIf
  ElseIf RpBusy = 0
    If r = 7
      RpWc = v
    ElseIf r = 8
      RpBa = v & $FFFE
    ElseIf r = 9
      RpCa = v & $3FF
    ElseIf r = 10
      RpDa = v & $1F0F
    EndIf
  EndIf
EndProcedure

CompilerIf #PSRAM = 1
; ---- the pack, at start-up (PsramLoad, when RK1 is absent) ---------------
Procedure RpInit()
  Define i.i, m.i
  RpPresent = 0
  If PeekL($10000000 + #FL_RK1) <> $31504450 Or PeekL($10000000 + #FL_RK1 + 4) <> $31505231
    ProcedureReturn                      ; not "PDP11RP1"
  EndIf
  If PeekL($10000000 + #FL_RK1 + 8) <> 1
    ProcedureReturn
  EndIf
  RpBlocks = PeekL($10000000 + #FL_RK1 + 12)
  RpFirst = PeekL($10000000 + #FL_RK1 + 16)
  RpMapSectors = PeekL($10000000 + #FL_RK1 + 20)
  If RpBlocks < 1 Or RpBlocks * 2 > #RP_OV_MAP Or RpMapSectors * 2048 < RpBlocks
    ProcedureReturn
  EndIf
  RpData = #FL_RK1 + 4096 + RpMapSectors * 4096
  RpRoom = (#FL_STORE - RpData) / 512   ; up to the store (store.pico2)
  RpSlots = 0                            ; the slots in use: up to the highest the map names
  For i = 0 To RpBlocks - 1
    m = PeekU($10000000 + #FL_RK1 + 4096 + i * 2)
    If m > RpSlots
      RpSlots = m
    EndIf
    PokeU(#PS_WIN + #PS_RK1 + i * 2, 0)  ; the overlay starts empty
  Next
  If RpSlots > RpRoom
    ProcedureReturn
  EndIf
  For i = 0 To #RP_OV_SLOTS - 1
    PokeA(@DkSwapRam(0) + #SW_RPDIRTY + i, 0)
  Next
  RpOvUsed = 0
  RpPresent = 1
  RpReset()
EndProcedure

Procedure RpBanner()                     ; PsramBanner's words on it
  Say("; RP03 drive 0 on the RP11: blocks ") : Num(RpFirst) : Say("-") : Num(RpFirst + RpBlocks - 1)
  Say(" (") : Num(RpSlots) : Say(" stored in flash), its writes held in PSRAM (room for ") : Num(#RP_OV_SLOTS)
  Say(" blocks) until Ctrl-] w")
EndProcedure

; ---- the storage, on core 1 (PsDiskRead / PsDiskWrite, drive 8) ----------
; b counts from the pack's first block.
Procedure.l RpStoreRead(b.l)
  Define i.l, w.l, s.l, a.l
  s = 0
  If b >= 0 And b < RpBlocks
    s = PeekU(#PS_WIN + #PS_RK1 + b * 2)
    If s
      a = #PS_WIN + #PS_RK1 + #RP_OV_MAP + #RP_OV_LIST + (s - 1) * 512
    Else
      s = PeekU($10000000 + #FL_RK1 + 4096 + b * 2)
      a = $10000000 + RpData + (s - 1) * 512
    EndIf
  EndIf
  If s = 0
    For i = 0 To 255
      DkBuf(i) = 0
    Next
    ProcedureReturn 1
  EndIf
  For i = 0 To 127
    w = PeekL(a + i * 4)
    DkBuf(i * 2) = w & $FFFF
    DkBuf(i * 2 + 1) = (w >> 16) & $FFFF
  Next
  ProcedureReturn 1
EndProcedure

Procedure.i RpStoreWrite(b.i)
  Define i.i, s.i, a.i
  If b < 0 Or b >= RpBlocks
    ProcedureReturn -1
  EndIf
  s = PeekU(#PS_WIN + #PS_RK1 + b * 2)
  If s = 0
    If RpOvUsed >= #RP_OV_SLOTS
      If RpOvStuck                       ; a save could not empty it (the flash refused): an error now
        RpOvFull = RpOvFull + 1
        ProcedureReturn -1
      EndIf
      If PsSaveReq = 0                   ; full: a save, as Ctrl-] w would ask (core 0 runs it between slices)
        RpAutoSave = 1
        RpAutoSaves = RpAutoSaves + 1
        SmpBarrier()
        PsSaveReq = 1
      EndIf
      ProcedureReturn 0                  ; not yet: DkServe asks again on its next pass, after the save
    EndIf
    RpOvUsed = RpOvUsed + 1
    s = RpOvUsed
    PokeU(#PS_WIN + #PS_RK1 + #RP_OV_MAP + (s - 1) * 2, b)
    PokeU(#PS_WIN + #PS_RK1 + b * 2, s)
  EndIf
  a = #PS_WIN + #PS_RK1 + #RP_OV_MAP + #RP_OV_LIST + (s - 1) * 512
  For i = 0 To 127
    PokeL(a + i * 4, DkBuf(i * 2) | (DkBuf(i * 2 + 1) << 16))
  Next
  PokeA(@DkSwapRam(0) + #SW_RPDIRTY + s - 1, 1)   ; for the next save into the store (store.pico2)
  StDirty = 1
  StLastWrite = Micros()
  ProcedureReturn 1
EndProcedure

; Block b's 512 bytes at address src into the overlay, not marked changed:
; the store's copy, at start-up (StInit). 0 the overlay is full.
Procedure.i RpOvPut(b.i, src.i)
  Define i.i, s.i, a.i
  If b < 0 Or b >= RpBlocks
    ProcedureReturn 0
  EndIf
  s = PeekU(#PS_WIN + #PS_RK1 + b * 2)
  If s = 0
    If RpOvUsed >= #RP_OV_SLOTS
      ProcedureReturn 0
    EndIf
    RpOvUsed = RpOvUsed + 1
    s = RpOvUsed
    PokeU(#PS_WIN + #PS_RK1 + #RP_OV_MAP + (s - 1) * 2, b)
    PokeU(#PS_WIN + #PS_RK1 + b * 2, s)
  EndIf
  a = #PS_WIN + #PS_RK1 + #RP_OV_MAP + #RP_OV_LIST + (s - 1) * 512
  For i = 0 To 127
    PokeL(a + i * 4, PeekL(src + i * 4))
  Next
  PokeA(@DkSwapRam(0) + #SW_RPDIRTY + s - 1, 0)
  ProcedureReturn 1
EndProcedure

; Overlay blocks changed since the last save.
Procedure.i RpDirtyCount()
  Define i.i, n.i
  For i = 0 To RpOvUsed - 1
    n = n + PeekA(@DkSwapRam(0) + #SW_RPDIRTY + i)
  Next
  ProcedureReturn n
EndProcedure

; The PSRAM address of the overlay's copy of block b, 0 if it has none.
Procedure.l RpOvAddr(b.l)
  Define s.l
  s = PeekU(#PS_WIN + #PS_RK1 + b * 2)
  If s = 0
    ProcedureReturn 0
  EndIf
  ProcedureReturn #PS_WIN + #PS_RK1 + #RP_OV_MAP + #RP_OV_LIST + (s - 1) * 512
EndProcedure

; ---- Ctrl-] w: the overlay into the flash (PsSave, core 0, PDP-11 paused) -
;  Each overlay block goes into its own slot if the map gives it one, else
;  into a new slot after the last. The work lists live in the swap RAM
;  disk's SRAM (idle when the PSRAM is in use), after the 4 KB staging
;  buffer: from byte 4096 a u16 per overlay slot (its destination slot, 0
;  = no room), from 12288 a byte per data sector (1 = rewrite), from 28672
;  a byte per map sector.
Procedure RpSave()
  Define buf.i, dst.i, dsec.i, msec.i, i.i, j.i, k.i, b.i, m.i, s.i, n.i, r.i, t0.i, ndsec.i
  RpSaveNew = 0 : RpSaveOld = 0 : RpSaveMap = 0 : RpSaveFail = 0
  If RpPresent = 0 Or RpOvUsed = 0
    ProcedureReturn
  EndIf
  t0 = Micros()
  While DkReqSeq <> DkDoneSeq And Micros() - t0 < 200000   ; a request still out finishes first
  Wend
  buf = @DkSwapRam(0)
  dst = buf + 4096
  dsec = buf + 12288
  msec = buf + 28672
  ndsec = (RpRoom + 7) / 8
  If ndsec > 16384
    ndsec = 16384
  EndIf
  For i = 0 To ndsec - 1
    PokeA(dsec + i, 0)
  Next
  For i = 0 To RpMapSectors - 1
    PokeA(msec + i, 0)
  Next
  n = RpSlots
  For i = 0 To RpOvUsed - 1              ; where each goes
    b = PeekU(#PS_WIN + #PS_RK1 + #RP_OV_MAP + i * 2)
    m = PeekU($10000000 + #FL_RK1 + 4096 + b * 2)
    If m = 0
      If n >= RpRoom
        RpSaveFail = RpSaveFail + 1      ; the flash is full: this one stays in the overlay
        PokeU(dst + i * 2, 0)
        Continue
      EndIf
      n = n + 1
      m = n
      PokeA(msec + (b * 2) / 4096, 1)
      RpSaveNew = RpSaveNew + 1
    Else
      RpSaveOld = RpSaveOld + 1
    EndIf
    PokeU(dst + i * 2, m)
    PokeA(dsec + (m - 1) / 8, 1)
  Next
  For k = 0 To ndsec - 1                 ; the data sectors, each with every overlay slot that lands in it
    If PeekA(dsec + k)
      For j = 0 To 1023
        If k * 8 + j / 128 < RpSlots
          PokeL(buf + j * 4, PeekL($10000000 + RpData + k * 4096 + j * 4))
        Else
          PokeL(buf + j * 4, 0)          ; past the old end: nothing there yet
        EndIf
      Next
      For i = 0 To RpOvUsed - 1
        m = PeekU(dst + i * 2)
        If m
          If (m - 1) / 8 = k
            s = #PS_WIN + #PS_RK1 + #RP_OV_MAP + #RP_OV_LIST + i * 512
            For j = 0 To 127
              PokeL(buf + ((m - 1) & 7) * 512 + j * 4, PeekL(s + j * 4))
            Next
          EndIf
        EndIf
      Next
      r = PsWriteSector(RpData + k * 4096, buf)
      If r < 0
        RpSaveFail = RpSaveFail + 1
        ProcedureReturn                  ; the map is not touched: the flash still reads as before
      EndIf
    EndIf
  Next
  For k = 0 To RpMapSectors - 1          ; then the map, so a save cut short leaves the old map
    If PeekA(msec + k)
      For j = 0 To 1023
        PokeL(buf + j * 4, PeekL($10000000 + #FL_RK1 + 4096 + k * 4096 + j * 4))
      Next
      For i = 0 To RpOvUsed - 1
        b = PeekU(#PS_WIN + #PS_RK1 + #RP_OV_MAP + i * 2)
        m = PeekU(dst + i * 2)
        If m
          If (b * 2) / 4096 = k
            PokeU(buf + ((b * 2) & 4095), m)
          EndIf
        EndIf
      Next
      r = PsWriteSector(#FL_RK1 + 4096 + k * 4096, buf)
      If r < 0
        RpSaveFail = RpSaveFail + 1
        ProcedureReturn
      EndIf
      RpSaveMap = RpSaveMap + 1
    EndIf
  Next
  RpSlots = n
  j = 0                                  ; the overlay keeps only what could not be saved
  For i = 0 To RpOvUsed - 1
    b = PeekU(#PS_WIN + #PS_RK1 + #RP_OV_MAP + i * 2)
    If PeekU(dst + i * 2)
      PokeU(#PS_WIN + #PS_RK1 + b * 2, 0)
    Else
      If j <> i
        s = #PS_WIN + #PS_RK1 + #RP_OV_MAP + #RP_OV_LIST
        For k = 0 To 127
          PokeL(s + j * 512 + k * 4, PeekL(s + i * 512 + k * 4))
        Next
        PokeU(#PS_WIN + #PS_RK1 + #RP_OV_MAP + j * 2, b)
      EndIf
      PokeA(@DkSwapRam(0) + #SW_RPDIRTY + j, 1)   ; not in the packs: the next save takes it
      j = j + 1
      PokeU(#PS_WIN + #PS_RK1 + b * 2, j)
    EndIf
  Next
  For i = j To #RP_OV_SLOTS - 1
    PokeA(@DkSwapRam(0) + #SW_RPDIRTY + i, 0)
  Next
  SmpBarrier()                           ; the overlay's map, then its count (core 1's RpStoreWrite reads it)
  RpOvUsed = j
  RpOvStuck = Bool(j >= #RP_OV_SLOTS)
EndProcedure
CompilerEndIf

