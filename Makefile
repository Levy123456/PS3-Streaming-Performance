TARGET = PS3StreamingPerformance
BUILD = build
SOURCE = Src/main.c

CC = ppu-gcc
CFLAGS = -02 -Wall

all:
    $(CC) $(CFLAGS) $(SOURCE) -o $(BUILD)/$(TARGET).elf
clean:
    rm -rf $(BUILD)
