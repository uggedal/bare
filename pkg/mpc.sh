ver 1.0.3
epoc 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz
bdep mpfr-bld

configure \
	--with-pic

sub mpc-bld type bld
sub mpc-bld rdep mpc mpfr-bld
