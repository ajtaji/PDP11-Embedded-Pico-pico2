char b[512]; int f[2];
main(){ int pid,i,n,k,st,e; e=0;
for(i=0;i<512;i++)b[i]=i;
if(pipe(f)<0){printf("PIPE CREATE FAILED\n");exit(1);}
pid=fork();if(pid<0){printf("FORK FAILED\n");exit(1);}
if(pid){
close(f[0]);for(i=0;i<1024;i++)if(write(f[1],b,512)!=512)e++;
close(f[1]);wait(&st);printf("PARENT 1024 ERR %d STATUS %d\n",e,st);exit(e!=0 || st!=0);
}
close(f[1]);k=0;
while((n=read(f[0],b,512))>0){if(n!=512)e++;for(i=0;i<n;i++)if((b[i]&255)!=(i&255))e++;k++;}
close(f[0]);printf("CHILD %d ERR %d END %d\n",k,e,n);exit(e!=0 || k!=1024 || n!=0);
}
