_xz_stat() {
  printf -- '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

step_pkg() {
  local pkg=$_REPO/${fullname}$PKG_EXT
  local stat

  progress pkg "'$name'"

  (
    cd $_DEST/$fullname
    set -- *
    [ "$1" != \* ] || die "no files in '$_DEST/$fullname'"
    tar -cJvf $pkg "$@"
  )

  [ ! -f $_REPO/files.txt ] || sed -i "/^$fullname\t/d" $_REPO/files.txt
  tar -tJf $pkg | awk '$0="'$fullname'\t"$0' >> $_REPO/files.txt

  stat="$(xz -l $pkg | tail -n1)"
  msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
  msg "Compressed:   $(_xz_stat "$stat" 3 4)"
}
