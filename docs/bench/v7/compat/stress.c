char a[24000][2]; char *q=a;
main(){ int p[2],j,n,pid,k,st,e; unsigned i; char c;
for(i=0;i<48000;i++) q[i]=i;
if(pipe(p)<0){printf("STRESS PIPE FAILED\n");exit(1);}
k=0;e=0;
for(j=0;j<38;j++) {
pid=fork(); if(pid<0){e++;break;}
if(pid==0) {
close(p[1]); if(read(p[0],&c,1)!=1)exit(2);
for(i=0;i<48000;i++) if((q[i]&255)!=(i&255))exit(3);
close(p[0]);exit(0);
}
k++;
}
close(p[0]);c='x';for(j=0;j<k;j++)if(write(p[1],&c,1)!=1)e++;
close(p[1]);for(j=0;j<k;j++){wait(&st);if(st)e++;}
printf("STRESS %d %d\n",k,e);
}
