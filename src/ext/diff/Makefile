LDFLAGS += -lbsd

PREFIX ?= /usr
BIN_DIR ?= $(PREFIX)/bin
MAN_DIR ?= $(PREFIX)/share/man

HEADERS = \
	diff.h \
	xmalloc.h

OBJECTS = \
	diff.o \
	diffdir.o \
	diffreg.o \
	xmalloc.o


all: diff

%.o: %.c $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

diff: $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

install: diff
	install -Dm755 diff $(DESTDIR)/$(BIN_DIR)/diff
	install -Dm644 diff.1 $(DESTDIR)/$(MAN_DIR)/man1/diff.1

clean:
	rm -f *.o diff

.PHONY: install clean
