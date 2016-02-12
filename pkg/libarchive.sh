ver 3.1.2
dist http://www.libarchive.org/downloads/libarchive-${PKG_VER}.tar.gz

configure \
	--disable-acl \
	--disable-posix-regex-lib \
	--disable-xattr \
	--without-lzma \
	--without-xz \
	--without-zlib

sub libarchive-bld type bld
sub libz-bld rdep libarchive

sub bsdtar type custom
sub bsdtar mv usr/bin/bsdtar usr/share/man/man1/bsdtar.5
