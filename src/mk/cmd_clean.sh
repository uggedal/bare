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

_clean_db() {
	rm -f $_DB/$PKG_DB/*
}

_clean_contain() {
	if use_contain; then
		rm -rf $_CONTAIN
	fi
}

_clean_cache() {
	local name=$1
	local dep

	[ -d $_CACE/$PKG_DB ] || return 0

	if [ "$name" ]; then
		REPO=$_ROOT/repo $(pkgpath tree) -p $_CACHE base-bld |
			awk '{ print $1 }' | sort | uniq | while read dep; do

			if [ "$name" = "$(sub_to_main $dep)" ]; then
				rm -rf $_CACHE
				break
			fi
		done
	else
		rm -rf $_CACHE
	fi
}

_sub_dest_dirs() {
	local name
	for name in $PKG_SUB; do
		printf '%s ' $_DEST/$name-${PKG_VER}_$PKG_REV
	done
}

cmd_clean() {
	local dirs="$_BUILD $_DEST"
	local dir

	if [ "$PKG_NAME" ]; then
		dirs="$MK_BUILD_ROOT $MK_DESTDIR $(_sub_dest_dirs)"
		progress clean "'$PKG_NAME'"
		_clean_cache $PKG_NAME
	else
		progress clean "all"
		_clean_obsolete_dist

		if [ "$MK_FORCE" ]; then
			dirs="
			    $dirs
			    $_BOOTSTRAP_CROSS
			    $_BOOTSTRAP_NATIVE
			    $_BOOTSTRAP_SUPPORT
			    $_CONTAIN
			    $_CACHE
			    $_REPO
			"
		else
			_clean_contain
			_clean_cache
		fi
	fi
	_clean_db

	for dir in $dirs; do
		rm -rf $dir
	done
}
