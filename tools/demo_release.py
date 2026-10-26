"""Add a tested demo build to an existing firmware manifest without changing Unix.

py -3 tools/demo_release.py --target rp2040 --build-dir work/demo2040-final
     --manifest images/manifest-2026-10-26.json --audio bluetooth
Commit the matching runtime source before running this publication step.
"""
import argparse
import json
import subprocess
from pathlib import Path
from firmware_release import ROOT, FAMILY, read_uf2, write_uf2, metadata, sha
from output_config import decode, TARGETS


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--target', choices=['rp2040', 'rp2350'], required=True)
    ap.add_argument('--build-dir', type=Path, required=True)
    ap.add_argument('--manifest', type=Path, required=True)
    ap.add_argument('--audio', choices=['silent', 'plugin', 'bluetooth'], required=True)
    args = ap.parse_args()
    source = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    manifest = json.loads(args.manifest.read_text())
    build = args.build_dir.resolve()
    family, pages = read_uf2(build/'demo_firmware.uf2')
    assert family == FAMILY[args.target]
    assert sorted(pages) == list(range(0x10000000, max(pages)+256, 256))
    assert max(pages)+256 <= 0x10000000 + TARGETS[args.target][0]
    settings = (build/'output_settings.bin').read_bytes()
    assert decode(settings)['audio'] == 'silent', 'public build must start silent'
    assert settings[8:14] == bytes(6), 'public settings must not contain a peer'
    folder = ROOT/'images'/('picow-demo' if args.target == 'rp2040' else 'pico2w-demo')
    folder.mkdir(parents=True, exist_ok=True)
    firmware = folder/'firmware.uf2'
    firmware.write_bytes(write_uf2(pages, family))
    sidecar = folder/'firmware.uf2.regions'
    metadata(build/'demo_firmware.uf2.regions', sidecar)
    for path in (firmware, sidecar):
        relative = path.relative_to(ROOT).as_posix()
        manifest['files'] = [f for f in manifest['files'] if f['path'] != relative]
        manifest['files'].append(dict(path=relative, bytes=path.stat().st_size, sha256=sha(path.read_bytes())))
    name = args.target+'-demo'
    if name not in manifest['programs']:
        manifest['programs'].append(name)
    manifest.setdefault('demo_profiles', {})[name] = dict(runtime_source=source, linked_audio=args.audio, default_audio='silent')
    args.manifest.write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8', newline='\n')
    (ROOT/'images/SHA256SUMS').write_text(''.join(f['sha256']+'  '+f['path'].removeprefix('images/')+'\n' for f in manifest['files']), encoding='utf-8', newline='\n')
    print('Published demo only:', firmware.relative_to(ROOT), sha(firmware.read_bytes()))


if __name__ == '__main__':
    main()
