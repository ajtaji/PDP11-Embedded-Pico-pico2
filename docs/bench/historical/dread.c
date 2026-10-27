main(){ char buffer[512]; char *filename; register int i; int f; int r;
filename="a_large_file"; f=open(filename,0);
if(f<0){printf("OPEN FAILED\n");exit(1);}
for(i=0;i<256;i++) {
r=rand();
if(seek(f,r/128,3)<0 || seek(f,(r%128)*4,1)<0){printf("SEEK FAILED %d\n",i);exit(1);}
if(read(f,buffer,512)<0){printf("READ FAILED %d\n",i);exit(1);}
}
unlink(filename);
}
