# Run under native V7 on a pristine full /usr distribution.
# Root single-user; /usr must be mounted from /dev/rp3.
# Original NBUF must be 29; do not run these edits twice.
cd /usr/sys/h
ed param.h <<'V7EDIT'

/NBUF/s/29/29/
w
q
V7EDIT
grep NBUF param.h
cd ../sys
ed slp.c <<'V7EDIT'

/^newproc()/
/p = NULL;/i
if(u.u_fpsaved==0) { savfp(&u.u_fps); u.u_fpsaved=1; }
.
w
q
V7EDIT
ed sys1.c <<'V7EDIT'

/^setregs()/
/for(i=0; i<NOFILE;/i
u.u_fpsaved=1;
.
w
q
V7EDIT
cc -O -c main.c
cc -O -c slp.c
cc -O -c sys1.c
cd ../dev
cc -O -c bio.c
cp rp.c rpmap.c
ed rpmap.c <<'V7EDIT'

/unit = minor(bp->b_dev);/i
if(bp->b_flags&B_PHYS) mapalloc(bp);
.
w
q
V7EDIT
cc -O -c rpmap.c
cd ../conf
cp mch.s mchfp.s
ed mchfp.s <<'V7EDIT'

/_savfp:/
/setd/s/setd/ldfps $200/
/_restfp:/
/setd/s/setd/ldfps $200/
w
q
V7EDIT
as -o mchfp.o mch0.s mchfp.s
cat >pmconf <<'V7EDIT'

rk
rp
root rk 0
swap rk 0
swplo 4000
nswap 872
ht
V7EDIT
mkconf <pmconf
cc -c c.c
as -o l.o l.s
ld -i -x -o /rkfinal29 l.o mchfp.o c.o ../sys/main.o ../sys/slp.o ../sys/sys1.o ../dev/bio.o ../dev/rpmap.o ../sys/LIB1 ../dev/LIB2
size /rkfinal29
ls -l /rkfinal29
sum /rkfinal29
od /rkfinal29
