/* Run with Mini-Unix cc on the physical board. Sixth Edition C syntax. */
char b[513];
int errors;

main()
{
 int p[2], f[12], d, n, i, j, pid, st, total;
 pipe(p);
 d = dup(p[0]);
 if(read(d,b,0)!=0) errors++;
 close(p[0]); close(p[1]);
 if(read(d,b,1)!=0) errors++;
 close(d);

 signal(13,1);
 pipe(p); close(p[0]);
 if(write(p[1],"x",1)!=-1) errors++;
 close(p[1]);

 /* Leave one free descriptor: the second falloc must fail cleanly. */
 d = dup(0);
 for(j=0;j<5;j++) {
  if(pipe(p)<0) { printf("PIPE SETUP FAILED\n"); exit(1); }
  f[j*2] = p[0]; f[j*2+1] = p[1];
 }
 if(pipe(p)!=-1) errors++;
 for(j=0;j<10;j++) close(f[j]);
 close(d);

 if(pipe(p)<0) { printf("PIPE CREATE FAILED\n"); exit(1); }
 pid = fork();
 if(pid<0) { printf("PIPE FORK FAILED\n"); exit(1); }
 if(pid==0) {
  close(p[0]);
  for(j=0;j<16;j++) {
   for(i=0;i<513;i++) b[i]=i+j;
   if(write(p[1],b,513)!=513) errors++;
  }
  close(p[1]); exit(errors);
 }
 close(p[1]); total = 0;
 while((n=read(p[0],b,513))>0) {
  for(i=0;i<n;i++) {
   if((b[i]&255)!=((total%513+total/513)&255)) errors++;
   total++;
  }
 }
 if(n!=0 || total!=8208) errors++;
 close(p[0]); wait(&st);
 if(st!=0) errors++;
 printf("PIPE CHECK %d %d %d\n", errors, total, st);
 exit(errors);
}
