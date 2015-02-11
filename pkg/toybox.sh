ver=0.5.1
rev=1
src=http://landley.net/$name/downloads/$name-${ver}.tar.bz2

bdep=linux-headers

style=make

pre_build() {
  cp $MK_FILE/config .config
}

do_build() {
  make CC=$CC HOSTCC=$CC -j $MK_NPROC
}

do_install() {
  PREFIX=$MK_DESTDIR make install
}
