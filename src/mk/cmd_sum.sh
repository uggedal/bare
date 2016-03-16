cmd_sum() {
	[ "$PKG_DIST" ] || return 0
	assert_distfiles

	sha512sum $(merge $(foreach relative $(distpaths $PKG_DIST))) > \
		$_SUM/${PKG_NAME}.sum
}
