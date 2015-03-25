cmd_sum() {
  [ -r $(distpath) ] || die "unable to read '$(distfile)'"

  progress sum "'$name' with '$(distfile)'"

  sha512sum $(relative $(distpath)) > $_SUM/${name}.sum
}
