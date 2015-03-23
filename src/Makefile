PREFIX ?= /usr/local
LIBDIR ?= ${PREFIX}/lib
CFLAGS += -Wall

BIN_SRC = $(wildcard pkg/*.c)
BIN = $(BIN_SRC:.c=)

SCRIPT_SRC = $(wildcard pkg/*.sh)
SCRIPT = $(SCRIPT_SRC:.sh=)

LIB = $(wildcard lib/*.sh)

${BIN}: ${BIN_SRC}
	${CC} $< ${CFLAGS} -o $@ ${LDFLAGS}

${SCRIPT}: ${SCRIPT_SRC}
	sed -e "s|@@LIBDIR@@|${LIBDIR}|" $< > $@

install-bin: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install -m755 $^ ${DESTDIR}${PREFIX}/bin

install-script: ${SCRIPT}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install -m755 $^ ${DESTDIR}${PREFIX}/bin

install-lib: ${LIB}
	mkdir -p ${DESTDIR}${LIBDIR}/pkg
	install -m644 $^ ${DESTDIR}${LIBDIR}/pkg

install: install-bin install-script install-lib
