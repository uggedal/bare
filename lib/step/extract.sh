step_extract() {
  local pkgarchive=$(get_archive $src $fullname)
  local archive=${pkgarchive##*/}

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  progress extract "'$name' using '$archive'"

  local args
  case $pkgarchive in
    *.tar.gz)
      args=x
      ;;
    *.tar.bz2)
      args=j
      ;;
    *.tar.xz)
      args=J
      ;;
    *)
      die "unsupported archive '$archive'"
      ;;
  esac

  tar -C $MK_BUILD_ROOT -x${args}f $pkgarchive
}
