inherit gcc

configure='
  --disable-libmudflap
  --disable-libquadmath
  --disable-libssp
  --disable-libstdcxx-pch
  --disable-multilib
  --disable-nls
  --enable-c99
  --enable-languages=c,c++,lto
  --enable-libstdcxx-time
  --enable-long-long
  --enable-lto
  --enable-shared
  --enable-threads=posix
  '
