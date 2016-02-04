inherit musl

post_install() {
	ln -sfn . $MK_DESTDIR/usr
}
