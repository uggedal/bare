_fetch() {
  local d=$1

  if [ -r $(distpath $d) ]; then
    progress fetch "'$name' cached in '$(relative $(distpath $d))'"
  else
    mkdir -p $(dirname $(distpath $d))
    progress fetch "'$name' using '$d'"
    curl -fL -o $(distpath $d) $d || die "fetch failure for '$name' ($d)"
  fi
}

cmd_fetch() {
  [ "$dist" ] || return 0

  foreach _fetch $dist
}
