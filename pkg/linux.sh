ver 4.4.2
dist https://www.kernel.org/pub/$PKG_NAME/kernel/v${PKG_VER%%.*}.x/$PKG_NAME-${PKG_VER}.tar.xz

style noop

do_install() {
	mkdir -p $MK_DESTDIR
}
