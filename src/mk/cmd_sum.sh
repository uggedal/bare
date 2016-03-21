cmd_sum() {
	[ "$PKG_DIST" ] || return 0
	assert_distfiles

	(
		cd $_DIST/$PKG_QUALIFIED_PARENT_NAME
		sha512sum $(merge $(foreach basename $(distpaths $PKG_DIST))) > \
		    $_SUM/${PKG_NAME}.sum
	)
}
