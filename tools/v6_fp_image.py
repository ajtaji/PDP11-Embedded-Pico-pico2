"""Install the board-built FP-enabled V6 kernel into an existing Pico UF2.

This edits disk-image bytes only; it never executes guest instructions.
Original regular files and fallback kernels remain, /unix names /rkfp.
Only RK0 is repacked; RK1/RP03, program, radio and output settings are kept.
The changed RK0 receives a new store nonce so old saved blocks cannot be
applied to a different filesystem. Back up saved files before installation.
"""
import argparse,hashlib,os,struct,tempfile
from pathlib import Path
from types import SimpleNamespace as N
import v6fs,rk_image
from firmware_release import FLASH,FAMILY,read_uf2,write_uf2

ROOT=Path(__file__).resolve().parents[1]
START=FLASH+0x240000
END=FLASH+0x4c0000

def span(pages,start,size):
    assert start%256==size%256==0
    return b''.join(pages[a] for a in range(start,start+size,256))

def unpack_root(pages):
    header=span(pages,START,4096)
    magic,version,layout,stored,slots,maps,flags=struct.unpack_from('<8s6I',header)
    assert magic==b'PDP11RK1' and version==1 and layout in (0,1)
    image=bytearray(4872*512)
    if layout==0:
        assert stored==4872
        image[:]=span(pages,START+4096,stored*512)
    else:
        assert maps==3 and stored<=slots
        table=span(pages,START+4096,maps*4096)
        body=span(pages,START+4096+maps*4096,stored*512)
        for block in range(4872):
            slot=struct.unpack_from('<H',table,block*2)[0]
            assert slot<=stored
            if slot:image[block*512:(block+1)*512]=body[(slot-1)*512:slot*512]
    return header,image

def kernel_symbols(data):
    h=struct.unpack_from('<8H',data)
    # V6 sysfix emits 0407 with DATA FIRST and text linked at 8192.
    # It is not the normal 0407 text/data layout used by user executables.
    assert h[0]==0o407 and h[7]==1 and h[5]==0
    assert len(data)==16+h[1]+h[2]+h[4]
    assert h[1]<0xe000 and h[2]+h[3]+512<=0xc000
    syms={}
    for off in range(16+h[1]+h[2],len(data),12):
        name,kind,value=struct.unpack_from('<8sHH',data,off)
        syms[name.rstrip(b'\0')]=(kind,value)
    for name in [b'_savfp',b'_cputype',b'_nswap',b'_etext',b'_edata']:assert name in syms,name
    assert syms[b'_etext'][1]==8192+h[1] and syms[b'_edata'][1]==h[2]
    offset=16+h[2]+syms[b'_savfp'][1]-8192
    assert 16+h[2]<=offset<16+h[2]+h[1]
    assert struct.unpack_from('<H',data,offset)[0]!=0o207,'FP save is a stub'
    return h,syms

def normalize_kernel(data):
    h,syms=kernel_symbols(data)
    kind,val=syms[b'_nswap'];assert kind&31==3 and val+2<=h[2]
    off=16+val
    assert struct.unpack_from('<H',data,off)[0] in (112,872)
    out=bytearray(data);struct.pack_into('<H',out,off,112)
    return bytes(out)

def patch_root(image,kernel,sources):
    fd,name=tempfile.mkstemp(suffix='.rk');os.close(fd)
    try:
        path=Path(name);path.write_bytes(image);fs=v6fs.Fs(path)
        regular={i:fs.read(i) for i in range(1,fs.isize*16+1)
                 if fs.inode(i)['mode']&v6fs.IALLOC and fs.inode(i)['mode']&v6fs.IFMT==0}
        assert not fs.lookup('/rkfp'),'new kernel name already exists'
        fd,kname=tempfile.mkstemp();os.close(fd)
        try:
            Path(kname).write_bytes(normalize_kernel(kernel))
            v6fs.cmd_put(fs,N(hostfile=kname,path='/rkfp',mode='777'))
        finally:Path(kname).unlink()
        old_unix=fs.lookup('/unix')
        if old_unix:
            if fs.inode(old_unix)['nlink']==1:
                assert not fs.lookup('/unix.prev'),'recovery name already exists'
                v6fs.cmd_ln(fs,N(existing='/unix',new='/unix.prev'))
            v6fs.cmd_rm(fs,N(path='/unix'))
        v6fs.cmd_ln(fs,N(existing='/rkfp',new='/unix'))
        for host,guest in [(sources/'m45fp.s','/usr/sys/conf/m45fp.s'),(sources/'mainfp.c','/usr/sys/ken/mainfp.c')]:
            assert not fs.lookup(guest),guest
            fd,sname=tempfile.mkstemp();os.close(fd)
            try:
                # Unix tools must receive LF source even from a CRLF checkout.
                Path(sname).write_bytes(host.read_text().encode('ascii'))
                v6fs.cmd_put(fs,N(hostfile=sname,path=guest,mode='644'))
            finally:Path(sname).unlink()
        where,_,old=v6fs.locate(fs,'/rkfp','_nswap');assert old==112
        fs.save_sb();v6fs.cmd_check(fs)
        # Verify every existing regular inode, including both fallback kernels.
        for i,data in regular.items():assert fs.read(i)==data,('existing file changed',i)
        assert fs.read(fs.lookup('/unix'))==normalize_kernel(kernel)
        print('Preserved',len(regular),'existing regular files; added FP kernel and sources')
        return bytes(fs.d),(where//512,where%512,112,872)
    finally:Path(name).unlink()

def repack(pages,chip,header,image,patch):
    layout=struct.unpack_from('<I',header,12)[0]
    rk_image.SWAP=struct.unpack_from('<II',header,64)
    parts,_=rk_image.build(image,chip,'mapped' if layout else 'dense',4872,'v6root')
    fresh=bytearray(header)
    fresh[12:28]=parts[0x240000][12:28]
    fresh[80:96]=b'rkfp'+bytes(12)
    if chip!='pico2':
        fresh[128:144]=b'rkfp'+bytes(12)
        struct.pack_into('<5I',fresh,96,1,*patch)
    # Deterministic new identity for this changed image, distinct from its base.
    fresh[192:196]=hashlib.sha256(header[192:196]+image).digest()[:4]
    assert fresh[192:196]!=header[192:196]
    parts[0x240000]=bytes(fresh)
    packed={}
    for offset,data in parts.items():
        for pos in range(0,len(data),256):packed[FLASH+offset+pos]=data[pos:pos+256].ljust(256,b'\0')
    limit=FLASH+rk_image.FLASH[chip] if chip=='pico2' else END
    assert packed and max(packed)+256<=limit
    out={a:p for a,p in pages.items() if not START<=a<limit}
    out.update(packed)
    assert {a:p for a,p in out.items() if not START<=a<limit}=={a:p for a,p in pages.items() if not START<=a<limit}
    return out,packed

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('image',type=Path)
    ap.add_argument('--kernel',type=Path,required=True)
    ap.add_argument('--chip',choices=['pico2','picoplus2','feather'],required=True)
    ap.add_argument('--sources',type=Path,default=ROOT/'docs/v6')
    ap.add_argument('--root-out',type=Path)
    ap.add_argument('--pack-only',type=Path)
    ap.add_argument('-o',type=Path,required=True)
    a=ap.parse_args();family,pages=read_uf2(a.image);assert family==FAMILY['rp2350']
    header,image=unpack_root(pages)
    image,patch=patch_root(image,a.kernel.read_bytes(),a.sources)
    out,pack=repack(pages,a.chip,header,image,patch)
    a.o.write_bytes(write_uf2(out,family))
    if a.pack_only:a.pack_only.write_bytes(write_uf2(pack,family))
    if a.root_out:a.root_out.write_bytes(image)
    print('Installed FP-enabled V6 kernel; every non-RK0 UF2 page unchanged')

if __name__=='__main__':main()
