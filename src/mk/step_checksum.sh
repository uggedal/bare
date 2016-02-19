_checksum() {
	sha512sum $(merge $(foreach relative $(distpaths $PKG_DIST)))
}

step_checksum() {
	local f=$_SUM/${PKG_PARENT_NAME}.sum

	[ "$PKG_DIST" ] || return 0

	assert_distfiles

	[ "$(_checksum)" = "$(cat $f)" ] ||
	    die "invalid checksum for '$PKG_NAME' ($(distfiles $PKG_DIST))"
}
