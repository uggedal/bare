ver=0.5.1
rev=1
src=http://landley.net/$parentname/downloads/$parentname-${ver}.tar.bz2

style=make

pre_build() {
  cp $MK_FILE/config .config
}

do_install() {
  PREFIX=$MK_DESTDIR make install
}
