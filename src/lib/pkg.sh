pkg_to_fullname() {
  local pkg=$1

  printf -- '%s' ${pkg%$PKG_EXT*}
}

pkg_to_name() {
  local pkg=$1

  printf -- '%s' ${pkg%-*}
}

pkg_to_version() {
  local pkg=$1
  local fullname=$(pkg_to_fullname $pkg)

  printf -- '%s' ${fullname##*-}
}
