#!/bin/sh -e

_ROOT=$(readlink -f $(dirname $0))

_FILE=$_ROOT/file
_PATCH=$_ROOT/patch
_PKG=$_ROOT/pkg
_SRC=$_ROOT/src
_SUM=$_ROOT/sum

for _f in $_SRC/mk/*.sh; do
	. $_f
done
unset _f

for _dir in \
    bootstrap/cross \
    bootstrap/native \
    bootstrap/support \
    build \
    cache \
    contain \
    dest \
    dist \
    log \
    repo; do
	eval _$(undercase $(uppercase $_dir))=$_ROOT/$_dir
	mkdir -p $_ROOT/$_dir
done
unset _dir

_usage() {
	cat <<-EOF
	mk <command|step> [<args>]

	Commands:
	    sum <pkg>
	    clean [pkg]
	    link <pkg>
	    query <pkg> <field>
	    stale [pkg]
	    bump <pkg> <version>
	    bootstrap
	    image
	    enter

	Ordered steps:
	$(printf '    %s <pkg>\n' $MK_STEPS | grep -v ' pkg <')
	    pkg [pkg]

	Options:
	    -k keep build artifacts
	    -f force rebuild or total clean
	    -n skip step dependencies
	    -j number of parallel build procs
	    -m message for bump
	    -v verbose output
	EOF
	exit 64
}

while getopts fknvj:m: opt; do
	case $opt in
	f)
		MK_FORCE=yes
		;;
	k)
		MK_KEEP=yes
		;;
	n)
		MK_NO_STEP_DEP=yes
		;;
	v)
		MK_VERBOSE=yes
		;;
	j)
		MK_NPROC=$OPTARG
		;;
	m)
		MK_MSG="$OPTARG"
		;;
	esac
done
unset opt

for i in $(seq $(($OPTIND - 1))); do
	eval MK_FLAGS=\"\$FLAGS \$$i\"
done
unset i

shift $(( $OPTIND - 1 ))

action=$1
[ "$action" ] || _usage
shift

if is_step $action; then
	run_step $action "$1"
elif is_cmd $action; then
	run_cmd $action "$@"
else
	_usage
fi
