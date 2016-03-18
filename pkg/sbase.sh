ver 756119
epoc 7
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
	local bin='
		[
		cat
		chgrp
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
	local sbin='
		chown
		mkfifo
	'
	local usrsbin='
		chroot
	'
	local f

	for f in $conflicts; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man1/${f}.1
	done

	mkdir -p $MK_DESTDIR/bin $MK_DESTDIR/sbin $MK_DESTDIR$MK_PREFIX/sbin
	for f in $bin; do
		mv $MK_DESTDIR$MK_PREFIX/bin/$f $MK_DESTDIR/bin
	done
	for f in $sbin; do
		mv $MK_DESTDIR$MK_PREFIX/bin/$f $MK_DESTDIR/sbin
	done
	for f in $usrsbin; do
		mv $MK_DESTDIR$MK_PREFIX/bin/$f $MK_DESTDIR$MK_PREFIX/sbin
	done
}
