ver=4.9.2
rev=1
src=$URI_GNU/$name/$name-${ver}/$name-${ver}.tar.bz2

style=configure
configure='
  --with-newlib
  --disable-nls
  --disable-shared
  --disable-multilib
  --disable-decimal-float
  --disable-libgomp
  --disable-libmudflap
  --disable-libquadmath
  --disable-libssp
  --disable-threads
  --enable-languages=c
  '
