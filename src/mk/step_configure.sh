step_configure() {
  progress configure "'$PKG_NAME' using $PKG_STYLE"

  (
    cd $MK_BUILD
    run_style $PKG_STYLE configure
  )
}
