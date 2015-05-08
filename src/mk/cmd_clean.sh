_current_qualified_name() {
  local qualified_name=$1

  $_ROOT/mk query $(pkg_to_name $qualified_name) qualified_name
}

_clean_obsolete_dist() {
  [ -d $_DIST ] || return 0

  local qualified_name

  for dir in $_DIST/*; do
    [ -d "$dir" ] || continue

    qualified_name=$(basename $dir)

    [ "$qualified_name" = "$(_current_qualified_name $qualified_name)" ] || rm -r $dir
  done
}

_clean_db() {
  rm -rf $_DB
}

cmd_clean() {
  local dirs="$_BUILD $_DEST"
  local dir

  if [ "$PKG_NAME" ]; then
    dirs="$MK_BUILD_ROOT $_DEST/$PKG_QUALIFIED_NAME"
    progress clean "'$PKG_NAME'"
  else
    progress clean "all"
    _clean_obsolete_dist
    _clean_db
  fi

  for dir in $dirs; do
    rm -rf $dir
  done
}
