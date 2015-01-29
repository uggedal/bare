step_gencksum() {
  local pkgarchive=$(fetch $src $fullname)

  progress gencksum "'$name' with '${pkgarchive##*/}'"

  sha256sum $(relative $pkgarchive) > $_CKSUM/${name}.sha256sum
}
