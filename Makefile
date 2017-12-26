CC = xtensa-lx106-elf-gcc
CFLAGS = -I. -mlongcalls
LDLIBS = -L. -nostdlib -Wl,--start-group -lmain -lnet80211 -lwpa -llwip -lpp -lphy -lc -Wl,--end-group -lgcc
LDFLAGS = -Teagle.app.v6.ld
LIBS = esp_mqtt.a

golemlet-0x00000.bin: golemlet
	esptool.py elf2image $^

golemlet: golemlet.o
	$(CC) $(LDFLAGS) golemlet.o $(LIBS) $(LDLIBS) -o golemlet

golemlet.o: golemlet.c
	$(CC) $(CFLAGS) -c -o golemlet.o golemlet.c

flash: golemlet-0x00000.bin
	esptool.py write_flash 0 golemlet-0x00000.bin 0x10000 golemlet-0x10000.bin

# esp_mqtt.a
#libsub.a libsubsub.a : force_look
#	$(ECHO) looking into subdir : $(MAKE) $(MFLAGS)
#	cd subdir; $(MAKE) $(MFLAGS)
#	mv TODO
#force_look:
#	true

clean:
	rm -f golemlet golemlet.o golemlet-0x00000.bin golemlet-0x10000.bin
