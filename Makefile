PKGS = $(shell ./mk list)

all: $(PKGS)

$(PKGS):
	./mk pkg $@

include deps.mk
