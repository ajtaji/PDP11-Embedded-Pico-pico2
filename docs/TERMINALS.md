# More terminals for V7 - the plan (not built yet)

Ron's ask (2026-10-22): more terminals on the Pico Plus 2 W, through the board's
UART and a USB-UART adapter, planned now and wired later. This page is the
plan: what to wire, what the firmware gains, and what V7 needs. Nothing here
is in the firmware yet.

## 1. The wiring (when it is done)

A USB-UART adapter with **3.3 V logic** (FTDI TTL-232R-3V3, a CP2102 or
CH340 board set to 3.3 V). Physical pins of the Pico Plus 2 W, which has the
Pico's pinout:

| Pico Plus 2 W pin | GPIO | Adapter |
|---|---|---|
| 1 | GP0, UART0 TX | RX |
| 2 | GP1, UART0 RX | TX |
| 3 | GND | GND |

Do **not** connect the adapter's VCC or 5 V pin: the board is powered from its
own USB. A 5 V adapter would damage GP1. GP0 and GP1 are free: the firmware
does not use the UART, and the PSRAM is on GP47.

A second adapter would go on UART1 (GP4 TX on pin 6, GP5 RX on pin 7, GND
pin 8) for a third terminal.

## 2. The firmware: a second DL11 at 176500

V7's kl.c addresses extra KL11 lines from 176500 (`KLBASE`), four registers
each, and mkconf gives them floating vectors from 300. So:

- **Registers** 176500 RCSR, 176502 RBUF, 176504 XCSR, 176506 XBUF: the
  console's DL11 (cpu.pico2, `#DL11_RCSR` ...) again, with its own state
  (`Kl1RxDone`, `Kl1RxIe`, `Kl1TxRdy`, `Kl1TxIe`, a receive and a transmit
  queue). A second line would be 176510-176516.
- **Interrupts** at BR4, like the console: new `IntReq` bits `#INT_KL1_RX` 32
  and `#INT_KL1_TX` 64, vectors 300 and 304, taken after the console's in
  `DevService`'s chain.
- **Core 1** owns the UART as it owns USB: each pass of its loop moves bytes
  between UART0's FIFOs and the line's queues (`UartOpen(0, 115200, 0, 1)`,
  `UartTrySend`, `UartReceive` from the compiler's `RP2350/Lib/uart.pico2`).
  Core 0 sees only the queues, as it does for the console. The receiver
  paces characters as the console does (`#DL11_RX_INSTRUCTIONS`), so pasted
  text is not lost.
- **Present only when asked for**: a pack header flag (rk_image.py
  `--terminals 2`), so images and diagnostics without it see no device at
  176500 (the bus times out there, as now).
- **Baud rate:** 115200 on the wire (the adapter's terminal program sets
  it). V7's own speed setting (`stty`) is ignored, as the console's is.

## 3. V7: three objects built on the board, as rp.o was

The kernel is linked from objects V7 builds on a board
(`media/unix/v7/build-on-board.txt`), so this is another session of the same
kind:

1. **kl.c** with `#define NKL11 2` (3 for two adapters): `kl11[]` gets the
   second line and klopen addresses minor 1 at 176500. Built as `rp.c` was
   (`cc -c -O`), kept as `media/unix/v7/kl.o`, linked ahead of LIB2 by
   `tools/v7_pack.py`.
2. **c.o and l.o** from mkconf with one more line in the configuration,
   `kl` (`2 kl` for two lines). mkconf then puts `klin; br4+1.` and `klou;
   br4+1.` at 300 and 304: the interrupt handlers get minor 1.
3. **On the pack** (v7_pack.py): `/dev/tty01` (`c 0 1`, the kl major),
   and in `/etc/ttys` a line `1` + speed code + `tty01`, so init starts a
   getty on it in multi-user. The speed code comes from getty.c's table
   (`/usr/src/cmd/getty.c`), read during the board session.

## 4. How it will be tested

On the board, with the adapter wired: multi-user, `login:` on the second
terminal, two users at once (`who` shows both), `write` from one to the
other, output on one while the other compiles, and a paste into the second
terminal arriving whole. Then the DEC diagnostic ladder again, without the
header flag, to show nothing else changed.

## 5. Without any wiring

If a second line is wanted before anything is soldered, the same DL11 can be
fed from the USB port instead of the UART: Ctrl-] then `1` or `2` chooses
which line the USB terminal is. It allows one person at a time, but it
exercises the kernel's second line, getty and init. A true second terminal
over the one USB cable needs a second CDC interface in the compiler's USB
library (`RP2350/Lib/usb_serial.pico2`), which is library work, not emulator
work.
