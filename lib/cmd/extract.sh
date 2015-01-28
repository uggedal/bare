cmd_extract() {
  local pkgbuild=$_BUILD/$fullname
  local pkgarchive=$(get_archive $src $fullname)

  [ -d $_BUILD ] || die "no build directory in '$_BUILD'"

  cmd_verify

  mkdir -p $pkgbuild

  local args
  case $pkgarchive in
    *.tar.bz2)
      args=j
      ;;
    *)
      die "unsupported archive '${pkgarchive##*/}'"
      ;;
  esac

  ( cd $pkgbuild && tar -x${args}f $pkgarchive )
}
