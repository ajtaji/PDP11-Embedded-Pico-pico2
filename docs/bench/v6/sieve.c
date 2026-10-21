/* Gilbreath's BYTE sieve (1981), in Sixth Edition C: =+ for +=. */
char flags[8191];
main()
{
	int i, prime, k, count, iter;
	printf("10 iterations\n");
	for (iter = 1; iter <= 10; iter++) {
		count = 0;
		for (i = 0; i <= 8190; i++)
			flags[i] = 1;
		for (i = 0; i <= 8190; i++) {
			if (flags[i]) {
				prime = i + i + 3;
				for (k = i + prime; k <= 8190; k =+ prime)
					flags[k] = 0;
				count++;
			}
		}
	}
	printf("\n%d primes\n", count);
}
