inherit gcc

configure \
  --disable-libsanitizer \
  --disable-libstdcxx-pch \
  --disable-multilib \
  --disable-nls \
  --enable-languages=c,c++ \
  --enable-shared \
  --target=$MK_TARGET_TRIPLE
