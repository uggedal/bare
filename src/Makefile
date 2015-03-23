PREFIX ?= /usr/local
CFLAGS += -Wall

BIN_SRC = $(wildcard pkg/*.c)
BIN = $(BIN_SRC:.c=)

${BIN}: ${BIN_SRC}
	${CC} $< ${CFLAGS} -o $@ ${LDFLAGS}

install-bin: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install -m755 $^ ${DESTDIR}${PREFIX}/bin

install: install-bin
