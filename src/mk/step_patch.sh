_filter_patch() {
  case $1 in
    *.diff|*.patch)
      printf -- '%s\n' $1
      ;;
  esac
}

_patch() {
  local p=$1

  progress patch "'$name' using '${p##*/}'"
  patch -d $MK_DIST -p1 < $p
}

step_patch() {
  local p

  if [ -d $MK_PATCH ]; then
    for p in $MK_PATCH/*.patch; do
      _patch $p
    done
  fi

  for p in $(foreach _filter_patch $(distpaths $dist)); do
    _patch $p
  done
}
