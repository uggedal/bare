ver 0.0.004.ac4fcd
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
	local unneeded='
		eject
		fsfreeze
	'

	local f
	for f in $unneeded; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man[18]/${f}.[18]
	done
}
