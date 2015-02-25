step_build() {
  progress build "'$name' using $style"

  (
    cd $MK_BUILD
    run_style $style build
  )
}
