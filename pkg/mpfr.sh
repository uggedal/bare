_ver=3.1.3
_patchver=0
ver ${_ver}.p$_patchver
epoc 1

_dist=http://www.${PKG_NAME}.org/$PKG_NAME-$_ver
for _patch in $(seq -w $_patchver); do
	_patches="$_patches $_dist/patch$_patch|${_patch}.patch"
done
dist $_dist/$PKG_NAME-${_ver}.tar.xz $_patches

bdep gmp-bld

sub mpfr-bld type bld
sub mpfr-bld rdep mpfr gmp-bld

distdir $PKG_NAME-$_ver

configure \
	--with-pic
