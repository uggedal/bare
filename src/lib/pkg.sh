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

read_repo() {
  local repo=$1
  local cb=$2

  [ -d $repo ] || die "unable to read repo: '$REPO'"

  local f p
  for f in $repo/*$PKG_EXT; do
    p=$(basename $f)
    $cb $(pkg_to_name $p) $(pkg_to_version $p) $(pkg_to_fullname $p) $p
  done
}
