/* Replace a process holding nondefault FPS and nonzero FP registers. */
int state[25];
main()
{
 int i;
 state[0] = 0146;
 for(i=0;i<6;i++) {
  state[1+i*4]=040200+i;
  state[2+i*4]=123+i;
  state[3+i*4]=456+i;
  state[4+i*4]=789+i;
 }
 loadfp(state);
 execl("./fpexec","fpexec",0);
 printf("FPEXEC LOAD FAILED\n");
 exit(1);
}
