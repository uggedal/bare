cmd_sum() {
	assert_distfiles

	progress sum "using '$(distfiles $PKG_DIST)'"

	sha512sum $(merge $(foreach relative $(distpaths $PKG_DIST))) > \
		$_SUM/${PKG_NAME}.sum
}
