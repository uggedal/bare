is_cmd() {
	[ "$(command -v cmd_$1)" ]
}

run_cmd() {
	local cmd=$1
	shift

	case $cmd in
	bootstrap|enter|list)
		:
		;;
	clean|stale)
		[ -z "$1" ] || {
			read_pkg $1
			shift
		}
		;;
	*)
		[ "$1" ] || _usage
		read_pkg $1
		shift
		;;
	esac

	case $cmd in
	link)
		MK_NO_SUB_VALIDATION=yes
		;;
	esac

	cmd_$cmd "$@"
}
