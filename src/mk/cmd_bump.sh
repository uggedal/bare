_pkg_recursive() {
	local p
	./mk pkg $PKG_NAME
	for p in $(list_pkgs); do
		[ "$(./mk query $p parent_name)" = $PKG_NAME ] || continue
		./mk pkg $p
	done
}

cmd_bump() {
	local v=$1
	local pkg=$_PKG/$PKG_NAME.sh
	local files="
		$_SUM/$PKG_NAME.sum
		$_PATCH/$PKG_NAME
		$_FILE/$PKG_NAME
		$pkg
	"
	local epoc
	local f
	local msg=rebuild

	epoc=$(sed -n 's/^epoc \([0-9][0-9]*\)$/\1/p' $pkg)
	[ "$epoc" ] || die 'missing epoc'
	epoc=$(($epoc + 1))

	if [ "$v" ]; then
		msg="update to $v"

		ed $pkg <<-EOF
		,s|^\(ver \).*\$|\1$v
		w
		q
		EOF
	fi

	ed $pkg <<-EOF
	,s|^\(epoc \).*\$|\1$epoc
	w
	q
	EOF

	./mk fetch $PKG_NAME
	./mk sum $PKG_NAME
	_pkg_recursive

	for f in $files; do
		if [ -e $f ]; then
			git add $f
		fi
	done
	git ci -m "$PKG_NAME: $msg ($epoc)"
}
