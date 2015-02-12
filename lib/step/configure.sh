step_configure() {
  progress configure "'$name' using $style"

  (
    cd $MK_BUILD
    run_style $style configure
  )
}
