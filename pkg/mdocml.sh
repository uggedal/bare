ver 1.13.3
rev 1
dist http://${PKG_NAME}.bsd.lv/snapshots/$PKG_NAME-${PKG_VER}.tar.gz

pre_configure() {
	cat <<EOF >configure.local
PREFIX=$MK_PREFIX
MANDIR=$MK_MANDIR
CFLAGS="\$CFLAGS $CFLAGS"
BUILD_DB=0
EOF
}

do_configure() {
	./configure
}

post_install() {
	local d
	for d in include lib share/man/man3; do
		rm -r $MK_DESTDIR$MK_PREFIX/$d
	done

	rm $MK_DESTDIR$MK_PREFIX/bin/man
	ln -s mandoc $MK_DESTDIR$MK_PREFIX/bin/man

	install -Dm644 $MK_FILE/man.conf $MK_DESTDIR/etc/man.conf
}
