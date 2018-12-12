// This routine reads a series of values in ROM (Flash) memory, at address
// ROM_TABLE, and copies them onto RAM (SRAM) memory at address RAM_TABLE, both
// defined as labels in our program.
// The ROM memory table always ends with 0x00, and its not longer than 1000
// bytes.

#include "avr-linux.h"
.org 0
    JMP MAIN

    .org 0x100
MAIN:
    // Boilerplate to init the stack
    LDI R20, HIGH(RAMEND)
    OUT SPH, R20
    LDI R20, LOW(RAMEND)
    OUT SPL, R20

    CALL COPY_TABLE
    RJMP END

COPY_TABLE:
    // Register Z will be used to access ROM and register X to access RAM
    LDI XH, HIGH(RAM_TABLE)
    LDI XL, LOW(RAM_TABLE)

    // Notice ROM_TABLE is a program space label, but we
    // use it just as any other tag, no need to multiply by 2.
    // All addresses in avr-gcc point to bytes
    LDI ZH, HIGH(ROM_TABLE)
    LDI ZL, LOW(ROM_TABLE)

loop:
    LPM R20, Z+
    CPI R20, 0x00   // Last element?
    BREQ exit

    // Copy value
    ST X+, R20
    RJMP loop

exit:
    RET

// End of program
END:
    RJMP END


// Table definitions

CSEG
ROM_TABLE:
  DB '0', '8', '5', 'l', '9', 0x3a, '4', 0x40, 0xff, 0x00

// Reserving RAM memory
DSEG
RAM_TABLE:
  BYTE 1000


