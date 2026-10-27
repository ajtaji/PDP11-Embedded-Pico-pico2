char a[512],b[512];
main(){ int i,s,e; for(i=0;i<512;i++) a[i]=i;
ucopy(b,a,512); e=0; for(i=0;i<512;i++) if(a[i]!=b[i]) e++;
s=0; for(i=0;i<20;i++) s=+fib(12);
printf("ARITH %d %d %d\n",s,gcd(1071,462),e); }
