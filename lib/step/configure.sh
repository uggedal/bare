step_configure() {
  local func
  local pkgbuild=$_BUILD/$fullname

  progress configure "'$name' using $style"

  local ocwd=$(pwd)
  cd $pkgbuild/$name-$ver
  run_style $style configure
  cd $ocwd
}
