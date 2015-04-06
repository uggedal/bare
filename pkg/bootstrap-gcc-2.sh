inherit gcc

configure \
  --disable-libsanitizer \
  --disable-libstdcxx-pch \
  --disable-multilib \
  --disable-nls \
  --enable-languages=c,c++ \
  --enable-shared \
  --build=$MK_BUILD_TRIPLE \
  --host=$MK_HOST_TRIPLE \
  --target=$MK_TARGET_TRIPLE
