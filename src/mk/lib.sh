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
  printf -- '%s\n' $_DIST/$PKG_FULLPARENTNAME/$distfile
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
  [ "$PKG_DIST" ] && foreach has_distfile $PKG_DIST
}

pkg_var() {
  uppercase PKG_$1
}

source_pkg() {
  local name=$1
  local f=$_PKG/${name}.sh

  [ -r "$f" ] || die "no file for '$name' ($f)"
  . $f
}

read_pkg() {
  local _v
  for _v in $PKG_VARS $PKG_COMPUTED_VARS; do
    unset -v $(pkg_var $v)
  done

  for _v in $PKG_VARS; do
    eval "$_v() { PKG_$(uppercase $_v)=\"\$@\"; }"
  done

  PKG_NAME=$1
  PKG_PARENTNAME=$PKG_NAME
  source_pkg $PKG_NAME

  for _v in $PKG_VARS; do
    unset -f $_v
  done

  PKG_FULLNAME=$PKG_NAME-${PKG_VER}_$PKG_REV
  PKG_FULLPARENTNAME=$PKG_PARENTNAME-${PKG_VER}_$PKG_REV

  init_env
}

inherit() {
  PKG_PARENTNAME=$1
  local childname=$PKG_NAME
  PKG_NAME=$PKG_PARENTNAME
  source_pkg $PKG_PARENTNAME
  PKG_NAME=$childname
}
