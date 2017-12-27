ESP_LIB = /home/ben/workspace/esp-open-sdk/sdk/lib
CC = xtensa-lx106-elf-gcc
CFLAGS = -I. -mlongcalls -I./esp_mqtt/mqtt/include/ -I./esp_mqtt/include/ -Wpointer-arith -Wundef \
	 -Wl,-EL -Wno-implicit-function-declaration -fno-inline-functions -nostdlib -ffunction-sections \
	 -fdata-sections -fno-builtin-printf -DICACHE_FLASH -DUSE_OPENSDK
LDLIBS = -L$(ESP_LIB) -g -O2 -Wl,--start-group -lc -lgcc -lphy -lpp -lnet80211 \
	 -lwpa -lmain -llwip -lcrypto -lssl -ljson -ldriver \
	 esp_mqtt/build/esp_mqtt.a -Wl,--end-group -P
LDFLAGS = -Teagle.app.v6.ld -nostdlib -Wl,--no-check-sections -u call_user_start -Wl,-static

golemlet-0x00000.bin: golemlet
	esptool.py elf2image $^

golemlet: golemlet.o
	$(CC) $(LDFLAGS) golemlet.o $(LDLIBS) -o golemlet
#	$(CC) $(LDFLAGS) golemlet.o $(LIBS) $(LDLIBS) -o golemlet


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
