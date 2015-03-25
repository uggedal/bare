cmd_fetch() {
  [ "$dist" ] || return 0

  if [ -r $(distpath) ]; then
    progress fetch "'$name' cached in '$(relative $(distpath))'"
  else
    mkdir -p $(dirname $(distpath))
    progress fetch "'$name' with '$dist'"
    curl -fL -o $(distpath) $dist || die "fetch failure for '$name' ($dist)"
  fi
}
