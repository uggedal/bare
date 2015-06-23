step_contain() {
  use_contain || return 0

  progress contain "'$PKG_NAME'"

  prepare_contain
}
