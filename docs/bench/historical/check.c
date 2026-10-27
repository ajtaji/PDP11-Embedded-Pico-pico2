main(){ int f,n,b; char a[512];
f=open("a_large_file",0); if(f<0){printf("FILECHECK OPEN FAILED\n");exit(1);}
b=0; while((n=read(f,a,512))>0) {if(n!=512){printf("FILECHECK SHORT\n");exit(1);} b++;}
close(f); printf("FILECHECK %d\n",b);
}
