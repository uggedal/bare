_validate_name() {
  [ "${#name}" -le $PKG_NAME_MAX ] ||
    die "name is longer than $PKG_NAME_MAX (${#name})"
}

_validate_conflicts() {
  local fl f prefix path

  fl="$(find $_DEST/$fullname -type f -o -type l |
          sed "s|^$_DEST/$fullname/||")"

  < $_REPO/files.txt | sed "/^$fullname\t/d" | while read prefix path; do
    for f in $fl; do
      [ "$f" != "$path" ] || die "conflicting file in '$prefix' ($f)"
    done
  done
}

step_validate() {
  progress validate "'$name'"

  _validate_name

  [ ! -f $_REPO/files.txt ] || _validate_conflicts
}
