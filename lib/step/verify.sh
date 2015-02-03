step_verify() {
  local f=$_CKSUM/${name}.sha256sum
  local pkgarchive=$(fetch $src $fullname)
  local archive=${pkgarchive##*/}

  progress verify "'$name' using '$archive'"

  [ "$(sha256sum $(relative $pkgarchive))" = "$(cat $f)" ] ||
    die "invalid checksum for '$name' ($archive)"
}
