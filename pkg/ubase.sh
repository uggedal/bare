ver 0e7ab0
epoc 4
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
	local core='
		dd
		df
		ps
	'
	local f

	for f in $unneeded; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man[18]/${f}.[18]
	done

	mkdir -p $MK_DESTDIR/bin
	for f in $core; do
		mv $MK_DESTDIR$MK_PREFIX/bin/$f $MK_DESTDIR/bin
	done
}
