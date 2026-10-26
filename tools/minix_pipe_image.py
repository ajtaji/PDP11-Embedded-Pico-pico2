"""Prepare Mini-Unix sources and a board-built J-11 pipe kernel in an RK05 image.

This edits a filesystem only. Compile the kernel with Mini-Unix cc/as/ld on
the physical board, following docs/minix/j11-pipes.md.
"""
import argparse
import re
import struct
from pathlib import Path
from types import SimpleNamespace as N
import v6fs

ROOT = Path(__file__).resolve().parents[1]


def patched_sources(fs):
    lines = (ROOT / 'docs/minix/j11-pipes.patch').read_text().splitlines(True)
    result = {}
    i = 0
    while i < len(lines):
        assert lines[i].startswith('--- a/')
        name = lines[i][6:].strip()
        assert lines[i + 1].strip() == '+++ b/' + name
        i += 2
        inode = fs.lookup('/usr/sys/mxsys/' + name)
        old = fs.read(inode).decode('ascii').splitlines(True) if inode else []
        new, pos = [], 0
        while i < len(lines) and not lines[i].startswith('--- '):
            h = re.fullmatch(r'@@ -(\d+)(?:,(\d+))? \+\d+(?:,\d+)? @@\n', lines[i])
            assert h, lines[i]
            # An insertion's old range ends AFTER this line; a nonempty
            # range starts AT its one-based line number.
            start = int(h[1]) if h[2] == '0' else max(0, int(h[1]) - 1)
            assert start >= pos
            new.extend(old[pos:start])
            pos = start
            i += 1
            while i < len(lines) and lines[i][0] in ' +-':
                line = lines[i]
                if line.startswith('--- '):
                    break
                if line[0] != '+':
                    assert pos < len(old) and old[pos] == line[1:], (name, pos)
                    pos += 1
                if line[0] != '-':
                    new.append(line[1:])
                i += 1
        new.extend(old[pos:])
        result[name] = ''.join(new).encode('ascii')
    return result


def kernel_check(data):
    magic, text, initialized, bss, symbols, entry, unused, stripped = struct.unpack_from('<8H', data)
    assert magic == 0o407 and stripped == 1 and entry == 0
    assert len(data) == 16 + text + initialized + symbols
    names = {}
    for offset in range(16 + text + initialized, len(data), 12):
        name, kind, value = struct.unpack_from('<8sHH', data, offset)
        names[name.rstrip(b'\0')] = (kind, value)
    end = text + initialized + bss
    assert names[b'_u'][1] == 0o56000 and names[b'_end'][1] == end
    # Mini-Unix's swap stack grows DOWN from _u-2, outside the user block.
    assert end + 512 <= 0o56000, 'kernel consumes the swap stack reserve'
    assert b'_pipe' in names and b'trapem' not in names
    return end


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('image', type=Path)
    ap.add_argument('--source-out', type=Path, required=True)
    ap.add_argument('--kernel', type=Path)
    ap.add_argument('--fallback', type=Path)
    ap.add_argument('-o', type=Path, required=True)
    a = ap.parse_args()
    fs = v6fs.Fs(a.image)
    sources = patched_sources(fs)
    a.source_out.mkdir(parents=True, exist_ok=True)

    def put(path, hostfile, mode):
        if fs.lookup(path):
            v6fs.cmd_rm(fs, N(path=path))
        v6fs.cmd_put(fs, N(hostfile=str(hostfile), path=path, mode=mode))

    for name, data in sources.items():
        host = a.source_out / name
        host.write_bytes(data)
        put('/usr/sys/mxsys/' + name, host, '644')
    if a.kernel:
        end = kernel_check(a.kernel.read_bytes())
        print('Kernel end:', end, '; swap stack reserve:', 0o56000 - end)
        assert a.fallback, '--fallback preserves a known working kernel'
        put('/rkmx.prev', a.fallback, '777')
        if fs.lookup('/mx'):
            v6fs.cmd_rm(fs, N(path='/mx'))
        put('/rkmx', a.kernel, '777')
        v6fs.cmd_ln(fs, N(existing='/rkmx', new='/mx'))
    fs.save_sb()
    a.o.write_bytes(fs.d)
    v6fs.cmd_check(fs)


if __name__ == '__main__':
    main()
