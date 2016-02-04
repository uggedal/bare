#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v[v] [-p root_prefix] name ...'

VERBOSE=0

while getopts "p:v" opt; do
	case $opt in
		p)
			PREFIX=$OPTARG
			;;
		v)
			VERBOSE=$(($VERBOSE + 1))
			;;
	esac
done
unset opt
shift $(( $OPTIND - 1 ))

: ${PREFIX:=/}

case $PREFIX in
	/*)
		:
		;;
	*)
		usage
		;;
esac

_changed_err() {
	local f=$1

	err "'$f' local changes, skipping removal"
}

_rm() {
	local f=$1

	[ "$VERBOSE" -le 1 ] || printf '%s\n' $f
	rm $f
}

handle_db_line() {
	local t=$1
	local path=$PREFIX$2
	local meta=$3

	case $t in
		f)
			if check_sum $path $meta; then
				_rm $path
			else
				_changed_err $path
			fi
			;;
		@)
			if [ "$(readlink $path)" = $meta ]; then
				_rm $path
			else
				_changed_err $path
			fi
			;;
		/)
			if [ -d $path ]; then
				if rmdir $d 2>/dev/null; then
					[ "$VERBOSE" -le 1 ] || printf '%s\n' $d
				fi
			else
				_changed_err $path
			fi
			;;
	esac
}

for p; do
	[ "$VERBOSE" -le 0 ] || msg "removing '$p'"
	read_db $PREFIX $p handle_db_line
	rm $(pkg_db $PREFIX $p)
	rm -f $(pkg_db $PREFIX $p explicit)
	rm -f $(pkg_db $PREFIX $p dependency)
done
unset p
