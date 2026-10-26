"""RP2040 memory access helpers, with the original macros kept as references.
The MMU generator removes the marked Thumb-1 code and keeps its mapped calls.
"""
from pathlib import Path
import re
from asm_mov_gen import U0,U1
P=Path(__file__).resolve().parents[1]/'J11_18MHz_KDJ11_BF/pico/instructions.pico'
G0='; ---- MEMORY THUMB1 ----\n';G1='; ---- END MEMORY THUMB1 ----\n'
RES={'PC':'r9','Res':'r10','FlagNZ':'r4','Op':'r8','RunLeft':'r11'}
def load(v,r):
 if v in RES:return '    mov '+r+', '+RES[v]+'\n'
 if v=='0':return '    movs '+r+', #0\n'
 return '    ldr '+r+', =global_'+v.lower()+'\n    ldr '+r+', ['+r+']\n'
def store(v,r):
 if v in RES:return '    mov '+RES[v]+', '+r+'\n'
 return '    ldr r1, =global_'+v.lower()+'\n    str '+r+', [r1]\n'
def strip(s):
 while U0+G0 in s:
  a=s.index(U0+G0);b=s.index(G1+U1,a)+len(G1+U1);s=s[:a]+s[b:]
 return s

def build(s):
 s=strip(s)
 s=re.sub(r'( +M(?:Read|Write)(?:Word|Byte)\([^\n]+\)[^\n]*\n)\n',r'\1',s)
 def sub(m):
  direction,width,x,y=m.group(2,3,4,5)
  dest,adr=(x,y) if direction=='Read' else (None,x)
  val=None if direction=='Read' else y
  uses=[v for v in [adr,val,dest] if v in RES]
  body=load(adr,'r0')
  if val:body+=load(val,'r1')
  body+='    bl __t1_'+direction.lower()+width.lower()+'\n'
  if dest:body+=store(dest,'r0')
  return (U0+G0+'CompilerIf #ASM_MEM = 1\n  ASM'+(' Uses '+', '.join(dict.fromkeys(uses)) if uses else '')+'\n'+body+'  EndASM\nCompilerElse\n'+G1+U1+m.group(0)+U0+G0+'CompilerEndIf\n'+G1+U1)
 s,n=re.subn(r'^( +)M(Read|Write)(Word|Byte)\((\w+), (\w+)\)[^\n]*\n',sub,s,flags=re.M)
 if n<90:raise RuntimeError('memory sites moved: '+str(n))
 helper=''
 for direction in ['read','write']:
  for width in ['word','byte']:
   tag='__t1_'+direction+width
   helper+=tag+':\n    ldr r2, =#RAM_BYTES\n    cmp r0, r2\n    bhs '+tag+'_slow\n'
   if width=='word':helper+='    lsrs r2, r0, #1\n    bcs '+tag+'_slow\n'
   helper+='    ldr r2, =global_mem\n'
   op=('ldr' if direction=='read' else 'str')+('h' if width=='word' else 'b')
   helper+='    '+op+' '+('r0' if direction=='read' else 'r1')+', [r2, r0]\n    bx lr\n'+tag+'_slow:\n    b '+direction+width+'\n'
 block=U0+G0+'CompilerIf #ASM_MEM = 1\n  ASM\n'+helper+'  EndASM\nCompilerEndIf\n'+G1+U1
 s=s.replace('; ---- MEMORY HELPERS ----\n',block+'; ---- MEMORY HELPERS ----\n',1)
 return s
if __name__=='__main__':
 import sys
 have=P.read_text();want=build(have)
 if '--check' in sys.argv:
  if want!=have:raise SystemExit('asm_mem_gen: stale output')
 else:P.write_text(want)
 print('asm_mem_gen: memory helpers current')
