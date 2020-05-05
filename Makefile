CC = gcc
CFLAGS = -Wall
LDFLAGS = -lyaml
OBJFILES = sha256.o yamltreeutil.o yamltree.o orbis-import.o orbis-import-parse.o orbis-libs-gen.o
TARGET = libs-gen


all: $(TARGET)

$(TARGET): $(OBJFILES)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJFILES) $(LDFLAGS)

clean:
	rm -f $(OBJFILES) $(TARGET)