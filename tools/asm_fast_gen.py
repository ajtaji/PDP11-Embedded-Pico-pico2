"""Generate the RP2040's Thumb-1 branch and register handlers.
Mapped generation strips the marked sections and keeps the original Basic.
Reference bodies are retained in the diskless hardware differential test.
"""
from pathlib import Path
import re
from asm_mov_gen import TAIL, U0, U1
from mmu_gen import BRANCHES
P=Path(__file__).resolve().parents[1]/'J11_18MHz_KDJ11_BF/pico/instructions.pico'
G0='; ---- FAST THUMB1 ----\n'
G1='; ---- END FAST THUMB1 ----\n'

def branches(name):
    z='    lsls r0, r4, #16\n'
    n='    movs r0, r4\n    lsrs r1, r0, #1\n    orrs r0, r1\n    lsls r0, r0, #16\n    lsrs r0, r0, #31\n'
    v='    ldr r1, =global_flagv\n    ldr r1, [r1]\n    lsls r0, r1, #16\n    lsrs r0, r0, #31\n'
    c='    ldr r1, =global_flagc\n    ldr r1, [r1]\n    lsls r0, r1, #15\n    lsrs r0, r0, #31\n'
    nv='    movs r0, r4\n    lsrs r1, r0, #1\n    orrs r0, r1\n    ldr r1, =global_flagv\n    ldr r1, [r1]\n    eors r0, r1\n    lsls r0, r0, #16\n    lsrs r0, r0, #31\n'
    tests={'BR_Z':z,'BR_N':n,'BR_V':v,'BR_C':c,'BR_NV':nv}
    import mmu_gen
    tag='__t1_'+name.lower()
    s=''
    for t,b in BRANCHES[name]:
        key=next(k for k in tests if t==getattr(mmu_gen,k))
        op,label=b.split();s+=tests[key]+'    '+op+' '+tag+'_'+label+'\n'
    s+=tag+'_tk:\n    mov r0, r8\n    lsls r0, r0, #24\n    asrs r0, r0, #23\n    mov r1, r9\n    adds r0, r0, r1\n    uxth r0, r0\n    mov r9, r0\n'+tag+'_nt:\n'
    return s

V0='    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n'
C0='    ldr r1, =global_flagc\n    str r0, [r1]\n'

def reg(name):
    kind=name.split('_')[0].lower(); tag='__t1_'+name.lower()
    s='    mov r0, r8\n    movs r1, #7\n    ands r0, r1\n    cmp r0, #7\n    beq __ul_cpurun_instruction'+name.lower()+'ref\n    lsls r0, r0, #2\n    ldr r1, =global_reg\n    adds r1, r1, r0\n'
    if name.endswith('_RR'):
        s+='    mov r0, r8\n    lsls r0, r0, #23\n    lsrs r0, r0, #29\n    lsls r0, r0, #2\n    ldr r2, =global_reg\n    ldr r0, [r2, r0]\n    ldr r2, [r1]\n'
        # r0 source, r1 destination pointer, r2 destination.
        if kind=='mov': return s+'    str r0, [r1]\n    movs r4, r0\n'+V0
        if kind=='cmp':
            return s+'    subs r3, r0, r2\n    mov r10, r3\n    ldr r1, =global_flagc\n    str r3, [r1]\n    eors r2, r0\n    eors r0, r3\n    ands r0, r2\n    ldr r1, =global_flagv\n    str r0, [r1]\n    uxth r4, r3\n'
        if kind in ('add','sub'):
            op='adds r3, r2, r0' if kind=='add' else 'subs r3, r2, r0'
            s+='    '+op+'\n'
            s+='    mov r10, r3\n    uxth r4, r3\n    str r4, [r1]\n    ldr r1, =global_flagc\n    str r3, [r1]\n'
            if kind=='add': s+='    eors r0, r3\n    eors r2, r3\n    ands r0, r2\n'
            else:s+='    eors r0, r2\n    eors r2, r3\n    ands r0, r2\n'
            return s+'    ldr r1, =global_flagv\n    str r0, [r1]\n'
        if kind in ('bit','bic','bis'):
            if kind=='bit':return s+'    ands r0, r2\n    movs r4, r0\n'+V0
            s+=('    bics r2, r0\n' if kind=='bic' else '    orrs r2, r0\n')+'    str r2, [r1]\n    mov r10, r2\n    movs r4, r2\n'
            return s+V0
    if kind=='clr':return s+'    movs r0, #0\n    str r0, [r1]\n    movs r4, #0\n'+V0+C0
    if kind=='tst':return s+'    ldr r4, [r1]\n'+V0+C0
    if kind in ('inc','dec'):
        edge='0x7fff' if kind=='inc' else '0x8000'; op='adds' if kind=='inc' else 'subs'
        return s+'    ldr r0, [r1]\n    '+op+' r3, r0, #1\n    uxth r3, r3\n    str r3, [r1]\n    mov r10, r3\n    movs r4, r3\n    ldr r2, ='+edge+'\n    movs r1, #0\n    cmp r0, r2\n    bne '+tag+'_nov\n    movs r1, #128\n    lsls r1, r1, #8\n'+tag+'_nov:\n    ldr r2, =global_flagv\n    str r1, [r2]\n'
    raise ValueError(name)

REGS=['MOV_01_RR','CMP_02_RR','ADD_06_RR','SUB_16_RR','BIT_03_RR','BIC_04_RR','BIS_05_RR','CLR_0050_R','TST_0057_R','INC_0052_R','DEC_0053_R']
NAMES=list(BRANCHES)+REGS

def strip(s):
    while U0+G0 in s:
        a=s.index(U0+G0); b=s.index(G1+U1,a)+len(G1+U1);s=s[:a]+s[b:]
    return s

def build(s):
    s=strip(s)
    for name in NAMES:
        lab='Instruction'+name+':'
        a=s.index(lab);a=s.index('\n',a)+1
        # The old body is both the unmapped reference and the mapped source.
        b=re.search(r'^Instruction\w+:',s[a:],re.M)
        if not b:raise ValueError(name)
        b=a+b.start()
        body=branches(name) if name in BRANCHES else reg(name)
        # Register R7 must use the plain handler even in production.
        # Keep its existing first If (the R7 bailout) outside the conditional.
        plain=s[a:b]
        prefix=''
        if name in REGS:
            end=plain.index('  EndIf\n')+len('  EndIf\n')
            prefix=plain[:end];plain=plain[end:]
            body=body.replace('    beq __ul_cpurun_instruction'+name.lower()+'ref\n','    beq __ul_cpurun_instruction'+name.rsplit('_',1)[0].lower()+'\n')
        use=['PC','RunLeft','Op']+(['FlagNZ'] if re.search(r'\br4\b',body) else [])+(['Res'] if re.search(r'\br10\b',body) else [])
        head=U0+G0+'CompilerIf #ASM_FAST = 1\n  ASM Uses '+', '.join(use)+'\n'+body+TAIL+'  EndASM\nCompilerEndIf\nCompilerIf #ASM_FAST = 0 Or #DISK_BACKEND = 0\nInstruction'+name+'Ref:\n'+G1+U1
        tail=U0+G0+'CompilerEndIf\n'+G1+U1
        s=s[:a]+head+prefix+plain+tail+s[b:]
    at='; ---- FAST ENTRY POINTS ----\n'
    fill=U0+G0+'CompilerIf #DISK_BACKEND = 0\n'
    for i,n in enumerate(NAMES):fill+='  FastAsm('+str(i)+') = ?Instruction'+n+'\n  FastRef('+str(i)+') = ?Instruction'+n+'Ref\n'
    fill+='CompilerEndIf\n'+G1+U1
    assert s.count(at)==1;s=s.replace(at,fill+at)
    return s

if __name__=='__main__':
    import sys
    have=P.read_text(); want=build(have)
    if '--check' in sys.argv:
        if want!=have:raise SystemExit('asm_fast_gen: stale output')
    else:P.write_text(want)
    print('asm_fast_gen: '+str(len(NAMES))+' Thumb-1 handlers current')
