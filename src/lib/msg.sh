msg() {
	printf '%s\n' "$@"
}

msglist() {
	local prefix="$1"
	shift

	local part
	for part; do
		printf '%-10s%s\n' '' $part
	done
}

err() {
	msg "error: $@" >&2
}

die() {
	err "$@"
	exit 1
}

progress() {
	local step="$(printf '%-10s' $1:)"
	shift

	msg "$step $@"
}

usage() {
	local progname=$(basename $0)
	local prefix='usage: '
	local indent_width=$((${#prefix} + ${#progname} + 1))
	(
		IFS='
'
		heading=yes
		for l in $_USAGE; do
			if [ "$heading" ]; then
				printf 'usage: %s %s\n' $progname "$l"
			else
				printf '%-*s%s\n' $indent_width '' "$l"
			fi
			unset heading
		done
	) >&2
	exit 1
}

dump() {
	local w
	for w; do
		printf '%-4s%s\n' '' $w
	done
}
