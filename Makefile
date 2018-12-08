PROG := $(wildcard *.S)
HEX := $(patsubst %.S,%.hex,$(PROG))
OBJ := $(patsubst %.S,%.o,$(PROG))

all:

%.o: %.S
	avr-gcc $< -mmcu=atmega2560 -Os -g -c -o $@ -nostartfiles

%.out: %.S
	avr-gcc $< -mmcu=atmega2560 -Os -g -o $@ -nostartfiles
	
%.hex: %.out
	avr-objcopy -O ihex $< $@ 
	
%.elf: %.out
	avr-objcopy -O elf32-avr -g $< $@ 
	
upload-%: %.hex
	avrdude -c wiring -p m2560 -P /dev/ttyACM0 -b 115200 -F -D -U flash:w:$<

inspect-%: %.out
	avr-objdump -D $<

sim-gdb-%: %.hex
	simavr -m atmega2560 -f 16m $< --gdb

gdb-%: %.out
	avr-gdb -q -s $< -e $< -n -ex 'target remote 127.0.0.1:1234'

clean:
	rm -rf *.o *.hex *.out
.PHONY: clean
 
.DEFAULT: all
.PHONY: upload
