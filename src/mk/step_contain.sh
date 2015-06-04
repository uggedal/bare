step_contain() {
  progress contain "'$PKG_NAME'"

  REPO=$_ROOT/repo $(pkgpath install) -p $_CACHE base-bld

  local f
  for f in $_CONTAIN/*; do
    [ -e "$f" ] || {
      cp -a $_CACHE/* $_CONTAIN
      break
    }
  done
}
