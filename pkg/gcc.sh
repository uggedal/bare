ver=4.9.2
rev=1
src=$URI_GNU/$parentname/$parentname-${ver}/$parentname-${ver}.tar.bz2
bdep='zlib-dev'

style=configure

configure='
  --disable-multilib
  --disable-nls
  --enable-checking=release
  --enable-languages=c,c++,lto
  --enable-lto
  --enable-shared
  --enable-threads=posix
  --with-system-zlib
  '

builddir=gcc-build
