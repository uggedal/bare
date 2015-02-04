step_build() {
  progress build "'$name' using $style"

  local ocwd=$(pwd)
  cd $MK_BUILD
  run_style $style build
  cd $ocwd
}
