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
  local libdir=$MK_DESTDIR/lib
  mkdir -p $libdir
  ln -sf ../usr/lib/libc.so $libdir/ld-musl-${MK_ARCH}.so.1
}
