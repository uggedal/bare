cmd_gendeps() {
	local p d

	for p in $(./mk list); do
		for d in $(./mk query $p bdep); do
			printf '%s: %s\n' $p $(sub_to_main $d)
		done
	done > $_ROOT/deps.mk
}
