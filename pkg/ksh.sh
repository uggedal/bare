ver 5.7

do_extract() {
	mkdir -p $MK_DIST
	cp -a $_SRC/ext/ksh/dist/* $MK_DIST
	cp $_SRC/ext/ksh/Makefile $MK_DIST
}
