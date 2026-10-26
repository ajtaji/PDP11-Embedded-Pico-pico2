"""Native indexed single-operand forms, with unchanged generic fault paths.
"""
from pathlib import Path
from asm_mov_gen import TAIL,U0,U1
FORMS=[('CLR_0050','clr',0x0a30),('TST_0057','tst',0x0bf0),('INC_0052','inc',0x0ab0),('DEC_0053','dec',0x0af0),('CLRB_1050','clrb',0x8a30),('TSTB_1057','tstb',0x8bf0)]
G0='; ---- INDEXED SINGLE NATIVE ----\n';G1='; ---- END INDEXED SINGLE NATIVE ----\n'

def body(name,kind,mapped):
 tag='__ix_'+kind+('m' if mapped else 'u');suffix='M' if mapped else '';slow=tag+'_slow';byte=kind.endswith('b');write=kind not in ('tst','tstb')
 s='    mov r2, r9\n'
 if mapped:
  s+=f'''    ldr r0, =global_fw
    ldr r3, [r0]
    cmp r2, r3
    blt {slow}
    ldr r3, [r0, #4]
    cmp r2, r3
    bge {slow}
    ldr r0, [r0, #8]
'''
 else:s+=f'    ldr r0, =#RAM_BYTES\n    cmp r2, r0\n    bhs {slow}\n    ldr r0, =global_mem\n'
 s+='    ldrh r0, [r0, r2]\n    mov r1, r8\n    lsls r1, r1, #29\n    lsrs r1, r1, #29\n'
 s+=f'''    cmp r1, #7
    beq {tag}_pc
    lsls r1, r1, #2
    ldr r2, =global_reg
    ldr r2, [r2, r1]
    b {tag}_base
{tag}_pc:
    mov r2, r9
    adds r2, #2
    uxth r2, r2
{tag}_base:
    adds r0, r0, r2
    uxth r0, r0
'''
 if not byte:s+=f'    lsrs r1, r0, #1\n    bcs {slow}\n'
 if mapped:
  lo,hi=(8,12) if write else (0,4)
  s+=f'''    ldr r2, =global_curd
    ldr r2, [r2]
    add.w r2, r2, r0, lsr #13
    lsls r2, r2, #5
    ldr r3, =global_mapf
    adds r2, r2, r3
    ldr r3, [r2, #{lo}]
    cmp r0, r3
    blt {slow}
    ldr r3, [r2, #{hi}]
    cmp r0, r3
    bge {slow}
    ldr r3, [r2, #16]
'''
 else:s+=f'    ldr r3, =#RAM_BYTES\n    cmp r0, r3\n    bhs {slow}\n    ldr r3, =global_mem\n'
 s+='    adds r3, r3, r0\n'
 if kind in ('clr','clrb'):
  s+='    movs r0, #0\n    '+('strb' if byte else 'strh')+' r0, [r3]\n    movs r4, #0\n'
 elif kind in ('tst','tstb'):
  s+='    '+('ldrb' if byte else 'ldrh')+' r4, [r3]\n'
  if byte:s+='    lsls r4, r4, #8\n'
 if kind in ('clr','clrb','tst','tstb'):
  s+='    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n    ldr r1, =global_flagc\n    str r0, [r1]\n'
 else:
  s+='    ldrh r0, [r3]\n    '+('adds' if kind=='inc' else 'subs')+' r2, r0, #1\n    uxth r2, r2\n    strh r2, [r3]\n    mov r10, r2\n    movs r4, r2\n'
  s+=('    movs r1, r2\n    bics r1, r0\n' if kind=='inc' else '    movs r1, r0\n    bics r1, r2\n')+'    ldr r3, =global_flagv\n    str r1, [r3]\n'
 s+='    mov r0, r9\n    adds r0, #2\n    uxth r0, r0\n    mov r9, r0\n'
 uses='PC, Op, FlagNZ'+(', Res' if kind in ('inc','dec') else '')
 guard='#ASM_INDEXED = 1'
 head='InstructionIX_'+name+suffix+':\nCompilerIf '+guard+'\n  ASM Uses '+uses+'\n'+s+'  EndASM\nCompilerIf #DISK_BACKEND = 0\n  SingleHit = SingleHit + 1\nCompilerEndIf\n'
 if mapped:tail='  NextNativeM()\n'
 else:tail='  ASM Uses PC, Op, RunLeft\n'+TAIL+'  EndASM\n'
 return head+tail+'  ASM\n'+slow+':\n  EndASM\nCompilerEndIf\n  Goto Instruction'+name+('RefM' if mapped else '')+'\n\n'

def generate(text):
 text=text.replace('OpAsmM.Label(59)','OpAsmM.Label(65)').replace('OpRefM.Label(59)','OpRefM.Label(65)')
 at='InstructionIMX_MOVB_11M:';assert text.count(at)==1;text=text.replace(at,''.join(body(n,k,True) for n,k,_ in FORMS)+at,1)
 fill='CompilerIf #ASM_INDEXED = 1\n'
 for n,k,c in FORMS:fill+='  OpTableM($'+format(c>>3,'X')+') = ?InstructionIX_'+n+'M\n'
 fill+='CompilerEndIf\n'
 for i,(n,k,c) in enumerate(FORMS):fill+='  OpAsmM('+str(59+i)+') = ?InstructionIX_'+n+'M\n  OpRefM('+str(59+i)+') = ?Instruction'+n+'RefM\n'
 return text.replace('  OpTableReadyM = 1\n',fill+'  OpTableReadyM = 1\n',1)

def generate_pico(text):
 while U0+G0 in text:
  a=text.index(U0+G0);b=text.index(G1+U1,a)+len(G1+U1);text=text[:a]+text[b:]
 at='; ---- INDEXED HANDLERS ----\n';assert text.count(at)==1;text=text.replace(at,U0+G0+''.join(body(n,k,False) for n,k,_ in FORMS)+G1+U1+at,1)
 fill=U0+G0+'CompilerIf #ASM_INDEXED = 1\n'
 for n,k,c in FORMS:fill+='  OpTable($'+format(c>>3,'X')+') = ?InstructionIX_'+n+'\n'
 fill+='CompilerEndIf\nCompilerIf #DISK_BACKEND = 0\n'
 for i,(n,k,c) in enumerate(FORMS):fill+='  FastAsm('+str(34+i)+') = ?InstructionIX_'+n+'\n  FastRef('+str(34+i)+') = ?Instruction'+n+'\n'
 fill+='CompilerEndIf\n'+G1+U1;at='; ---- INDEXED ENTRY POINTS ----\n';assert text.count(at)==1
 return text.replace(at,fill+at,1)

if __name__=='__main__':
 import sys
 p=Path(__file__).resolve().parents[1]/'J11_18MHz_KDJ11_BF/pico/instructions.pico';have=p.read_text();want=generate_pico(have)
 if '--check' in sys.argv:
  if have!=want:raise SystemExit('asm_indexed_gen: stale output')
 else:p.write_text(want)
 print('asm_indexed_gen: indexed single-operand handlers current')
