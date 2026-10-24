XIncludeFile "../machine.pbi"
XIncludeFile "../gen/core.pbi"
OpenConsole()
FpInit()
Define ah.l, al.l, bh.l, bl.l
; 020052 125252 125252 125252 fraction with hidden bit, times 020300 0 0 0
PH(#P_FAC) = ($2052A << 0) : ah = ($102A << 16) | $AAAA : al = $AAAAAAAA
bh = ($10C0 << 16) : bl = 0
PH(#P_FAC) = ah : PL(#P_FAC) = al : PH(#P_SRC) = bh : PL(#P_SRC) = bl
FpGetFrac(#P_FF, #P_FAC) : FpGetFrac(#P_SF, #P_SRC)
PrintN("ff " + Hex(PH(#P_FF) & $FFFFFFFF) + " " + Hex(PL(#P_FF) & $FFFFFFFF) + "  sf " + Hex(PH(#P_SF) & $FFFFFFFF) + " " + Hex(PL(#P_SF) & $FFFFFFFF))
FpFracMulRef()
PrintN("ref " + Hex(PH(#P_FF) & $FFFFFFFF) + " " + Hex(PL(#P_FF) & $FFFFFFFF))
PrintN("ULt(-1,1)=" + Str(ULt(-1, 1)) + " ULt(1,-1)=" + Str(ULt(1, -1)) + " ULt($80000000,1)=" + Str(ULt($80000000, 1)))
Define x.l = -1
PrintN("x & $FFFFFFFF = " + Str(x & $FFFFFFFF))
