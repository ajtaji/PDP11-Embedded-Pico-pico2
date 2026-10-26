/* A new executable starts with cleared FP accumulators and SETD's FPS. */
int actual[25];
main()
{
 int i,e;
 readfp(actual);
 e = actual[0]!=0200;
 for(i=1;i<25;i++) if(actual[i]!=0) e++;
 printf("FPEXEC %d\n", e);
 exit(e!=0);
}
