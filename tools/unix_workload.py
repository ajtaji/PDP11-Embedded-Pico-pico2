"""Generate and validate ordinary V6/Mini-Unix hardware workloads.

Each phase starts from a fresh boot of the same disk pack. A full RAM write
overlay is a failed phase, never an accepted timing. No firmware changes or
guest program recognition are involved. board_session.py records each reply.
"""
import argparse
import json
from pathlib import Path
import re


CALC = '''fib(n) int n; { if(n<2) return(n); return(fib(n-1)+fib(n-2)); }
gcd(a,b) int a,b; { int t; while(b){ t=a%b; a=b; b=t; } return(a); }
ucopy(a,b,n) char *a,*b; int n; { while(n--) *a++ = *b++; }
'''
MAIN = '''char a[512],b[512];
main(){ int i,s,e; for(i=0;i<512;i++) a[i]=i;
ucopy(b,a,512); e=0; for(i=0;i<512;i++) if(a[i]!=b[i]) e++;
s=0; for(i=0;i<20;i++) s=+fib(12);
printf("ARITH %d %d %d\\n",s,gcd(1071,462),e); }
'''
IPC = '''main(){ int p[2],pid,n,st; char b[32];
if(pipe(p)<0){ printf("PIPE FAILED\\n"); exit(1); }
pid=fork(); if(pid<0){ printf("FORK FAILED\\n"); exit(1); }
if(pid==0){ close(p[0]); write(p[1],"unix-pipe-ok\\n",13); close(p[1]); exit(0); }
close(p[1]); n=read(p[0],b,32); close(p[0]); st=123; wait(&st);
write(1,b,n); printf("IPC %d %d\\n",n,st); }
'''
FILES = '''char b[512],c[512];
main(){ int f,i,j,n,e; e=0; n=0; f=creat("binary",0600);
if(f<0){ printf("CREATE FAILED\\n"); exit(1); }
for(j=0;j<4;j++){ for(i=0;i<512;i++) b[i]=i+j;
if(write(f,b,512)!=512) e++; } close(f); f=open("binary",0);
for(j=0;j<4;j++){ n=+read(f,c,512); for(i=0;i<512;i++) if((c[i]&255)!=((i+j)&255)) e++; }
seek(f,511,0); if(read(f,c,3)!=3) e++;
if((c[0]&255)!=255 || (c[1]&255)!=1 || (c[2]&255)!=2) e++;
close(f); printf("FILES %d %d\\n",n,e); }
'''
GEN = '''main(){ int i; for(i=127;i>=0;i--) printf("%03d group%d\\n",i,i%8); }
'''


class Phase:
    def __init__(self):
        self.script = ['!boot', '!wait 1', 'stty -lcase', '!timeout 120']
        self.rules = [dict(command='stty -lcase', group='setup')]

    def cmd(self, command, group='setup', exact=None, pattern=None):
        self.script.append(command)
        self.rules.append(dict(command=command, group=group, exact=exact, pattern=pattern))

    def file(self, name, source):
        self.script += ['!raw cat >' + name, '!line ']
        self.script += ['!line ' + line for line in source.splitlines()]
        self.script += ['!eof', '!wait 0.2']

    def finish(self):
        self.cmd('sync', exact='')
        self.cmd('ls /', pattern=r'(?m)^usr$')
        self.script.append('!stats')


def generate(folder, target):
    folder.mkdir(parents=True, exist_ok=True)
    phases = {}
    p = Phase()
    p.cmd('mkdir /ut', exact='')
    p.cmd('chdir /ut', exact='')
    p.file('calc.c', CALC)
    p.file('main.c', MAIN)
    p.cmd('cc -O -c calc.c', 'compile', exact='')
    p.cmd('cc -O -S main.c', 'compile', exact='')
    p.cmd('as - main.s', 'assemble', exact='')
    p.cmd('mv a.out main.o', exact='')
    p.cmd('ar r libu.a calc.o', 'archive')
    p.cmd('ar t libu.a', 'archive', exact='calc.o')
    p.cmd('cc main.o libu.a', 'link', exact='')
    p.cmd('mv a.out run', exact='')
    p.cmd('./run', 'execute', exact='ARITH 2880 21 0')
    p.cmd('size run', 'inspect', pattern=r'\d')
    p.cmd('nm run', 'inspect', pattern=r'_fib')
    p.cmd('cp run run2', 'file', exact='')
    p.cmd('cmp run run2', 'file', exact='')
    p.cmd('strip run', 'strip', exact='')
    p.cmd('./run', 'execute', exact='ARITH 2880 21 0')
    p.cmd('cc -O main.c calc.c', 'compile')
    p.cmd('mv a.out run', exact='')
    p.file('runs', './run\n' * 10)
    p.cmd('sh runs', 'repeated execution', exact='\n'.join(['ARITH 2880 21 0'] * 10))
    p.finish()
    phases['build'] = p

    p = Phase()
    p.cmd('mkdir /ut', exact='')
    p.cmd('chdir /ut', exact='')
    app = ('main(argc,argv) int argc; char **argv; { if(argc>1) files(); else ipc(); }\n'
           + IPC.replace('main(){', 'ipc(){', 1) + FILES.replace('main(){', 'files(){', 1))
    p.file('app.c', app)
    p.cmd('cc -O app.c', 'compile', exact='')
    p.cmd('mv a.out app', exact='')
    p.cmd('./app', 'IPC', exact='unix-pipe-ok\nIPC 13 0')
    p.cmd('./app files', 'file syscalls', exact='FILES 2048 0')
    p.file('stress', './app\n./app files\n' * 10)
    p.cmd('sh stress', 'repeated IPC and files', exact='\n'.join(['unix-pipe-ok\nIPC 13 0\nFILES 2048 0'] * 10))
    p.cmd('ps', 'processes', pattern=r'(?i)PID')
    p.finish()
    phases['ipc'] = p

    p = Phase()
    p.cmd('mkdir /ut', exact='')
    p.cmd('chdir /ut', exact='')
    p.file('gen.c', GEN)
    p.cmd('cc -O gen.c', 'compile', exact='')
    p.cmd('mv a.out gen', exact='')
    p.cmd('./gen > data', 'generate', exact='')
    ordered = '\n'.join(f'{i:3d} group{i%8}' for i in range(128))
    matched = '\n'.join(f'{i:3d} group3' for i in range(3, 128, 8))
    p.cmd('sort data > ordered', 'sort', exact='')
    p.cmd('cat ordered', 'verify sort', exact=ordered)
    p.cmd('sort -r data > reversed', 'sort', exact='')
    p.cmd('cmp data reversed', 'compare', exact='')
    p.cmd('cat data data | sort | uniq > unique', 'pipeline', exact='')
    p.cmd('cmp ordered unique', 'compare', exact='')
    p.cmd('grep group3 data | sort > matched', 'pipeline', exact='')
    p.cmd('cat matched', 'verify grep', exact=matched)
    p.cmd("tr '[a-z]' '[A-Z]' < matched > upper", 'translate', exact='')
    p.cmd('cat upper', 'verify translation', exact=matched.upper())
    p.cmd('wc data', 'count', pattern=r'(?m)^\s*128\s+256\s+data\s*$')
    p.cmd('split -32 data', 'split', exact='')
    p.cmd('cat xaa xab xac xad > joined', 'join', exact='')
    p.cmd('cmp data joined', 'compare', exact='')
    p.cmd('cp data copy', 'copy', exact='')
    p.cmd('ln copy hard', 'link', exact='')
    p.cmd('mv copy renamed', 'rename', exact='')
    p.cmd('cmp renamed hard', 'compare', exact='')
    p.file('edit', '1c\n999 group9\n.\nw\nq\n')
    p.cmd('ed hard < edit', 'edit', pattern=r'1408')
    p.cmd('cmp renamed hard', 'compare', exact='')
    p.cmd('/usr/bin/diff data renamed', 'diff', exact='1c1\n* 127 group7\n---\n. 999 group9')
    p.cmd('dd if=data of=blocks bs=512 count=2', 'block I/O', pattern=r'2\+0')
    partial = ''.join(f'{i:3d} group{i%8}\n' for i in range(127, -1, -1))[:1024]
    p.cmd('wc blocks', 'count', pattern=rf'(?m)^\s*{partial.count(chr(10))}\s+{len(partial.split())}\s+blocks\s*$')
    p.cmd("echo '2 100 ^ p' | dc", 'calculator', exact=str(2**100))
    p.cmd("echo 'Unix workload formatting check.' > note", exact='')
    p.cmd('nroff note > formatted', 'format', exact='')
    p.cmd("grep 'Unix workload' formatted", 'verify formatting', pattern=r'Unix workload formatting check\.')
    p.cmd('df /dev/rk0', 'filesystem', pattern=r'\d')
    p.cmd('du /ut', 'filesystem', pattern=r'/ut')
    p.finish()
    phases['text'] = p

    p = Phase()
    kernel = '/rkmx' if target == 2040 else '/rkunix'
    p.file('/tmp/readwork', (f'od {kernel} >/dev/null\nls -l /bin /etc /lib /usr/bin >/dev/null\n'
                           'du /bin /usr/bin >/dev/null\nsum /bin/sh /bin/ls /bin/cc /bin/as /bin/ld\n') * 3)
    p.cmd('sh /tmp/readwork', 'repeated Unix utilities', pattern=r'\A(?:\d+[ \t]+\d+\n){14}\d+[ \t]+\d+\Z')
    p.cmd('ps', 'processes', pattern=r'(?i)PID')
    p.finish()
    phases['read'] = p
    for name, phase in phases.items():
        (folder / (name + '.txt')).write_text('\n'.join(phase.script) + '\n')
        (folder / (name + '.plan.json')).write_text(json.dumps(phase.rules, indent=2))
    print('unix_workload: generated', ', '.join(phases), 'for', target)


def validate(plan_path, results_path):
    rules = json.loads(plan_path.read_text())
    result = json.loads(results_path.read_text())
    failures = []
    groups = {}
    if result['exit_code'] != 0:
        failures.append('session exit code ' + str(result['exit_code']))
    if len(rules) != len(result['commands']):
        failures.append(f"expected {len(rules)} commands, got {len(result['commands'])}")
    for rule, record in zip(rules, result['commands']):
        command = rule['command']
        output = record['output'].strip('\n')
        if command != record['command'] or not record['completed']:
            failures.append(command + ': incomplete or wrong command')
        if rule.get('exact') is not None and output != rule['exact']:
            failures.append(command + ': unexpected output ' + repr(output[:300]))
        if rule.get('pattern') and not re.search(rule['pattern'], output):
            failures.append(command + ': missing expected output ' + repr(output[:300]))
        if re.search(r'(?im)^(?:.*: )?(?:cannot|not found|syntax error|out of space|fork failed|create failed|pipe failed)\b', output):
            failures.append(command + ': Unix error ' + repr(output[:300]))
        groups[rule['group']] = groups.get(rule['group'], 0) + record['seconds']
    transcript = results_path.with_suffix('.txt').read_text()
    if not re.search(r'(?m)^clock .*\b0 dropped,', transcript):
        failures.append('missing clean line-clock statistics')
    if not re.search(r'(?m)^typed .*\b0 lost;', transcript):
        failures.append('missing clean console statistics')
    if re.search(r'(?im)^.*(?:RAM overlay.*is full|HALT at|panic:)', transcript):
        failures.append('firmware or Unix failure in transcript')
    for failure in failures:
        print('FAIL', failure)
    print(json.dumps(dict(passed=not failures, commands=len(result['commands']), seconds=groups), indent=2))
    return int(bool(failures))


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--generate', type=Path)
    ap.add_argument('--target', type=int, choices=[2040, 2350])
    ap.add_argument('--plan', type=Path)
    ap.add_argument('--results', type=Path)
    args = ap.parse_args()
    if args.generate:
        if args.target is None:
            ap.error('--generate requires --target')
        generate(args.generate, args.target)
    else:
        if args.plan is None or args.results is None:
            ap.error('validation requires --plan and --results')
        raise SystemExit(validate(args.plan, args.results))
