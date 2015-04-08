_xz_stat() {
  printf -- '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

step_pkg() {
  local pkg=$_REPO/${PKG_FULLNAME}$PKG_EXT
  local stat

  progress pkg "'$PKG_NAME'"

  pkg-create $PKG_NAME $_DEST/$PKG_FULLNAME $pkg

  [ ! -f $_REPO/files.txt ] || sed -i "/^$PKG_FULLNAME\t/d" $_REPO/files.txt
  tar -tJf $pkg | awk '$0="'$PKG_FULLNAME'\t"$0' >> $_REPO/files.txt

  stat="$(xz -l $pkg | tail -n1)"
  msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
  msg "Compressed:   $(_xz_stat "$stat" 3 4)"
}
