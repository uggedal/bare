step_build() {
  progress build "'$PKG_NAME' using $PKG_STYLE"

  (
    cd $MK_BUILD
    run_style $PKG_STYLE build
  )
}
