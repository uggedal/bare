uppercase() {
  printf '%s' "$@" | tr 'a-z' 'A-Z'
}

relative() {
  printf '%s\n' ${1#$(pwd)/*}
}

merge() {
  local part res

  for part; do
    res="$res $part"
  done

  printf '%s' "${res# *}"
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
  printf '%s\n' ${1##*/}
}

distpath() {
  local distfile=$(distfile $1)
  printf '%s\n' $_DIST/$PKG_QUALIFIED_PARENT_NAME/$distfile
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

validate_pkg() {
  local _v
  local _val

  for _v in $PKG_REQUIRED_VARS; do
    eval _val=\$$(pkg_var $_v)
    [ "$_val" ] || die "missing required var '$_v'"
  done
}

read_pkg() {
  local _v
  for _v in $PKG_VARS $PKG_COMPUTED_VARS; do
    unset -v $(pkg_var $_v)
  done

  for _v in $PKG_VARS; do
    eval "$_v() { PKG_$(uppercase $_v)=\"\$@\"; }"
  done

  pre_env

  PKG_NAME=$1
  PKG_PARENT_NAME=$PKG_NAME
  source_pkg $PKG_NAME

  for _v in $PKG_VARS; do
    unset -f $_v
  done

  PKG_QUALIFIED_NAME=$PKG_NAME-${PKG_VER}_$PKG_REV
  PKG_QUALIFIED_PARENT_NAME=$PKG_PARENT_NAME-${PKG_VER}_$PKG_REV

  validate_pkg

  post_env
}

inherit() {
  PKG_PARENT_NAME=$1
  local childname=$PKG_NAME
  PKG_NAME=$PKG_PARENT_NAME
  source_pkg $PKG_PARENT_NAME
  PKG_NAME=$childname
}
