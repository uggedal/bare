cmd_sum() {
	assert_distfiles

	sha512sum $(merge $(foreach relative $(distpaths $PKG_DIST))) > \
		$_SUM/${PKG_NAME}.sum
}
