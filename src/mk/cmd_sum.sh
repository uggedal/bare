cmd_sum() {
  assert_distfiles

  progress sum "'$name' using '$(distfiles $dist)'"

  sha512sum $(merge $(foreach relative $(distpaths $dist))) > $_SUM/${name}.sum
}
