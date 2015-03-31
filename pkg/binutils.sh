ver 2.25
rev 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

configure \
  --disable-multilib \
  --disable-nls \
  --disable-werror

pre_configure() {
  sed -i -e 's#MAKEINFO="$MISSING makeinfo"#MAKEINFO=true#g' configure
}
