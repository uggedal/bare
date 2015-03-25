step_checksum() {
  local f=$_CKSUM/${parentname}.sum
  local pkgarchive=$(fetch)
  local archive=${pkgarchive##*/}

  [ "$src" ] || return 0

  progress checksum "'$name' using '$archive'"

  [ -s "$pkgarchive" ] ||
    die "missing or empty archive for '$name' ($archive)"

  [ "$(sha512sum $(relative $pkgarchive))" = "$(cat $f)" ] ||
    die "invalid checksum for '$name' ($archive)"
}
