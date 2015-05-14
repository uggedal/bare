is_cmd() {
  [ "$(command -v cmd_$1)" ]
}

run_cmd() {
  local cmd=$1
  shift

  cmd_$cmd "$@"
}
