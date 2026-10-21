/* Eratosthenes Sieve Prime Number Program in C, J. Gilbreath, BYTE,
 * September 1981 (the benchmark's published form; 1899 primes). */
#define true 1
#define false 0
#define size 8190

char flags[size+1];

main()
{
	int i, prime, k, count, iter;

	printf("10 iterations\n");
	for (iter = 1; iter <= 10; iter++) {
		count = 0;
		for (i = 0; i <= size; i++)
			flags[i] = true;
		for (i = 0; i <= size; i++) {
			if (flags[i]) {
				prime = i + i + 3;
				for (k = i + prime; k <= size; k += prime)
					flags[k] = false;
				count++;
			}
		}
	}
	printf("\n%d primes\n", count);
}
