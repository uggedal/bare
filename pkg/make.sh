ver 4.1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

bdep bsdtar

configure \
	--disable-nls \
	--without-guile

if [ -z "$MK_CROSS" ] && [ -z "$MK_NO_DEP" ]; then
	export TAR='bsdtar --no-same-owner'
fi

post_install() {
	rm -r $MK_DESTDIR$MK_PREFIX/include
}
