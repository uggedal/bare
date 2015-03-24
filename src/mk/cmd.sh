is_cmd() {
  [ "$(command -v cmd_$1)" ]
}

run_cmd() {
  cmd_$1 "$@"
}
