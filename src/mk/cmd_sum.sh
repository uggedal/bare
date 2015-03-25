cmd_sum() {
  local pkgarchive=$(distpath)
  local archive=${pkgarchive##*/}

  [ -r $pkgarchive ] || die "unable to read '$archive'"

  progress sum "'$name' with '$archive'"

  sha512sum $(relative $pkgarchive) > $_SUM/${name}.sum
}
