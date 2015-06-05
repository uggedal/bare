make_default_configure() {
  :
}

make_default_build() {
  msg $MK_NPROC procs
  make -j $MK_NPROC
}

make_default_install() {
  make PREFIX=$MK_PREFIX DESTDIR=$MK_DESTDIR install
}
