ver 1.1.9
rev 1
dist http://www.$PKG_NAME-libc.org/releases/$PKG_NAME-${PKG_VER}.tar.gz

lib libc.so

configure \
  --disable-gcc-wrapper \
  --enable-debug \
  --enable-optimize

post_install() {
  mkdir -p $MK_DESTDIR/lib $MK_DESTDIR$MK_PREFIX/bin
  ln -sf ..$MK_PREFIX/lib/libc.so $MK_DESTDIR/lib/ld-musl-${MK_ARCH}.so.1
  ln -s ../lib/libc.so $MK_DESTDIR$MK_PREFIX/bin/ldd
}

sub musl-bld type bld
sub musl-bld rdep musl
