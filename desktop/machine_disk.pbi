; desktop/machine_disk.pbi - the desktop PDP-11's disks: the board's disk.pico2
; interface (DiskRead / DiskWrite / DiskPresent / DiskWritable through DkBuf)
; over packs held in memory. Included by gen/core.pbi where the board includes
; disk.pico2.
;
; THE SAME IMAGE FILES. The packs come from the image a board is flashed with:
; a combined UF2 (images/*/combined.uf2) is read into a picture of the board's
; flash, and each pack is taken from its region as the firmware takes it
; (flash_layout.pico2: RK0 at $240000, RK1 or the RP03 at $4C0000):
;   "PDP11RK1"  an RK05 pack: +12 layout (0 dense, 1 mapped), +16 blocks stored;
;               dense: block n at +4096 + n * 512; mapped: a u16 map per block
;               at +4096 (slot + 1, 0 = never written), the data after the
;               map's sectors (tools/rk_image.py, build)
;   "PDP11RP1"  the RP03's pack: +12 blocks, +16 first block, +20 map sectors;
;               the map at +4096, the data from +4096 + map sectors * 4096
;               (pico2/rp11.pico2, THE PACK IN FLASH)
; A raw image file (.rk: 512-byte blocks) can be attached to a drive instead.
; Writes go to the packs in memory; the image file is not changed.
;
; Drives: 0 RK0, 1 RK1, 8 the RP03 (the board's drive number for it).

#MD_RK_BLOCKS = 4872               ; an RK05
#MD_RP_BLOCKS = 81200              ; an RP03: 406 * 20 * 10
#MD_FL_RK0 = $240000
#MD_FL_RK1 = $4C0000

Global Dim DkBuf.u(256)            ; the block being moved (rk11.pico2, rp11.pico2)
Global DkWhy.l                     ; why the last -1 (the board's meanings: 1 no pack, 2 past the end)
Global *MdPack0, *MdPack1, *MdRp   ; the packs, 512 bytes a block
Global MdPresent.l                 ; bit d: drive d has a pack (0, 1)
Global MdRpLoaded.l, MdRpBlocks.l     ; the RP pack: loaded, and its blocks (rp11.pico2 keeps RpBlocks too)
Global MdReads.l, MdWrites.l
Global MdWhat0$, MdWhat1$, MdWhatRp$   ; where each pack came from, for the window

Procedure.l DiskPresent(d.l)
  ProcedureReturn (MdPresent >> (d & 7)) & 1
EndProcedure

Procedure.l DiskWritable(d.l)
  ProcedureReturn DiskPresent(d)
EndProcedure

Procedure.i MdBlockAddr(d.l, blk.l)    ; the block's bytes, or 0
  If d = 0 And *MdPack0 And blk >= 0 And blk < #MD_RK_BLOCKS
    ProcedureReturn *MdPack0 + blk * 512
  ElseIf d = 1 And *MdPack1 And blk >= 0 And blk < #MD_RK_BLOCKS
    ProcedureReturn *MdPack1 + blk * 512
  ElseIf d = 8 And *MdRp And blk >= 0 And blk < MdRpBlocks
    ProcedureReturn *MdRp + blk * 512
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.l DiskRead(d.l, blk.l)
  Protected *a, i.l
  If d = 8 And MdRpLoaded And (blk < 0 Or blk >= MdRpBlocks)   ; outside the RP pack's blocks: zeros (rp11)
    For i = 0 To 255 : DkBuf(i) = 0 : Next
    ProcedureReturn 1
  EndIf
  *a = MdBlockAddr(d, blk)
  If *a = 0
    DkWhy = 1
    ProcedureReturn -1
  EndIf
  For i = 0 To 255
    DkBuf(i) = PeekU(*a + i * 2)
  Next
  MdReads + 1
  ProcedureReturn 1
EndProcedure

Procedure.l DiskWrite(d.l, blk.l)
  Protected *a, i.l
  *a = MdBlockAddr(d, blk)
  If *a = 0
    DkWhy = 2
    ProcedureReturn -1
  EndIf
  For i = 0 To 255
    PokeU(*a + i * 2, DkBuf(i))
  Next
  MdWrites + 1
  ProcedureReturn 1
EndProcedure
