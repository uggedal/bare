_fetch() {
  local d=$1

  if [ -r $(distpath $d) ]; then
    progress fetch "'$PKG_NAME' cached in '$(relative $(distpath $d))'"
  else
    mkdir -p $(dirname $(distpath $d))
    progress fetch "'$PKG_NAME' using '$d'"
    curl -fL -o $(distpath $d) $(disturl $d) ||
      die "fetch failure for '$PKG_NAME' ($d)"
  fi
}

step_fetch() {
  [ "$PKG_DIST" ] || return 0

  foreach _fetch $PKG_DIST
}
