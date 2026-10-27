fib(n) int n; { if(n<2) return(n); return(fib(n-1)+fib(n-2)); }
gcd(a,b) int a,b; { int t; while(b){ t=a%b; a=b; b=t; } return(a); }
ucopy(a,b,n) char *a,*b; int n; { while(n--) *a++ = *b++; }
