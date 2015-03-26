_current_fullname() {
  local fullname=$1

  $_ROOT/mk query $(pkg_to_name $fullname) fullname
}

_clean_obsolete_dist() {
  [ -d $_DIST ] || return 0

  local fullname

  for dir in $_DIST/*; do
    [ -d "$dir" ] || continue

    fullname=$(basename $dir)

    [ "$fullname" = "$(_current_fullname $fullname)" ] || rm -r $dir
  done
}

cmd_clean() {
  local dirs="$_BUILD $_DEST"
  local dir

  if [ "$PKG_NAME" ]; then
    dirs="$MK_BUILD_ROOT $_DEST/$PKG_FULLNAME"
    progress clean "'$PKG_NAME'"
  else
    progress clean "all"
    _clean_obsolete_dist
  fi

  for dir in $dirs; do
    rm -rf $dir
  done
}
