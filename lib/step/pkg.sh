_xz_stat() {
  printf -- '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

step_pkg() {
  local pkgdest=$_DEST/$fullname
  local pkg=$_REPO/${fullname}.tar.xz
  local stat

  progress pkg "'$name'"

  tar -C $pkgdest -cJvf $pkg .

  stat="$(xz -l $pkg | tail -n1)"
  msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
  msg "Compressed:   $(_xz_stat "$stat" 3 4)"
}
