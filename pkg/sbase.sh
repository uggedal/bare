ver 0.0.024.bb83ea
dist http://git.suckless.org/$PKG_NAME/snapshot/$PKG_NAME-${PKG_VER##*.}.tar.bz2

distdir $PKG_NAME-${PKG_VER##*.}

pre_configure() {
	ed config.mk <<-EOF
	,s|^\(CC = \).*\$|\1$CC
	,s|^\(PREFIX = \).*\$|\1$MK_PREFIX
	/^CFLAGS/s|=|+=
	w
	q
	EOF
}

post_install() {
	local f
	for f in ed strings tar; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man1/${f}.1
	done
}
