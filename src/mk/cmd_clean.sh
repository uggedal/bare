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

_clean_contain() {
  if use_contain; then
    rm -rf $_CONTAIN
  fi
}

_sub_dest_dirs() {
  local name
  for name in $PKG_SUB; do
    printf '%s ' $_DEST/$name-${PKG_VER}_$PKG_REV
  done
}

cmd_clean() {
  local dirs="$_BUILD $_DEST"
  local dir

  if [ "$PKG_NAME" ]; then
    dirs="$MK_BUILD_ROOT $MK_DESTDIR $(_sub_dest_dirs)"
    progress clean "'$PKG_NAME'"
  else
    progress clean "all"
    _clean_obsolete_dist
    _clean_db
    _clean_contain
  fi

  for dir in $dirs; do
    rm -rf $dir
  done
}
