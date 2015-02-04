step_clean() {
  local dirs="$_BOOTSTRAP $_BUILD $_DEST"
  local dir

  if [ "$name" ]; then
    dirs="$MK_BUILD_ROOT $_DEST/$fullname"
    progress clean "'$name'"
  else
    progress clean "globally"
  fi

  for dir in $dirs; do
    rm -rf $dir
  done
}
