step_extract() {
  local pkgarchive=$(get_archive)
  local archive=${pkgarchive##*/}

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
