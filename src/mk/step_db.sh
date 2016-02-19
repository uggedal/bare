step_db() {
	progress db "'$PKG_NAME'"

	read_repo $_REPO extract_db_file >&3 2>&3
}
