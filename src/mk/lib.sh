uppercase() {
  printf -- '%s' "$@" | tr 'a-z' 'A-Z'
}

relative() {
  printf -- '%s\n' ${1#$(pwd)/*}
}

merge() {
  local part res

  for part; do
    res="$res $part"
  done

  printf -- '%s' "${res# *}"
}

foreach() {
  local func=$1
  local part
  shift

  for part; do
    eval $func \$part
  done
}

distfile() {
  printf -- '%s\n' ${1##*/}
}

distpath() {
  local distfile=$(distfile $1)
  printf -- '%s\n' $_DIST/$fullparentname/$distfile
}

distfiles() {
  merge $(foreach distfile "$@")
}

distpaths() {
  merge $(foreach distpath "$@")
}

has_distfile() {
  local d=$1

  [ -r $(distpath $d) ] || die "unable to read '$(distfile $d)'"
}

assert_distfiles() {
  foreach has_distfile $dist
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

  init_env
}

inherit() {
  parentname=$1
  local oname=$name
  name=$parentname
  . $_PKG/${1}.sh
  name=$oname
}
