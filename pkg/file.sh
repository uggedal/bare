ver 5.22
rev 1
dist ftp://ftp.astron.com/pub/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz

pre_configure() {
  cp -f $MK_FILE/config.sub .
}
