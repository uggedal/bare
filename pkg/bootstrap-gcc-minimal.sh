inherit gcc

configure='
  --disable-nls
  --disable-decimal-float
  --disable-libatomic
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
