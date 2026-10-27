/ User-mode FP11 state transfer for the process isolation check.
.globl _loadfp, _readfp
_loadfp:
 mov 2(sp),r0
 tst (r0)+
 ldfps $200
 movf (r0)+,fr0
 movf (r0)+,fr1
 movf (r0)+,fr2
 movf (r0)+,fr3
 movf (r0)+,fr0
 movf fr0,fr4
 movf (r0)+,fr0
 movf fr0,fr5
 mov 2(sp),r0
 movf 2(r0),fr0
 ldfps (r0)
 rts pc
_readfp:
 mov 2(sp),r0
 stfps (r0)+
 ldfps $200
 movf fr0,(r0)+
 movf fr1,(r0)+
 movf fr2,(r0)+
 movf fr3,(r0)+
 movf fr4,fr0
 movf fr0,(r0)+
 movf fr5,fr0
 movf fr0,(r0)+
 mov 2(sp),r0
 movf 2(r0),fr0
 ldfps (r0)
 rts pc
