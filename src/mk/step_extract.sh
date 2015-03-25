_extract() {
  local d=$1
  local fmt

  case $(distfile $d) in
    *.tar.gz)
      fmt=z
      ;;
    *.tar.bz2)
      fmt=j
      ;;
    *.tar.xz)
      fmt=J
      ;;
    *.diff|*.patch)
      return 0
      ;;
    *)
      die "unsupported archive '$(distfile $d)'"
      ;;
  esac

  progress extract "'$name' using '$(distfile $d)'"

  tar -C $MK_BUILD_ROOT -x${fmt}f $(distpath $d)
}

step_extract() {
  if [ "$(command -v do_extract)" ]; then
    do_extract
    return 0
  fi

  [ "$dist" ] || return 0

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  foreach _extract $dist
}
