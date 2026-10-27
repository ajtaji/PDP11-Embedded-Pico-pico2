char b[512],a[512];
main(argc,argv) int argc; char **argv; {
int f,i,j,e,n,k,w; unsigned s; char *path;
e=0;n=0;w=argc>1;
for(k=0;k<2;k++) {
path=k?"/usr/tmp/persist-pattern":"/persist-pattern";
f=w?creat(path,0600):open(path,0); if(f<0){e++;continue;}
s=12345;
for(j=0;j<64;j++) {
for(i=0;i<512;i++){s=s*25173+13849;b[i]=s>>8;}
if(w){if(write(f,b,512)!=512)e++;}
else {if(read(f,a,512)!=512)e++;for(i=0;i<512;i++)if(a[i]!=b[i])e++;}
n++;
}
close(f);
}
printf("PERSIST %d %d %d\n",2,n,e);
}
