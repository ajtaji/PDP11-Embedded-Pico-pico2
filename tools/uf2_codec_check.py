"""UF2 release safety tests using real sparse layouts and rejection mutants."""
from pathlib import Path
import unittest,struct
from uf2_codec import *
from bootsel_upload import validate_drive
import tempfile

class Uf2Safety(unittest.TestCase):
    def setUp(self):
        self.pages={FLASH:b'A'*256,FLASH+0x100:b'B'*256,FLASH+0x240000:b'D'*256}
    def test_sparse_sectors_without_writing_gaps(self):
        data=encode(self.pages,RP2350);family,pages=check_bootrom(data)
        self.assertEqual(family,RP2350);self.assertEqual(len(pages),32)
        for a,b in self.pages.items():self.assertEqual(pages[a],b)
        self.assertTrue(all(a<FLASH+4096 or FLASH+0x240000<=a<FLASH+0x241000 for a in pages))
        self.assertEqual(data[:512],e10_block())
        self.assertNotIn(E10_TARGET,pages)
    def test_unsafe_last_flash_workaround_rejected(self):
        data=bytearray(encode(self.pages,RP2350));struct.pack_into('<I',data,12,FLASH+0x1000000-256)
        with self.assertRaises(ValueError):decode(data)
    def test_image_cannot_occupy_workaround_sector(self):
        with self.assertRaises(ValueError):encode({E10_SECTOR:b'X'*256},RP2350)
    def test_wrong_main_family_rejected(self):
        data=bytearray(encode(self.pages,RP2350));struct.pack_into('<I',data,512+28,RP2040)
        with self.assertRaises(ValueError):decode(data)
    def test_duplicate_address_and_bad_counts_rejected(self):
        data=bytearray(encode(self.pages,RP2350))
        for offset,value in [(512+24,1),(1024+12,FLASH),(1024+20,0)]:
            mutant=bytearray(data);struct.pack_into('<I',mutant,offset,value)
            with self.assertRaises(ValueError):decode(mutant)
    def test_missing_page_rejected_by_release_gate(self):
        data=encode(self.pages,RP2350)
        family,pages=decode(data);pages.pop(FLASH+0x200)
        body=bytearray()
        for i,(a,b) in enumerate(sorted(pages.items())):
            body+=struct.pack('<8I',MAGIC0,MAGIC1,0x2000,a,256,i,len(pages),family)+b+bytes(220)+struct.pack('<I',END)
        with self.assertRaises(ValueError):check_bootrom(e10_block()+body)
    def test_prefix_extension_is_required(self):
        data=bytearray(encode(self.pages,RP2350));data[288]^=1
        with self.assertRaises(ValueError):decode(data)
    def test_rp2040_has_padding_without_e10(self):
        data=encode(self.pages,RP2040);self.assertEqual(struct.unpack_from('<I',data,28)[0],RP2040);check_bootrom(data)
    def test_bootsel_drive_family_is_checked(self):
        with tempfile.TemporaryDirectory() as folder:
            p=Path(folder);(p/'INFO_UF2.TXT').write_text('UF2 Bootloader v1.1\nModel: Raspberry Pi RP2350\nBoard-ID: RP2350\n')
            validate_drive(p,RP2350)
            with self.assertRaises(ValueError):validate_drive(p,RP2040)
            (p/'INFO_UF2.TXT').write_text('UF2 Bootloader v3.0\nBoard-ID: RPI-RP2\n')
            validate_drive(p,RP2040)
            with self.assertRaises(ValueError):validate_drive(p,RP2350)
    def test_missing_drive_is_refused(self):
        with tempfile.TemporaryDirectory() as folder:
            with self.assertRaises(FileNotFoundError):validate_drive(Path(folder),RP2350)
    def test_ram_images_do_not_gain_flash_prefix_or_padding(self):
        p={0x20000000:b'R'*256};data=encode(p,RP2350);self.assertEqual(decode(data),(RP2350,p))

if __name__=='__main__':unittest.main()
