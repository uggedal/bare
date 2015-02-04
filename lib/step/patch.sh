step_patch() {
  local p

  [ -d $MK_PATCH ] || return 0


  local ocwd=$(pwd)
  cd $MK_SRC
  for p in $MK_PATCH/*.patch; do
    progress patch "'$name' using '${p##*/}'"
    patch -p1 < $p
  done
  cd $ocwd
}
