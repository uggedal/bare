PREFIX ?= /usr/local
LIBDIR ?= ${PREFIX}/lib
CFLAGS += -Wall

BIN_SRC = $(wildcard pkg/*.c)
BIN = $(BIN_SRC:.c=)

SCRIPT_SRC = $(wildcard pkg/*.sh)
SCRIPT = $(SCRIPT_SRC:.sh=)

LIB = $(wildcard lib/*.sh)

${BIN}: %: %.c
	${CC} $< ${CFLAGS} -o $@ ${LDFLAGS}

${SCRIPT}: %: %.sh
	sed -e "s|@@LIBDIR@@|${LIBDIR}|" $^ > $@

.PHONY: install-bin install-lib

install-bin: ${BIN} ${SCRIPT}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install -m755 $^ ${DESTDIR}${PREFIX}/bin

install-lib: ${LIB}
	mkdir -p ${DESTDIR}${LIBDIR}/pkg
	install -m644 $^ ${DESTDIR}${LIBDIR}/pkg

install: install-bin install-lib
