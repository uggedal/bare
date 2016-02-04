_filter_patch() {
	case $1 in
		*.diff|*.patch)
			printf '%s\n' $1
			;;
	esac
}

_patch() {
	local p=$1

	progress patch "'$PKG_NAME' using '${p##*/}'"
	(
		cd $MK_DIST
		patch ${PKG_PATCHFLAG:-'-p1'} < $p
	)
}

step_patch() {
	local p
	local haspatch

	if [ -d $MK_PATCH ]; then
		for p in $MK_PATCH/*.patch; do
			_patch $p
			haspatch=yes
		done
	fi

	for p in $(foreach _filter_patch $(distpaths $PKG_DIST)); do
		_patch $p
		haspatch=yes
	done

	[ "$haspatch" ] || progress patch "'$PKG_NAME' no patch"
}
