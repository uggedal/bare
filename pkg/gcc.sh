ver=4.9.2
rev=1
src=$URI_GNU/$name/$name-${ver}/$name-${ver}.tar.bz2

style=configure
configure='
  --disable-nls
  --disable-decimal-float
  --disable-libgomp
  --disable-libmudflap
  --disable-libquadmath
  --disable-libssp
  --disable-multilib
  --disable-shared
  --disable-threads
  --enable-languages=c
  --with-newlib
  '
