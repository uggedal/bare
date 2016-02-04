#!/bin/sh

[ -r @@SYSCONFDIR@@/pkg.conf ] && . @@SYSCONFDIR@@/pkg.conf
. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v]'

query_line() {
	local name=$1
	local ver=$2

	if [ "$VERBOSE" ]; then
		printf "%-${PKG_NAME_MAX}s %s\n" $name $ver
	else
		printf '%s\n' $name
	fi
}

while getopts "v" opt; do
	case $opt in
		v)
			VERBOSE=yes
			;;
	esac
done
unset opt

[ "$REPO" ] || usage

read_repo $REPO query_line
