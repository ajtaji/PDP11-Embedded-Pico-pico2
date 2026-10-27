main(){ long i; int *w; for(i=0;i<1000000;i++); w=(int *)&i; printf("Done\nLOOPCHECK %d %d\n",w[0],w[1]); }
