configure_default_configure() {
	dump $MK_CONFIGURE $PKG_CONFIGURE
	$MK_DIST/configure $MK_CONFIGURE $PKG_CONFIGURE
}

configure_default_build() {
	msg "Build procs: '$MK_NPROC'"
	make -j $MK_NPROC
}

configure_default_install() {
	make PREFIX=$MK_PREFIX DESTDIR=$MK_DESTDIR install
}
