_rootify() {
  printf -- '%s' ${1#$_DEST/$PKG_FULLNAME}
}

remove_libtool_archives() {
  local f

  find $_DEST/$PKG_FULLNAME -type f -name \*.la | while read f; do
    msg "remove libtool archive: $(_rootify $f)"
    rm $f
  done
}

remove_below() {
  local dir=$1
  local desc="$2"

  local f

  [ -d $_DEST/$PKG_FULLNAME$MK_PREFIX/$dir ] || return 0

  find $_DEST/$PKG_FULLNAME$MK_PREFIX/$dir -type f | while read f; do
    msg "remove $desc: $(_rootify $f)"
    rm $f
  done
}

remove_empty_dirs() {
  local d

  find $_DEST/$PKG_FULLNAME -depth -type d | while read d; do
    if rmdir $d 2>/dev/null; then
      msg "remove empty dir: $(_rootify $d)"
    fi
  done
}

strip_binaries() {
  local f mime type args

  find $_DEST/$PKG_FULLNAME -type f | while read f; do
    mime="$(file -bi "$f")"
    type=
    args=
    case "$mime" in
      application/x-executable*)
        type=executable
        ;;
      application/x-sharedlib*)
        type='shared lib'
        args=--strip-unneeded
        ;;
      application/x-archive*)
        type='static lib'
        args=--strip-debug
        ;;
    esac

    if [ "$type" ]; then
      msg "strip $type: $(_rootify $f)"
      ${STRIP:-strip} $args $f
    fi
  done
}

step_optimize() {
  local f

  progress optmimize "'$PKG_NAME'"

  remove_libtool_archives
  remove_below share/info 'info page'
  remove_below share/doc doc
  strip_binaries
  [ "$emptydirs" = keep ] || remove_empty_dirs
}
