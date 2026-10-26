"""RP2350 fetch windows use (low, byte count, host, instruction PC).

Unsigned subtraction folds the two bounds branches into one. Invalid windows
have a zero byte count. The PC remains intact for the existing slow path.
"""
import re


def rewrite(text):
    # These three scratch-register sets belong to tails, indexed operands,
    # and the fused JSR prefix respectively; no live input is overwritten.
    scratch = {('r3','r1','r0'): 'r2', ('r0','r3','r2'): 'r1'}
    pattern = re.compile(
        r'    ldr (?P<base>r\d+), =global_fw\n'
        r'    ldr (?P<lo>r\d+), \[(?P=base)(?:, #0)?\]\n'
        r'    cmp (?P<pc>r\d+), (?P=lo)\n'
        r'    blt(?P<wide>\.w)? (?P<exit>\w+)\n'
        r'    ldr (?P=lo), \[(?P=base), #4\]\n'
        r'    cmp (?P=pc), (?P=lo)\n'
        r'    bge(?P=wide)? (?P=exit)\n')

    def single(m):
        base, lo, pc = m.group('base','lo','pc')
        if (base,lo,pc) == ('r1','r3','r0'):
            # JSR keeps the checked physical stack pointer live in r12.
            # Reuse the window-base register, then reload it for the host
            # field. base_rel folds both pointer loads into GBase offsets.
            return ('    ldr r1, =global_fw\n    ldr r3, [r1, #0]\n'
                    '    subs r3, r0, r3\n    ldr r1, [r1, #4]\n'
                    f'    cmp r3, r1\n    bhs{m["wide"] or ""} {m["exit"]}\n'
                    '    ldr r1, =global_fw\n')
        temp = scratch[(base,lo,pc)]
        return (f'    ldr {base}, =global_fw\n    ldr {lo}, [{base}, #0]\n'
                f'    subs.w {temp}, {pc}, {lo}\n    ldr {lo}, [{base}, #4]\n'
                f'    cmp {temp}, {lo}\n    bhs{m["wide"] or ""} {m["exit"]}\n')

    text, count = pattern.subn(single, text)
    # The immediate/indexed forms fetch two words and check both addresses.
    pattern = re.compile(
        r'    ldr r0, =global_fw\n    ldr r3, \[r0\]\n'
        r'    cmp r2, r3\n    blt (?P<exit>\w+)\n'
        r'    adds r3, r2, #2\n    ldr r12, \[r0, #4\]\n'
        r'    cmp r3, r12\n    bge (?P=exit)\n')
    text, pairs = pattern.subn(lambda m:
        '    ldr r0, =global_fw\n    ldr r3, [r0]\n'
        '    subs r3, r2, r3\n    ldr r12, [r0, #4]\n'
        f'    cmp r3, r12\n    bhs {m["exit"]}\n'
        f'    adds r3, #2\n    cmp r3, r12\n    bhs {m["exit"]}\n'
        '    adds r3, r2, #2\n', text)
    assert pairs == 8, ('two-word fetch guards moved', pairs)
    if count < 8:
        raise ValueError('fetch guards moved: '+str(count))
    # The optional LDM tail already loads all three fields together.
    text = re.sub(r'    cmp r0, r1\n    blt (__tm\d+_s)\n'
                  r'    cmp r0, r2\n    bge \1\n',
                  r'    subs r1, r0, r1\n    cmp r1, r2\n    bhs \1\n', text)
    # The non-assembly reference retains its lower-bound test.
    text = text.replace('If PC < Fw(1)', 'If PC - Fw(0) < Fw(1)')
    return text


def double_load(text):
    # Only the standard tails have this register contract. Both values are
    # dead after the guard; the next load puts the opcode into r2.
    pattern = re.compile(r'    ldr r1, \[r5, #56\]\n'
                         r'    subs\.w r2, r0, r1\n'
                         r'    ldr r1, \[r5, #60\]\n'
                         r'    cmp r2, r1\n    bhs(?P<wide>\.w)? (?P<exit>\w+)\n')
    text, count = pattern.subn(lambda m:
        '    ldrd r1, r2, [r5, #56]\n    subs r1, r0, r1\n'
        f'    cmp r1, r2\n    bhs{m["wide"] or ""} {m["exit"]}\n', text)
    assert count > 50 or text.count('ldm r3, {r1, r2, r12}') > 50, ('fetch tails moved', count)
    return text
