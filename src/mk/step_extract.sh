_extract() {
	local d=$1
	local arg

	case $(distfile $d) in
	*.tar.gz)
		arg=z
		;;
	*.tar.bz2)
		arg=j
		;;
	*.tar.xz)
		arg=J
		;;
	*.diff|*.patch)
		return 0
		;;
	*)
		die "unsupported archive '$(distfile $d)'"
		;;
	esac

	progress extract "'$PKG_NAME' using '$(distfile $d)'"

	${TAR:-tar} -C $MK_BUILD_ROOT -x${arg}f $(distpath $d) >&3 2>&3
}

step_extract() {
	if [ "$(command -v do_extract)" ]; then
		progress extract "'$PKG_NAME' using 'do_extract'"
		do_extract
		return 0
	fi

	[ "$PKG_DIST" ] || {
		progress extract "'$PKG_NAME' no dist"
		return 0
	}

	[ -d $_BUILD ] || die "no build directory in '$_BUILD'"

	foreach _extract $PKG_DIST
}
