"""The board's compact CPU state and the desktop's typed host-pointer view.
R0-R7, the alternate bank, hot scalar state and four fetch words occupy one
140-byte block. Assembly offsets are constants and cannot depend on unrelated
linker placement. Desktop generation restores the separate 64-bit fetch view.
"""
import re
HOT=['CurD','CurI','EaBase','Ea','Src','Dst','TrapVector','FlagC','FlagV','Mmr0','Mmr1','MmuPcRec','Tmp','Adr','EaSpec','EaStep','EaReg']
SLOTS={n:18+i for i,n in enumerate(HOT)}
OFFSETS={'regalt':32,'fw':56,**{n.lower():4*i for n,i in SLOTS.items()}}

def calls(text,name,replace):
 p=re.compile(r'\b'+name+r'\(');out=[];start=0
 while (m:=p.search(text,start)):
  depth=1;i=m.end()
  while i<len(text) and depth:
   depth+=(text[i]=='(')-(text[i]==')');i+=1
  if depth:raise ValueError('unclosed '+name+' index')
  out.extend([text[start:m.start()],replace(text[m.end():i-1])]);start=i
 return ''.join(out)+text[start:]

def code_line(line,fn):
 # Never rewrite user-visible string literals or comments as BASIC identifiers.
 out=[];start=0;i=0;quoted=False
 while i<len(line):
  if line[i]=='"':
   if not quoted:
    out.append(fn(line[start:i]));start=i;quoted=True
   elif i+1<len(line) and line[i+1]=='"':i+=1
   else:out.append(line[start:i+1]);start=i+1;quoted=False
  elif line[i]==';' and not quoted:
   out.append(fn(line[start:i]));out.append(line[i:]);return ''.join(out)
  i+=1
 out.append(line[start:] if quoted else fn(line[start:]));return ''.join(out)

def arguments(text):
    result=[];start=0;depth=0
    for i,c in enumerate(text):
        depth+=(c=='(')-(c==')')
        if c==',' and depth==0:result.append(text[start:i].strip());start=i+1
    result.append(text[start:].strip());return result

def slot_reads(line):
    for name in ['MReadWord','MReadByte','MMReadWordE','MMReadByteE','MMReadWord','MMReadByte']:
        def convert(a):
            args=arguments(a)
            if args and args[0].startswith('Reg(#CPU_'):
                return name+'Slot(@'+args[0]+', '+', '.join(args[1:])+')'
            return name+'('+a+')'
        line=calls(line,name,convert)
    return line

def basic_forward(line):
 line=calls(line,'RegAlt',lambda a:'Reg(#CPU_ALT + ('+a+'))')
 line=calls(line,'Fw',lambda a:'Reg(#CPU_FW + ('+a+'))')
 line=re.sub(r'\b('+ '|'.join(HOT)+r')\b',lambda m:'Reg(#CPU_'+m[0].upper()+')',line)
 return slot_reads(line)

def basic_reverse(line):
 def reg(a):
  m=re.fullmatch(r'\s*#CPU_(\w+)\s*(?:\+\s*(.*))?',a)
  if not m:return 'Reg('+basic_reverse(a)+')'
  n,tail=m.groups()
  if n in ('ALT','FW'):
   tail=tail.strip()
   if tail.startswith('(') and tail.endswith(')'):tail=tail[1:-1]
   return ('RegAlt' if n=='ALT' else 'Fw')+'('+tail+')'
  names={n.upper():n for n in HOT}
  if n not in names or tail:raise ValueError('unknown compact CPU field '+a)
  return names[n]
 return calls(line,'Reg',reg)

def forward(text,native_base=False):
 out=[];asm=False
 for line in text.splitlines():
  if re.match(r'\s*ASM(?:\s|$)',line):asm=True
  if asm:
   line=re.sub(r'\bglobal_('+ '|'.join(OFFSETS)+r')\b',lambda m:'global_reg + '+str(OFFSETS[m[1]]),line)
   if native_base:
    def mem(m):
     op,dest,expr=m.groups();expr=expr.replace('global_reg','0')
     if not re.fullmatch(r'[0-9 +\-()]+',expr):return m[0]
     offset=eval(expr,{'__builtins__':{}},{})
     suffix='' if offset>=0 and offset<=124 and offset%4==0 and int(dest[1:])<8 else '.w'
     return op+suffix+' '+dest+', [r5, #'+str(offset)+']'
    line=re.sub(r'\b(ldr|str)\.w (r\d+), \[r5, #([^]]+)\]',mem,line)
    line=re.sub(r'ldr (r\d+), =global_reg \+ (\d+)\s*$',lambda m:'add.w '+m[1]+', r5, #'+m[2],line)
  else:line=code_line(line,basic_forward)
  out.append(line)
  if re.match(r'\s*EndASM\b',line):asm=False
 text='\n'.join(out)+'\n'
 if native_base:
  def uses(m):
   indent,header,body=m.groups()
   if re.search(r'\br5\b',body) and 'GBase' not in header:
    header=header+', GBase' if 'Uses' in header else header+' Uses GBase'
   return indent+header+'\n'+body+indent+'EndASM'
  text=re.sub(r'(?m)^( *)(ASM[^\n]*)\n([\s\S]*?)^ *EndASM',uses,text)
 return text

def pack_cpu(text):
 old=re.search(r'Global Dim Reg\.i\(8\)',text)
 if not old:raise ValueError('CPU register declaration moved')
 lines=[]
 for line in text.splitlines():
  if re.match(r'Global Dim (RegAlt|Fw)\.',line):continue
  if line.startswith('Global ') and not line.startswith('Global Dim '):
   code,sep,comment=line.partition(';')
   decls=[x.strip() for x in code[len('Global '):].split(',')]
   decls=[x for x in decls if re.match(r'(\w+)\.',x).group(1) not in SLOTS]
   if not decls:
    if sep:lines.append('; '+comment.strip())
    continue
   line='Global '+', '.join(decls)+(' ;'+comment if sep else '')
  lines.append(line)
 text='\n'.join(lines)+'\n'
 consts='; Compact CPU state: two register banks, hot scalar words, fetch window.\n#CPU_ALT = 8\n'
 consts+=''.join('#CPU_'+n.upper()+' = '+str(i)+'\n' for n,i in SLOTS.items())
 consts+='#CPU_FW = 14\n#CPU_WORDS = 35\n'
 text=text.replace('Global Dim Reg.i(8)',consts+'Global Dim Reg.i(#CPU_WORDS)',1)
 return forward(text)

def desktop(text,is_cpu=False):
 out=[];asm=False
 for line in text.splitlines():
  if re.match(r'\s*ASM(?:\s|$)',line):asm=True
  out.append(line if asm else code_line(line,basic_reverse))
  if re.match(r'\s*EndASM\b',line):asm=False
 text='\n'.join(out)+'\n'
 # The desktop has scalar destinations again; use its original read macros.
 reads=['MReadWord','MReadByte','MMReadWordE','MMReadByteE','MMReadWord','MMReadByte']
 if is_cpu:
  for name in reads:
   text=re.sub(r'(?m)^Macro '+name+r'Slot\([^\n]*\)\n[\s\S]*?^EndMacro\n', '', text)
 for name in reads:
  def restore(a):
   args=arguments(a)
   if not args[0].startswith('@'):raise ValueError('slot destination is not an address')
   return name+'('+args[0][1:]+', '+', '.join(args[1:])+')'
  text=calls(text,name+'Slot',restore)
 if is_cpu:
  text=re.sub(r'(?m)^#CPU_\w+ = [0-9]+\n','',text)
  decls=''.join('Global '+n+'.i\n' for n in HOT)+'Global Dim RegAlt.i(6)\nGlobal Dim Fw.i(4)\n'
  text=text.replace('Global Dim Reg.i(#CPU_WORDS)',decls+'Global Dim Reg.i(8)',1)
 return text
