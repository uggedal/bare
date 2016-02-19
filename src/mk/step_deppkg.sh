step_deppkg() {
	[ -z "$MK_NO_DEP" ] || return 0

	local dep
	for dep in $PKG_BDEP $PKG_RDEP; do
		pkg_in_repo $_REPO $dep ||
		    ./mk $MK_FLAGS pkg $(sub_to_main $dep)
	done
}
