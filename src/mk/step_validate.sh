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

  local line

  tar -xOJf $_REPO/$pkg var/db/pkg/$name | while read line; do
    for f in $_VALIDATE_FL; do
      [ "$f" != "${line%|*}" ] || die "conflicting file in '$name' ($f)"
    done
  done
}

_validate_conflicts() {
  local fl f prefix path

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
