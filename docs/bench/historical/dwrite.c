main(){ char buffer[512]; char *filename; register int i; int f;
filename="a_large_file";
f=creat(filename,0640); if(f<0){printf("CREATE FAILED\n");exit(1);} close(f);
f=open(filename,1); if(f<0){printf("OPEN FAILED\n");exit(1);}
for(i=0;i<256;i++) if(write(f,buffer,512)<0){printf("WRITE FAILED %d\n",i);exit(1);}
close(f);
}
