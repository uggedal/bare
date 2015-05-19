uppercase() {
  printf '%s' "$@" | tr a-z A-Z
}

undercase() {
  printf '%s' "$@" | tr /.- _
}

relative() {
  local f=$1
  local from=$2
  : ${from:=$(pwd)}

  printf '%s\n' ${f#$from/*}
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
  case $1 in
    *\|*)
      printf '%s\n' ${1##*|}
      ;;
    *)
      printf '%s\n' ${1##*/}
      ;;
  esac
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

disturl() {
  printf '%s\n' ${1%%|*}
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

  [ ! -h "$f" ] || die "subpackage '$name' ($(readlink -f $f))"
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

sub_var() {
  printf 'PKG_SUB_%s_%s' $(uppercase $(undercase $1)) $(uppercase $2)
}

sub() {
  local subname=$1
  local var=$2
  shift 2

  local s allowedsub
  for s in $PKG_SUB; do
    [ "$subname" != "$s" ] || allowedsub=yes
  done
  [ "$allowedsub" ] || die "missing sub package '$subname'"

  local v allowedvar
  for v in $PKG_SUB_VARS; do
    [ "$var" != "$v" ] || allowedvar=yes
  done
  [ "$allowedvar" ] || die "unsupported sub var '$var'"

  eval $(sub_var $subname $var)=\"\$@\"
}

find_sub() {
  local f target sub

  for f in $_PKG/*.sh; do
    [ -h $f ] || continue
    target=$(readlink $f)
    target=${target%*.sh}
    [ $PKG_NAME = "$target" ] || continue
    sub=$(basename $f)
    sub=${sub%*.sh}
    PKG_SUB="$PKG_SUB $sub"
  done
}

read_pkg() {
  local _v
  for _v in $PKG_VARS $PKG_COMPUTED_VARS; do
    unset -v $(pkg_var $_v)
  done

  for _v in $PKG_VARS; do
    eval "$_v() { $(pkg_var $_v)=\"\$@\"; }"
  done

  pre_env

  PKG_NAME=$1
  PKG_PARENT_NAME=$PKG_NAME

  find_sub

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
