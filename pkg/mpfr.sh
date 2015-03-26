ver 3.1.2
rev 1
dist http://www.${PKG_NAME}.org/$PKG_NAME-current/$PKG_NAME-${PKG_VER}.tar.xz
bdep gmp-dev

style configure

configure \
  --with-pic

pre_configure() {
  cp -f $MK_FILE/config.sub .
}
