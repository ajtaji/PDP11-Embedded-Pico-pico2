/* General D-format arithmetic, precision, conversions and libm checks. */
double sqrt(), sin(), cos(), atan(), exp(), log();
double a[9], b[9], c[9];
int errors;

near(x,y)
double x,y;
{
 double d;
 d = x-y;
 if(d<0) d = -d;
 if(d>0.00000001) errors++;
}

main()
{
 int i,j,k,n;
 double x,t,s;
 near(sqrt(81.0),9.0);
 near(exp(log(2.0)),2.0);
 near(atan(1.0)*4.0,3.141592653589793);
 x = 0.5; s = sin(x); t = cos(x);
 near(s*s+t*t,1.0);
 t = 1.0;
 for(i=0;i<54;i++) t=t/2.0;
 x = (1.0+t)-1.0;
 if(x!=t) errors++;
 x = 1.0;
 for(i=0;i<30;i++) x=x*2.0;
 for(i=0;i<30;i++) x=x/2.0;
 if(x!=1.0) errors++;
 if((n=1.125*16.0)!=18) errors++;
 if((n= -32760.75)!= -32760) errors++;
 for(i=0;i<9;i++) { a[i]=i+1; b[i]=0.0; }
 b[0]=1.0; b[4]=1.0; b[8]=1.0;
 for(i=0;i<3;i++) for(j=0;j<3;j++) {
  x = 0.0;
  for(k=0;k<3;k++) x=x+a[i*3+k]*b[k*3+j];
  c[i*3+j]=x;
 }
 for(i=0;i<9;i++) if(c[i]!=a[i]) errors++;
 printf("FP MATH %d\n", errors);
 exit(errors);
}
