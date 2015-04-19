ver 0.0.002.34a3ab8cdaee7ca671f42799cc5e499f8351f9b7
rev 1
dist http://git.2f30.org/$PKG_NAME/snapshot/$PKG_NAME-${PKG_VER##*.}.tar.bz2

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
    tar
  '

  local f
  for f in $conflicts $broken; do
    rm $MK_DESTDIR$MK_PREFIX/bin/$f
    rm -f $MK_DESTDIR$MK_PREFIX/share/man/man1/${f}.1
  done
}
