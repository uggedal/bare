ver 6.1.0
epoc 1
dist https://gmplib.org/download/$PKG_NAME/${PKG_NAME}-${PKG_VER}.tar.xz
bdep m4

configure \
	--with-pic

sub gmp-bld type bld
sub gmp-bld rdep gmp
