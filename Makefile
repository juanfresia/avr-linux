PROG := $(wildcard *.S)
HEX := $(patsubst %.S,%.hex,$(PROG))
OBJ := $(patsubst %.S,%.o,$(PROG))

# Only tested with atmega2560 (Arduino Mega) and atmega328p (Arduino Uno)
MMCU := atmega2560

# Device where the board is connected (usually this would work just fine)
DEVICE := /dev/ttyACM0

UPLOAD_FLAGS := -P $(DEVICE) -m $(MMCU) -b 115200
ifeq ($(MMCU), atmega2560)
	UPLOAD_FLAGS += -c wiring -F -D
else
	UPLOAD_FLAGS += -c arduino
endif

# By default, build everything in the directory
all: $(HEX)

%.out: %.S
	avr-gcc $< -mmcu=$(MMCU) -Os -g -o $@ -nostartfiles
	
%.hex: %.out
	avr-objcopy -O ihex $< $@ 
	
%.elf: %.out
	avr-objcopy -O elf32-avr -g $< $@ 
	
upload-%: %.hex
	avrdude $(UPLOAD_FLAGS) -U flash:w:$<

inspect-%: %.out
	avr-objdump -D $<

sim-gdb-%: %.hex
	simavr -m $(MMCU) -f 16m $< --gdb

gdb-%: %.out
	avr-gdb -q -s $< -e $< -n -ex 'target remote 127.0.0.1:1234'

clean:
	rm -rf *.o *.hex *.out
.PHONY: clean
 
.DEFAULT: all
.PHONY: upload
