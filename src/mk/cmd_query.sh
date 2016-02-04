cmd_query() {
	local field=$1
	local v ok

	if printf '%s' $field | grep -q ^MK_; then
		eval v="\$$field"
	else
		for v in $PKG_VARS $PKG_COMPUTED_VARS; do
			[ "$v" != "$field" ] || ok=yes
		done

		[ "$ok" ] || die "unsupported pkg field '$field'"

		eval v="\$$(pkg_var $field)"
	fi

	[ "$v" ] || return 0

	printf '%s\n' "$v"
}
