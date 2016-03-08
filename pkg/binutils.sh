ver 2.26
epoc 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

bdep libz-bld

sub binutils-bld type bld
sub binutils-bld rdep binutils

_configure="
	--disable-multilib \
	--disable-nls \
	--disable-werror \
	--build=$MK_BUILD_TRIPLE \
	--host=$MK_HOST_TRIPLE \
	--target=$MK_TARGET_TRIPLE
	"

if [ -z "$MK_CROSS" ] && [ -z "$MK_NO_DEP" ]; then
	_configure="$_configure --with-system-zlib"
fi

configure $_configure

pre_configure() {
	ed configure <<-EOF
	,s|MAKEINFO="\$MISSING makeinfo"|MAKEINFO=true|g
	w
	q
	EOF
}
