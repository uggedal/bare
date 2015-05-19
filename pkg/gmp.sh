ver 6.0.0
rev 1
dist https://gmplib.org/download/$PKG_NAME/${PKG_NAME}-${PKG_VER}a.tar.xz
bdep m4

configure \
  --with-pic

sub gmp-bld type bld
sub gmp-bld rdep gmp
