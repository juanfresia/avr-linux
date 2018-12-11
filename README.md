# avr-linux

Base project and toolchain for AVR assembly programming in Linux.

This is inspired by the lack of resources available for programmers using Unix
like systems and wanting to get into the AVR assembly world.  We've been through
that, so we decided to create a base project, together with the documentation of
the issues we found in the path for those who may come after us.

This project will help you code, debug and upload projects based on Arduino AVR
from your favourite Unix OS.  We use `avr-*` cross-compiler tool chain, spanning
`avr-gcc`, `avr-ld`, `avr-gdb`, `avr-objcpy` and `avrdude`.  Together with that,
we include a `/docs` folder with tools and tips on how to run and use each of
those.

## Installation

To install all the dependencies needed to start using this base project, simply
run the following command:

```bash
sudo apt-get install -y gcc-avr avr-libc avrdude libtool texinfo elfutils \
                     libglu1-mesa-dev freeglut3-dev gdb-avr libelf-dev
```

If you want to also be able to debug your programs, you will need an AVR
architecture simulator. The provided Makefile uses
[`simavr`](https://github.com/buserror/simavr), and you can install it as
follows (unluckily, the project needs to be build from source as there are no
binaries uploaded to the repositories):

```bash
git clone https://github.com/buserror/simavr /tmp/simavr
cd /tmp/simavr
sudo make install RELEASE=1
```

This will create several `simavr` folders under `/usr/local/bin` and
`/usr/local/include`. Remove them to uninstall.

## Compiling

The provided makefile has two targets to compile the source code. It expects the
source files to have the .S extension. The makefile is able to generate two
types of binaries: _ihex_ and _elf_ formats. The first one is used to upload the
program to the MCU; the latter to use gdb and inspect capabilities.

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

## Debugging

The makefile provides two features to debug and inspect the generated code: the
equivalent to `objdump` to inspect the compiled code, and the equivalent to
`gdb` for general purpose debugging.

To get a dump of the generated binary (compiled from `source.S` file) simply run:

```bash
make inspect-source
```

This will output a dump of the assembly code, with all the constants replaced,
useful to check whether the registers and port constants were replaced
correctly.
This target will recompile the code if it was changed since last inspection.

### gdb debugging

The second feature is gdb debugging. This is achieved by running the code on a
AVR architecture emulator, `sim-avr`, and then attaching gdb to that process.

To use this feature you will need to start the simulator with:

```bash
make sim-gdb-source
```

After that it will wait for a gdb session to be attached, which can be done with
the following command **from another terminal**:

```bash
make gdb-source
```

This will prompt you with a gdb terminal ready to start debugging the program.

More information on debugging with `avr-gdb` can be found in [here](/docs/avr-gdb.md).

## Contributing

Any bugs, suggestions and improvements are always welcome so feel free to open an
issue or submitting a PR.
Let us know if you tested our repos in any new MCU or base OS, and the problems
you may have stumbled upon so we can keep this growing.

Maintainers:

- Juan Manuel Fresia <<juanmanuelfresia@gmail.com>>

Contributors:

- Ana Czarnitzki
- Alejandro Gracía
