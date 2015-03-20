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

read_pkg() {
  local _v
  for _v in $PKG_VARS; do
    unset $v
  done

  name=$1
  parentname=$name
  pkgfile=$_PKG/${name}.sh

  [ -r "$pkgfile" ] || die "no file for '$name' ($pkgfile)"
  . $pkgfile

  fullname=$name-${ver}_$rev
  fullparentname=$parentname-${ver}_$rev

  . $_SRC/env.sh
}

inherit() {
  parentname=$1
  local oname=$name
  name=$parentname
  . $_PKG/${1}.sh
  name=$oname
}
