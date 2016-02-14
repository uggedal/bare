ver 3.1.2
dist http://www.libarchive.org/downloads/libarchive-${PKG_VER}.tar.gz

configure \
	--disable-acl \
	--disable-bsdcpio \
	--disable-posix-regex-lib \
	--disable-xattr \
	--enable-bsdtar=shared \
	--without-bz2lib \
	--without-iconv \
	--without-lzma \
	--without-openssl \
	--without-zlib

sub libarchive-bld type bld
sub libarchive-bld rdep libarchive
sub libarchive-bld mv usr/share/man/man5

sub bsdtar type custom
sub bsdtar mv usr/bin/bsdtar usr/share/man/man1/bsdtar.1
sub bsdtar pkgorder after_main
