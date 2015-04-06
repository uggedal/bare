ver 2.25
rev 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

configure \
  --disable-multilib \
  --disable-nls \
  --disable-werror \
  --build=$MK_BUILD_TRIPLE \
  --host=$MK_HOST_TRIPLE \
  --target=$MK_TARGET_TRIPLE

pre_configure() {
  sed -i -e 's#MAKEINFO="$MISSING makeinfo"#MAKEINFO=true#g' configure
}
