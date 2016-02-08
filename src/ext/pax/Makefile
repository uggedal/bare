CFLAGS += -Wall -isystem .
LDFLAGS += -lbsd

PREFIX ?= /usr
BIN_DIR ?= /bin
MAN_DIR ?= $(PREFIX)/share/man

OBJECTS = \
  fts.o \
  ar_io.o \
  ar_subs.o \
  buf_subs.o \
  cache.o \
  cpio.o \
  file_subs.o \
  ftree.o \
  gen_subs.o \
  getoldopt.o \
  options.o \
  pat_rep.o \
  pax.o \
  sel_subs.o \
  tables.o \
  tar.o \
  tty_subs.o

pax: $(OBJECTS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

install: pax
	install -Dm755 pax $(DESTDIR)/$(BIN_DIR)/pax
	ln -s pax $(DESTDIR)/$(BIN_DIR)/tar
	ln -s pax $(DESTDIR)/$(BIN_DIR)/cpio
	install -Dm644 cpio.1 $(DESTDIR)/$(MAN_DIR)/man1/cpio.1
	install -Dm644 pax.1 $(DESTDIR)/$(MAN_DIR)/man1/pax.1
	install -Dm644 tar.1 $(DESTDIR)/$(MAN_DIR)/man1/tar.1

clean:
	rm -f *.o pax

.PHONY: install clean
