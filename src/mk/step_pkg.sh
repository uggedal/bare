_xz_stat() {
	printf '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

_provided_libs() {
	local dest=$1
	local d f mime

	for d in $dest$MK_PREFIX/lib $dest/lib; do
		[ -d $d ] || continue
		find $d -type f | while read f; do
			mime="$(file -bi "$f")"
			case "$mime" in
			application/x-sharedlib*)
				objdump -p $f | awk '/^ +SONAME/ { print $2 }'
				;;
			esac
		done
	done

}

_needed_libs() {
	local dest=$1
	local f mime

	[ -d $dest ] || return 0

	find $dest -type f | while read f; do
		mime="$(file -bi "$f")"
		case "$mime" in
		application/x-executable*|application/x-sharedlib*)
			objdump -p $f | awk '/^ +NEEDED/ { print $2 }'
			;;
		esac
	done
}

_find_pkg_with_lib() {
	local name=$1
	local ver=$2
	local epoc=$3
	local lib="$4"

	[ $name != $_PKG_NAME ] || return 0

	local l
	for l in $lib; do
		if [ "$_NEEDED_LIB" = "$l" ]; then
			printf '%s:%s\n' $name $l
		fi
	done
}

_lib_deps() {
	local name=$1
	local dest=$2
	local needed_libs provided_libs provided_lib lib_dep
	provided_libs="$3"

	needed_libs=$(_needed_libs $dest | sort | uniq)
	_PKG_NAME=$name

	for _NEEDED_LIB in $needed_libs; do
		# No need checking for libraries internal to the pkg:
		for provided_lib in $provided_libs; do
			[ "$provided_lib" != "$_NEEDED_LIB" ] || continue 2
		done

		lib_dep=$(read_repo _find_pkg_with_lib)

		[ "$lib_dep" ] ||
			die "unable to find package providing '$_NEEDED_LIB'"

		printf '%s\n' $lib_dep
	done

	unset _PKG_NAME _NEEDED_LIB
}

_pkg() {
	local name=$1
	local qualified_name=$2
	local dest=$3
	local libs="$4"
	local deps="$5"
	local pkg=${qualified_name}$PKG_EXT

	msg "packaging $name"

	[ "$libs" ] || libs="$(_provided_libs $dest)"
	msglist 'provided lib:' $libs

	deps="$deps $(_lib_deps $name $dest "$libs")"
	msglist 'run-time dep:' $deps

	REPO=$_REPO pkg -cv \
		$pkg \
		"$(csv $libs)" \
		"$(csv $deps)" \
		$dest

	local stat="$(xz -l $_REPO/$pkg | tail -n1)"
	msg "uncompressed: $(_xz_stat "$stat" 5 6)"
	msg "compressed: $(_xz_stat "$stat" 3 4)"
}

_pkg_sub() {
	local name=$1

	local pkgorder="$(get_sub_var $name pkgorder)"

	if [ -z "$pkgorder" ] && [ "$_BUILD_STEP" = after_main ]; then
		return 0
	fi

	if [ "$pkgorder" ] && [ "$_BUILD_STEP" != "$pkgorder" ]; then
		return 0
	fi

	local qualified_name=${name}_${PKG_VER}_${PKG_EPOC}
	local dest=$_DEST/$qualified_name
	local lib="$(get_sub_var $name lib)"
	local rdep="$(get_sub_var $name rdep)"

	_pkg \
		$name \
		$qualified_name \
		$dest \
		"$lib" \
		"$rdep"
}

step_pkg() {
	_BUILD_STEP=before_main
	foreach _pkg_sub $PKG_SUB

	_pkg \
		$PKG_NAME \
		$PKG_QUALIFIED_NAME \
		$MK_DESTDIR \
		"$PKG_LIB" \
		"$PKG_RDEP"

	_BUILD_STEP=after_main
	foreach _pkg_sub $PKG_SUB

	unset _AFTER_MAIN
}
