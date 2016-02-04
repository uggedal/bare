pkg_to_qualified_name() {
	local pkg=$1

	printf '%s' ${pkg%$PKG_EXT*}
}

pkg_to_name() {
	local pkg=$1

	printf '%s' ${pkg%-*}
}

pkg_to_version() {
	local pkg=$1
	local qualified_name=$(pkg_to_qualified_name $pkg)

	printf '%s' ${qualified_name##*-}
}

pkg_db() {
	local prefix=$1
	local name=$2
	local type=$3

	[ -z "$type" ] || type=$type/

	printf '%s' ${prefix%/}/$PKG_DB/$type$name
}

pkg_installed() {
	local prefix=$1
	local name=$2

	[ -f $(pkg_db $prefix $name) ]
}

read_repo() {
	local repo=$1
	local cb=$2

	[ -d $repo ] || die "unable to read repo: '$REPO'"

	local f p
	for f in $repo/*$PKG_EXT; do
		case $f in
			$repo/\*$PKG_EXT)
				return 0
				;;
		esac

		p=$(basename $f)
		$cb $(pkg_to_name $p) $(pkg_to_version $p) $(pkg_to_qualified_name $p) $p
	done
}

read_db() {
	local prefix=$1
	local name=$2
	local cb=$3
	local db=$(pkg_db $prefix $name)

	[ -f $db ] || die "unable to read '$name' ($db)"

	local t f1 f2
	while IFS='|' read -r t f1 f2; do
		$cb $t $f1 $f2
	done < $db
}

_pkg_in_repo_check() {
	local name=$1

	[ "$_PKG_NAME" = "$name" ] || return 0

	_HAS_PKG_IN_REPO=yes
}

pkg_in_repo() {
	local repo=$1
	_PKG_NAME=$2

	read_repo $repo _pkg_in_repo_check

	local has_pkg="$_HAS_PKG_IN_REPO"
	unset _PKG_NAME _HAS_PKG_IN_REPO

	[ "$has_pkg" ]
}

file_sum() {
	local f=$1

	sha512sum $f | cut -d' ' -f1
}

check_sum() {
	local f=$1
	local sum=$2

	[ $(file_sum $f) = $sum ]
}

dir_merge() {
	local src=$1
	local dst=$2

	(
		cd $src

		set -- *
		[ "$1" != \* ] || die "no files in '$src'"

		for f; do
			if ! [ -e $dst/$f ]; then
				mv $src/$f $dst/$f
				continue
			fi

			if [ -d $src/$f ]; then
				dir_merge $src/$f $dst/$f
				continue
			fi

			die "file already exist: '$dst/$f'"
		done
	)
}
