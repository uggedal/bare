ver 4.9.2
rev 1
dist \
  $URI_GNU/$PKG_NAME/$PKG_NAME-$PKG_VER/$PKG_NAME-${PKG_VER}.tar.bz2 \
  $URI_BB/GregorR/musl-cross/raw/a945614feb1e213411728cf52d8813c966691e14/patches/$PKG_NAME-$PKG_VER-musl.diff

bdep mpc-dev

configure \
  --disable-libsanitizer \
  --disable-libstdcxx-pch \
  --disable-multilib \
  --disable-nls \
  --enable-languages=c,c++,lto \
  --enable-lto \
  --enable-shared \
  --libdir=/usr/lib

builddir gcc-build
