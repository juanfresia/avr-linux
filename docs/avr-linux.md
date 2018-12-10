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

## The compiler directives

WIP

## Flash memory addressing and interrupt vector

WIP
