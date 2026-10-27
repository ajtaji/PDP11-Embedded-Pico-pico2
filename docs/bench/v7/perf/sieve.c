/* Eratosthenes Sieve Prime Number Program in C, J. Gilbreath, BYTE,
 * September 1981 (the benchmark's published form; 1899 primes). */

char flags[8190+1];

main()
{
	int i, prime, k, count, iter;

	printf("100 iterations\n");
	for (iter = 1; iter <= 100; iter++) {
		count = 0;
		for (i = 0; i <= 8190; i++)
			flags[i] = 1;
		for (i = 0; i <= 8190; i++) {
			if (flags[i]) {
				prime = i + i + 3;
				for (k = i + prime; k <= 8190; k += prime)
					flags[k] = 0;
				count++;
			}
		}
	}
	printf("\n%d primes\n", count);
}
