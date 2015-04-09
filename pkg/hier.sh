ver 0.0.1
rev 1

builddir .
emptydirs keep

do_install() {
  local d

  for d in dev etc proc sys tmp; do
    mkdir -p $MK_DESTDIR/$d
  done
}
