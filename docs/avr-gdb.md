# Using avr-gdb with simavr

This document aims to give insight on how to use `avr-gdb` with `simavr` by
going through the particularities that occur when trying to use a debugger that
was designed for __Von Neumann__ architectures with a __Harvard__ architecture
such as __avr__.

## Running the debugger

WIP

## Accessing code and data memories

In avr architecture memory is divided into two regions: Flash memory (aka
program memory) and SRAM (aka data memory). However, gdb shows only one
contiguous range of memory, and maps those two regions into a single address
space. This is only a side effect of using gdb.

The mapping can be seen by using `info mem` command inside gdb. Flash memory is
mapped as expected starting at address 0x0, while SRAM memory starts at 0x800000
(i.e. all SRAM addresses have a 0x800000 offset).

Another important caveat of using gdb to debug avr architecture programs is that
**both memories are addressed by byte**. That means that gdb address 0x100 (256) will
point to 16-bit word 0x80 (128) in actual Flash memory. The same way, address
0x800100 in gdb memory will point to 8-bit 0x100 address in actual SRAM memory.

This mapping makes it possible to run __Harvard__ architecture in gdb, but
breaks other things, including addressing commands from within gdb. When trying
to use labels or direct addressing with `p` or `x` commands, every address is
interpreted as a data (SRAM) address, as depicted in the following example (note
that the label __end__ points to 0x106 in Flash memory):

```bash
(gdb) x/x 0x100
0x800100:   0x00000000
(gdb) x/x end
0x800106:   0x00000000
```

To properly print contents of Flash memory and avoid that weird conversion, you
can use an offset from a label in Flash, or prepend `&` to the name of the
label. The following examples show this:

```bash
(gdb) x/x end + 0x0
0x106 <end>:    0xffffcfff
(gdb) x/x &end
0x106 <end>:    0xffffcfff
(gdb) x/x __trampolines_start + 0x100
0x100 <main>:   0xb904ef0f
```

This exact problem is depicted
[here](https://stackoverflow.com/questions/46122094/avr-gdb-can-not-understand-my-input-address).
