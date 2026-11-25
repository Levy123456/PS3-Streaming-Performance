TARGET = PS3StreamingPerformance
BUILD = build
SOURCE = Src/main.c

CC = ppu-gcc
CFLAGS = -O2 -Wall

all: $(BUILD)/$(TARGET).elf

$(BUILD)/$(TARGET).elf: $(SOURCE)
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SOURCE) -o $(BUILD)/$(TARGET).elf

clean:
	rm -rf $(BUILD)
