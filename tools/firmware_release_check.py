"""Verify prepared release hashes, UF2 records, settings and unchanged packs."""
from pathlib import Path
import os,tempfile,argparse
import hashlib,json,re,subprocess,struct
from firmware_release import ROOT,FAMILY,PACKS,read_uf2,decode_bytes,payload_hash
from output_config import decode,TARGETS
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--manifest',type=Path,default=ROOT/'images/manifest-2026-10-27.json')
manifest=json.loads(ap.parse_args().manifest.read_text())
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
if 'v6_fp_kernel' in manifest:
 import v6fs
 from v6_fp_image import unpack_root,normalize_kernel
 kernel=(ROOT/manifest['v6_fp_kernel']['path']).read_bytes()
 assert hashlib.sha256(kernel).hexdigest()==manifest['v6_fp_kernel']['sha256']
 for folder in ['pico2w-v6','picoplus2','feather']:
  _,pages=read_uf2(ROOT/'images'/folder/'combined.uf2')
  header,image=unpack_root(pages)
  assert header[80:96].split(b'\0')[0]==b'rkfp'
  fd,name=tempfile.mkstemp(suffix='.rk');os.close(fd)
  try:
   Path(name).write_bytes(image);fs=v6fs.Fs(name)
   assert fs.read(fs.lookup('/rkfp'))==kernel==normalize_kernel(kernel)
   assert fs.lookup('/unix')==fs.lookup('/rkfp')
   for host,guest in [('m45fp.s','/usr/sys/conf/m45fp.s'),('mainfp.c','/usr/sys/ken/mainfp.c')]:
    assert fs.read(fs.lookup(guest))==(ROOT/'docs/v6'/host).read_text().encode('ascii')
   if folder!='pico2w-v6':
    assert header[128:144].split(b'\0')[0]==b'rkfp'
    where,_,old=v6fs.locate(fs,'/rkfp','_nswap')
    assert old==112 and struct.unpack_from('<5I',header,96)==(1,where//512,where%512,112,872)
  finally:Path(name).unlink()
if 'v7_psram_kernel' in manifest:
 from v7fs import FS
 from v6_fp_image import unpack_root
 m=manifest['v7_psram_kernel']
 assert hashlib.sha256((ROOT/m['path']).read_bytes()).hexdigest()==m['native_sha256']
 for folder in ['feather-v7','picoplus2-v7']:
  _,pages=read_uf2(ROOT/'images'/folder/'combined.uf2')
  _,image=unpack_root(pages);fs=FS(image)
  assert fs.namei('/unix')==fs.namei('/rkunix')
  kernel=fs.read(fs.namei('/rkunix'))
  assert hashlib.sha256(kernel).hexdigest()==m['installed_sha256']
  h=struct.unpack_from('<8H',kernel)
  assert h[0]==0o411 and h[2]+h[3]==41766<49152
print('RELEASE PASS:',len(seen),'files; hashes, UF2 families/records, settings, program payloads, accepted pack bytes/nonces and V6/V7 FP kernels verified')
