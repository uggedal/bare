cmd_fetch() {
  [ "$src" ] || return 0

  if [ -r $(distpath) ]; then
    progress fetch "'$name' cached in '$(relative $(distpath))'"
  else
    mkdir -p $(dirname $(distpath))
    progress fetch "'$name' with '$src'"
    curl -fL -o $(distpath) $src || die "fetch failure for '$name' ($src)"
  fi
}
