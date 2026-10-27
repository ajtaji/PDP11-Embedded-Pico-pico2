"""Make a small UF2 of output settings; it does not contain emulator firmware.

Example: py -3 tools/output_config.py --target rp2350 --panel display-pack2
         --out work/panel-settings.uf2

Flash this settings UF2 through the normal uploader or write its .bin through
the IDE's named 'PDP11 outputs' storage region. The selected resident driver
is used after reboot. Panel wiring matches the NES output profiles.
"""
import argparse
from pathlib import Path
import re
import struct

PANELS = {'none': 0, 'lafvin': 1, 'display-pack2': 2, 'ili9341': 3, 'hx8357d': 4}
FONTS = {'readable': 0, 'compact': 1}
AUDIO = {'silent': 0, 'bluetooth': 1, 'plugin': 2}
TARGETS = {'rp2040': (0x3f000, 0xe48bff56), 'rp2350': (0x4f000, 0xe48bff59)}


def checksum(data):
    value = 0x811c9dc5
    for byte in data:
        value = ((value ^ byte) * 16777619) & 0xffffffff
    return value


def record(panel, audio, peer=None, font="readable"):
    data = bytearray(4096)
    data[:] = b'\xff' * len(data)
    data[:24] = bytes(24)
    data[:4] = b'P11O'
    data[4:8] = bytes([1, PANELS[panel], AUDIO[audio], FONTS[font]])
    if peer:
        if not re.fullmatch(r'(?:[0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}', peer):
            raise ValueError('speaker must be six colon-separated hexadecimal bytes')
        data[8:14] = bytes.fromhex(peer.replace(':', ''))
    if audio == 'bluetooth' and not any(data[8:14]):
        raise ValueError('Bluetooth audio requires a nonzero --speaker address')
    struct.pack_into('<I', data, 24, checksum(data[:24]))
    return bytes(data)


def uf2(data, target):
    offset, family = TARGETS[target]
    if len(data)!=4096:
        raise ValueError('output settings require exactly one sector')
    from uf2_codec import encode
    return encode({0x10000000+offset+i:data[i:i+256] for i in range(0,4096,256)}, family)


def decode(data):
    if data[:4] != b'P11O':
        return dict(factory=True, panel='lafvin', audio='silent', font='readable')
    if len(data) < 32 or data[4] != 1 or data[5] not in PANELS.values() or data[6] not in AUDIO.values() or data[7] not in FONTS.values():
        raise ValueError('unsupported output record')
    if checksum(data[:24]) != struct.unpack_from('<I', data, 24)[0]:
        raise ValueError('output settings checksum failed')
    return dict(factory=False,
                panel=next(k for k, v in PANELS.items() if v == data[5]),
                audio=next(k for k, v in AUDIO.items() if v == data[6]),
                font=next(k for k, v in FONTS.items() if v == data[7]))


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--target', required=True, choices=TARGETS)
    ap.add_argument('--panel', choices=PANELS, default='lafvin')
    ap.add_argument('--audio', choices=AUDIO, default='silent')
    ap.add_argument('--speaker')
    ap.add_argument('--font', choices=FONTS, default='readable')
    ap.add_argument('--reset', action='store_true', help='restore factory LAFVIN/silent settings')
    ap.add_argument('--out', required=True, type=Path)
    args = ap.parse_args()
    try:
        data = b'\xff' * 4096 if args.reset else record(args.panel, args.audio, args.speaker, args.font)
    except ValueError as error:
        ap.error(str(error))
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(uf2(data, args.target))
    args.out.with_suffix('.bin').write_bytes(data)
    print('output_config:', args.target, decode(data), '->', args.out)
