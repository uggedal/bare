step_pkg() {
  local pkgdest=$_DEST/$fullname
  local pkg=$_REPO/${fullname}.tar.xz

  progress pkg "'$name'"

  tar -C $pkgdest -cJf $pkg .
}
