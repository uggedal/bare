inherit musl

post_install() {
  local libdir=$MK_DESTDIR/lib
  mkdir -p $libdir
  ln -sf ../usr/lib/libc.so $libdir/ld-musl-${MK_ARCH}.so.1
}
