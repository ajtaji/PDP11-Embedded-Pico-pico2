/* FP11 state must survive fork and blocking IPC, including all six D
 * accumulators and FPS modes/condition codes. Compile with fpstate_io.s. */
int expected[25], actual[25], errors;

fill(seed, fps)
{
 int i;
 expected[0] = fps;
 for(i=0;i<6;i++) {
  expected[1+i*4] = 040200+i;
  expected[2+i*4] = seed+i;
  expected[3+i*4] = seed*7+i;
  expected[4+i*4] = seed*13+i;
 }
 /* Preserve reserved/dirty-zero bit patterns without raising FIUV. */
 expected[17] = 0100000;
 expected[21] = 0;
}

check()
{
 int i;
 readfp(actual);
 for(i=0;i<25;i++) if(actual[i]!=expected[i]) errors++;
}

main()
{
 int p[2], q[2], pid, i, st;
 char c;
 if(pipe(p)<0 || pipe(q)<0) { printf("FPSTATE PIPE FAILED\n"); exit(1); }
 fill(123,04251);
 loadfp(expected);
 pid = fork();
 if(pid<0) { printf("FPSTATE FORK FAILED\n"); exit(1); }
 check();
 if(pid==0) {
  close(p[1]); close(q[0]);
  fill(456,04146);
  loadfp(expected);
  for(i=0;i<40;i++) {
   if(read(p[0],&c,1)!=1) errors++;
   if(write(q[1],&c,1)!=1) errors++;
   check();
  }
  close(p[0]); close(q[1]); exit(errors!=0);
 }
 close(p[0]); close(q[1]);
 for(i=0;i<40;i++) {
  c = i;
  if(write(p[1],&c,1)!=1) errors++;
  if(read(q[0],&c,1)!=1 || c!=i) errors++;
  check();
 }
 close(p[1]); close(q[0]); wait(&st);
 printf("FPSTATE %d %d\n", errors, st);
 exit(errors || st);
}
