ver 1.0
epoc 1
dist $URI_SUCK/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz

pre_configure() {
	ed config.mk <<-EOF
	,s|^\(CC = \).*\$|\1$CC
	,s|^\(PREFIX = \).*\$|\1$MK_PREFIX
	/^CFLAGS/s|=|+=
	w
	q
	EOF

	ed config.def.h <<-EOF
	,s|/bin/rc.init|/etc/rc
	,s|/bin/rc.shutdown|/etc/rc
	w
	q
	EOF

	ed Makefile <<-"EOF"
	,s|$(PREFIX)/bin|/sbin
	w
	q
	EOF
}

post_install() {
	ln -sf sinit $MK_DESTDIR/sbin/init
}
