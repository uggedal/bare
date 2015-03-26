step_install() {
  progress install "'$PKG_NAME' using $PKG_STYLE"

  [ -z "$MK_DESTDIR" ] || mkdir -p $MK_DESTDIR

  (
    cd $MK_BUILD
    run_style $PKG_STYLE install
  )
}
