main(argc,argv) int argc; char **argv; { if(argc>1) files(); else ipc(); }
ipc(){ int p[2],pid,n,st; char b[32];
if(pipe(p)<0){ printf("PIPE FAILED\n"); exit(1); }
pid=fork(); if(pid<0){ printf("FORK FAILED\n"); exit(1); }
if(pid==0){ close(p[0]); write(p[1],"unix-pipe-ok\n",13); close(p[1]); exit(0); }
close(p[1]); n=read(p[0],b,32); close(p[0]); st=123; wait(&st);
write(1,b,n); printf("IPC %d %d\n",n,st); }
long lseek();
seek(f,o,w) int f,o,w; { return(lseek(f,(long)o,w)<0?-1:0); }
char b[512],c[512];
files(){ int f,i,j,n,e; e=0; n=0; f=creat("binary",0600);
if(f<0){ printf("CREATE FAILED\n"); exit(1); }
for(j=0;j<4;j++){ for(i=0;i<512;i++) b[i]=i+j;
if(write(f,b,512)!=512) e++; } close(f); f=open("binary",0);
for(j=0;j<4;j++){ n=+read(f,c,512); for(i=0;i<512;i++) if((c[i]&255)!=((i+j)&255)) e++; }
seek(f,511,0); if(read(f,c,3)!=3) e++;
if((c[0]&255)!=255 || (c[1]&255)!=1 || (c[2]&255)!=2) e++;
close(f); printf("FILES %d %d\n",n,e); }
