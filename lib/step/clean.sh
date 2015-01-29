step_clean() {
  local name=$1
  local dirs="$_BUILD $_DEST"
  local dir

  if [ "$name" ]; then
    dirs="$_BUILD/$fullname $_DEST/$fullname"
    progress clean "'$name'"
  else
    progress clean "globally"
  fi

  for dir in $dirs; do
    rm -r $dir
  done
}
