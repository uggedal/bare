ver 5.8

bdep libbsd-bld

do_extract() {
	mkdir -p $MK_DIST
	cp -a $_SRC/ext/$PKG_NAME/dist/* $MK_DIST
	cp $_SRC/ext/$PKG_NAME/Makefile $MK_DIST
}
