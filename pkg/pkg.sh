ver=0.0.1
rev=1

style=noop

do_extract() {
  mkdir -p $MK_SRC
  cp -a $_SRC/pkg $_SRC/common $MK_SRC
}

do_build() {
  $CC $CFLAGS -Wall pkg/pkg-contain.c -o pkg-contain
}

do_install() {
  install -Dm755 pkg-contain $MK_DESTDIR$MK_PREFIX/bin/pkg-contain
}
