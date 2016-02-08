LDFLAGS += -lbsd

PREFIX ?= /usr
BIN_DIR ?= $(PREFIX)/bin
MAN_DIR ?= $(PREFIX)/share/man

OBJECTS = \
	backupfile.o \
	inp.o \
	mkpath.o \
	patch.o \
	pch.o \
	util.o

patch: $(OBJECTS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

install: patch
	install -Dm755 patch $(DESTDIR)/$(BIN_DIR)/patch
	install -Dm644 patch.1 $(DESTDIR)/$(MAN_DIR)/man1/patch.1

clean:
	rm -f *.o patch

.PHONY: install clean
