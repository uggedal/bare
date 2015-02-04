ver=1.1.6
rev=1
src=http://www.$name-libc.org/releases/$name-${ver}.tar.gz

style=configure

do_configure() {
  CC=$MK_TARGET-gcc CROSS_COMPILE=${MK_TARGET}- ./configure $MK_CONFIGURE
}

do_install() {
  make install DESTDIR=$MK_DESTDIR/$MK_PREFIX/$MK_TARGET
}
