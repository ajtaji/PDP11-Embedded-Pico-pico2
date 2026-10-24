; desktop/machine.pbi - the desktop PDP-11's board: what the Pico's hardware and
; firmware give the core (J11_18MHz_KDJ11_BF/pico2), done on the PC. Included
; before gen/core.pbi.
EnableExplicit

; ---- the build's constants (diag.pico2 sets these on the board) -----------
#PSRAM = 0                ; no PSRAM chip (and so no RP11 storage in flash: machine_disk.pbi)
#SRAM_MEM_KB = 248        ; Mem(): all an 18-bit machine reaches below its I/O page (cpu.pico2)
#DESK_MEM = 1             ; the memory past it, as a board with PSRAM has it (desktop_gen.py)
#DEMO_DEV = 0             ; the board's demo-device hooks (pico2/demo_dev.pico2) stay out: the desktop has its own (machine_demo.pbi)
#DESK_MEM_TOP = $3B9000   ; 3812 KB, the Pico Plus 2's (psram_pdp11.pico2, #PS_MEM_TOP)
Global PsMem.i = AllocateMemory(#DESK_MEM_TOP)   ; physical byte pa >= #RAM_BYTES is at PsMem + pa
#PSRAM_SRAM_KB = 224
#FLASH_CHIP = $1000000
#DISK_BACKEND = 2
#DISK_READ_ONLY = 0
#DISK_FLASH_MODEL = 0
#DESK_PROBE = 0
#STAT_CHIP = 0
#CLOCK_KHZ = 150000

; ---- the board's clock and cores -------------------------------------------
Global MachFreq.q, MachT0.q
QueryPerformanceFrequency_(@MachFreq)
QueryPerformanceCounter_(@MachT0)
Procedure.l Micros()                      ; microseconds, wrapping at 32 bits as on the board
  Protected t.q
  QueryPerformanceCounter_(@t)
  ProcedureReturn ((t - MachT0) * 1000000 / MachFreq) & $FFFFFFFF
EndProcedure

; SmpBarrier: cpu.pico2's own (its dmb, Arm assembly, is dropped: one thread on the PC)

; ---- the demo devices (machine_demo.pbi): what the core's hooks need first ---
#DEMO_BASE   = $E800                 ; 164000-164177
#INT_DEMO    = 32                    ; an IntReq bit no board device uses
#VEC_DEMO    = $D0                   ; 000320
Declare.l DdRead(a.l)
Declare DdWrite(a.l, v.l)
Declare DdWriteByte(a.l, v.l)
Declare DdPoll()
