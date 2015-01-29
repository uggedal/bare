step_extract() {
  local pkgbuild=$_BUILD/$fullname
  local pkgarchive=$(get_archive $src $fullname)
  local archive=${pkgarchive##*/}

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  progress extract "'$name' using '$archive'"

  mkdir -p $pkgbuild

  local args
  case $pkgarchive in
    *.tar.bz2)
      args=j
      ;;
    *)
      die "unsupported archive '$archive'"
      ;;
  esac

  tar -C $pkgbuild -x${args}f $pkgarchive
}
