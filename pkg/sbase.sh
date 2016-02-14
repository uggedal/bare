ver 0.0.022.cfc37b
dist http://git.suckless.org/$PKG_NAME/snapshot/$PKG_NAME-${PKG_VER##*.}.tar.bz2

bdep bsdtar

distdir $PKG_NAME-${PKG_VER##*.}

if [ "$MK_BUILD_TRIPLE" = "$MK_TARGET_TRIPLE" ] && [ -z "$MK_NO_DEP" ]; then
	export TAR='bsdtar --no-same-owner'
fi

pre_configure() {
	ed config.mk <<EOF
,s|^\(CC = \).*\$|\1$CC
,s|^\(PREFIX = \).*\$|\1$MK_PREFIX
/^CFLAGS/s|=|+=
w
q
EOF
}

post_install() {
	local f
	for f in strings ed; do
		rm $MK_DESTDIR$MK_PREFIX/bin/$f
		rm -f $MK_DESTDIR$MK_MANDIR/man1/${f}.1
	done
}
