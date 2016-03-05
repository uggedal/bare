include config.mk

SRC = pkg.c \
      util/eprintf.c \
      util/ealloc.c \
      util/strlcpy.c \
      util/strlcat.c
HDR = util.h util/arg.h util/queue.h
OBJ =$(SRC:.c=.o)

all: pkg

pkg: $(OBJ)

$(OBJ): $(HDR)

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp pkg $(DESTDIR)$(PREFIX)/bin

clean:
	rm -f pkg $(OBJ)

.PHONY: all install clean
