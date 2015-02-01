ver=0.5.1
rev=1
src=http://landley.net/$name/downloads/$name-${ver}.tar.bz2

style=make

pre_build() {
  # TODO: save config and maybe stip it
  make defconfig
}

do_install() {
  PREFIX=$MK_DESTDIR make install
}
