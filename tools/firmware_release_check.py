"""Verify prepared release hashes, UF2 records, settings and unchanged packs."""
from pathlib import Path
import hashlib,json,re,subprocess,struct
from firmware_release import ROOT,FAMILY,PACKS,read_uf2,decode_bytes,payload_hash
from output_config import decode,TARGETS
manifest=json.loads((ROOT/'images/manifest-2026-10-26.json').read_text())
assert re.fullmatch('[0-9a-f]{64}',manifest['compiler_sha256'])
seen=set()
for entry in manifest['files']:
 path=ROOT/entry['path'];assert path.resolve().is_relative_to(ROOT/'images')
 assert entry['path'] not in seen;seen.add(entry['path'])
 data=path.read_bytes()
 assert len(data)==entry['bytes'] and hashlib.sha256(data).hexdigest()==entry['sha256'],entry['path']
 if path.suffix=='.uf2':
  family,pages=read_uf2(path)
  assert family in FAMILY.values()
  if path.name=='firmware.uf2':
   target='rp2040' if path.parent.name in ('picow-mini-unix','picow-demo') else 'rp2350'
   assert family==FAMILY[target] and min(pages)==0x10000000
   assert max(pages)+256<=0x10000000+TARGETS[target][0]
  if 'output-settings' in entry['path']:
   target='rp2040' if path.name.startswith('rp2040') else 'rp2350'
   assert family==FAMILY[target] and sorted(pages)==list(range(0x10000000+TARGETS[target][0],0x10000000+TARGETS[target][0]+4096,256))
   decoded=decode(b''.join(pages[a] for a in sorted(pages)))
   assert decoded['audio']=='silent' and decoded['font']=='readable'
   assert path.stem==target+'-'+decoded['panel']
 if path.suffix=='.regions':
  assert b'\r' not in data
  for line in data.decode().splitlines():
   if line.startswith('F|'):assert not re.match(r'[A-Za-z]:|/',line.split('|')[2])
   if line.startswith('S|'):assert int(line.split('|')[4])<0x4f000
for folder,fw in [('pico2w-v6','pico2w-v6'),('picoplus2','picoplus2'),('picoplus2-v7','picoplus2'),('feather','feather'),('feather-v7','feather')]:
 rel='images/'+folder+'/combined.uf2';family,pages=read_uf2(ROOT/rel)
 old=subprocess.check_output(['git','show',manifest['pack_base_revision']+':'+rel],cwd=ROOT)
 old_family,old_pages=decode_bytes(old)
 packs={a:p for a,p in pages.items() if a>=PACKS}
 assert old_family==family and packs=={a:p for a,p in old_pages.items() if a>=PACKS},rel
 assert payload_hash(packs)==manifest['unchanged_disk_payload_sha256'][rel]
 _,code=read_uf2(ROOT/'images'/fw/'firmware.uf2')
 assert {a:p for a,p in pages.items() if a<PACKS}==code
assert (ROOT/'images/picow-mini-unix/minix.uf2').read_bytes()==subprocess.check_output(['git','show',manifest['pack_base_revision']+':images/picow-mini-unix/minix.uf2'],cwd=ROOT)
print('RELEASE PASS:',len(seen),'files; hashes, UF2 families/records, settings, program payloads and all original disk bytes/nonces verified')
