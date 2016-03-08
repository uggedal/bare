uppercase() {
	printf '%s' "$@" | tr a-z A-Z
}

undercase() {
	printf '%s' "$@" | tr /.- _
}

relative() {
	local f=$1
	local from=$2
	: ${from:=$(pwd)}

	printf '%s\n' ${f#$from/*}
}

merge() {
	local part res

	for part; do
		res="$res $part"
	done

	printf '%s' "${res# *}"
}

foreach() {
	local func=$1
	local part
	shift

	for part; do
		eval $func \$part
	done
}

msg() {
	printf '%s\n' "$@"
}

msglist() {
	local prefix="$1"
	shift

	local part
	for part; do
		printf '%s %s\n' "$prefix" $part
	done
}

err() {
	msg "error: $@" >&2
}

die() {
	err "$@"
	exit 1
}

dump() {
	local w
	for w; do
		printf '%-4s%s\n' '' $w
	done
}

csv() {
	local v
	local ret
	for v; do
		ret="$ret,$v"
	done

	printf '%s' "${ret#,*}"
}

uncvs() {
	printf '%s' "$1" | sed 's/,/ /'
}

pkg_to_qualified_name() {
	local pkg=$1

	printf '%s' ${pkg%$PKG_EXT*}
}

pkg_to_name() {
	local pkg=$1

	printf '%s' ${pkg%%_*}
}

pkg_to_version() {
	local qualified_name=$(pkg_to_qualified_name $1)
	local tmp=${qualified_name#*_}

	printf '%s' ${tmp%_*}
}

pkg_to_epoc() {
	local qualified_name=$(pkg_to_qualified_name $1)

	printf '%s' ${qualified_name##*_}
}

read_repo() {
	local cb=$1

	[ -f $_REPO/INDEX ] || return 0

	local p raw_lib raw_dep sum
	while IFS='|' read -r p raw_lib raw_dep sum; do
		$cb $(pkg_to_name $p) $(pkg_to_version $p) $(pkg_to_epoc $p) \
		    "$(uncvs $raw_lib)" "$(uncvs $raw_dep)" $sum
	done < $_REPO/INDEX
}

pkg_in_repo() {
	local repo=$1
	name=$2

	grep -q ^${name}_ $repo/INDEX
}

distfile() {
	case $1 in
	*\|*)
		printf '%s\n' ${1##*\|}
		;;
	*)
		printf '%s\n' ${1##*/}
		;;
	esac
}

distpath() {
	local distfile=$(distfile $1)
	printf '%s\n' $_DIST/$PKG_QUALIFIED_PARENT_NAME/$distfile
}

distfiles() {
	merge $(foreach distfile "$@")
}

distpaths() {
	merge $(foreach distpath "$@")
}

disturl() {
	printf '%s\n' ${1%%|*}
}

has_distfile() {
	local d=$1

	[ -r $(distpath $d) ] || die "unable to read '$(distfile $d)'"
}

assert_distfiles() {
	[ "$PKG_DIST" ] && foreach has_distfile $PKG_DIST
}

pkg_var() {
	uppercase PKG_$1
}

source_pkg() {
	local name=$1
	local f=$_PKG/${name}.sh

	[ ! -h "$f" ] || die "subpackage '$name' ($(readlink -f $f))"
	[ -r "$f" ] || die "no file for '$name' ($f)"
	. $f
}

validate_pkg() {
	local _v
	local _val

	for _v in $PKG_REQUIRED_VARS; do
		eval _val=\$$(pkg_var $_v)
		[ "$_val" ] || die "missing required var '$_v'"
	done
}

sub_var() {
	printf 'PKG_SUB_%s_%s' $(uppercase $(undercase $1)) $(uppercase $2)
}

get_sub_var() {
	eval printf '%s' \"\$$(sub_var $1 $2)\"
}

validate_sub() {
	local name=$1
	local f=$_PKG/${name}.sh

	[ "$MK_NO_SUB_VALIDATION" ] || return 0
	[ -h $f ] || die "missing sub link '$name'"

	local target=$(readlink $f)
	target=${target%*.sh}
	[ $PKG_NAME = "$target" ] || die "wrong sub link target '$target'"
}

sub() {
	local name=$1
	local var=$2
	shift 2

	if [ "$var" = type ]; then
		validate_sub $name
		PKG_SUB="$PKG_SUB $name"
	fi

	local s allowedsub
	for s in $PKG_SUB_LINKS; do
		[ "$name" != "$s" ] || allowedsub=yes
	done

	local v allowedvar
	for v in $PKG_SUB_VARS; do
		[ "$var" != "$v" ] || allowedvar=yes
	done
	[ "$allowedvar" ] || die "unsupported sub var '$var'"

	eval $(sub_var $name $var)=\"\$@\"
}

stale() {
	local type=$1
	shift

	case $type in
	ignore|url|re)
		eval PKG_STALE_$(uppercase $type)=\"\$@\"
		;;
	esac
}

pkgfile_to_name() {
	local f=$(basename $1)

	printf '%s' ${f%*.sh}
}

name_to_repo_pkg() {
	local name=$1

	printf '%s/%s%s\n' $_REPO $(./mk query $name qualified_name) $PKG_EXT
}

sub_to_main() {
	local name=$1
	local f=$_PKG/${name}.sh

	if ! [ -h $f ]; then
		printf '%s' $name
		return 0
	fi

	local target=$(readlink $f)
	printf '%s' ${target%*.sh}
}

read_pkg() {
	local _v
	for _v in $PKG_VARS $PKG_COMPUTED_VARS; do
		unset -v $(pkg_var $_v)
	done

	for _v in $PKG_VARS; do
		eval "$_v() { $(pkg_var $_v)=\"\$@\"; }"
	done

	pre_env

	PKG_NAME=$1
	PKG_PARENT_NAME=$PKG_NAME

	source_pkg $PKG_NAME

	for _v in $PKG_VARS; do
		unset -f $_v
	done

	PKG_QUALIFIED_NAME=${PKG_NAME}_${PKG_VER}_$PKG_EPOC
	PKG_QUALIFIED_PARENT_NAME=${PKG_PARENT_NAME}_${PKG_VER}_$PKG_EPOC

	validate_pkg

	post_env
}

list_pkgs() {
	local f

	for f in $_PKG/*.sh; do
		printf '%s\n' $(sub_to_main $(pkgfile_to_name $f))
	done | sort | uniq | grep -v '^bootstrap-'
}

inherit() {
	PKG_PARENT_NAME=$1
	local childname=$PKG_NAME
	PKG_NAME=$PKG_PARENT_NAME
	source_pkg $PKG_PARENT_NAME
	PKG_NAME=$childname

	if [ "$PKG_STYLE" = phony ]; then
		unset PKG_STYLE
	fi
}

use_contain() {
	[ -z "$MK_NO_CONTAIN" ] && [ -z "$MK_CONTAINED" ]
}

pkgpath() {
	local cmd=pkg
	command -v $cmd >/dev/null || cmd=$_BOOTSTRAP_SUPPORT/bin/$cmd

	printf '%s' $cmd
}

contain() {
	env -i \
		PS1='[contain] \w \$ ' \
		HOME=/root \
		HOSTDIR=$_ROOT \
		MK_CONTAINED=yes \
		REPO=/host/repo \
		$(pkgpath) -e $_CONTAIN "$@"
}

contain_mk() {
	local args
	args="$@"

	contain /bin/sh -lc "cd /host && ./mk $args"
}

prepare_contain() {
	REPO=$_ROOT/repo $(pkgpath) -ip $_CACHE base-bld

	mkdir -p $_CONTAIN

	local f
	for f in $_CONTAIN/*; do
		[ -e "$f" ] || {
			cp -a $_CACHE/* $_CONTAIN
			break
		}
	done
}
