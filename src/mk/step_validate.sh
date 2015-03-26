_validate_name() {
  [ "${#PKG_NAME}" -le $PKG_NAME_MAX ] ||
    die "name is longer than $PKG_NAME_MAX (${#PKG_NAME})"
}

_validate_conflicts() {
  local fl f prefix path

  fl="$(find $_DEST/$PKG_FULLNAME -type f -o -type l |
          sed "s|^$_DEST/$PKG_FULLNAME/||")"

  < $_REPO/files.txt | sed "/^$PKG_FULLNAME\t/d" | while read prefix path; do
    for f in $fl; do
      [ "$f" != "$path" ] || die "conflicting file in '$prefix' ($f)"
    done
  done
}

step_validate() {
  progress validate "'$PKG_NAME'"

  _validate_name

  [ ! -f $_REPO/files.txt ] || _validate_conflicts
}
