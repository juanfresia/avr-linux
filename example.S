// Just turn on a led in pin B0

#include "avr-linux.h"
.org 0x0
    JMP main

.org 0x100

main:
    LDI R16, 0xFF
    OUT DDRB, R16
    SBI PORTB, 0

end:
    RJMP end
