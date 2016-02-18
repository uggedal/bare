CFLAGS += -DEXTENDED -I.
LDFLAGS += -lbsd

PREFIX ?= /usr
BIN_DIR ?= $(PREFIX)/bin
MAN_DIR ?= $(PREFIX)/share/man

OBJECTS = \
	ohash.o \
	eval.o \
	expr.o \
	look.o \
	main.o \
	misc.o \
	gnum4.o \
	trace.o \
	tokenizer.o \
	parser.o

m4: $(OBJECTS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

parser.c parser.h: parser.y
	${YACC} -d $@ && mv y.tab.c parser.c && mv y.tab.h parser.h

tokenizer.o: parser.h

install: m4
	install -Dm755 m4 $(DESTDIR)/$(BIN_DIR)/m4
	install -Dm644 m4.1 $(DESTDIR)/$(MAN_DIR)/man1/m4.1

clean:
	rm -f *.o m4

.PHONY: install clean
