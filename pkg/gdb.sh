ver 7.10.1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.xz

bdep libz-bld linux-headers readline-bld

configure \
	--disable-gdbserver \
	--disable-nls \
	--with-system-readline \
	--with-system-zlib

pre_configure() {
	ed configure <<-EOF
	,s|MAKEINFO="\$MISSING makeinfo"|MAKEINFO=true|g
	w
	q
	EOF
}

post_install() {
	rm -r $MK_DESTDIR$MK_PREFIX/include $MK_DESTDIR$MK_PREFIX/lib 
}
