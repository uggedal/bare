make_default_build() {
  # TODO: set CFLAGS/LDFLAGS/CC etc
  # TODO: set -j
  make
}

make_default_install() {
  make PREFIX=/usr DESTDIR=$DESTDIR install
}
