step_install() {
  local func
  local pkgbuild=$_BUILD/$fullname
  local pkgdest=$_DEST/$fullname

  progress install "'$name' using $style"

  local ocwd=$(pwd)
  cd $pkgbuild/$name-$ver
  run_style $style install
  cd $ocwd
}
