pre_env() {
	: ${CC:=gcc}

	MK_ARCH=$(uname -m)
	MK_KERNEL_ARCH=$(printf '%s' $MK_ARCH | sed 's/-.*//')

	: ${MK_BUILD_TRIPLE:=$($CC -dumpmachine)}
	: ${MK_HOST_TRIPLE:=$($CC -dumpmachine)}
	: ${MK_TARGET_TRIPLE:=$MK_ARCH-linux-musl}

	if [ "$MK_BUILD_TRIPLE" != "$MK_TARGET_TRIPLE" ]; then
		MK_CROSS=yes
	fi
}

post_env() {
	umask 022
	export LC_ALL=C

	: ${CFLAGS:='-Os -pipe'}
	: ${CXXFLAGS:=$CFLAGS}
	export CFLAGS CXXFLAGS CC

	: ${MK_PREFIX:=/usr}

	if [ "$MK_DESTDIR" = no ]; then
		unset MK_DESTDIR
	else
		: ${MK_DESTDIR:=$_DEST/$PKG_QUALIFIED_NAME}
	fi

	MK_FILE=$_FILE/$PKG_PARENT_NAME
	MK_PATCH=$_PATCH/$PKG_PARENT_NAME
	MK_LOG=$_LOG/$PKG_QUALIFIED_NAME

	MK_BUILD_ROOT=$_BUILD/$PKG_QUALIFIED_NAME

	if [ "$PKG_DISTDIR" ]; then
		MK_DIST=$MK_BUILD_ROOT/$PKG_DISTDIR
	else
		MK_DIST=$MK_BUILD_ROOT/$PKG_PARENT_NAME-$PKG_VER
	fi

	MK_BUILD=$MK_DIST

	if [ "$PKG_BUILDDIR" ]; then
		MK_BUILD=$MK_BUILD_ROOT/$PKG_BUILDDIR
	fi

	MK_MANDIR=$MK_PREFIX/share/man

	: ${MK_CONFIGURE:="
		--prefix=$MK_PREFIX
		--sysconfdir=/etc
		--localstatedir=/var
		--mandir=$MK_MANDIR
		"}
}
