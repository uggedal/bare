step_build() {
  local func
  local pkgbuild=$_BUILD/$fullname

  step_extract

  progress build "'$name' using $style"

  local ocwd=$(pwd)
  cd $pkgbuild/$name-$ver
  run_style $style build
  cd $ocwd
}
