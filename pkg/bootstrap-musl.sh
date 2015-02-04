inherit musl

do_configure() {
  CC=$MK_TARGET-gcc CROSS_COMPILE=${MK_TARGET}- ./configure $MK_CONFIGURE
}

do_install() {
  make install DESTDIR=$MK_DESTDIR/$MK_PREFIX/$MK_TARGET
}
