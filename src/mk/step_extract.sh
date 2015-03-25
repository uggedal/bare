step_extract() {
  if [ "$(command -v do_extract)" ]; then
    do_extract
    return 0
  fi

  [ "$src" ] || return 0

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  progress extract "'$name' using '$(distfile)'"

  local fmt
  case $(distpath) in
    *.tar.gz)
      fmt=z
      ;;
    *.tar.bz2)
      fmt=j
      ;;
    *.tar.xz)
      fmt=J
      ;;
    *)
      die "unsupported archive '$(distfile)'"
      ;;
  esac

  tar -C $MK_BUILD_ROOT -x${fmt}f $(distpath)
}
