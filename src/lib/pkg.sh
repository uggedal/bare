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