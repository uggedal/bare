ver=0.0.1
rev=1

style=noop
builddir=.
emptydirs=keep

do_install() {
  local d

  for d in dev proc sys; do
    mkdir -p $MK_DESTDIR/$d
  done
}
