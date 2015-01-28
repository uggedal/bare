cmd_verify() {
  local f=$_CKSUM/${name}.sha256sum
  local pkgarchive=$(fetch $src $fullname)

  sha256sum --status -c $f ||
    die "invalid checksum for '$name' ($pkgarchive)"
}
