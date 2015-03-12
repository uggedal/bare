ver=0.0.1
rev=1

style=noop
builddir=.

do_build() {
  $CC $CFLAGS $MK_FILE/pkg-contain.c -o pkg-contain
}

do_install() {
  install -Dm755 pkg-contain $MK_DESTDIR/usr/bin/pkg-contain
}
