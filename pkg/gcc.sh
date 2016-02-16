ver 5.3.0
dist \
	$URI_GNU/$PKG_NAME/$PKG_NAME-$PKG_VER/$PKG_NAME-${PKG_VER}.tar.bz2 \
	http://port70.net/~nsz/musl/$PKG_NAME-$PKG_VER/$PKG_NAME-$PKG_VER.diff

bdep gxx mpc-bld libz-bld bsdtar

sub libgcc type custom
sub libgcc mv usr/lib/libgcc_s.so.\*

sub libstdcxx type custom
sub libstdcxx mv usr/lib/libstdc++.so.\*

sub libstdcxx-bld type custom
sub libstdcxx-bld rdep libstdcxx
sub libstdcxx-bld mv \
	usr/include/c++ \
	usr/lib/*++*

sub gxx type custom
sub gxx rdep libstdcxx-bld gcc
sub gxx mv \
	usr/bin/'[gc]'++ \
	usr/bin/$MK_TARGET_TRIPLE-'[gc]'++ \
	usr/libexec/gcc/$MK_TARGET_TRIPLE/$PKG_VER/cc1plus \
	usr/share/man/man1/g++.1

_configure="
	--disable-libsanitizer
	--disable-libstdcxx-pch
	--disable-multilib
	--disable-nls
	--enable-checking=release
	--enable-languages=c,c++,lto
	--enable-lto
	--enable-shared
	--libdir=/usr/lib
	--build=$MK_BUILD_TRIPLE
	--host=$MK_HOST_TRIPLE
	--target=$MK_TARGET_TRIPLE
	"

if [ "$MK_CROSS" ]; then
	# target library libgomp-plugin-host_nonshm.so gets linked
	# against host libc on gentoo:
	_configure="$_configure --disable-libgomp"
else
	_configure="$_configure --with-system-zlib"

	if [ -z "$MK_NO_DEP" ]; then
		export TAR='bsdtar --no-same-owner'
	fi
fi

configure $_configure

builddir gcc-build

# configure detects max_cmd_len=512 without getconf and the
# libtool code to split long command lines is utterly broken.
export lt_cv_sys_max_cmd_len=8192

pre_configure() {
	ed $MK_DIST/gcc/Makefile.in <<EOF
,s|tar xpf|tar -xf
w
q
EOF
}

post_install() {
	ln -s gcc $MK_DESTDIR$MK_PREFIX/bin/cc
	rm $MK_DESTDIR$MK_PREFIX/lib/*.py
	rm -r $MK_DESTDIR$MK_PREFIX/share/gcc-$PKG_VER/python
}

stale url https://gcc.gnu.org/releases.html
stale re 'GCC ([\d\.]+)<'
