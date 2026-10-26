"""Build standard panel firmware for either Pico family.

All four screen drivers are resident; output_config.py selects one at boot.
Audio is a build choice because the Bluetooth stack has substantial RAM cost.
The plugin choice uses the supplied silent PCM meter until audio_plugin.pmi
is replaced with a hardware sink. Compile first, lease/upload separately.
"""
import argparse
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent

def build(target, audio, compiler, out, keep=False):
    family, ext = ('pico', 'pico') if target == 'rp2040' else ('pico2', 'pico2')
    source = ROOT / 'J11_18MHz_KDJ11_BF' / family
    tmp = source / ('diag_outputs.' + ext)
    code = (source / ('diag.' + ext)).read_text(encoding='utf-8')
    old = '#OUTPUT_AUDIO_DRIVER = 0 '
    if code.count(old) != 1:
        raise ValueError('audio selection moved; update output_build.py')
    code = code.replace(old, '#OUTPUT_AUDIO_DRIVER = %d ' % {'silent': 0, 'bluetooth': 1, 'plugin': 2}[audio], 1)
    out = out.resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    try:
        tmp.write_text(code, encoding='utf-8')
        result = subprocess.run([compiler, '--compile', str(tmp), '-t', target, '-o', str(out)], cwd=source, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        print(result.stdout, end="", flush=True)
        result.check_returncode()
    finally:
        if not keep: tmp.unlink(missing_ok=True)

if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--target', choices=['rp2040', 'rp2350'], required=True)
    ap.add_argument('--audio', choices=['silent', 'bluetooth', 'plugin'], default='silent')
    ap.add_argument('--compiler', default='PureMetalForge.exe')
    ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--keep', action='store_true')
    a = ap.parse_args()
    if a.target == 'rp2040' and a.audio == 'bluetooth':
        ap.error('the current RP2040 Mini-Unix pack overlaps the radio firmware at 0x100000; use a non-radio audio sink')
    build(a.target, a.audio, a.compiler, a.out, a.keep)
