make_default_build() {
  # TODO: set CFLAGS/LDFLAGS/CC etc
  make -j $MK_NPROC
}

make_default_install() {
  make PREFIX=/usr DESTDIR=$DESTDIR install
}
