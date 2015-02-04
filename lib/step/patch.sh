step_patch() {
  local func
  local p
  local pkgbuild=$_BUILD/$fullname

  [ -d $MK_PATCH ] || return


  local ocwd=$(pwd)
  cd $pkgbuild/$name-$ver
  for p in $MK_PATCH/*.patch; do
    progress patch "'$name' using '${p##*/}'"
    patch -p1 < $p
  done
  cd $ocwd
}
