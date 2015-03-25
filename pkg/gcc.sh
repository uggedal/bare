ver=4.9.2
rev=1
dist="
  $URI_GNU/$name/$name-$ver/$name-${ver}.tar.bz2
  $URI_BB/GregorR/musl-cross/raw/a945614feb1e213411728cf52d8813c966691e14/patches/$name-$ver-musl.diff
  "

bdep='mpc-dev'

style=configure

configure='
  --disable-libsanitizer
  --disable-libstdcxx-pch
  --disable-multilib
  --disable-nls
  --enable-languages=c,c++,lto
  --enable-lto
  --enable-shared
  --libdir=/usr/lib
  '

builddir=gcc-build
