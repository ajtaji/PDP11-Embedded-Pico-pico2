"""Check a running board's graphics/audio demo. Acquire its lease first.

py -3 tools/demo_check.py --port COM7 --out work/demo-check.txt --audio bluetooth
"""
import argparse
import json
import re
import time
from pathlib import Path
import serial


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--port', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--audio', choices=['silent', 'plugin', 'bluetooth'], default='silent')
    args = ap.parse_args()
    transcript = ''
    with serial.Serial(args.port, 115200, timeout=.1, write_timeout=3) as port:
        for delay in (6, 5):
            port.write(b'\x1ds')
            until = time.monotonic() + delay
            while time.monotonic() < until:
                chunk = port.read(port.in_waiting or 1).decode('ascii', 'replace')
                transcript += chunk
    Path(args.out).write_text(transcript, encoding='utf-8')
    display = re.findall(r'display 164000: DPCSR ([0-7]+), DPBASE ([0-7]+), (\d+) frames seen by the PDP-11, (\d+) sent to the panel, (\d+) vertical blanks', transcript)
    assert len(display) == 2, 'missing display statistics'
    first, last = display
    assert int(last[0], 8) & 1, 'display disabled'
    assert int(last[2]) > int(first[2]), 'guest frame counter stopped'
    sent = int(last[3]) - int(first[3])
    ticks = int(last[4]) - int(first[4])
    assert sent > 0 and ticks > 0, 'panel stopped'
    assert 'HALT at' not in transcript, 'guest halted'
    assert re.search(r'errors 0 config', transcript), 'panel errors'
    result = dict(panel_frames=sent, vertical_blanks=ticks, panel_fps=round(60 * sent / ticks, 2), audio=args.audio)
    if args.audio == 'plugin':
        pcm = re.findall(r'pcm\s+consumed (\d+) nonzero (\d+) peak (\d+) lost (\d+) late (\d+)', transcript)
        assert len(pcm) == 2 and int(pcm[-1][1]) > int(pcm[0][1]), 'no sound samples'
        assert pcm[-1][3:] == ('0', '0'), 'lost or late samples'
        result['pcm'] = pcm
    if args.audio == 'bluetooth':
        audio = re.findall(r'a2dp\s+live (\d+) packets (\d+) underruns (\d+) overruns (\d+) error (\d+) late (\d+)', transcript)
        assert len(audio) == 2, 'missing A2DP statistics'
        assert all(row[0] == '1' and row[4] == '0' for row in audio), 'speaker stream failed'
        assert int(audio[-1][1]) > int(audio[0][1]), 'no audio packets'
        assert audio[-1][2] == audio[0][2], 'continuing underruns'
        assert audio[-1][3] == audio[0][3], 'continuing overruns'
        assert audio[-1][5] == audio[0][5], 'continuing synthesis delays'
        result['a2dp'] = audio
    Path(args.out + '.json').write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result))


if __name__ == '__main__':
    main()
