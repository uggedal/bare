_extract() {
	local d=$1
	local flag arg

	case $(distfile $d) in
	*.tar.gz)
		flag=z
		;;
	*.tar.bz2)
		flag=j
		;;
	*.tar.xz)
		flag=J
		;;
	*.diff|*.patch)
		return 0
		;;
	*)
		die "unsupported archive '$(distfile $d)'"
		;;
	esac

	if [ "$MK_CONTAINED" ]; then
		arg=--no-same-owner
	fi

	tar $arg -C $MK_BUILD_ROOT -x${flag}f $(distpath $d)
}

step_extract() {
	if [ "$(command -v do_extract)" ]; then
		do_extract
		return 0
	fi

	[ "$PKG_DIST" ] || {
		return 0
	}

	[ -d $_BUILD ] || die "no build directory in '$_BUILD'"

	foreach _extract $PKG_DIST
}
