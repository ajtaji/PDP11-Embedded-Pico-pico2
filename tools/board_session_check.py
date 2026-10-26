"""Run from the repository root: py -3 tools/board_session_check.py.

A delayed reply must not reuse the previous prompt as a command result.
The serial port and clock are replaced; no physical board is accessed.
"""
import contextlib
import importlib.util
import io
import json
import sys
import types
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('board_session', 'tools/board_session.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)

class Port:
    def __init__(self, reply):
        self.initial = True
        self.sent = False
        self.reads = 0
        self.reply = reply
    @property
    def in_waiting(self):
        return 0

    def write(self, data):
        self.sent = True

    def read(self, count):
        if self.initial:
            self.initial = False
            return b'# '
        self.reads += 1
        if self.sent and self.reads == 4:
            return self.reply
        return b''

    def close(self):
        pass

Path('work').mkdir(exist_ok=True)
for name, reply, expected in [('delayed', b'slow\nACTUAL RESULT\n# ', 0), ('timeout', b'', 1)]:
    p = Port(reply)
    clock = [0.]

    def now():
        clock[0] += .1
        return clock[0]

    script = Path('work/harness-' + name + '.txt')
    output = Path('work/harness-' + name + '.json')
    script.write_text('!boot\n!timeout 1\nslow\n')
    argv = ['board_session', '--usb-serial', 'TEST', '--script', str(script), '--json-out', str(output)]
    fake = types.SimpleNamespace(Serial=lambda *a, **k: p)
    with (patch.dict(sys.modules, serial=fake),
          patch.object(m.pack_install, 'find_port_quiet', return_value='TEST'),
          patch.object(sys, 'argv', argv),
          patch.object(m.time, 'time', side_effect=now),
          contextlib.redirect_stdout(io.StringIO())):
        rc = m.main()
    data = json.loads(output.read_text())
    assert rc == expected, (name, rc)
    if name == 'delayed':
        assert data['commands'][0]['output'] == 'ACTUAL RESULT', data
    else:
        assert not data['commands'][0]['completed'], data
    print(name, 'PASS')
