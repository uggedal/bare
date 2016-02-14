_xz_stat() {
	printf '%s' "$1" | awk "{ print \$$2 \" \" \$$3 }"
}

_provided_libs() {
	local dest=$1
	local libdir=$dest$MK_PREFIX/lib
	local f mime

	[ -d $libdir ] || return 0

	find $libdir -type f | while read f; do
		mime="$(file -bi "$f")"
		case "$mime" in
		application/x-sharedlib*)
			objdump -p $f | awk '/^ +SONAME/ { print $2 }'
			;;
		esac
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

_find_lib_in_db() {
	local t=$1
	local f1=$2

	[ "$_NEEDED_LIB" != "$f1" ] || printf '%s:%s\n' $_LIB_PKG_NAME $_NEEDED_LIB
}

_find_pkg_with_lib() {
	local name=$1
	local ver=$2
	local qualified_name=$3
	local pkg=$4

	[ $name != $_PKG_NAME ] || return 0

	_LIB_PKG_NAME=$name
	read_db $_DB $name _find_lib_in_db
	unset _LIB_PKG_NAME
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

		lib_dep=$(read_repo $_REPO _find_pkg_with_lib)

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

	local pkg=$_REPO/${qualified_name}$PKG_EXT

	progress pkg "'$name'"

	[ "$libs" ] || libs="$(_provided_libs $dest)"
	msglist 'Provided lib:' $libs

	deps="$deps $(_lib_deps $name $dest "$libs")"
	msglist 'Run-time dep:' $deps

	pkg-create \
		-p $dest \
		-o $pkg \
		-l "$libs" \
		-d "$deps" \
		$qualified_name

	local stat="$(xz -l $pkg | tail -n1)"
	msg "Uncompressed: $(_xz_stat "$stat" 5 6)"
	msg "Compressed:	 $(_xz_stat "$stat" 3 4)"

	extract_db_file $name $PKG_VER $qualified_name ${qualified_name}$PKG_EXT
}

_pkg_sub() {
	local name=$1
	local qualified_name=$name-${PKG_VER}_$PKG_REV
	local dest=$_DEST/$qualified_name

	local lib="$(get_sub_var $name lib)"
	local rdep="$(get_sub_var $name rdep)"

	_pkg \
		$name \
		$qualified_name \
		$dest \
		"$lib" \
		"$rdep"

	step_db
}

step_pkg() {
	foreach _pkg_sub $PKG_SUB

	_pkg \
		$PKG_NAME \
		$PKG_QUALIFIED_NAME \
		$MK_DESTDIR \
		"$PKG_LIB" \
		"$PKG_RDEP"
}
