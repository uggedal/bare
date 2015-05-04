_xz_stat() {
  printf '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

_provided_libs() {
  local libdir=$_DEST/$PKG_QUALIFIED_NAME$MK_PREFIX/lib
  local f mime

  [ -d $libdir ] || return 0

  find $libdir -type f | while read f; do
    mime="$(file -bi "$f")"
    case "$mime" in
      application/x-sharedlib*)
        objdump -p $f | awk '/^ +SONAME/ { print $2 }'
        ;;
    esac
  done
}

step_pkg() {
  local pkg=$_REPO/${PKG_QUALIFIED_NAME}$PKG_EXT
  local stat

  progress pkg "'$PKG_NAME'"

  pkg-create \
    -p $_DEST/$PKG_QUALIFIED_NAME \
    -o $pkg \
    -l "$(_provided_libs)" \
    $PKG_QUALIFIED_NAME

  stat="$(xz -l $pkg | tail -n1)"
  msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
  msg "Compressed:   $(_xz_stat "$stat" 3 4)"
}
