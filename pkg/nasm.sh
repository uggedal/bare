ver 2.12
dist http://www.nasm.us/pub/$PKG_NAME/releasebuilds/$PKG_VER/$PKG_NAME-$PKG_VER.tar.xz

do_install() {
	make INSTALLROOT=$MK_DESTDIR install
}
