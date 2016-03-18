include config.mk

SRC = pkg.c \
      util/eprintf.c \
      util/ealloc.c \
      util/strlcpy.c \
      util/strlcat.c \
      util/strtonum.c \
      util/mkdirp.c \
      util/sha256.c
HDR = util.h util/arg.h util/queue.h util/sha256.h
OBJ =$(SRC:.c=.o)

all: pkg

pkg: $(OBJ)

$(OBJ): $(HDR)

install:
	mkdir -p $(DESTDIR)/sbin
	cp pkg $(DESTDIR)/sbin

clean:
	rm -f pkg $(OBJ)

.PHONY: all install clean
