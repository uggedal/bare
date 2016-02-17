step_deppkg() {
	progress deppkg "'$PKG_NAME'"
	msglist 'Bdep:' $PKG_BDEP

	[ -z "$MK_NO_DEP" ] || return 0

	local dep
	for dep in $PKG_BDEP $PKG_RDEP; do
		if [ "$MK_FORCE" -a "$MK_RECURSIVE" ] || ! pkg_in_repo $_REPO $dep; then
			./mk $MK_FLAGS pkg $(sub_to_main $dep)
		fi
	done
}
