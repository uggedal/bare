LDFLAGS += -lbsd

PREFIX ?= /usr
BIN_DIR ?= $(PREFIX)/bin
MAN_DIR ?= $(PREFIX)/share/man

OBJECTS = \
	main.c \
	zopen.c \
	gzopen.c \
	nullopen.c

compress: $(OBJECTS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

install: compress
	install -Dm755 compress $(DESTDIR)/$(BIN_DIR)/compress
	install -Dm644 compress.1 $(DESTDIR)/$(MAN_DIR)/man1/compress.1
	for l in uncompress zcat gzip gunzip; do \
		ln -s compress $(DESTDIR)/$(BIN_DIR)/$l ;\
		ln -s compress.1 $(DESTDIR)/$(MAN_DIR)/man1/$l.1 ;\
	done

clean:
	rm -f *.o compress

.PHONY: install clean
