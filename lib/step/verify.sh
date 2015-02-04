step_verify() {
  local f=$_CKSUM/${parentname}.sha256sum
  local pkgarchive=$(fetch)
  local archive=${pkgarchive##*/}

  progress verify "'$name' using '$archive'"

  [ -s "$pkgarchive" ] || die "missing or empty archive for '$name' ($archive)"

  [ "$(sha256sum $(relative $pkgarchive))" = "$(cat $f)" ] ||
    die "invalid checksum for '$name' ($archive)"
}
