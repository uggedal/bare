_xz_stat() {
  printf -- '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

step_pkg() {
  local pkg=$_REPO/${PKG_FULLNAME}$PKG_EXT
  local stat

  progress pkg "'$PKG_NAME'"

  pkg-create \
    -n $PKG_FULLNAME \
    -r $_DEST/$PKG_FULLNAME \
    -p $pkg

  stat="$(xz -l $pkg | tail -n1)"
  msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
  msg "Compressed:   $(_xz_stat "$stat" 3 4)"
}
