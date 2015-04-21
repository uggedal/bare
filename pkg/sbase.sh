ver 0.0.006.22c0ae
rev 1
dist http://git.suckless.org/$PKG_NAME/snapshot/$PKG_NAME-${PKG_VER##*.}.tar.bz2

distdir $PKG_NAME-${PKG_VER##*.}

pre_configure() {
  sed -i \
    -e "s|^\(CC = \).*|\1$CC|" \
    -e "s|^\(PREFIX = \).*|\1$MK_PREFIX|" \
    config.mk
}

post_install() {
  local conflicts='
    strings
  '
  local broken='
    expr
    sed
  '

  local f
  for f in $conflicts $broken; do
    rm $MK_DESTDIR$MK_PREFIX/bin/$f
    rm -f $MK_DESTDIR$MK_PREFIX/share/man/man1/${f}.1
  done
}
