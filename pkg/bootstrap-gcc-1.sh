inherit gcc

CFLAGS='-O0 -g0'
CXXFLAGS="$CFLAGS"

configure="
  --disable-decimal-float
  --disable-libatomic
  --disable-libgomp
  --disable-libmudflap
  --disable-libquadmath
  --disable-libssp
  --disable-multilib
  --disable-nls
  --disable-shared
  --disable-threads
  --enable-languages=c
  --with-newlib
  "
