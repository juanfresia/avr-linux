#ifndef __AVR_LINUX__
#define __AVR_LINUX__

#define __SFR_OFFSET 0
#include <avr/io.h>
#include <avr/interrupt.h>

// avr-studio like macros and directives
#define	LOW(x) lo8(x)
#define	HIGH(x) hi8(x)

#define CSEG .text
#define DB .byte
#define DSEG .data
#define BYTE .space

#endif
