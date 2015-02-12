step_clean() {
  local dirs="$_BUILD $_DEST"
  local dir

  if [ "$name" ]; then
    dirs="$MK_BUILD_ROOT $_DEST/$fullname"
    progress clean "'$name'"
  else
    progress clean "all"
  fi

  for dir in $dirs; do
    rm -rfv $dir
  done
}
