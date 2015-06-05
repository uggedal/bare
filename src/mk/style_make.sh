make_default_configure() {
  :
}

make_default_build() {
  msg "Build procs: '$MK_NPROC'"
  make -j $MK_NPROC
}

make_default_install() {
  make PREFIX=$MK_PREFIX DESTDIR=$MK_DESTDIR install
}
