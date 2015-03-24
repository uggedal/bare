cmd_gencksum() {
  local pkgarchive=$(fetch)

  progress gencksum "'$name' with '${pkgarchive##*/}'"

  sha512sum $(relative $pkgarchive) > $_CKSUM/${name}.sum
}
