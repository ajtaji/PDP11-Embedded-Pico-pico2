/* Hardware-style FP divide by zero must deliver Unix signal 8. */
double one, zero;
caught()
{
 printf("FPE SIGNAL 8\n");
 exit(0);
}
main()
{
 double x;
 one = 1.0; zero = 0.0;
 signal(8,caught);
 x = one/zero;
 printf("FPE SIGNAL MISSED\n");
 exit(x!=0.0);
}
