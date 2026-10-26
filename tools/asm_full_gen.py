"""Native word/byte operand handlers for both unmapped Arm loops.

The existing address/read/write helpers retain all device and fault behavior.
The Basic bodies remain the mapped source and diskless comparison reference.
"""
from pathlib import Path
import re
from asm_mov_gen import U0, U1

ROOT = Path(__file__).resolve().parents[1]
P = ROOT/'J11_18MHz_KDJ11_BF/pico/instructions.pico'
G0 = '; ---- FULL NATIVE OPERANDS ----\n'
G1 = '; ---- END FULL NATIVE OPERANDS ----\n'
FORMS = [('MOV_01', False), ('MOVB_11', True), ('CMP_02', False),
         ('ADD_06', False), ('SUB_16', False), ('BIT_03', False),
         ('BIC_04', False), ('BIS_05', False), ('CMPB_12', True),
         ('BITB_13', True), ('BICB_14', True), ('BISB_15', True)]
GUARD = '#ASM_FULL = 1 And #ASM_EA = 1 And #ASM_MEM = 1'


def body(name, byte):
    tag = '__full_'+name.lower()
    ea = '__eab1' if byte else '__eaw1'
    width = 'byte' if byte else 'word'
    code = f'''    ldr r1, =global_reg
    mov r0, r9
    str r0, [r1, #28]
    mov r0, r8
    lsrs r0, r0, #6
    movs r1, #63
    ands r0, r1
    cmp r0, #8
    blo {tag}_srcreg
    bl {ea}
    ldr r1, =global_ea
    str r0, [r1]
    bl __t1_read{width}
    b {tag}_source
{tag}_srcreg:
    lsls r0, r0, #2
    ldr r1, =global_reg
    ldr r0, [r1, r0]
'''
    if byte:
        code += '    uxtb r0, r0\n'
    code += f'''{tag}_source:
    ldr r1, =global_src
    str r0, [r1]
    mov r0, r8
    movs r1, #63
    ands r0, r1
    cmp r0, #8
    blo {tag}_dstreg
    bl {ea}
    ldr r1, =global_ea
    str r0, [r1]
'''
    if name.startswith(('ADD', 'SUB', 'BIC', 'BIS')):
        kind = name.split('_')[0]
        if byte: kind = kind[:-1]
        calculation = {'ADD': 'adds r3, r0, r1', 'SUB': 'subs r3, r0, r1',
                       'BIC': 'bics r0, r1\n    '+('uxtb' if byte else 'uxth')+' r3, r0',
                       'BIS': 'orrs r0, r1\n    '+('uxtb r3, r0' if byte else 'movs r3, r0')}[kind]
        save_dst = '    ldr r3, =global_dst\n    str r0, [r3]\n' if kind in ('ADD','SUB') else ''
        code += ('    bl __t1_read'+width+'\n'+save_dst
                 +'    ldr r1, =global_src\n    ldr r1, [r1]\n    '+calculation+'\n'
                 +'    mov r10, r3\n    ldr r0, =global_ea\n    ldr r0, [r0]\n'
                 +'    mov r1, r10\n    bl __t1_write'+width+'\n    b '+tag+'_flags\n'
                 +tag+'_dstreg:\n    lsls r0, r0, #2\n    ldr r2, =global_reg\n'
                 +'    adds r2, r2, r0\n    ldr r0, [r2]\n'+save_dst
                 +'    ldr r1, =global_src\n    ldr r1, [r1]\n    '+calculation+'\n'
                 +'    mov r10, r3\n'
                 +('    str r0, [r2]\n' if byte else '    uxth r3, r3\n    str r3, [r2]\n')+tag+'_flags:\n')
        if kind in ('ADD','SUB'):
            code += ('    mov r2, r10\n    ldr r3, =global_flagc\n    str r2, [r3]\n'
                     +'    ldr r0, =global_src\n    ldr r0, [r0]\n'
                     +'    ldr r1, =global_dst\n    ldr r1, [r1]\n')
            if kind == 'ADD':
                code += '    eors r0, r2\n    eors r1, r2\n    ands r0, r1\n'
            else:
                code += '    eors r0, r1\n    eors r1, r2\n    ands r0, r1\n'
            code += '    ldr r1, =global_flagv\n    str r0, [r1]\n    uxth r4, r2\n'
        else:
            code += '    mov r4, r10\n'+('    lsls r4, r4, #8\n' if byte else '')+'    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n'
    elif name.startswith(('CMP','BIT')):
        code += f'''    bl __t1_read{width}
    b {tag}_compare
{tag}_dstreg:
    lsls r0, r0, #2
    ldr r1, =global_reg
    ldr r0, [r1, r0]
'''
        if byte: code += '    uxtb r0, r0\n'
        code += f'''
{tag}_compare:
    ldr r1, =global_dst
    str r0, [r1]
    ldr r1, =global_src
    ldr r1, [r1]
'''
        if name.startswith('CMP'):
            code += '''    subs r2, r1, r0
    mov r10, r2
'''
            if byte:
                code += '    uxtb r4, r2\n    lsls r4, r4, #8\n'
                code += '    lsls r3, r2, #8\n    mov r12, r3\n'
                code += '    eors r0, r1\n    eors r1, r2\n    ands r0, r1\n    lsls r0, r0, #8\n'
                code += '    ldr r1, =global_flagv\n    str r0, [r1]\n    mov r0, r12\n    ldr r1, =global_flagc\n    str r0, [r1]\n'
            else:
                code += '''    uxth r4, r2
    ldr r3, =global_flagc
    str r2, [r3]
    eors r0, r1
    eors r1, r2
    ands r0, r1
    ldr r1, =global_flagv
    str r0, [r1]
'''
        else:
            code += '    ands r0, r1\n    movs r4, r0\n'+('    lsls r4, r4, #8\n' if byte else '')+'    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n'
    else:
        code += f'''    ldr r1, =global_src
    ldr r1, [r1]
    bl __t1_write{width}
    b {tag}_flags
{tag}_dstreg:
    lsls r0, r0, #2
    ldr r1, =global_src
    ldr r1, [r1]
'''
        if byte:
            code += '    sxtb r1, r1\n    uxth r1, r1\n'
        code += f'''    ldr r2, =global_reg
    str r1, [r2, r0]
{tag}_flags:
    ldr r1, =global_src
    ldr r4, [r1]
'''
        if byte:
            code += '    lsls r4, r4, #8\n'
        code += '    movs r0, #0\n    ldr r1, =global_flagv\n    str r0, [r1]\n'
    return code


def build(text):
    while U0+G0 in text:
        a = text.index(U0+G0)
        b = text.index(G1+U1, a)+len(G1+U1)
        text = text[:a]+text[b:]
    for name, byte in FORMS:
        a = text.index('\n', text.index('Instruction'+name+':'))+1
        next_label = re.search(r'^Instruction\w+:', text[a:], re.M)
        assert next_label, name
        b = a+next_label.start()
        plain = text[a:b]
        uses = 'Op, PC, FlagNZ'+(', Res' if name.startswith(('CMP','ADD','SUB','BIC','BIS')) else '')
        head = (U0+G0+'CompilerIf '+GUARD+'\n  ASM Uses '+uses+'\n'
                +body(name, byte)+'  EndASM\n  NextSynced()\nCompilerEndIf\n'
                +'CompilerIf #ASM_FULL = 0 Or #ASM_EA = 0 Or #ASM_MEM = 0 Or #DISK_BACKEND = 0\n'
                +'Instruction'+name+'FullRef:\n'+G1+U1)
        end = U0+G0+'CompilerEndIf\n'+G1+U1
        text = text[:a]+head+plain+end+text[b:]
    fill = U0+G0+'CompilerIf #DISK_BACKEND = 0\n'
    for i, (name, _) in enumerate(FORMS):
        fill += f'  FastAsm({42+i}) = ?Instruction{name}\n  FastRef({42+i}) = ?Instruction{name}FullRef\n'
    fill += 'CompilerEndIf\n'+G1+U1
    # Native-call reference entries stay last, as asm_call_gen expects.
    at = '; ---- UNMAPPED ONLY: native calls (tools/asm_call_gen.py) ----\nCompilerIf #DISK_BACKEND = 0\n  FastAsm(40)'
    if at not in text:
        at = '  OpTableReady = 1\n'
    assert text.count(at) == 1
    return text.replace(at, fill+at, 1)


if __name__ == '__main__':
    import sys
    have = P.read_text()
    want = build(have)
    if '--check' in sys.argv:
        if have != want:
            raise SystemExit('asm_full_gen: stale output')
    else:
        P.write_text(want)
    print('asm_full_gen: complete unmapped operand handlers current')
