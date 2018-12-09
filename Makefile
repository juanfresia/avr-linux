# Expected source files to match *.S
# All generated ihex binaries match *.hex
# All generated elf binaries match *.elf

PROG := $(wildcard *.S)
HEX := $(patsubst %.S,%.hex,$(PROG))
OBJ := $(patsubst %.S,%.o,$(PROG))

# Micro Controller Unit
# Only tested with atmega2560 (Arduino Mega) and atmega328p (Arduino Uno)
MCU := atmega2560

# Flags for compiling
CFLAGS := -mmcu=$(MCU) -Os -g -nostartfiles

# Device where the board is connected (usually this would work just fine)
DEVICE := /dev/ttyACM0

UPLOAD_FLAGS := -P $(DEVICE) -m $(MCU) -b 115200

# If using a different MCU or board, these flags may change
ifeq ($(MCU), atmega2560)
	UPLOAD_FLAGS += -c wiring -F -D
else
	UPLOAD_FLAGS += -c arduino
endif

# By default, build everything in the directory
all: $(HEX)

%.out: %.S
	avr-gcc $< $(CFLAGS) -o $@

%.hex: %.out
	avr-objcopy -O ihex $< $@ 
	
%.elf: %.out
	avr-objcopy -O elf32-avr -g $< $@ 
	
upload-%: %.hex
	avrdude $(UPLOAD_FLAGS) -U flash:w:$<

inspect-%: %.out
	avr-objdump -D $<

sim-gdb-%: %.hex
	simavr -m $(MCU) -f 16m $< --gdb

gdb-%: %.out
	avr-gdb -q -s $< -e $< -n -ex 'target remote 127.0.0.1:1234'

clean:
	rm -rf *.hex *.out *.elf
 
.DEFAULT: all
.PHONY: all clean upload
