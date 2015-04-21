_extract() {
  local d=$1
  local cmd

  case $(distfile $d) in
    *.tar.gz)
      cmd=gunzip
      ;;
    *.tar.bz2)
      cmd=bunzip2
      ;;
    *.tar.xz)
      cmd=xzdec
      ;;
    *.diff|*.patch)
      return 0
      ;;
    *)
      die "unsupported archive '$(distfile $d)'"
      ;;
  esac

  progress extract "'$PKG_NAME' using '$(distfile $d)'"

  $cmd -c $(distpath $d) | tar -C $MK_BUILD_ROOT -x
}

step_extract() {
  if [ "$(command -v do_extract)" ]; then
    do_extract
    return 0
  fi

  [ "$PKG_DIST" ] || return 0

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  foreach _extract $PKG_DIST
}
