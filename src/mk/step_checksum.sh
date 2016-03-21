_checksum() {
	(
		cd $_DIST/$PKG_QUALIFIED_PARENT_NAME
		sha512sum $(merge $(foreach basename $(distpaths $PKG_DIST)))
	)
}

step_checksum() {
	local f=$_SUM/${PKG_PARENT_NAME}.sum

	[ "$PKG_DIST" ] || return 0

	assert_distfiles

	[ "$(_checksum)" = "$(cat $f)" ] ||
	    die "invalid checksum for '$PKG_NAME' ($(distfiles $PKG_DIST))"
}
