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

	${TAR:-tar} -C $MK_BUILD_ROOT -x${arg}f $(distpath $d)
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
