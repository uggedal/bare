include config.mk

SRC = pkg.c eprintf.c ealloc.c strlcpy.c strlcat.c
HDR = util.h arg.h queue.h
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
