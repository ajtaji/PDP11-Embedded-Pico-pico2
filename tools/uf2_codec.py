"""Strict project UF2 codec, sector padding and a data-safe RP2350 A2 prefix.

The E10 block is a separate, incomplete Absolute-family transfer, not an
ordinary data page. Newer ROMs ignore its extension; A2 may erase its sector.
Only the explicitly reserved project sector is accepted for that write.
"""
from pathlib import Path
import struct
import flash_layout

FLASH = 0x10000000
SECTOR = 4096
PAGE = 256
RP2040 = 0xe48bff56
RP2350 = 0xe48bff59
ABSOLUTE = 0xe48bff57
MAGIC0, MAGIC1, END = 0x0a324655, 0x9e5d5157, 0x0ab16f30
IGNORE = 0x9957e304
E10_SECTOR = FLASH + flash_layout.E10
E10_TARGET = E10_SECTOR + SECTOR - PAGE

def pad_pages(pages):
    """Fill only touched flash sectors. Never fill the gaps between regions."""
    result = dict(pages)
    for a,b in pages.items():
        if a % PAGE or len(b) != PAGE:
            raise ValueError('UF2 pages must be aligned 256-byte payloads')
    for sector in {a & ~(SECTOR-1) for a in pages if FLASH <= a < FLASH+0x2000000}:
        for a in range(sector, sector+SECTOR, PAGE):
            result.setdefault(a, b'\xff'*PAGE)
    return result

def e10_block():
    header = struct.pack('<8I', MAGIC0,MAGIC1,0xa000,E10_TARGET,PAGE,0,2,ABSOLUTE)
    return header + b'\xef'*PAGE + struct.pack('<I',IGNORE) + bytes(216) + struct.pack('<I',END)

def encode(pages,family,*,bootrom=True):
    if family not in (RP2040,RP2350):
        raise ValueError('unsupported main UF2 family')
    pages = pad_pages(pages)
    if not pages:
        raise ValueError('empty UF2')
    prefix = bootrom and family == RP2350 and all(FLASH <= a < FLASH+0x2000000 for a in pages)
    if prefix and any(E10_SECTOR <= a < E10_SECTOR+SECTOR for a in pages):
        raise ValueError('image overlaps reserved E10 workaround sector')
    result = bytearray(e10_block() if prefix else b'')
    count = len(pages)
    for i,(a,b) in enumerate(sorted(pages.items())):
        result += struct.pack('<8I',MAGIC0,MAGIC1,0x2000,a,PAGE,i,count,family)
        result += b + bytes(220) + struct.pack('<I',END)
    return bytes(result)

def decode(data):
    if not data or len(data)%512:
        raise ValueError('UF2 length must be a nonzero multiple of 512')
    first = struct.unpack_from('<8I',data)
    prefix = first[7] == ABSOLUTE
    if prefix:
        if data[:512] != e10_block():
            raise ValueError('invalid or unsafe E10 prefix')
        data = data[512:]
    total = len(data)//512
    if not total:
        raise ValueError('E10 prefix has no main image')
    pages={};indices=set();family=None
    for pos in range(0,len(data),512):
        h=struct.unpack_from('<8I',data,pos)
        if h[:3]!=(MAGIC0,MAGIC1,0x2000) or h[4]!=PAGE or h[6]!=total or h[5]>=total or h[5] in indices:
            raise ValueError('invalid UF2 header/count/index')
        if struct.unpack_from('<I',data,pos+508)[0]!=END or h[3]%PAGE:
            raise ValueError('invalid UF2 address/end marker')
        if h[7] not in (RP2040,RP2350) or (family is not None and family!=h[7]):
            raise ValueError('mixed or unsupported main UF2 family')
        family=h[7];indices.add(h[5])
        if h[3] in pages:
            raise ValueError('duplicate UF2 target address')
        pages[h[3]]=data[pos+32:pos+288]
    if prefix and (family != RP2350 or not all(FLASH <= a < FLASH+0x2000000 for a in pages) or any(E10_SECTOR <= a < E10_SECTOR+SECTOR for a in pages)):
        raise ValueError('E10 prefix conflicts with main image')
    return family,pages

def read(path):
    return decode(Path(path).read_bytes())

def check_bootrom(data):
    family,pages=decode(data)
    if pages!=pad_pages(pages):
        raise ValueError('incomplete touched flash sector')
    if family==RP2350 and all(FLASH <= a < FLASH+0x2000000 for a in pages) and struct.unpack_from('<I',data,28)[0]!=ABSOLUTE:
        raise ValueError('RP2350 BOOTSEL image is missing E10 prefix')
    return family,pages
