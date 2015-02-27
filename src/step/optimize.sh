_rootify() {
  printf -- '%s' ${1#$_DEST/$fullname}
}

remove_libtool_archives() {
  local f

  find $_DEST/$fullname -type f -name \*.la | while read f; do
    msg "remove libtool archive: $(_rootify $f)"
    rm $f
  done
}

remve_info_pages() {
  local f

  find $_DEST/$fullname$MK_PREFIX/share/info -type f | while read f; do
    msg "remove info page: $(_rootify $f)"
    rm $f
  done
}

strip_binaries() {
  local f type args

  find $_DEST/$fullname -type f | while read f; do
    type=
    args=
    case "$(file -bi "$f")" in
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

  progress optmimize "'$name'"

  remove_libtool_archives
  remve_info_pages
  strip_binaries
}
