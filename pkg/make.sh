ver 4.1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

configure \
	--disable-nls \
	--without-guile

post_install() {
	rm -r $MK_DESTDIR$MK_PREFIX/include
}
