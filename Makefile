TARGET = PS3StreamingPerformance
BUILD = build
SOURCE = Src/main.c

CC = ppu-gcc
CFLAGS = -O2 -Wall

all: $(TARGET)

$(TARGET): $(SOURCE)
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

clean:
	rm -rf $(BUILD)
