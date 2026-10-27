"""Refresh firmware in the published UF2 images while preserving disk payloads.

Build the five programs first (output_build.py, psram_build.py, demo_build.py).
Then: py -3 tools/firmware_release.py --build-dir work/publish-20261026
          --date 2026-10-26 --compiler-sha256 HASH
The existing combined images supply the previously validated Unix packs and
pack nonces. Every preserved address/payload is compared byte-for-byte.
No private settings, debug files, or board backups are included.
"""
import argparse,hashlib,json,struct,subprocess,sys,tempfile
from datetime import date
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
FAMILY={'rp2040':0xe48bff56,'rp2350':0xe48bff59}
FLASH=0x10000000
PACKS=FLASH+0x240000

def sha(data):return hashlib.sha256(data).hexdigest()

from uf2_codec import read as read_uf2, decode as decode_bytes, pad_pages, E10_SECTOR
from uf2_codec import encode as write_uf2

def binary_pages(data,base=FLASH):
 return {base+i:data[i:i+256].ljust(256,b'\0') for i in range(0,len(data),256)}

def payload_hash(pages):
 return sha(b''.join(struct.pack('<I',a)+p for a,p in sorted(pages.items())))

def replace_program(old_path,new_program,family):
 new_program=pad_pages(new_program)
 old_family,old=read_uf2(old_path)
 if old_family!=family:raise ValueError('wrong chip family')
 if any(a>=E10_SECTOR or a<FLASH for a in new_program):raise ValueError('program reaches reserved E10 sector')
 if any(FLASH+0x200000<=a<PACKS for a in old):raise ValueError('combined image contains radio bytes')
 packs=pad_pages({a:p for a,p in old.items() if a>=PACKS})
 if not packs:raise ValueError('combined image has no disk data')
 addresses=sorted(new_program)
 if addresses!=list(range(FLASH,FLASH+len(addresses)*256,256)):
  raise ValueError('firmware must be contiguous from flash start')
 # Use the existing, proven pack-preserving replacement tool.
 with tempfile.TemporaryDirectory(prefix='pdp11-uf2-') as folder:
  fw=Path(folder)/'firmware.bin';output=Path(folder)/'combined.uf2'
  fw.write_bytes(b''.join(new_program[a] for a in addresses))
  result=subprocess.run([sys.executable,str(ROOT/'tools/uf2_firmware.py'),str(old_path),str(fw),'-o',str(output)],check=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
  print(result.stdout,end='')
  result=output.read_bytes()
 # Verify the complete output after encoding, including every unchanged address.
 _,check=decode_bytes(result)
 if {a:p for a,p in check.items() if a>=PACKS}!=packs:raise ValueError('disk bytes changed')
 if {a:p for a,p in check.items() if a<PACKS}!=new_program:raise ValueError('firmware bytes changed')
 return result,payload_hash(packs)

def metadata(source,destination):
 # Publish flash-region protections, with source paths relative to this repo.
 lines=[]
 for line in Path(source).read_text().splitlines():
  if line.startswith('F|'):
   fields=line.split('|');path=Path(fields[2])
   fields[2]=path.relative_to(ROOT).as_posix();line='|'.join(fields)
  lines.append(line)
 Path(destination).write_text('\n'.join(lines)+'\n',encoding='utf-8',newline='\n')

def main():
 ap=argparse.ArgumentParser(description=__doc__)
 ap.add_argument('--build-dir',type=Path,required=True)
 ap.add_argument('--compiler-sha256',required=True)
 ap.add_argument('--date',required=True,help='release date YYYY-MM-DD')
 ap.add_argument('--verify-existing',action='store_true',help='refuse to change any prepared UF2 bytes')
 a=ap.parse_args();date.fromisoformat(a.date);build=a.build_dir.resolve()
 a.compiler_sha256=a.compiler_sha256.lower()
 if len(a.compiler_sha256)!=64 or any(c not in '0123456789abcdefABCDEF' for c in a.compiler_sha256):ap.error('compiler SHA-256 must be 64 hexadecimal digits')
 source=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
 programs={}
 for target in ['rp2040','rp2350']:
  family,pages=read_uf2(build/(target+'.uf2'))
  assert family==FAMILY[target]
  programs[target]=(family,pages)
 for board in ['picoplus2','feather']:
  data=(build/board/'diag.bin').read_bytes()
  programs[board]=(FAMILY['rp2350'],binary_pages(data))
 files=[];disk_hashes={}
 def save(relative,data):
  path=ROOT/relative;path.parent.mkdir(parents=True,exist_ok=True)
  if a.verify_existing:
   if not path.exists() or path.read_bytes()!=data:raise ValueError('prepared image differs: '+relative)
  elif not path.exists() or path.read_bytes()!=data:path.write_bytes(data)
  files.append({'path':relative,'bytes':len(data),'sha256':sha(data)})
 for name,relative in [('rp2040','images/picow-mini-unix/firmware.uf2'),('rp2350','images/pico2w-v6/firmware.uf2'),('picoplus2','images/picoplus2/firmware.uf2'),('feather','images/feather/firmware.uf2')]:
  family,pages=programs[name];save(relative,write_uf2(pages,family))
  original=build/(name+'.uf2.regions') if name.startswith('rp') else build/name/'diag.bin.regions'
  sidecar=ROOT/(relative+'.regions');metadata(original,sidecar)
  files.append({'path':relative+'.regions','bytes':sidecar.stat().st_size,'sha256':sha(sidecar.read_bytes())})
 for folder,program in [('pico2w-v6','rp2350'),('picoplus2','picoplus2'),('picoplus2-v7','picoplus2'),('feather','feather'),('feather-v7','feather')]:
  relative='images/'+folder+'/combined.uf2';family,pages=programs[program]
  data,digest=replace_program(ROOT/relative,pages,family)
  disk_hashes[relative]=digest;save(relative,data)
 demo=build/'demo/demo_firmware.uf2';family,pages=read_uf2(demo)
 assert family==FAMILY['rp2350'];save('images/pico2w-demo/firmware.uf2',write_uf2(pages,family))
 sidecar=ROOT/'images/pico2w-demo/firmware.uf2.regions';metadata(str(demo)+'.regions',sidecar)
 files.append({'path':sidecar.relative_to(ROOT).as_posix(),'bytes':sidecar.stat().st_size,'sha256':sha(sidecar.read_bytes())})
 from output_config import PANELS,record,uf2
 for target in ['rp2040','rp2350']:
  for panel in PANELS:
   save('images/output-settings/'+target+'-'+panel+'.uf2',uf2(record(panel,'silent'),target))
 minix=ROOT/'images/picow-mini-unix/minix.uf2'
 minix_family,minix_pages=read_uf2(minix)
 save(minix.relative_to(ROOT).as_posix(),write_uf2(minix_pages,minix_family))
 manifest={'date':a.date,'runtime_source':source,'pack_base_revision':source,'compiler_sha256':a.compiler_sha256,'psram_profiles':{'picoplus2':'Pimoroni_Pico_Plus_2_W.board','feather':'Adafruit_Feather_RP2350_HSTX.board'},'audio':'silent','default_font':'Lato-derived Terminal Sans 16 px, sRGB text coverage','programs':list(programs)+['rp2350-demo'],'unchanged_disk_payload_sha256':disk_hashes,'files':files}
 kernel=ROOT/'media/unix/rkfp-j11'
 manifest['v6_fp_kernel']={'path':'media/unix/rkfp-j11','sha256':sha(kernel.read_bytes()),'boot':'rkfp','format':'V6 sysfix 0407 data-first','context':'FPS and six full D accumulators','sources':'docs/v6/FP-KERNEL.md'}
 from v6_fp_image import unpack_root
 from v7fs import FS
 _,v7pages=read_uf2(ROOT/'images/picoplus2-v7/combined.uf2')
 _,v7root=unpack_root(v7pages)
 v7fs=FS(v7root)
 native=ROOT/'media/unix/v7/rkunix-psram'
 manifest['v7_psram_kernel']={'path':'media/unix/v7/rkunix-psram','native_sha256':sha(native.read_bytes()),'installed_sha256':sha(v7fs.read(v7fs.namei('/rkunix'))),'buffers':29,'context':'FPS and six D accumulators across fork/exec; masked raw transfers','sources':'docs/v7/PSRAM-KERNEL.md'}
 (ROOT/('images/manifest-'+a.date+'.json')).write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
 (ROOT/'images/SHA256SUMS').write_text(''.join(f["sha256"]+'  '+f['path'].removeprefix('images/')+'\n' for f in files),encoding='utf-8',newline='\n')
 print('Prepared',len(files),'files; all existing disk payloads unchanged.')

if __name__=='__main__':main()
