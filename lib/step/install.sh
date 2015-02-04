step_install() {
  progress install "'$name' using $style"

  local ocwd=$(pwd)
  cd $MK_BUILD
  run_style $style install
  cd $ocwd
}
