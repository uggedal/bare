_cur_qual_name() {
	local qual_name=$1

	$_ROOT/mk query $(pkg_to_name $qual_name) qualified_name
}

_clean_obsolete_dist() {
	[ -d $_DIST ] || return 0

	local qual_name

	for dir in $_DIST/*; do
		[ -d "$dir" ] || continue

		qual_name=$(basename $dir)

		[ "$qual_name" = "$(_cur_qual_name $qual_name)" ] || rm -r $dir
	done
}

_clean_contain() {
	if use_contain; then
		rm -rf $_CONTAIN
	fi
}

_sub_dest_dirs() {
	local name
	for name in $PKG_SUB; do
		printf '%s ' $_DEST/${name}_${PKG_VER}_$PKG_EPOC
	done
}

cmd_clean() {
	local dirs="$_BUILD $_DEST $_CACHE"
	local dir

	if [ "$PKG_NAME" ]; then
		dirs="$MK_BUILD_ROOT $MK_DESTDIR $(_sub_dest_dirs)"
	else
		_clean_obsolete_dist

		if [ "$MK_FORCE" ]; then
			dirs="
			    $dirs
			    $_BOOTSTRAP_CROSS
			    $_BOOTSTRAP_NATIVE
			    $_BOOTSTRAP_SUPPORT
			    $_CONTAIN
			    $_CACHE
			    $_LOG
			    $_REPO
			"
		else
			_clean_contain
		fi
	fi

	for dir in $dirs; do
		rm -rf $dir
	done
}
