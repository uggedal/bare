step_checksum() {
  local f=$_SUM/${parentname}.sum

  [ "$src" ] || return 0

  progress checksum "'$name' using '$(distfile)'"

  [ -s "$(distpath)" ] ||
    die "missing or empty archive for '$name' ($(distfile))"

  [ "$(sha512sum $(relative $(distpath)))" = "$(cat $f)" ] ||
    die "invalid checksum for '$name' ($(distfile))"
}
