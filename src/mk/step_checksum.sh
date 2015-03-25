_checksum() {
  sha512sum $(merge $(foreach relative $(distpaths $dist)))
}

step_checksum() {
  local f=$_SUM/${parentname}.sum

  [ "$dist" ] || return 0

  progress checksum "'$name' using '$(distfiles $dist)'"

  assert_distfiles

  [ "$(_checksum)" = "$(cat $f)" ] ||
    die "invalid checksum for '$name' ($(distfile))"
}
