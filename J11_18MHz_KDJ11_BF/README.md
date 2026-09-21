# J-11 at 18 MHz — KDJ11-BF

PureMetal emulator target for the DEC DCJ11 (J-11) CPU on the 18 MHz
KDJ11-BF module, in the PDP-11/83 system family. Intended host boards are
Raspberry Pi Pico and Pico 2.

This directory is the starting point for the implementation. CPU instructions,
registers, addressing modes, MMU behavior, traps, and timing belong to the
selected J-11 profile; system devices and bus behavior must follow the chosen
board profile. The 18 MHz value is the emulated clock, not a claim of achieved
emulator speed or a fixed number of clocks per instruction.

DEC's *PDP-11 Systems Handbook* (1987), printed page 2-3, identifies the
KDJ11-BF module and its 18 MHz clock:
[DEC handbook](https://bitsavers.org/pdf/dec/pdp11/handbooks/EB-29317_PDP-11_Systems_Handbook_1987.pdf#page=35).
