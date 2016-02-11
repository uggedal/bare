#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='-p prefix -o output
[-l libs] [-d deps] qualified-name'

while getopts "p:o:l:d:" opt; do
	case $opt in
	p)
		PREFIX=$OPTARG
		;;
	o)
		OUTPUT=$OPTARG
		;;
	l)
		LIBS="$OPTARG"
		;;
	d)
		DEPS="$OPTARG"
		;;
	esac
done
unset opt
shift $(( $OPTIND - 1 ))

QUALIFIED_NAME=$1

[ "$QUALIFIED_NAME" ] || usage
[ "$PREFIX" ] || usage
[ "$OUTPUT" ] || usage

NAME=$(pkg_to_name $QUALIFIED_NAME)
VERSION=$(pkg_to_version $QUALIFIED_NAME)

TMP=$(mktemp)
trap "rm -f $TMP" INT TERM EXIT

(
	cd $PREFIX


	printf 'v|%s\n' $VERSION > $TMP

	for lib in $LIBS; do
		printf 'l|%s\n' $lib
	done >> $TMP

	for dep in $DEPS; do
		printf 'd|%s\n' $dep
	done >> $TMP

	set -- *
	if [ "$1" = \* ]; then
		err "no files in '$PREFIX'"
		set --
	else
		find * -type f | sort | while read f; do
			printf 'f|%s|%s\n' $f $(file_sum $f)
		done >> $TMP

		find * -type l | sort | while read l; do
			printf '@|%s|%s\n' $l $(readlink $l)
		done >> $TMP

		find * -type d | sort | while read d; do
			printf '/|%s\n' $d
		done >> $TMP
	fi

	mkdir -p $PKG_DB
	mv $TMP $PKG_DB/$NAME

	set -- *
	tar -cJf $OUTPUT "$@"

	[ -s $OUTPUT ] || die "empty package '$OUTPUT'"

	cat $PKG_DB/$NAME
)
