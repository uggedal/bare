_distpatch() {
  case $1 in
    *.diff|*.patch)
      printf -- '%s\n' $1
      ;;
  esac
}

step_patch() {
  local p

  [ -d $MK_PATCH ] || return 0

  for p in $MK_PATCH/*.patch $(foreach _distpatch $(distpaths $dist)); do
    progress patch "'$name' using '${p##*/}'"
    patch -d $MK_DIST -p1 < $p
  done
}
