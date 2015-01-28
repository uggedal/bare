cmd_clean() {
  local name=$1
  local dirs="$_BUILD $_DEST"
  local dir

  [ "$name" ] && dirs="$_BUILD/$fullname $_DEST/$fullname"

  for dir in $dirs; do
    rm -r $dir
  done
}
