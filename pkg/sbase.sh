ver 756119
epoc 6
dist http://git.suckless.org/$PKG_NAME/snapshot/$PKG_NAME-${PKG_VER##*.}.tar.bz2

distdir $PKG_NAME-${PKG_VER##*.}

pre_configure() {
	ed config.mk <<-EOF
	,s|^\(CC = \).*\$|\1$CC
	,s|^\(PREFIX = \).*\$|\1$MK_PREFIX
	,s|^\(LDFLAGS.*=.*\)-s.*\$|\1 -static
	/^CFLAGS/s|=|+=
	w
	q
	EOF
}

post_install() {
	local conflicts='
		ed
		strings
		tar
	'
	local core='
		cat
		chmod
		cp
		date
		echo
		expr
		hostname
		kill
		ln
		ls
		mkdir
		mv
		pwd
		rm
		rmdir
		sleep
		sync
		test
	'
	local f

	for f in $conflicts; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man1/${f}.1
	done

	mkdir -p $MK_DESTDIR/bin
	for f in $core; do
		mv $MK_DESTDIR$MK_PREFIX/bin/$f $MK_DESTDIR/bin
	done
}
