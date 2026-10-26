/*
 * C Converted Whetstone Double Precision Benchmark
 *		Version 1.2	22 March 1998
 *
 *	(c) Copyright 1998 Painter Engineering, Inc.
 *		All Rights Reserved.
 *
 *		Permission is granted to use, duplicate, and
 *		publish this text and program as long as it
 *		includes this entire comment block and limited
 *		rights reference.
 *
 * Converted by Rich Painter, Painter Engineering, Inc. based on the
 * www.netlib.org benchmark/whetstoned version obtained 16 March 1998.
 *
 * A novel approach was used here to keep the look and feel of the
 * FORTRAN version.  Altering the FORTRAN-based array indices,
 * starting at element 1, to start at element 0 for C, would require
 * numerous changes, including decrementing the variable indices by 1.
 * Instead, the array E1[] was declared 1 element larger in C.  This
 * allows the FORTRAN index range to function without any literal or
 * variable indices changes.  The array element E1[0] is simply never
 * used and does not alter the benchmark results.
 *
 * The major FORTRAN comment blocks were retained to minimize
 * differences between versions.  Modules N5 and N12, like in the
 * FORTRAN version, have been eliminated here.
 *
 * An optional command-line argument has been provided [-c] to
 * offer continuous repetition of the entire benchmark.
 * An optional argument for setting an alternate LOOP count is also
 * provided.  Define PRINTOUT to cause the POUT() function to print
 * outputs at various stages.  Final timing measurements should be
 * made with the PRINTOUT undefined.
 *
 * Questions and comments may be directed to the author at
 *			r.painter@ieee.org
 */
/* The double precision Whetstone of netlib's whetstone.c (Painter, 1998,
 * after the FORTRAN A001), modules 1-11 with the same arithmetic, in Sixth
 * Edition C: no long (LOOP = 10, every count fits an int), =+ for +=,
 * timed by the shell's time. 10 loops = 1,000,000 Whetstone instructions. */
double T, T1, T2, E1[5];
int J, K, L;
double sin(), cos(), atan(), log(), exp(), sqrt();

main()
{
	int I, N1, N2, N3, N4, N6, N7, N8, N9, N10, N11, LOOP, R;
	double X1, X2, X3, X4, X, Y, Z;

	T = .499975; T1 = 0.50025; T2 = 2.0;
	LOOP = 10;
	N1 = 0; N2 = 12*LOOP; N3 = 14*LOOP; N4 = 345*LOOP; N6 = 210*LOOP;
	N7 = 32*LOOP; N8 = 899*LOOP; N9 = 616*LOOP; N10 = 0; N11 = 93*LOOP;

	X1 = 1.0; X2 = -1.0; X3 = -1.0; X4 = -1.0;
	for (I = 1; I <= N1; I++) {
		X1 = (X1 + X2 + X3 - X4) * T;
		X2 = (X1 + X2 - X3 + X4) * T;
		X3 = (X1 - X2 + X3 + X4) * T;
		X4 = (-X1+ X2 + X3 + X4) * T;
	}
	E1[1] = 1.0; E1[2] = -1.0; E1[3] = -1.0; E1[4] = -1.0;
	for (I = 1; I <= N2; I++) {
		E1[1] = ( E1[1] + E1[2] + E1[3] - E1[4]) * T;
		E1[2] = ( E1[1] + E1[2] - E1[3] + E1[4]) * T;
		E1[3] = ( E1[1] - E1[2] + E1[3] + E1[4]) * T;
		E1[4] = (-E1[1] + E1[2] + E1[3] + E1[4]) * T;
	}
	for (I = 1; I <= N3; I++)
		PA(E1);
	J = 1;
	for (I = 1; I <= N4; I++) {
		if (J == 1) J = 2; else J = 3;
		if (J > 2) J = 0; else J = 1;
		if (J < 1) J = 1; else J = 0;
	}
	J = 1; K = 2; L = 3;
	for (I = 1; I <= N6; I++) {
		J = J * (K-J) * (L-K);
		K = L * K - (L-J) * K;
		L = (L-K) * (K+J);
		E1[L-1] = J + K + L;
		E1[K-1] = J * K * L;
	}
	X = 0.5; Y = 0.5;
	for (I = 1; I <= N7; I++) {
		X = T * atan(T2*sin(X)*cos(X)/(cos(X+Y)+cos(X-Y)-1.0));
		Y = T * atan(T2*sin(Y)*cos(Y)/(cos(X+Y)+cos(X-Y)-1.0));
	}
	X = 1.0; Y = 1.0; Z = 1.0;
	for (I = 1; I <= N8; I++)
		P3(X, Y, &Z);
	J = 1; K = 2; L = 3; E1[1] = 1.0; E1[2] = 2.0; E1[3] = 3.0;
	for (I = 1; I <= N9; I++)
		P0();
	J = 2; K = 3;
	for (I = 1; I <= N10; I++) {
		J = J + K; K = J + K; J = K - J; K = K - J - J;
	}
	X = 0.75;
	for (I = 1; I <= N11; I++)
		X = sqrt(exp(log(X)/T1));
	/* V6 printf has no prototype: explicitly convert the double for %d. */
	R = X*10000.0;
	printf("1000 KWhetstones done; X = %d/10000\n", R);
}

PA(E)
double E[];
{
	J = 0;
L10:
	E[1] = ( E[1] + E[2] + E[3] - E[4]) * T;
	E[2] = ( E[1] + E[2] - E[3] + E[4]) * T;
	E[3] = ( E[1] - E[2] + E[3] + E[4]) * T;
	E[4] = (-E[1] + E[2] + E[3] + E[4]) / T2;
	J =+ 1;
	if (J < 6)
		goto L10;
}

P0()
{
	E1[J] = E1[K];
	E1[K] = E1[L];
	E1[L] = E1[J];
}

P3(X, Y, Z)
double X, Y, *Z;
{
	double X1, Y1;
	X1 = X; Y1 = Y;
	X1 = T * (X1 + Y1);
	Y1 = T * (X1 + Y1);
	*Z = (X1 + Y1) / T2;
}
