ver 0.0.1
epoc 2

bdep libarchive-bld liblzma-bld

do_extract() {
	cp -a $_SRC/pkg $MK_DIST
}
