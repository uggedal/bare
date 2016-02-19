remove_libtool_archives() {
	local dest=$1
	local f

	find $dest -type f -name \*.la | while read f; do
		msg "remove libtool archive: $(relative $f $dest)"
		rm $f
	done
}

remove_below() {
	local dest=$1
	local dir=$2
	local desc="$3"

	local f

	[ -d $dest$MK_PREFIX/$dir ] || return 0

	find $dest$MK_PREFIX/$dir -type f | while read f; do
		msg "remove $desc: $(relative $f $dest)"
		rm $f
	done
}

remove_empty_dirs() {
	local dest=$1
	local d

	find $dest -depth -type d | while read d; do
		[ "$dest" != "$d" ] || continue

		if rmdir $d 2>/dev/null; then
			msg "remove empty dir: $(relative $d $dest)"
		fi
	done
}

strip_binaries() {
	local dest=$1
	local f mime type args

	find $dest -type f | while read f; do
		mime="$(file -bi "$f")"
		type=
		args=
		case "$mime" in
		application/x-executable*)
			type=executable
			;;
		application/x-sharedlib*)
			type='shared lib'
			args=--strip-unneeded
			;;
		application/x-archive*)
			type='static lib'
			args=--strip-debug
			;;
		esac

		if [ "$type" ]; then
			msg "strip $type: $(relative $f $dest)"
			${STRIP:-strip} $args $f
		fi
	done
}

_optimize() {
	local name=$1
	local dest=$2

	progress optimize "'$name'"

	{
		remove_libtool_archives $dest
		remove_below $dest share/info 'info page'
		remove_below $dest share/doc doc
		remove_below $dest share/examples examples
		strip_binaries $dest
		[ "$PKG_EMPTYDIRS" = keep ] || remove_empty_dirs $dest
	} >&3 2>&3
}

_optimize_sub() {
	local name=$1
	local qualified_name=$name-${PKG_VER}_$PKG_REV
	local dest=$_DEST/$qualified_name

	_optimize $name $dest
}

step_optimize() {
	foreach _optimize_sub $PKG_SUB

	_optimize $PKG_NAME $MK_DESTDIR
}
