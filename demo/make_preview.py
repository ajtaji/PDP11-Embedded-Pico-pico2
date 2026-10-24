"""Run the demo on the PDP-11 emulator's console program and save its screen as a PNG.

    python demo/make_preview.py [SECONDS] [--compiler EXE] [--out demo/preview/frame.png]

The demo is built, run for SECONDS on pdp11_cli with its display and sound devices, and the
emulator's own shot: step saves the frame as the display shows it; this enlarges it 2x.
"""
import argparse, os, subprocess, sys, tempfile
from pathlib import Path
from PIL import Image

HERE = Path(__file__).resolve().parent
CLI = os.environ.get('PDP11_CLI', r'C:\PMFBuild\pdp11\desktop\pdp11_cli.exe')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('seconds', nargs='?', type=int, default=4)
    ap.add_argument('--compiler', default=os.environ.get('PUREMETALFORGE_EXE', 'PureMetalForge.exe'))
    ap.add_argument('--out', default=str(HERE / 'preview' / 'frame.png'))
    a = ap.parse_args()
    with tempfile.TemporaryDirectory() as td:
        out = Path(td) / 'demo.hex'
        r = subprocess.run([a.compiler, '--compile', '-q', str(HERE / 'demo.pdp11'), '-o', str(out)],
                           capture_output=True, text=True)
        if r.returncode:
            print(r.stdout + r.stderr)
            return 1
        shot = Path(td) / 'shot.bmp'
        r = subprocess.run([CLI, 'lda:%s@%d' % (Path(td) / 'demo.lda', max(1, a.seconds)), 'shot:%s' % shot],
                           capture_output=True, text=True, timeout=a.seconds + 60)
        print('\n'.join(ln for ln in r.stdout.splitlines() if ln.startswith('cli:')))
        if not shot.exists():
            print('no shot was taken')
            return 1
        img = Image.open(shot)
        Path(a.out).parent.mkdir(exist_ok=True)
        img.resize((img.width * 2, img.height * 2), Image.NEAREST).save(a.out)
    print('wrote', a.out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
