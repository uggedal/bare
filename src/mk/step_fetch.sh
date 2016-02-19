_fetch() {
	local d=$1

	if ! [ -r $(distpath $d) ]; then
		mkdir -p $(dirname $(distpath $d))
		curl -\# -fL -o $(distpath $d) $(disturl $d) ||
			die "fetch failure for '$PKG_NAME' ($d)"
	fi
}

step_fetch() {
	[ "$PKG_DIST" ] || return 0

	foreach _fetch $PKG_DIST
}
