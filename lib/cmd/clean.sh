cmd_clean() {
  local dir

  for dir in $_BUILD/$fullname $_DEST/$fullname; do
    rm -r $dir
  done
}
