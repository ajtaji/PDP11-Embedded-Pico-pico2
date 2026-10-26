"""Generate the board fetch-sequence comparison and its plain mapped loop."""
from pathlib import Path
import re,sys
from mmu_gen import generate
from cpu_state_layout import forward

ROOT=Path(__file__).resolve().parents[1]
DIR=ROOT/'J11_18MHz_KDJ11_BF/pico2'


def reference():
    text=generate()
    for a,b in [('FetchLo','Fw(0)'),('FetchHi','Fw(1)'),('FetchBase','Fw(2)')]:
        text=re.sub(r'\b'+a+r'\b',b,text)
    text=text.replace('If PC < Fw(1)','If PC - Fw(0) < Fw(1)')
    text=text.replace('Op = Mem((PC + Fw(2)) >> 1)','Op = PeekU(PC + Fw(2))')
    names=re.findall(r'(?m)^(?:Procedure(?:RAM)?(?:\.\w+)?|Macro) (\w+)',text)
    for line in text.splitlines():
        if line.startswith('Global '):
            names+=re.findall(r'\b(\w+)\.(?:i|Label)\b',line.partition(';')[0])
    renames={n:n+'FetchRef' for n in names}
    text=re.sub(r'\b('+ '|'.join(sorted(renames,key=len,reverse=True))+r')\b',lambda m:renames[m[0]],text)
    return '; Generated plain interpreter for fetch-sequence comparisons.\n'+forward(text)


def fixture():
    text=(DIR/'asm_check.pico2').read_text()
    at='XIncludeFile "instructions.pico2"\n'
    assert text.count(at)==1
    text=text.replace(at,at+'XIncludeFile "instructions_fetch_ref.pico2"\n')
    assert text.endswith('Main()\n')
    return text[:-len('Main()\n')]+'XIncludeFile "fetch_compare.pmi"\nFetchMain()\n'


if __name__=='__main__':
    for name,data in [('instructions_fetch_ref.pico2',reference()),('fetch_check.pico2',fixture())]:
        path=DIR/name
        if '--check' in sys.argv:
            assert path.read_text()==data,name+' is stale'
        else:path.write_text(data)
    print('fetch_check_gen: plain reference and sequence fixture current')
