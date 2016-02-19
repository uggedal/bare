_submv() {
	local dest=$1
	local files="$2"
	local maindest=$MK_DESTDIR

	(
		cd $maindest

		local f dir
		for f in $files; do
			case $f in
			*\**)
				continue
				;;
			esac

			if [ ! -e $f ] && [ ! -h $f ]; then
				continue
			fi

			dir=$(dirname $(relative $f $maindest))
			mkdir -p $dest/$dir
			mv $f $dest/$dir
		done
	)
}

_split_lib() {
	local name=$1
	local dest=$2
	local prefix=$(relative .$MK_PREFIX .)

	_submv $dest $prefix/lib/\*.so.\*
}

_split_bld() {
	local name=$1
	local dest=$2
	local prefix=$(relative .$MK_PREFIX .)

	_submv $dest $prefix/lib/\*.a
	_submv $dest $prefix/lib/\*.so
	_submv $dest $prefix/include
	_submv $dest $(relative .$MK_MANDIR .)'/man[23]'
	_submv $dest $prefix/lib/pkgconfig
}

_split_custom() {
	local name=$1
	local dest=$2
	local mv="$(get_sub_var $name mv)"

	[ -z "$mv" ] || _submv $dest "$mv"
}

_create_sub() {
	local name=$1
	local qualified_name=$name-${PKG_VER}_$PKG_REV
	local type=$(get_sub_var $name type)
	local dest=$_DEST/$qualified_name

	mkdir -p $dest

	case $type in
	lib|bld)
		_split_$type $name $dest
		;;
	esac
	_split_custom $name $dest
}

step_sub() {
	progress sub
	msglist 'subpackage:' $PKG_SUB
	foreach _create_sub $PKG_SUB
}
