_link_sub() {
	local name=$1
	local target=$_PKG/${name}.sh

	[ ! -h $target ] || return 0

	progress link "'$name' to '$PKG_NAME'"

	ln -s ${PKG_NAME}.sh $target
}

cmd_link() {
	foreach _link_sub $PKG_SUB
}
