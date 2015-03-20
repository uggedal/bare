uppercase() {
  printf -- '%s' "$@" | tr 'a-z' 'A-Z'
}

relative() {
  printf -- '%s' ${1#$(pwd)/*}
}

get_archive() {
  local archive=${src##*/}

  printf -- '%s' $_CACHE/$fullparentname/$archive
}

fetch() {
  [ "$src" ] || return 0

  local pkgarchive=$(get_archive)

  if [ -r $pkgarchive ]; then
    progress fetch "'$name' cached in '$(relative $pkgarchive)'"
  else
    mkdir -p $(dirname $pkgarchive)
    progress fetch "'$name' with '$src'"
    curl -fL -o $pkgarchive $src || die "fetch failure for '$name' ($src)"
  fi

  printf -- '%s' $pkgarchive
}

read_pkg() {
  local _v
  for _v in $PKG_VARS; do
    unset $v
  done

  name=$1
  parentname=$name
  pkgfile=$_PKG/${name}.sh

  [ -r "$pkgfile" ] || die "no file for '$name' ($pkgfile)"
  . $pkgfile

  fullname=$name-${ver}_$rev
  fullparentname=$parentname-${ver}_$rev

  init_env
}

inherit() {
  parentname=$1
  local oname=$name
  name=$parentname
  . $_PKG/${1}.sh
  name=$oname
}
