inherit gcc

CFLAGS='-O0 -g0'
CXXFLAGS="$CFLAGS"

configure \
  --disable-decimal-float \
  --disable-libatomic \
  --disable-libgomp \
  --disable-libmudflap \
  --disable-libquadmath \
  --disable-libssp \
  --disable-multilib \
  --disable-nls \
  --disable-shared \
  --disable-threads \
  --enable-languages=c \
  --with-newlib \
  --build=$MK_BUILD_TRIPLE \
  --host=$MK_HOST_TRIPLE \
  --target=$MK_TARGET_TRIPLE
