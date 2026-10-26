"""Check settings records and UF2 boundaries without executing target code."""
import struct
from output_config import record, decode, uf2, TARGETS, PANELS

for target, (offset, family) in TARGETS.items():
    for panel in PANELS:
        data = record(panel, 'silent')
        assert decode(data)['panel'] == panel
        image = uf2(data, target)
        assert len(image) == 8192
        rebuilt = bytearray()
        for number in range(16):
            block = image[number*512:(number+1)*512]
            magic, magic2, flags, address, size, index, count, chip = struct.unpack_from('<8I', block)
            assert (magic, magic2, flags, size, index, count, chip) == (0x0a324655,0x9e5d5157,0x2000,256,number,16,family)
            assert address == 0x10000000 + offset + number * 256
            assert struct.unpack_from('<I', block, 508)[0] == 0x0ab16f30
            rebuilt += block[32:288]
        assert rebuilt == data
    assert offset + 4096 <= (0x40000 if target == 'rp2040' else 0x50000)

valid = record('ili9341', 'plugin')
for index in range(4, 28):
    broken = bytearray(valid)
    broken[index] ^= 0x80
    try:
        decode(broken)
    except ValueError:
        pass
    else:
        raise AssertionError('damaged settings accepted at byte %d' % index)
for bad in [None, '00:00:00:00:00:00', 'invalid']:
    try:
        record('lafvin', 'bluetooth', bad)
    except ValueError:
        pass
    else:
        raise AssertionError('invalid speaker accepted')
assert decode(bytes([255])*4096)['factory']
print('OUTPUT SETTINGS PASS: two targets, five panels, sector boundaries, corruption and speaker validation')
