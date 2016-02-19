_validate_name() {
	local name=$1
	[ "${#name}" -le $PKG_NAME_MAX ] ||
		die "name is longer than $PKG_NAME_MAX (${#name})"
}

_find_conflict_in_db() {
	local t=$1
	local f1=$2
	local f

	case $t in
	@|f)
		for f in $_VALIDATE_FL; do
			[ "$f" != "$f1" ] ||
				die "conflicting file in '$_CONFLICT_PKG_NAME' ($f)"
		done
		;;
	esac
}

_validate_confict() {
	local name=$1
	local ver=$2
	local qualified_name=$3
	local pkg=$4

	case $name in
	$_PKG_NAME|$PKG_NAME)
		return 0
		;;
	esac

	_CONFLICT_PKG_NAME=$name
	read_db $_DB $name _find_conflict_in_db
	unset _CONFLICT_PKG_NAME
}

_validate_conflicts() {
	local name=$1
	local dest=$2

	[ -d "$dest" ] || return 0

	_PKG_NAME=$name
	_VALIDATE_FL="$(find $dest -type f -o -type l | sed "s|^$MK_DESTDIR/||")"

	read_repo $_REPO _validate_confict

	unset _PKG_NAME
	unset _VALIDATE_FL
}

_validate() {
	local name=$1
	local dest=$2

	progress validate

	{
		_validate_name $name
		_validate_conflicts $name $dest
	} >&3 2>&3
}

_validate_sub() {
	local name=$1
	local qualified_name=$name-${PKG_VER}_$PKG_REV
	local dest=$_DEST/$qualified_name
	
	_validate $name $dest
}

step_validate() {
	foreach _validate_sub $PKG_SUB

	_validate $PKG_NAME $MK_DESTDIR
}
