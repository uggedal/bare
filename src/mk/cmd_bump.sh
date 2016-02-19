cmd_bump() {
	local v=$1
	local pkg=$_PKG/$PKG_NAME.sh
	local f

	ed $pkg <<-EOF
	,s|^\(ver \).*\$|\1$v
	w
	q
	EOF

	./mk fetch $PKG_NAME
	./mk sum $PKG_NAME
	./mk pkg $PKG_NAME

	for f in $_SUM/$PKG_NAME.sum $_PATCH/$PKG_NAME $_FILE/$PKG_NAME $pkg; do
		if [ -e $f ]; then
			git add $f
		fi
	done
	git ci -m "$PKG_NAME: update to $v"
}
