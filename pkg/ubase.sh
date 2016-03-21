ver e0dc3f
epoc 11
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
		freeramdisk
		fsfreeze
		lastlog
		switch_root
		watch
	'
	local bin='
		dd
		df
		ps
	'
	local sbin='
		ctrlaltdel
		dmesg
		getty
		halt
		hwclock
		insmod
		killall5
		lsmod
		mknod
		mkswap
		mount
		pivot_root
		sysctl
		swaplabel
		swapon
		swapoff
		rmmod
		umount
	'
	local usrsbin='
		lsusb
	'
	local f

	for f in $unneeded; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man[18]/${f}.[18]
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
