step_patch() {
  local p

  [ -d $MK_PATCH ] || return 0

  for p in $MK_PATCH/*.patch; do
    progress patch "'$name' using '${p##*/}'"
    patch -d $MK_SRC -p1 < $p
  done
}
