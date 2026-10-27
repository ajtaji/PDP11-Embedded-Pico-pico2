# V7 hardware benchmark and compatibility sources

These are the exact program/data inputs from the accepted October 27
FP29 V7 sessions. Text hashes use UTF-8 with LF line endings. Algorithm
attribution and historical-version differences are documented in
[the historical source notes](../historical/README.md).

Each phase directory has its inputs and a `session.txt` for
`tools/board_session.py`. The session files are the Feather form: for
Pico Plus 2 W change `/dev/rk1` to `/dev/rp3` and `/dev/rrk1` to `/dev/rrp3`.
Run each measured phase against clean factory filesystems and an isolated
empty saved-change store; back up an existing installation first.
Source entry, flashing and boot time are excluded from command totals.
`unix` is four phases: build, ipc, text and read. They retain all original
work, with V7-compatible C syntax, native seek and V7 output expectations.
V7 sort puts capital `Now` first; the older V6 sort folds case.

C uses native `cc -O`. Whetstone and the math check link `-lm`; Fortran
uses native `f77 -o fhello fhello.f`. The general FP phase assembles its
helper before linking the C tests. Follow the recorded commands for each
phase. Each Dhrystone sample executes 10,000 checked iterations; its rate
is whole-process host elapsed time, not original net-loop calibration.

Persistence uses two files, on RK0 and `/usr`, followed by sync, explicit
save, program-only reboot (same pack nonces), and readback. Feather uses
8 sectors per file because its supplied `/usr` has only 24 free blocks;
Pico Plus 2 W uses 64 sectors per file. Both read checks require zero
errors. Multi-user startup uses Ctrl-D at the single-user prompt, then
root login without a password and `/etc/mount` to verify `/usr`.

The raw-drive check reads 2048 bytes and compares the V7 BSD checksum
against the factory image: 65274 on Feather, 41999 on Pico Plus 2 W.
The six-job control retains each word-count result before ordinary cleanup.
All six must be three lines, three words and fourteen bytes.
