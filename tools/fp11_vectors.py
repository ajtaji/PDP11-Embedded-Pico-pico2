"""Generate exact integer reference vectors for the native RP2040 FP checks.

No guest instructions are executed here. The identities are full 32x32
multiplication, product bits 56..119, and quotient/remainder of scaled
integers. Run with --check to verify the committed fixture data.
"""
import sys
from pathlib import Path
import random
r=random.Random(0x11F02040);mask=(1<<32)-1
lines=['; Exact integer identities, deterministic seed 0x11F02040.','DataSection','mul_vectors:']
for i in range(1024):
 a=[0,1,0xffff,0x10000,0x7fffffff,0x80000000,0xffffffff][i%7] if i<49 else r.getrandbits(32)
 b=[0,1,0xffff,0x10000,0x7fffffff,0x80000000,0xffffffff][i//7] if i<49 else r.getrandbits(32)
 p=a*b;v=[a,b,(p>>32)&mask,p&mask];lines.append('Data.l '+','.join('$%08X'%x for x in v))
lines+=['frac_vectors:']
for i in range(1024):
 a=r.randrange(1<<55,1<<56);b=r.randrange(1<<55,1<<56)
 if i<16:a=[0,1,(1<<55),(1<<56)-1][i%4];b=[0,1,(1<<55),(1<<56)-1][i//4]
 p=(a*(b<<3))>>56;v=[a>>32,a&mask,b>>32,b&mask,(p>>32)&mask,p&mask];lines.append('Data.l '+','.join('$%08X'%x for x in v))
lines+=['div_vectors:']
for i in range(1024):
 b=r.randrange(1<<57,1<<59);a=r.randrange(0,2*b);n=[0,1,2,27,31,32,59,63][i%8];d=i%2
 if i<8:a=[0,b-1,b,b+1,2*b-1,1,b//2,b][i]
 q=(a<<(n-1))//b if n else 0;rem=2*((a<<(n-1))%b) if n else a
 v=[a>>32,a&mask,b>>32,b&mask,n,d,(q>>(32 if d else 0))&mask,(q&mask) if d else 0,rem>>32,rem&mask]
 lines.append('Data.l '+','.join('$%08X'%x for x in v))
lines+=['shift_vectors:']
for i in range(1024):
 a=r.getrandbits(64);n=i%64
 if i<8:a=[0,1,(1<<32)-1,1<<32,1<<63,(1<<64)-1,0x8000000080000000,0x7fffffff7fffffff][i]
 l=(a<<n)&((1<<64)-1);rr=a>>n
 v=[a>>32,a&mask,n,l>>32,l&mask,rr>>32,rr&mask]
 lines.append('Data.l '+','.join('$%08X'%x for x in v))
lines+=['EndDataSection']
target = Path(__file__).resolve().parents[1] / 'J11_18MHz_KDJ11_BF/pico/fp_vectors.pmi'
data = '\n'.join(lines)+'\n'
if '--check' in sys.argv:
 assert target.read_text() == data, 'floating-point vectors are stale'
 print('FP VECTORS PASS: exact integer identities, fixed seed')
else:
 target.write_text(data, encoding='utf-8', newline='\n')
