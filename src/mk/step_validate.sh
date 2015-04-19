_validate_name() {
  [ "${#PKG_NAME}" -le $PKG_NAME_MAX ] ||
    die "name is longer than $PKG_NAME_MAX (${#PKG_NAME})"
}

_validate_confict() {
  local name=$1
  local ver=$2
  local fullname=$3
  local pkg=$4

  [ $name != $PKG_NAME ] || return 0

  local t f1 f2 f

  tar -xOJf $_REPO/$pkg $PKG_DB/$name | while IFS='|' read -r t f1 f2; do
    case $t in
      @|f)
        for f in $_VALIDATE_FL; do
          [ "$f" != "$f1" ] || die "conflicting file in '$name' ($f)"
        done
        ;;
    esac
  done
}

_validate_conflicts() {
  _VALIDATE_FL="$(find $_DEST/$PKG_FULLNAME -type f -o -type l |
                  sed "s|^$_DEST/$PKG_FULLNAME/||")"

  read_repo $_REPO _validate_confict

  unset _VALIDATE_FL
}

step_validate() {
  progress validate "'$PKG_NAME'"

  _validate_name
  _validate_conflicts
}
