// Just turn on a led in pin B0

#include "avr-linux.h"
.org 0

main:
	LDI R16, 0xFF
	OUT DDRB, R16
	SBI PORTB, 0

end:
    RJMP end
