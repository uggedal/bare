ver 1.0.2
rev 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz
bdep gmp-dev mpfr-dev

style=configure

configure \
  --with-pic

pre_configure() {
  cp -f $MK_FILE/config.sub .
}
