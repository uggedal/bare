ver 0.2.3
epoc 1
dist $URI_SUCK/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz

bdep kernel-headers

pre_configure() {
	ed config.mk <<-EOF
	,s|^\(PREFIX = \).*\$|\1$MK_PREFIX
	,s|^\(LDFLAGS.*=.*\)-s.*\$|\1 -static
	/^CFLAGS/s|=|+=
	w
	q
	EOF

	ed Makefile <<-"EOF"
	,s|$(PREFIX)/bin|/sbin
	w
	q
	EOF
}
