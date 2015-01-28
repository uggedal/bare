cmd_build() {
  local func
  local pkgbuild=$_BUILD/$fullname

  cmd_extract

  local ocwd=$(pwd)
  cd $pkgbuild/$name-$ver
  run_style $style build
  cd $ocwd
}
