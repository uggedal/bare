step_extract() {
  local pkgarchive=$(distfile)
  local archive=${pkgarchive##*/}

  if [ "$(command -v do_extract)" ]; then
    do_extract
    return 0
  fi

  [ "$src" ] || return 0

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  progress extract "'$name' using '$archive'"

  local fmt
  case $pkgarchive in
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
      die "unsupported archive '$archive'"
      ;;
  esac

  tar -C $MK_BUILD_ROOT -x${fmt}f $pkgarchive
}
