make_default_build() {
  # TODO: set CFLAGS/LDFLAGS/CC etc
  make
}

make_default_install() {
  make PREFIX=/usr DESTDIR=$DESTDIR install
}
