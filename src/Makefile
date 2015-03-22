PREFIX ?= /usr/local
CFLAGS += -Wall

C_SRC = $(wildcard pkg/*.c)
BIN = $(C_SRC:.c=)

${BIN}: ${C_SRC}
	${CC} $< ${CFLAGS} -o $@ ${LDFLAGS}

install-bin: ${BIN}
	install -Dm755 $< ${DESTDIR}${PREFIX}/bin/$(<:pkg/%=%)

install: install-bin
