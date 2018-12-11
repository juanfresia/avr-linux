# Using avr-linux.h

This document provides all the information you need to know in order to use
avr-linux.h, as well as some advice on interrupts vectors and `avr-gcc` compiler
directives.

## What does avr-linux.h include?

You can include `avr-linux.h` file to automatically let the compiler recognize
I/O register and interrupts related constants (e.g. `DDRB`). The include are
dynamic and will adapt to the MCU you are using.

Note that you could include both `<avr/io.h>` and `<avr/interrupt.h>` but there
is a caveat that the constants would be badly defined. This is because of the
Special Function Register offset (SFR offset), which decides whether the I/O
register constants are defined by its actual memory address or by its I/O
register number (i.e. the difference between using `out` or `st` instructions).

The mechanism that decides which SFR offset to use is kind of broken when using
`avr-gcc` to compile assembly code (it works just fine with C code, but that is
not what we want to compile right now).

For example, the `DDRB` register for atmega2560 MCU could be replaced by `0x04`
or by `0x24`, and that could lead to trouble. To make sure the I/O registers can
be used, and that the offset is always right, we override the SFR offset in
`avr-linux.h` to 0.

This has the following effect:

- All I/O registers that have a I/O number (first 32 registers) will have an
  offset of 0. Example, you can use `DDRB` with `out` but not with `st`.
- The other I/O registers will have an offset of 0x20, meaning they will
  evaluate to its memory address. Example, you can use `TCTN2` only with `st`.

We also included in `avr-linux.h` two wrappers `LOW()` and `HIGH()` of the
macros `lo8()` and `hi8()`, to allow the usage of the semantics of other
compilers. These macros simply allow you to take the high or low byte from a 16
bit number, useful for Flash addresses and loading them into `Z` register.

Lastly, some other macros have been defined to allow correspondence with AVR
Studio-like compiler directives (avrasm2). These are explained in the following
section.

## The compiler directives

The directives of `avr-gcc` are slightly different from the ones provided by
`avrasm2` (used by AVR Studio), however we can find an equivalence between both
compilers, as described by the following table:

| avr-gcc | avrasm2 | avr-linux.h | Description                             |
| ------- | ------- | ----------- | --------------------------------------- |
| .text   | .cseg   | CSEG        | Indicates code segment (Flash memory)   |
| .data   | .dseg   | DSEG        | Indicates data segment (SRAM memory)    |
| .byte   | .db     | DB          | Set up constant data in Flash memory    |
| .space  | .byte   | BYTE        | Reserve space in SRAM memory            |
| .org    | .org    | (_DNA_)     | Put following inst. at specific address |

The third column describes the macros defined in `avr-linux.h` if you want your
code to better resemble AVR Studio like directives.

## Flash memory addressing and interrupt vector

It is worth mentioning that for `avr-gcc` compiler __all labels and memory
addresses point to a byte__. This applies to labels and immediate values
regardless of the memory they refer to (SRAM or Flash). This means that there is
no need to multiply by 2 addresses when using labels from the code segment.

This is also true for interrupt vectors and ISRs. All the addresses of the
interrupt vector provided by the MCUs datasheets are in program address space,
meaning they point to 16-bit words. As `avr-gcc` addresses memories as bytes,
you will need to multiply that addresses by 2.

As an example, assume you want to set up an ISR for timer 1 overflow in an
atmega2560. The manual says `TIMER1 OVF` is interrupt number 21, and that its
corresponding address is at `0x28` (40, in decimal). This means that its ISR
will start at __byte__ `0x50` (80, in decimal), and it could be set up as
follows:

```bash
.org 0x50
    JMP TIMER1_OVF
```
