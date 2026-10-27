char buffer[512]; int fid[2];
main(){ register int i;
pipe(fid);
if(fork()) {
for(i=0;i<1024;i++)
if(write(fid[1],buffer,512)<0) printf("Error writing %d\n",i);
if(close(fid[1])!=0) printf("Error parent closing\n");
} else {
if(close(fid[1])!=0) printf("Error child closing\n");
for(;;) if(read(fid[0],buffer,512)==0) break;
}
}
