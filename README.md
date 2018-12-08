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

## Contributing

Any bugs, suggestions and improvements are always welcome.

Maintainer: Juan Manuel Fresia <juanmanuelfresia@gmail.com>
