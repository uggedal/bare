ver=4.9.2
rev=1
src=$URI_GNU/$name/$name-${ver}/$name-${ver}.tar.bz2
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
