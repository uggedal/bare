step_install() {
  progress install "'$name' using $style"

  [ -z "$MK_DESTDIR" ] || mkdir -p $MK_DESTDIR

  (
    cd $MK_BUILD
    run_style $style install
  )
}
