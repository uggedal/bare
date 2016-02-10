_ver=6.3
_patchver=008
ver ${_ver}.p$_patchver

_dist=$URI_GNU/$PKG_NAME
for _patch in $(seq -w $_patchver); do
	_patches="$_patches
	    $_dist/$PKG_NAME-${_ver}-patches/$PKG_NAME$(echo $_ver | tr -d .)-$_patch|$_patch.patch"
done
dist $_dist/$PKG_NAME-${_ver}.tar.gz $_patches

sub readline-bld type bld
sub readline-bld rdep readline
sub readline-bld mv usr/share/'*'

distdir $PKG_NAME-$_ver

configure \
	--disable-nls \
	--enable-multibyte
