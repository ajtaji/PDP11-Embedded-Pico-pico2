"""Copy a validated project UF2 unchanged to an identified BOOTSEL drive.

Older uploaders may reject the standard E10 prefix. Never remove it before
mass-storage flashing: RP2350 A2 needs that flash-initialization transfer.
"""
import argparse,os
from pathlib import Path
from uf2_codec import check_bootrom,RP2350

def validate_drive(drive,family):
    info=(drive/'INFO_UF2.TXT').read_text()
    ids={'RP2350'} if family==RP2350 else {'RP2040','RPI-RP2'}
    fields=dict(line.split(':',1) for line in info.splitlines() if ':' in line)
    if not info.startswith('UF2 Bootloader') or fields.get('Board-ID','').strip() not in ids:
        raise ValueError('BOOTSEL drive does not match the UF2 target')
    return info

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('image',type=Path)
    ap.add_argument('--drive',type=Path,required=True,help='mounted BOOTSEL drive, for example I:/')
    a=ap.parse_args();data=a.image.read_bytes();family,_=check_bootrom(data)
    validate_drive(a.drive,family)
    destination=a.drive/a.image.name
    if destination.resolve()==a.image.resolve():raise ValueError('source is already on BOOTSEL drive')
    with destination.open('wb') as stream:
        stream.write(data);stream.flush();os.fsync(stream.fileno())
    print('Copied validated UF2 unchanged; wait for the board to reboot.')

if __name__=='__main__':main()
