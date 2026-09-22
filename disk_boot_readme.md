Copying DEC RK05 Disk Image to Pico flash using Picotool from Linux
=======================================================================
```

./picotool load --ignore-partitions mini-unix.rk05 -t bin -o 0x10100000

```

RK05 Disk Storage - general notes
=======================================================================

Direct Flash Storage (no underlying FAT32 or similar filesystem)
----------------------------------------------------------------

RK05 disk images can be run directly from onboard Pico flash, i.e. no 
underlying FAT32 or similar file system is required. 

Note however that unix writes repeatedly to the same disk area which is 
likely to cause premature flash memory wear and render a board fully or 
partially unreliable or even unusable. 

Continuous use for more than a minute or so is therefore not recommended.

Flash also requires specific handling for the erase/write cycle, which 
both increases code complexity and reduces overall system performance. 

External SPI-connected Winbond flash such as the Adafruit Flash Breakout 
https://www.adafruit.com/product/5636 can also be used with no perceptible
performance degradation, again subject to the same flash wear issue above. 


Indirect Flash Storage Considerations (filesystem)
-------------------------------------------------------------------------

1. LittleFS is commonly used in microcontroller environments, however, due
to the copy-on-write technique it uses, it requires approximately twice the
size of the file being updated and is unacceptably slow for emulator use.
NOT RECOMMENDED.

2. SD Cards - not evaluated or tested here. Can be unreliable on breadboard.

3. FAT32 filesystems can be used if required, subject to them providing a 
flash translation layer to even out erase/write cycles on the onboard or
external flash storage used. 

3. SPIFFS (SPI Flash File System) provides acceptable functionality and 
performance in an emulator environment and is the second choice behind PSRAM.
Provides erase/write wear-levelling functionality.

5. PSRAM (Pseudo-Static RAM) is used in some third-party boards and offers far
better performance than any flash memory storage. QSPI drivers are required and the
device needs to be initialised before use. Read and Write functionality thereafter is 
very simple. PSRAM is volatile and needs to be loaded from a non-volatile source or
from a network or serial connnection. Any data to be retained also needs to be saved 
back before the board is powered down. 

Starting Unix
===============================================

The CPU Switch Register should have (octal) value = 0173030 before booting to enter single-user mode.
A single @ character should appear on the console when emulation is started. 
Enter the name of the kernel to start here - usually rkmx (all lower case) for mini-unix

A `RESTRICTED RIGHTS` message should appear in all capitals. 

The `@` prompt will be repeated if the entered kernel name is not present on disk

Note that the system may hang if a boot attempt is made with an unsupported kernel 

There is no login username or password required for single-user mode. 

Boot is complete when the `#` character is displayed. 
Normal unix commands can be entered from here onwards. 


Upper / Lower case
================================================

Unix starts in all upper-case - this is normal.

Issue `STTY -LCASE` to change


Setting Date and Time - note - non-Y2K compliant
================================================

`DATE 0922100098`  
