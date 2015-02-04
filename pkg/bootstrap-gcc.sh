inherit gcc

configure='
  --disable-libmudflap
  --disable-libsanitizer
  --disable-multilib
  --disable-nls
  --enable-languages=c,c++,lto
  --enable-lto
  --enable-shared
  '
