configure_default_configure() {
  $MK_SRC/configure $MK_CONFIGURE $configure
}

configure_default_build() {
  # TODO: set CFLAGS/LDFLAGS/CC etc
  make -j $MK_NPROC
}

configure_default_install() {
  make PREFIX=$MK_PREFIX DESTDIR=$MK_DESTDIR install
}
