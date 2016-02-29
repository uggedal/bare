kconfig_default_configure() {
	yes '' | make oldconfig
}

kconfig_default_build() {
	msg "Build procs: '$MK_NPROC'"
	make -j $MK_NPROC
}

kconfig_default_install() {
	local targets=install

	if grep -q '=m$' .config; then
		targets="modules_install $targets"
	fi

	mkdir -p $MK_DESTDIR/boot
	make $targets \
		INSTALL_PATH=$MK_DESTDIR/boot \
		INSTALL_MOD_PATH=$MK_DESTDIR
}
