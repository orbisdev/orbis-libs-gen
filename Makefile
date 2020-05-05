CC = gcc
CFLAGS = -Wall
LDFLAGS = -lyaml
OBJFILES = sha256.o yamltreeutil.o yamltree.o orbis-import.o orbis-import-parse.o orbis-libs-gen.o
TARGET = libs-gen

ifeq ($(DEBUG), 1)
	CFLAGS += -O0 -g
else
	CFLAGS += -O3
	LDFLAGS +=  -s
endif


all: $(TARGET)

$(TARGET): $(OBJFILES)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJFILES) $(LDFLAGS)

clean:
	rm -f $(OBJFILES) $(TARGET)