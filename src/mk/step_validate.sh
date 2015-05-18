_validate_name() {
  [ "${#PKG_NAME}" -le $PKG_NAME_MAX ] ||
    die "name is longer than $PKG_NAME_MAX (${#PKG_NAME})"
}

_find_conflict_in_db() {
  local t=$1
  local f1=$2
  local f

  case $t in
    @|f)
      for f in $_VALIDATE_FL; do
        [ "$f" != "$f1" ] || die "conflicting file in '$_PKG_NAME' ($f)"
      done
      ;;
  esac
}

_validate_confict() {
  local name=$1
  local ver=$2
  local qualified_name=$3
  local pkg=$4

  [ $name != $PKG_NAME ] || return 0

  _PKG_NAME=$name
  read_db $_DB $name _find_conflict_in_db
  unset _PKG_NAME
}

_validate_conflicts() {
  local dest=$_DEST/$PKG_QUALIFIED_NAME
  [ -d "$dest" ] || return 0

  _VALIDATE_FL="$(find $dest -type f -o -type l |
                  sed "s|^$_DEST/$PKG_QUALIFIED_NAME/||")"

  read_repo $_REPO _validate_confict

  unset _VALIDATE_FL
}

step_validate() {
  progress validate "'$PKG_NAME'"

  _validate_name
  _validate_conflicts
}
