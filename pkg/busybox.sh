ver=1.23.1
rev=1
src=http://${parentname}.net/downloads/$parentname-${ver}.tar.bz2

style=make

pre_build() {
  make allnoconfig KCONFIG_ALLCONFIG=$MK_FILE/config
}

do_install() {
  make CONFIG_PREFIX=$MK_DESTDIR install
}
