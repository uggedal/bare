ver 1.23.2
dist http://${PKG_NAME}.net/downloads/$PKG_NAME-${PKG_VER}.tar.bz2

pre_build() {
	make allnoconfig KCONFIG_ALLCONFIG=$MK_FILE/config
}

do_install() {
	make CONFIG_PREFIX=$MK_DESTDIR install
}
