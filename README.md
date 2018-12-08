# avr-Linux

Base project and tool chain for avr assembly programming in Linux.

This is inspired by the lack of resources available for programmers using Unix
like systems and wanting to get into the avr assembly world.  We've been through
that, so we decided to create a base project, together with the documentation of
the issues we found in the path for those who may come after us.

This project will help you code, debug and upload projects based on Arduino avr
from your favourite Unix OS.  We use `avr-*` cross-compiler tool chain, spanning
`avr-gcc`, `avr-ld`, `avr-gdb`, `avr-objcpy` and `avrdude`.  Together with that,
we include a `/docs` folder with tools and tips on how to run and use each of
those.

## Installation

To install all the dependencies needed to start using this base project, simply
run the following command:

```bash
sudo apt-get install gcc-avr avr-libc avrdude libtool texinfo elfutils \
                     libglu1-mesa-dev freeglut3-dev gdb-avr
```

## Compiling

The provided makefile has two targets to compile the source code. It expects the
source files to have the extension .S. The makefile is able to generate two
types of binaries: _ihex_ and _elf_ formats. The first one is used to upload the
program to the MCU, the latter to use gdb and inspect capabilities.

It is important to note that only one .S can be built at a time, meaning there
is no linking of binaries. All dependencies can be managed using `#include`
directives of `avr-gcc` compiler.

To build a specific `source.S` file into an _ihex_ binary simply run:

```bash
make source.hex
```

To build the _elf_ version of the binary instead run:

```bash
make source.elf
```

Lastly, the default target `make all` will attempt to build all .S files
individually.

## Uploading

To upload the code from a compiled `source.S`, first plug the board to an USB
and then run:

 ```bash
sudo make upload-source
```

This will attempt to upload the _ihex_ binary to the device at `/dev/ttyACM0`,
which should be fine if the board is the only device connected. Check the
makefile if you need to change that, or if you need to change the programmer
(`avrdude` `-c` flag).

## Contributing

Any bugs, suggestions and improvements are always welcome.

Maintainer: Juan Manuel Fresia (<juanmanuelfresia@gmail.com>)
