"""Build the PureMetal PDP-11 demo's graphics and music into demo/demo_assets.pdp11.

    python demo/make_demo_assets.py            # write demo/demo_assets.pdp11 (+ preview PNGs in demo/preview/)
    python demo/make_demo_assets.py --check    # exit 1 if the committed file is not what this tool writes

Everything the demo shows or plays is DATA here and CODE in demo/demo.pdp11: this tool renders and
encodes once, on the PC; the PDP-11 program copies the logo into the framebuffer, draws the rest
itself and plays the song. Nothing here runs on the PDP-11.

  Logo     "PDP-11" rendered from Lato Regular (fonts/Lato-Regular.ttf, SIL OFL 1.1, fonts/OFL.txt),
           thickened and outlined, as 4-bit pixels: colour 7 the outline, 8-13 the body from top to
           bottom (the demo cycles those six colours: the shimmer).
  Font     the demo's own bold 7x7 capitals (the PureMetal NES demo's, the same drawing), one byte a
           row, bit 7 the leftmost pixel.
  Tables   a 256-entry sine (-127..127), the note frequencies in Hz.
  Song     an original tune: four voices (lead, arpeggio, bass, drums), 16 rows a pattern.

The display is 256 x 192 at 4 bits a pixel, 128 bytes a row: the even x in a byte's low nibble.
"""
import argparse, math, os, sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

HERE = Path(__file__).resolve().parent
LATO = HERE / 'fonts' / 'Lato-Regular.ttf'
OUT = HERE / 'demo_assets.pdp11'
PREVIEW = HERE / 'preview'

LOGO_W, LOGO_H = 224, 52          # the logo's box, a whole number of words wide
FONT_CHARS = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!-:/\'?'

FONT7 = {
    ' ': ['.......'] * 7,
    'A': ['.#####.', '##...##', '##...##', '#######', '##...##', '##...##', '##...##'],
    'B': ['######.', '##...##', '##...##', '######.', '##...##', '##...##', '######.'],
    'C': ['.#####.', '##...##', '##.....', '##.....', '##.....', '##...##', '.#####.'],
    'D': ['#####..', '##..##.', '##...##', '##...##', '##...##', '##..##.', '#####..'],
    'E': ['#######', '##.....', '##.....', '######.', '##.....', '##.....', '#######'],
    'F': ['#######', '##.....', '##.....', '######.', '##.....', '##.....', '##.....'],
    'G': ['.#####.', '##...##', '##.....', '##.####', '##...##', '##...##', '.######'],
    'H': ['##...##', '##...##', '##...##', '#######', '##...##', '##...##', '##...##'],
    'I': ['######.', '..##...', '..##...', '..##...', '..##...', '..##...', '######.'],
    'J': ['...####', '....##.', '....##.', '....##.', '##..##.', '##..##.', '.####..'],
    'K': ['##...##', '##..##.', '##.##..', '####...', '##.##..', '##..##.', '##...##'],
    'L': ['##.....', '##.....', '##.....', '##.....', '##.....', '##.....', '#######'],
    'M': ['##...##', '###.###', '#######', '##.#.##', '##...##', '##...##', '##...##'],
    'N': ['##...##', '###..##', '####.##', '##.####', '##..###', '##...##', '##...##'],
    'O': ['.#####.', '##...##', '##...##', '##...##', '##...##', '##...##', '.#####.'],
    'P': ['######.', '##...##', '##...##', '######.', '##.....', '##.....', '##.....'],
    'Q': ['.#####.', '##...##', '##...##', '##...##', '##.#.##', '##..##.', '.###.##'],
    'R': ['######.', '##...##', '##...##', '######.', '##.##..', '##..##.', '##...##'],
    'S': ['.#####.', '##...##', '##.....', '.#####.', '.....##', '##...##', '.#####.'],
    'T': ['######.', '..##...', '..##...', '..##...', '..##...', '..##...', '..##...'],
    'U': ['##...##', '##...##', '##...##', '##...##', '##...##', '##...##', '.#####.'],
    'V': ['##...##', '##...##', '##...##', '##...##', '.##.##.', '..###..', '...#...'],
    'W': ['##...##', '##...##', '##...##', '##.#.##', '#######', '###.###', '##...##'],
    'X': ['##...##', '.##.##.', '..###..', '..###..', '.##.##.', '##...##', '##...##'],
    'Y': ['##..##.', '##..##.', '##..##.', '.####..', '..##...', '..##...', '..##...'],
    'Z': ['#######', '....##.', '...##..', '..##...', '.##....', '##.....', '#######'],
    '0': ['.#####.', '##..###', '##.####', '####.##', '###..##', '##...##', '.#####.'],
    '1': ['..##...', '.###...', '####...', '..##...', '..##...', '..##...', '######.'],
    '2': ['.#####.', '##...##', '.....##', '...###.', '.###...', '##.....', '#######'],
    '3': ['.#####.', '##...##', '.....##', '..####.', '.....##', '##...##', '.#####.'],
    '4': ['...###.', '..####.', '.##.##.', '##..##.', '#######', '....##.', '....##.'],
    '5': ['#######', '##.....', '######.', '.....##', '.....##', '##...##', '.#####.'],
    '6': ['.#####.', '##.....', '##.....', '######.', '##...##', '##...##', '.#####.'],
    '7': ['#######', '.....##', '....##.', '...##..', '..##...', '..##...', '..##...'],
    '8': ['.#####.', '##...##', '##...##', '.#####.', '##...##', '##...##', '.#####.'],
    '9': ['.#####.', '##...##', '##...##', '.######', '.....##', '.....##', '.#####.'],
    '.': ['.......', '.......', '.......', '.......', '.......', '..##...', '..##...'],
    ',': ['.......', '.......', '.......', '.......', '..##...', '..##...', '.##....'],
    '!': ['..##...', '..##...', '..##...', '..##...', '..##...', '.......', '..##...'],
    '-': ['.......', '.......', '.......', '######.', '.......', '.......', '.......'],
    ':': ['.......', '..##...', '..##...', '.......', '..##...', '..##...', '.......'],
    '/': ['.....##', '....##.', '...##..', '..##...', '.##....', '##.....', '.......'],
    "'": ['..##...', '..##...', '.##....', '.......', '.......', '.......', '.......'],
    '?': ['.#####.', '##...##', '.....##', '...###.', '..##...', '.......', '..##...'],
}

SCROLL_TEXT = ("   PUREMETAL ON THE PDP-11 ...   A J-11 AT YOUR SERVICE: MOV, ADD, MUL AND DIV IN ONE "
               "INSTRUCTION EACH, AND THE FP11 FOR THE MATHS ...   EVERYTHING ON THIS SCREEN WAS WRITTEN IN "
               "PUREMETAL AND COMPILED STRAIGHT TO PDP-11 MACHINE CODE ...   NO UNIX, NO OPERATING SYSTEM, "
               "JUST THE MACHINE ...   ")


def dilate(img, n=1):
    for _ in range(n):
        img = img.filter(ImageFilter.MaxFilter(3))
    return img


def render_logo():
    """The logo as LOGO_W x LOGO_H colour numbers: 0 clear, 7 outline, 8-13 the body by row."""
    text = 'PDP-11'
    size = 50
    font = ImageFont.truetype(str(LATO), size, layout_engine=ImageFont.Layout.BASIC)
    box = font.getbbox(text)
    w, h = box[2] - box[0], box[3] - box[1]
    body = Image.new('L', (LOGO_W, LOGO_H), 0)
    d = ImageDraw.Draw(body)
    ox, oy = (LOGO_W - w) // 2 - box[0], (LOGO_H - h) // 2 - box[1]
    d.text((ox, oy), text, font=font, fill=255)
    body = dilate(body.point(lambda v: 255 if v >= 110 else 0), 1)      # Regular, thickened to a bold
    outline = dilate(body, 2)
    pic = [[0] * LOGO_W for _ in range(LOGO_H)]
    top = min(y for y in range(LOGO_H) for x in range(LOGO_W) if body.getpixel((x, y)))
    bot = max(y for y in range(LOGO_H) for x in range(LOGO_W) if body.getpixel((x, y)))
    for y in range(LOGO_H):
        for x in range(LOGO_W):
            if body.getpixel((x, y)):
                pic[y][x] = 8 + min(5, (y - top) * 6 // max(1, bot - top + 1))
            elif outline.getpixel((x, y)):
                pic[y][x] = 7
    return pic


def pack4(pic):
    """Rows of 4-bit pixels -> words, low nibble of each byte the even x; a word's low byte first."""
    words = []
    for row in pic:
        bs = [row[x] | (row[x + 1] << 4) for x in range(0, len(row), 2)]
        words += [bs[i] | (bs[i + 1] << 8) for i in range(0, len(bs), 2)]
    return words


def font_bytes():
    out = []
    for ch in FONT_CHARS:
        rows = FONT7[ch] + ['.......']
        for r in rows:
            out.append(sum(0x80 >> x for x in range(7) if r[x] == '#'))
    return out


def sine_table():
    return [round(127 * math.sin(2 * math.pi * i / 256)) for i in range(256)]


NOTE_NAMES = {'C': 0, 'C#': 1, 'D': 2, 'D#': 3, 'E': 4, 'F': 5, 'F#': 6, 'G': 7, 'G#': 8, 'A': 9, 'A#': 10, 'B': 11}


def note_index(name):
    """'A3' -> index into the frequency table (0 = no note, 1 = C1)."""
    return (int(name[-1]) - 1) * 12 + NOTE_NAMES[name[:-1]] + 1


def note_freqs():
    return [0] + [round(440.0 * 2 ** ((24 + i - 69) / 12)) for i in range(72)]     # C1 .. B6


def song():
    """Rows of (lead, arpeggio, bass, drums). Original; D minor, i - VII - VI - V (Dm C Bb A)."""
    chords = [('D', ['D4', 'F4', 'A4']), ('C', ['C4', 'E4', 'G4']), ('A#', ['A#3', 'D4', 'F4']), ('A', ['A3', 'C#4', 'E4'])]
    bass = {'D': 'D2', 'C': 'C2', 'A#': 'A#1', 'A': 'A1'}
    leads = [
        ['A4', '', 'D5', '', 'F5', '', 'E5', 'D5', 'C5', '', 'D5', '', 'A4', '', '', ''],
        ['G4', '', 'C5', '', 'E5', '', 'D5', 'C5', 'E5', '', 'G5', '', 'E5', '', '', ''],
        ['F4', '', 'A#4', '', 'D5', '', 'F5', 'D5', 'A#4', '', 'D5', '', 'F5', '', 'G5', ''],
        ['E5', '', 'C#5', '', 'A4', '', 'C#5', 'E5', 'A5', '', 'G5', 'F5', 'E5', '', 'C#5', ''],
    ]
    finale = ['D5', 'E5', 'F5', 'G5', 'A5', '', 'G5', 'F5', 'E5', '', 'C#5', '', 'D5', '', '', '']
    drums_a = ['K', 'H', 'H', 'H', 'S', 'H', 'H', 'K', 'K', 'H', 'H', 'H', 'S', 'H', 'H', 'H']
    drums_b = ['K', 'H', 'H', 'H', 'S', 'H', 'H', 'K', 'K', 'H', 'K', 'H', 'S', 'S', 'S', 'S']

    def pattern(lead, root, notes, drums, quiet=False):
        out = []
        for r in range(16):
            ld = '' if quiet else lead[r]
            arp = notes[r % 3] if r % 2 == 0 else notes[(r // 2) % 3].replace('4', '5').replace('3', '4')
            b = bass[root] if r % 4 == 0 else (bass[root][:-1] + str(int(bass[root][-1]) + 1) if r % 4 == 2 else '')
            out.append((ld, arp, b, drums[r]))
        return out

    rows = []
    for k, (root, notes) in enumerate(chords):              # intro: no lead
        rows += pattern(leads[k], root, notes, drums_a, quiet=True)
    for loop in range(2):
        for k, (root, notes) in enumerate(chords):
            lead = finale if (loop == 1 and k == 3) else leads[k]
            rows += pattern(lead, root, notes, drums_b if k == 3 else drums_a)
    return rows


def encode_song(rows):
    """Four words a row: lead, arpeggio, bass (a note index, 0 nothing) and drums (0 nothing,
    1 kick, 2 snare, 3 hat)."""
    out = []
    for ld, arp, b, dr in rows:
        for n in (ld, arp, b):
            out.append(0 if n == '' else note_index(n))
        out.append({'': 0, 'K': 1, 'S': 2, 'H': 3}[dr])
    return out


def data_lines(label, values, per=16, kind='w'):
    if kind == 'w':                                 # .w is signed: a word above 32767 is written negative
        values = [v - 65536 if v > 32767 else v for v in values]
    lines = [label + ':']
    for i in range(0, len(values), per):
        lines.append('  Data.%s %s' % (kind, ', '.join(str(v) for v in values[i:i + per])))
    return lines


def text_codes(s):
    return [FONT_CHARS.index(c) for c in s.upper()] + [255]


PALETTE_PREVIEW = [0x000, 0x00F, 0x04F, 0x08F, 0x0CF, 0x0FF, 0x0FC, 0x226,
                   0xF40, 0xF80, 0xFC0, 0xFF4, 0xFF8, 0xFFF, 0xFFA, 0xFFF]


def rgb(c):
    return ((c >> 8) & 15) * 17, ((c >> 4) & 15) * 17, (c & 15) * 17


def generate(write_previews):
    logo = render_logo()
    rows = song()
    lines = ['; demo_assets.pdp11 - WRITTEN BY demo/make_demo_assets.py; do not edit by hand.',
             '; The logo (4-bit pixels, %d x %d), the font, the sine table, the note frequencies,' % (LOGO_W, LOGO_H),
             '; the song (%d rows of four words) and the scroller text.' % len(rows),
             '#LOGO_W = %d' % LOGO_W, '#LOGO_H = %d' % LOGO_H, '#SONG_ROWS = %d' % len(rows),
             '#FONT_CHARS = %d' % len(FONT_CHARS),
             'DataSection']
    lines += data_lines('logo_pixels', pack4(logo))
    lines += data_lines('font_rows', font_bytes(), kind='a')
    lines += data_lines('sine_table', sine_table())
    lines += data_lines('note_hz', note_freqs())
    lines += data_lines('song_rows', encode_song(rows))
    lines += data_lines('scroll_text', text_codes(SCROLL_TEXT), kind='a')
    lines.append('EndDataSection')
    text = '\n'.join(lines) + '\n'
    if write_previews:
        PREVIEW.mkdir(exist_ok=True)
        img = Image.new('RGB', (LOGO_W, LOGO_H))
        for y in range(LOGO_H):
            for x in range(LOGO_W):
                img.putpixel((x, y), rgb(PALETTE_PREVIEW[logo[y][x]]))
        img.resize((LOGO_W * 3, LOGO_H * 3), Image.NEAREST).save(PREVIEW / 'logo.png')
    return text


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--check', action='store_true')
    a = ap.parse_args()
    text = generate(not a.check)
    if a.check:
        old = OUT.read_text(encoding='utf-8') if OUT.exists() else ''
        if old != text:
            print('demo_assets.pdp11 is not what make_demo_assets.py writes - run it')
            return 1
        print('demo_assets.pdp11 is current')
        return 0
    OUT.write_text(text, encoding='utf-8', newline='\n')
    print('wrote', OUT, '(%d bytes)' % len(text))
    return 0


if __name__ == '__main__':
    sys.exit(main())
