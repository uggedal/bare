step_contain() {
	use_contain || return 0

	progress contain

	prepare_contain >&3 2>&3
}
