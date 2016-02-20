ver 2.26
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

bdep bsdtar

sub binutils-bld type bld
sub binutils-bld rdep binutils

configure \
	--disable-multilib \
	--disable-nls \
	--disable-werror \
	--build=$MK_BUILD_TRIPLE \
	--host=$MK_HOST_TRIPLE \
	--target=$MK_TARGET_TRIPLE

if [ -z "$MK_CROSS" ] && [ -z "$MK_NO_DEP" ]; then
	export TAR='bsdtar --no-same-owner'
fi

pre_configure() {
	ed configure <<-EOF
	,s|MAKEINFO="\$MISSING makeinfo"|MAKEINFO=true|g
	w
	q
	EOF
}
