"""RP2350 native handlers for immediate source and indexed memory destination.
The opcode table selects these operand forms for all programs. Fast paths
check instruction and data windows before changing any emulated state.
"""
FORMS=[('MOVB_11','movb',0x95f0),('MOV_01','mov',0x15f0),('CMP_02','cmp',0x25f0),('ADD_06','add',0x65f0),('SUB_16','sub',0xe5f0),('BIT_03','bit',0x35f0),('BIC_04','bic',0x45f0),('BIS_05','bis',0x55f0)]

def body(name,kind):
 tag='__imx_'+kind
 write=kind not in ('cmp','bit')
 lo,hi=(8,12) if write else (0,4)
 s=f'''    mov r2, r9
    ldr r0, =global_fw
    ldr r3, [r0]
    cmp r2, r3
    blt {tag}_slow
    adds r3, r2, #2
    ldr r12, [r0, #4]
    cmp r3, r12
    bge {tag}_slow
    ldr r0, [r0, #8]
    ldrh r1, [r0, r2]
    ldrh r0, [r0, r3]
    and.w r3, r8, #7
    cmp r3, #7
    beq {tag}_pc
    ldr r2, =global_reg
    lsls r3, r3, #2
    ldr r3, [r2, r3]
    b {tag}_base
{tag}_pc:
    mov r3, r9
    adds r3, r3, #4
    uxth r3, r3
{tag}_base:
    adds r0, r0, r3
    uxth r0, r0
'''
 if kind!='movb':s+=f'    lsls r3, r0, #31\n    bne {tag}_slow\n'
 s+=f'''    ldr r2, =global_curd
    ldr r2, [r2]
    add.w r2, r2, r0, lsr #13
    lsls r2, r2, #5
    ldr r3, =global_mapf
    adds r2, r2, r3
    ldr r3, [r2, #{lo}]
    cmp r0, r3
    blt {tag}_slow
    ldr r3, [r2, #{hi}]
    cmp r0, r3
    bge {tag}_slow
    ldr r3, [r2, #16]
'''
 v0='    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n'
 if kind in ('mov','movb'):
  op='strh' if kind=='mov' else 'strb'
  s+='    '+op+' r1, [r3, r0]\n'
  s+=('    mov.w r4, r1\n' if kind=='mov' else '    uxtb r4, r1\n    lsls r4, r4, #8\n')+v0
 else:
  s+='    adds r3, r3, r0\n    ldrh r0, [r3]\n'
  if kind in ('add','sub','cmp'):
   op={'add':'adds r2, r0, r1','sub':'subs r2, r0, r1','cmp':'subs r2, r1, r0'}[kind]
   s+='    '+op+'\n'
   if write:s+='    strh r2, [r3]\n'
   s+='    ldr r3, =global_flagc\n    str r2, [r3]\n'
   if kind=='add':s+='    eor.w r0, r0, r2\n    eor.w r1, r1, r2\n    and.w r0, r0, r1\n'
   elif kind=='sub':s+='    eor.w r1, r1, r0\n    eor.w r0, r0, r2\n    and.w r0, r0, r1\n'
   else:s+='    eor.w r0, r0, r1\n    eor.w r1, r1, r2\n    and.w r0, r0, r1\n'
   s+='    ldr r3, =global_flagv\n    str r0, [r3]\n    uxth r4, r2\n    mov r10, r4\n'
  else:
   op={'bit':'and.w r2, r0, r1','bic':'bic.w r2, r0, r1','bis':'orr.w r2, r0, r1'}[kind]
   s+='    '+op+'\n'
   if write:s+='    strh r2, [r3]\n    mov r10, r2\n'
   s+='    mov.w r4, r2\n'+v0
 s+='    mov r0, r9\n    adds r0, r0, #4\n    uxth r0, r0\n    mov r9, r0\n'
 uses='PC, Op, FlagNZ'+(', Res' if kind in ('add','sub','cmp','bic','bis') else '')
 return ('InstructionIMX_'+name+'M:\nCompilerIf #ASM_OPS = 1\n  ASM Uses '+uses+'\n'+s+'  EndASM\n  NextNativeM()\n  ASM\n'+tag+'_slow:\n  EndASM\nCompilerEndIf\n  Goto Instruction'+name+'RefM\n\n')

def generate(text):
 assert 'Global Dim OpAsmM.Label(51)' in text and 'Global Dim OpRefM.Label(51)' in text
 text=text.replace('Global Dim OpAsmM.Label(51)', 'Global Dim OpAsmM.Label(59)').replace('Global Dim OpRefM.Label(51)', 'Global Dim OpRefM.Label(59)')
 at='InstructionMOV_01M:'
 assert text.count(at)==1
 text=text.replace(at,''.join(body(n,k) for n,k,_ in FORMS)+at,1)
 fill=''
 for i,(n,k,code) in enumerate(FORMS):
  label='InstructionIMX_'+n+'M'
  fill+='  OpTableM($'+format(code>>3,'X')+') = ?'+label+'\n'
  fill+='  OpAsmM('+str(51+i)+') = ?'+label+'\n  OpRefM('+str(51+i)+') = ?Instruction'+n+'RefM\n'
 text=text.replace('  OpTableReadyM = 1\n',fill+'  OpTableReadyM = 1\n',1)
 return text

def thumb1_body(name,kind):
 from asm_mov_gen import TAIL
 tag='__imx1_'+kind
 s=f'''    mov r2, r9
    adds r3, r2, #2
    ldr r0, =#RAM_BYTES
    cmp r3, r0
    bhs {tag}_slow
    ldr r0, =global_mem
    ldrh r1, [r0, r2]
    ldrh r0, [r0, r3]
    mov r3, r8
    lsls r3, r3, #29
    lsrs r3, r3, #29
    cmp r3, #7
    beq {tag}_pc
    ldr r2, =global_reg
    lsls r3, r3, #2
    ldr r3, [r2, r3]
    b {tag}_base
{tag}_pc:
    mov r3, r9
    adds r3, #4
    uxth r3, r3
{tag}_base:
    adds r0, r0, r3
    uxth r0, r0
    ldr r3, =#RAM_BYTES
    cmp r0, r3
    bhs {tag}_slow
'''
 if kind!='movb':s+=f'    lsrs r3, r0, #1\n    bcs {tag}_slow\n'
 s+='    ldr r3, =global_mem\n'
 v0='    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n'
 if kind in ('mov','movb'):
  s+='    '+('strb' if kind=='movb' else 'strh')+' r1, [r3, r0]\n'
  s+=('    uxtb r4, r1\n    lsls r4, r4, #8\n' if kind=='movb' else '    movs r4, r1\n')+v0
 else:
  s+='    adds r3, r3, r0\n    ldrh r0, [r3]\n'
  if kind in ('add','sub','cmp'):
   s+='    '+{'add':'adds r2, r0, r1','sub':'subs r2, r0, r1','cmp':'subs r2, r1, r0'}[kind]+'\n'
   if kind!='cmp':s+='    strh r2, [r3]\n'
   s+='    ldr r3, =global_flagc\n    str r2, [r3]\n'
   s+= {'add':'    eors r0, r2\n    eors r1, r2\n    ands r0, r1\n','sub':'    eors r1, r0\n    eors r0, r2\n    ands r0, r1\n','cmp':'    eors r0, r1\n    eors r1, r2\n    ands r0, r1\n'}[kind]
   s+='    ldr r3, =global_flagv\n    str r0, [r3]\n    uxth r4, r2\n    mov r10, r4\n'
  else:
   s+='    movs r2, r0\n    '+{'bit':'ands','bic':'bics','bis':'orrs'}[kind]+' r2, r1\n'
   if kind!='bit':s+='    strh r2, [r3]\n    mov r10, r2\n'
   s+='    movs r4, r2\n'+v0
 s+='    mov r0, r9\n    adds r0, #4\n    uxth r0, r0\n    mov r9, r0\n'
 uses='PC, RunLeft, Op, FlagNZ'+(', Res' if kind in ('add','sub','cmp','bic','bis') else '')
 return ('InstructionIMX_'+name+':\nCompilerIf #ASM_IMX = 1\n  ASM Uses '+uses+'\n'+s+TAIL+'  EndASM\n  ASM\n'+tag+'_slow:\n  EndASM\nCompilerEndIf\n  Goto Instruction'+name+'\n\n')

def generate_pico(s):
 from asm_mov_gen import U0,U1
 import re
 g0='; ---- IMMEDIATE INDEXED THUMB1 ----\n';g1='; ---- END IMMEDIATE INDEXED THUMB1 ----\n'
 while U0+g0 in s:
  a=s.index(U0+g0);b=s.index(g1+U1,a)+len(g1+U1);s=s[:a]+s[b:]
 at='; ---- IMX HANDLERS ----\n'
 block=U0+g0+''.join(thumb1_body(n,k) for n,k,_ in FORMS)+g1+U1
 s=s.replace(at,block+at,1)
 fill=U0+g0
 for i,(n,k,code) in enumerate(FORMS):
  fill+='  OpTable($'+format(code>>3,'X')+') = ?InstructionIMX_'+n+'\n'
 fill+='CompilerIf #DISK_BACKEND = 0\n'
 for i,(n,k,_) in enumerate(FORMS):
  fill+='  FastAsm('+str(26+i)+') = ?InstructionIMX_'+n+'\n  FastRef('+str(26+i)+') = ?Instruction'+n+'\n'
 fill+='CompilerEndIf\n'+g1+U1
 at='; ---- IMX ENTRY POINTS ----\n';assert s.count(at)==1;s=s.replace(at,fill+at)
 return s

if __name__=='__main__':
 from pathlib import Path
 import sys
 p=Path(__file__).resolve().parents[1]/'J11_18MHz_KDJ11_BF/pico/instructions.pico'
 have=p.read_text();want=generate_pico(have)
 if '--check' in sys.argv:
  if want!=have:raise SystemExit('asm_imm_index_gen: stale RP2040 output')
 else:p.write_text(want)
 print('asm_imm_index_gen: RP2040 native immediate/indexed forms current')
