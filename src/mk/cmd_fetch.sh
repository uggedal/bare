cmd_fetch() {
  [ "$src" ] || return 0

  local pkgarchive=$(get_archive)

  if [ -r $pkgarchive ]; then
    progress fetch "'$name' cached in '$(relative $pkgarchive)'"
  else
    mkdir -p $(dirname $pkgarchive)
    progress fetch "'$name' with '$src'"
    curl -fL -o $pkgarchive $src || die "fetch failure for '$name' ($src)"
  fi
}
