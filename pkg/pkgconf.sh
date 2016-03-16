ver 0.9.12
epoc 1
dist https://github.com/$PKG_NAME/$PKG_NAME/releases/download/$PKG_NAME-$PKG_VER/$PKG_NAME-${PKG_VER}.tar.bz2

post_install() {
	ln -sf pkgconf $MK_DESTDIR$MK_PREFIX/bin/pkg-config
}
