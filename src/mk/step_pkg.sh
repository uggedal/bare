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

_needed_libs() {
  local dest=$_DEST/$PKG_QUALIFIED_NAME
  local f mime

  [ -d $dest ] || return 0

  find $dest -type f | while read f; do
    mime="$(file -bi "$f")"
    case "$mime" in
      application/x-executable*|application/x-sharedlib*)
        objdump -p $f | awk '/^ +NEEDED/ { print $2 }'
        ;;
    esac
  done
}

_find_lib_in_db() {
  local t=$1
  local f1=$2
  local l

  [ "$t" = l ] || return 0

  for l in $_NEEDED_LIBS; do
    [ "$l" != "$f1" ] || printf '%s:%s\n' $_PKG_NAME $l
  done
}

_find_pkg_with_lib() {
  local name=$1
  local ver=$2
  local qualified_name=$3
  local pkg=$4

  [ $name != $PKG_NAME ] || return 0

  _PKG_NAME=$name
  read_db $_DB $name _find_lib_in_db
  unset _PKG_NAME
}

_lib_deps() {
  _NEEDED_LIBS=$(_needed_libs)
  [ -z "$_NEEDED_LIBS" ] || read_repo $_REPO _find_pkg_with_lib | sort | uniq
  unset _NEEDED_LIBS
}

_msg_list() {
  local prefix="$1"
  shift

  local part
  for part; do
    msg "$prefix '$part'"
  done
}

step_pkg() {
  local pkg=$_REPO/${PKG_QUALIFIED_NAME}$PKG_EXT

  progress pkg "'$PKG_NAME'"

  local libs="$PKG_LIB"
  [ "$libs" ] || libs="$(_provided_libs)"
  _msg_list 'Provided lib:' $libs

  local deps="$PKG_RDEP $(_lib_deps)"
  _msg_list 'Run-time dep:' $deps

  pkg-create \
    -p $_DEST/$PKG_QUALIFIED_NAME \
    -o $pkg \
    -l "$libs" \
    -d "$deps" \
    $PKG_QUALIFIED_NAME

  local stat="$(xz -l $pkg | tail -n1)"
  msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
  msg "Compressed:   $(_xz_stat "$stat" 3 4)"
}
