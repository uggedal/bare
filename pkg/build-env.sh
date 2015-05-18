ver 0.0.1
rev 1

rdep \
  hier \
  sbase \
  ubase \
  busybox \
  ksh \
  ed \
  awk \
  pax \
  bzip2 \
  xz \
  pkg \
  binutils \
  gcc \
  make \
  file

builddir .

do_install() {
  mkdir -p $MK_DESTDIR
}
