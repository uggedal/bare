CFLAGS += -Wall -isystem .

PREFIX ?= /usr
BIN_DIR ?= /bin
MAN_DIR ?= $(PREFIX)/share/man

HEADERS = \
	c_test.h \
	charclass.h \
	config.h \
	edit.h \
	expand.h \
	ksh_limval.h \
	lex.h \
	proto.h \
	sh.h \
	shf.h \
	table.h \
	tree.h \
	tty.h

OBJECTS = \
	alloc.o \
  c_ksh.o \
  c_sh.o \
  c_test.o \
  c_ulimit.o \
  edit.o \
  emacs.o \
  eval.o \
  exec.o \
  expr.o \
  history.o \
  io.o \
  jobs.o \
  lex.o \
  mail.o \
  main.o \
  mknod.o \
  misc.o \
  path.o \
  shf.o \
  syn.o \
  table.o \
  trap.o \
  tree.o \
  tty.o \
  var.o \
  version.o \
  vi.o

all: ksh

%.o: %.c $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)

ksh: $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

install: ksh
	install -Dm755 ksh $(DESTDIR)/$(BIN_DIR)/ksh
	ln -s ksh $(DESTDIR)/$(BIN_DIR)/sh
	install -Dm644 ksh.1 $(DESTDIR)/$(MAN_DIR)/man1/ksh.1
	install -Dm644 sh.1 $(DESTDIR)/$(MAN_DIR)/man1/sh.1

clean:
	rm -f *.o ksh

.PHONY: install clean
