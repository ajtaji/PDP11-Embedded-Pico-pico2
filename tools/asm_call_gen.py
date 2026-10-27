"""Native unmapped JSR/RTS paths, shared by both Cortex-M targets.

All guards precede guest writes. Unsupported addressing and exceptional stacks
retain the original handlers. Run after the other shared-source generators.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'J11_18MHz_KDJ11_BF/pico/instructions.pico'
BEGIN = '; ---- UNMAPPED ONLY: native calls (tools/asm_call_gen.py) ----\n'
END = '; ---- END UNMAPPED ONLY ----\n'

RTS = '''    ldr r2, =global_reg
    ldr r0, [r2, #24]
    lsrs r3, r0, #1
    bcs __call_rts_slow
    ldr r3, =#RAM_BYTES
    cmp r0, r3
    bhs __call_rts_slow
    mov r1, r8
    lsls r1, r1, #29
    lsrs r1, r1, #27
    ldr r3, [r2, r1]
    str r3, [r2, #28]
    ldr r3, =global_mem
    ldrh r3, [r3, r0]
    adds r0, #2
    uxth r0, r0
    str r0, [r2, #24]
    str r3, [r2, r1]
'''

JSR = '''    ldr r2, =global_reg
    ldr r0, [r2, #24]
    subs r0, #2
    uxth r0, r0
    cmp r0, #255
    bls __call_jsr_slow
    lsrs r3, r0, #1
    bcs __call_jsr_slow
    ldr r3, =#RAM_BYTES
    cmp r0, r3
    bhs __call_jsr_slow
    mov r12, r0
    mov r0, r8
    movs r1, #63
    ands r0, r1
    cmp r0, #31
    beq __call_jsr_fetch
    movs r1, #56
    ands r0, r1
    cmp r0, #8
    beq __call_jsr_indirect
    cmp r0, #48
    bne __call_jsr_slow
__call_jsr_fetch:
    mov r0, r9
    lsrs r1, r0, #1
    bcs __call_jsr_slow
    ldr r1, =#RAM_BYTES
    cmp r0, r1
    bhs __call_jsr_slow
    ldr r1, =global_mem
    ldrh r3, [r1, r0]
    adds r0, #2
    uxth r0, r0
    mov r1, r8
    lsls r1, r1, #26
    lsrs r1, r1, #29
    cmp r1, #3
    beq __call_jsr_commit
    b __call_jsr_base
__call_jsr_indirect:
    movs r3, #0
    mov r0, r9
__call_jsr_base:
    mov r1, r8
    lsls r1, r1, #29
    lsrs r1, r1, #27
    cmp r1, #28
    beq __call_jsr_pc
    ldr r1, [r2, r1]
    b __call_jsr_target
__call_jsr_pc:
    movs r1, r0
__call_jsr_target:
    adds r3, r3, r1
    uxth r3, r3
__call_jsr_commit:
    str r0, [r2, #28]
    ldr r1, =global_ea
    str r3, [r1]
    mov r1, r8
    lsls r1, r1, #23
    lsrs r1, r1, #29
    lsls r1, r1, #2
    ldr r3, [r2, r1]
    mov r0, r12
    str r0, [r2, #24]
    mov r12, r1
    ldr r1, =global_mem
    strh r3, [r1, r0]
    ldr r3, [r2, #28]
    mov r1, r12
    str r3, [r2, r1]
    ldr r1, =global_ea
    ldr r0, [r1]
    str r0, [r2, #28]
'''

def build(text):
    while BEGIN in text:
        a = text.index(BEGIN)
        b = text.index(END, a) + len(END)
        text = text[:a] + text[b:]
    for name, body, tag in [('JSR_004', JSR, 'jsr'), ('RTS_00020', RTS, 'rts')]:
        label = 'Instruction' + name + ':'
        a = text.index('\n', text.index(label)) + 1
        uses = 'Op, PC' if tag == 'jsr' else 'Op'
        asm = (BEGIN + 'CompilerIf #ASM_FAST = 1\n  ASM Uses ' + uses + '\n' + body
               + '  EndASM\n  NextSynced()\n  ASM\n__call_' + tag
               + '_slow:\n  EndASM\nCompilerEndIf\nInstruction' + name + 'Ref:\n' + END)
        text = text[:a] + asm + text[a:]
    fill = BEGIN + 'CompilerIf #DISK_BACKEND = 0\n'
    for i, name in enumerate(['JSR_004', 'RTS_00020']):
        fill += f'  FastAsm({40+i}) = ?Instruction{name}\n  FastRef({40+i}) = ?Instruction{name}Ref\n'
    fill += 'CompilerEndIf\n' + END
    at = '  OpTableReady = 1\n'
    assert text.count(at) == 1
    return text.replace(at, fill + at)


def mapped_prefix(call):
    """Fuse the existing mapped window checks into the handler, before writes."""
    tag = '__call_jsr' if call else '__call_rts'
    lo, hi = (8, 12) if call else (0, 4)
    check = f'''    ldr r2, =global_curd
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
    adds r3, r3, r0
    mov r12, r3
    ldr r2, =global_reg
'''
    body = JSR if call else RTS
    old = '    ldr r3, =#RAM_BYTES\n    cmp r0, r3\n    bhs ' + tag + '_slow\n'
    assert body.count(old) == 1
    body = body.replace(old, check)
    if call:
        body = body.replace('    mov r12, r0\n', '', 1)
        old = '''    ldr r1, =#RAM_BYTES
    cmp r0, r1
    bhs __call_jsr_slow
    ldr r1, =global_mem
    ldrh r3, [r1, r0]
'''
        new = '''    ldr r1, =global_fw
    ldr r3, [r1]
    cmp r0, r3
    blt __call_jsr_slow
    ldr r3, [r1, #4]
    cmp r0, r3
    bge __call_jsr_slow
    ldr r1, [r1, #8]
    ldrh r3, [r1, r0]
'''
        assert old in body
        body = body.replace(old, new)
        old = '''    mov r0, r12
    str r0, [r2, #24]
    mov r12, r1
    ldr r1, =global_mem
    strh r3, [r1, r0]
    ldr r3, [r2, #28]
    mov r1, r12
'''
        new = '''    ldr r0, [r2, #24]
    subs r0, #2
    uxth r0, r0
    str r0, [r2, #24]
    strh.w r3, [r12]
    ldr r3, [r2, #28]
'''
        assert old in body
        body = body.replace(old, new)
    else:
        body = body.replace('    ldr r3, =global_mem\n    ldrh r3, [r3, r0]\n',
                            '    ldrh.w r3, [r12]\n')
    # The mapped loop runs only on Cortex-M33. Extract opcode fields directly;
    # retain the Thumb-1 shared bodies and every exceptional-address guard.
    body = body.replace('    mov r0, r8\n    movs r1, #63\n    ands r0, r1\n',
                        '    and.w r0, r8, #63\n')
    for left, right in [(26, 29), (29, 27), (23, 29)]:
        old_field = (f'    mov r1, r8\n    lsls r1, r1, #{left}\n'
                     f'    lsrs r1, r1, #{right}\n')
        shift = right - left
        width = 32 - right
        # The 29/27 idiom extracts bits 0..2 and scales the byte offset by 4.
        if (left, right) == (29, 27):
            new_field = '    ubfx r1, r8, #0, #3\n    lsls r1, r1, #2\n'
        else:
            new_field = f'    ubfx r1, r8, #{shift}, #{width}\n'
        expected = 1 if call or (left, right) == (29, 27) else 0
        assert body.count(old_field) == expected, (call, left, right)
        body = body.replace(old_field, new_field)
    body = body.replace(tag, tag + 'm')
    uses = 'Op, PC' if call else 'Op'
    return ('  ASM Uses ' + uses + '\n' + body + '  EndASM\n  NextSyncedM()\n'
            + '  ASM\n' + tag + 'm_slow:\n  EndASM\n')

if __name__ == '__main__':
    have = SRC.read_text()
    want = build(have)
    if '--check' in sys.argv:
        if want != have:
            raise SystemExit('asm_call_gen: stale output')
    else:
        SRC.write_text(want)
    print('asm_call_gen: native calls current')
