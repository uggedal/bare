ver 1.4.17
rev 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.xz

post_install() {
	rm $MK_DESTDIR$MK_PREFIX/lib/charset.alias
}
