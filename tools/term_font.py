"""Compatibility entry point: prepare TrueType outlines for runtime fonts.
Rasterization now runs on the Pico; this tool only prepares the source fonts.
"""
from font_pack import main
if __name__ == '__main__': main()
