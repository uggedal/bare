ver 0.0.1
rev 1

style make

do_extract() {
  mkdir -p $MK_DIST
  cp -a $_SRC/Makefile $_SRC/lib $_SRC/pkg $MK_DIST
}
