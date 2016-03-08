_validate_name() {
	local name=$1
	[ "${#name}" -le $PKG_NAME_MAX ] ||
		die "name is longer than $PKG_NAME_MAX (${#name})"
}

_validate_confict() {
	local name=$1
	local ver=$2
	local epoc=$3

	case $name in
	$_PKG_NAME|$PKG_NAME)
		return 0
		;;
	esac

	# TODO: reimplement
}

_validate_conflicts() {
	local name=$1
	local dest=$2

	[ -d "$dest" ] || return 0

	_PKG_NAME=$name
	_VALIDATE_FL="$(find $dest -type f -o -type l | sed "s|^$MK_DESTDIR/||")"

	read_repo _validate_confict

	unset _PKG_NAME
	unset _VALIDATE_FL
}

_validate() {
	local name=$1
	local dest=$2

	_validate_name $name
	_validate_conflicts $name $dest
}

_validate_sub() {
	local name=$1
	local qualified_name=${name}_${PKG_VER}_$PKG_EPOC
	local dest=$_DEST/$qualified_name
	
	_validate $name $dest
}

step_validate() {
	foreach _validate_sub $PKG_SUB

	_validate $PKG_NAME $MK_DESTDIR
}
