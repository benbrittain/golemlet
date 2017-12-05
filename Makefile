CC = xtensa-lx106-elf-gcc
CFLAGS = -I. -mlongcalls
LDLIBS = -L. -nostdlib -Wl,--start-group -lmain -lnet80211 -lwpa -llwip -lpp -lphy -lc -Wl,--end-group -lgcc
LDFLAGS = -Teagle.app.v6.ld

golemlet-0x00000.bin: golemlet
	esptool.py elf2image $^

golemlet: golemlet.o

golemlet.o: golemlet.c

flash: golemlet-0x00000.bin
	esptool.py write_flash 0 golemlet-0x00000.bin 0x10000 golemlet-0x10000.bin

clean:
	rm -f golemlet golemlet.o golemlet-0x00000.bin golemlet-0x10000.bin
