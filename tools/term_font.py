#!/usr/bin/env python3
"""term_font.py - the PDP-11 panel terminal's glyphs (pico2/term_font.pico2) from a monospace TTF.

    python tools/term_font.py DejaVuSansMono.ttf [--preview glyphs.png]

The terminal (pico2/term_panel.pico2) is 80 x 24 characters on the LAFVIN kit's 480 x 320 panel,
so a character cell is 6 x 13 pixels. Each printable ASCII character (32-126) is drawn into one cell
with anti-aliasing and kept at four grey levels: 13 rows of 12 bits, two bits a pixel, the leftmost
pixel in bits 11-10. term_panel.pico2 turns two pixels at a time into RGB565 through a 16-entry table.

The font used for the firmware is DejaVu Sans Mono (Bitstream Vera licence with DejaVu's public
domain changes, which allow embedding the glyphs; the font file is not part of this repository -
any Linux has it at /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf).
"""
import argparse
import os

from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "J11_18MHz_KDJ11_BF", "pico2", "term_font.pico2")
W, H = 6, 13


def glyphs(ttf, size, base):
    font = ImageFont.truetype(ttf, size)
    out = []
    for c in range(32, 127):
        im = Image.new("L", (W, H), 0)
        ImageDraw.Draw(im).text((0, base), chr(c), font=font, fill=255, anchor="ls")
        rows = []
        for y in range(H):
            v = 0
            for x in range(W):
                g = im.getpixel((x, y))
                v = (v << 2) | min(3, (g + 42) // 85)      # 0, 1/3, 2/3, full
            rows.append(v)
        out.append(rows)
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("ttf")
    ap.add_argument("--size", type=float, default=10.0)
    ap.add_argument("--base", type=int, default=10, help="the baseline's row in the 13-row cell")
    ap.add_argument("--preview", help="a PNG of all 95 glyphs, 8x enlarged")
    a = ap.parse_args()
    g = glyphs(a.ttf, a.size, a.base)
    lines = ["; ======================================================================",
             ";  term_font.pico2 - the panel terminal's 95 glyphs (ASCII 32-126), made by",
             ";  tools/term_font.py from DejaVu Sans Mono at %.1f px, baseline row %d: a 6 x 13" % (a.size, a.base),
             ";  cell, 13 rows of 12 bits a glyph, two bits (four grey levels) a pixel, the",
             ";  leftmost pixel in bits 11-10. GENERATED - change tools/term_font.py, not this.",
             "; ======================================================================",
             "DataSection", "TermFontData:"]
    for c, rows in enumerate(g):
        lines.append("  Data.u " + ", ".join("$%03X" % r for r in rows) + "   ; %r" % chr(c + 32))
    lines += ["EndDataSection", ""]
    open(OUT, "w", newline="\n").write("\n".join(lines))
    print("term_font: wrote %s (95 glyphs)" % os.path.normpath(OUT))
    if a.preview:
        cols = 19
        im = Image.new("L", (cols * W, 5 * H), 0)
        for i, rows in enumerate(g):
            for y, v in enumerate(rows):
                for x in range(W):
                    im.putpixel(((i % cols) * W + x, (i // cols) * H + y), ((v >> (10 - 2 * x)) & 3) * 85)
        im.resize((im.width * 8, im.height * 8), Image.NEAREST).save(a.preview)
        print("term_font: preview %s" % a.preview)


if __name__ == "__main__":
    main()
