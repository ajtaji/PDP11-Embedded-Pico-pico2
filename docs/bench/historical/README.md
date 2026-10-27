# Historical benchmark compatibility sources

These are the final sources actually typed into the physical boards for the
27 October 2026 measurements. See ../historical-2026-10-27.md and its JSON for
samples, controls, source hashes, timing definitions and resource failures.

Dhrystone C1.1 is by Reinhold P. Weicker / Rick Richardson. Original archived
source: https://raw.githubusercontent.com/Keith-S-Thompson/dhrystone/master/v2.1/dhrystone.c
(the directory name says v2.1, but this particular file identifies C1.1).
The BYTE Unix programs follow David F. Hinnant's August 1984 listings.

All C files compile with `cc -O file.c`, then `mv a.out program` on V6/Mini-Unix.
For Dhrystone, run each executable three times; it performs 10,000 iterations.
The reported rate includes process setup and checked output and does not
subtract an empty-loop calibration. It is a whole-process host rate, not the
original internal net-loop Dhrystone rating.
The checked state is DHRYCHECK5 1 7 10010 7 39 9 and DHRYREC17 18 65 66.
For the long loop, LOOPCHECK15 16960 verifies the exact PDP-11 representation
of one million. Function-call variants end CALLCHECK-15536 -15537 after50,000
iterations. The initial count is not silently truncated to16 bits.

V6 cannot express the original long literal or unsigned declaration. The
loop initializes the long limit using its two PDP-11 words; the function-call
loop terminates at the same unsigned16 final bit pattern. No iteration or
operation inside either workload is omitted. V6 casts/long library helpers
are unavailable in this distribution, so dread.c computes the equivalent
block and byte offsets with ordinary16-bit arithmetic and two seek calls.

V6 register parameters are unsupported. The Dhrystone port uses the original
NOENUM/NOSTRUCTASSIGN approach, expands typedefs, supplies plain C strcpy and
strcmp, and uses static records instead of heap allocation outside the core
loop. One unused register declaration is removed so the register variant fits
the1975 compiler's register pool. No timed algorithm statement is removed.

For shell tests, create `words` containing one word per line:
Now is the time for all good men to come to the aid of their country
Run `time sh tst.sh`; m1.sh..m6.sh are the original launch loop expanded for
V6's shell. Unchanged job counts are not a promise that limited swap/process
resources can support all of them. Failures have no accepted score.

The 128KiB file uses the original repeated uninitialized buffer. Its write
success is checked separately by reading exactly256 complete blocks. That
is a file-length check, not a claim of arbitrary128KiB write capacity in the
RP2040 compressed overlay. A separate patterned512KiB pipe control checks
all bytes and child status on both boards.
