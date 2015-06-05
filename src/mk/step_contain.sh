step_contain() {
  use_contain || return 0

  progress contain "'$PKG_NAME'"

  REPO=$_ROOT/repo $(pkgpath install) -p $_CACHE base-bld

  mkdir -p $_CONTAIN

  local f
  for f in $_CONTAIN/*; do
    [ -e "$f" ] || {
      cp -a $_CACHE/* $_CONTAIN
      break
    }
  done
}
