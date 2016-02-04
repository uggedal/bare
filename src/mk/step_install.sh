step_install() {
	[ -z "$MK_DESTDIR" ] || mkdir -p $MK_DESTDIR

	(
		cd $MK_BUILD
		run_style install
	)
}
