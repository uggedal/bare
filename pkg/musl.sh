ver=1.1.6
rev=1
src=http://www.$name-libc.org/releases/$name-${ver}.tar.gz

style=configure

configure='
  --disable-gcc-wrapper
  --enable-debug
  --enable-optimize
  '

post_install() {
  mkdir -p $MK_DESTDIR/lib $MK_DESTDIR$MK_PREFIX/bin
  ln -sf ..$MK_PREFIX/lib/libc.so $MK_DESTDIR/lib/ld-musl-${MK_ARCH}.so.1
  ln -s ../lib/libc.so $MK_DESTDIR$MK_PREFIX/bin/ldd
}
