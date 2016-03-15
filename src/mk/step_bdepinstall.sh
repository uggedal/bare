step_bdepinstall() {
	[ -z "$MK_NO_DEP" ] || return 0

	[ -z "$PKG_BDEP" ] ||
	    contain $_CONTAIN /bin/sh -lc "pkg -i $PKG_BDEP"
}
