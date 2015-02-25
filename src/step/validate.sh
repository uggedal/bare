_validate_conflicts() {
  local fl f prefix path

  fl="$(find $_DEST/$fullname -type f -o -type l |
          sed "s|^$_DEST/$fullname/||")"

  while read prefix path; do
    for f in $fl; do
      [ "$f" != "$path" ] || die "conflicting file in '$prefix' ($f)"
    done
  done < $_REPO/files.txt
}

step_validate() {
  progress validate "'$name'"

  [ ! -f $_REPO/files.txt ] || _validate_conflicts
}
