inherit musl

post_install() {
  local libdir=$MK_PREFIX/../lib
  mkdir -p $libdir
  ln -s ../usr/lib/libc.so $libdir/ld-musl-${MK_ARCH}.so.1
}
