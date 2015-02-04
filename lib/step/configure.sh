step_configure() {
  progress configure "'$name' using $style"

  local ocwd=$(pwd)
  cd $MK_BUILD
  run_style $style configure
  cd $ocwd
}
