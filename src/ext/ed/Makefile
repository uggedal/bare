CFLAGS += -Wall -isystem .
LDFLAGS += -lbsd

PREFIX ?= /usr
BIN_DIR ?= /bin
MAN_DIR ?= $(PREFIX)/share/man

OBJECTS = \
	buf.o \
	glbl.o \
	io.o \
	main.o \
	re.o \
	sub.o \
	undo.o

ed: $(OBJECTS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

install: ed
	install -Dm755 ed $(DESTDIR)/$(BIN_DIR)/ed
	install -Dm644 ed.1 $(DESTDIR)/$(MAN_DIR)/man1/ed.1

clean:
	rm -f *.o ed

.PHONY: install clean
