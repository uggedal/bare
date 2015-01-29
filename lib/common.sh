color() {
  local n=$1
  shift

  if tput colors >/dev/null 2>&1; then
    printf -- '\033[%dm%s\033[0m' $n "$@"
  else
    printf -- '%s' "$@"
  fi
}

msg() {
  printf -- '%s\n' "$@" 1>&2
}

err() {
  msg "$(color 31 mk:) $@"
}

die() {
  err "$@"
  exit 1
}

progress() {
  local step="$(printf '%-10s' $1:)"
  shift

  msg "$(color 33 "$step") $@"
}

relative() {
  printf -- '%s' ${1#$(pwd)/*}
}

uppercase() {
  printf -- '%s' "$@" | tr '[:lower:]' '[:upper:]'
}

read_pkg() {
  # TODO: sanity check for variables
  # TODO: unsetting of variables before read

  name=$1
  pkgfile=$_PKG/${name}.sh

  [ -r "$pkgfile" ] || die "no file for '$name' ($pkgfile)"
  . $pkgfile

  fullname=$name-${ver}_$rev
}

get_archive() {
  local src=$1
  local fullname=$2
  local archive=${src##*/}

  printf -- '%s' $_CACHE/$fullname/$archive
}

fetch() {
  local src=$1
  local fullname=$2
  local pkgarchive=$(get_archive $src $fullname)

  if [ -r $pkgarchive ]; then
    progress fetch "'$name' cached in '$(relative $pkgarchive)'"
  else
    mkdir -p $(dirname $pkgarchive)
    progress fetch "'$name' with '$src'"
    curl -L $src > $pkgarchive
  fi

  printf -- '%s' $pkgarchive
}

run_step() {
  local step=$1
  local deps hasdeps s d
  local steps='
    verify
    extract
    build
    install
    pkg
    '
  local pkgbuild=$_BUILD/$fullname

  for s in $steps; do
    deps="$deps $s"

    if [ "$step" = "$s" ]; then
      hasdeps=yes
      break
    fi
  done

  [ "$hasdeps" ] || deps=$step

  # TODO: move to env setup
  mkdir -p $pkgbuild

  for d in $deps; do
    if [ -f $pkgbuild/.${d}.done ]; then
      progress $d "'$name' $(color 34 cached)"
      continue
    fi

    step_$d
    [ "$hasdeps" ] && touch $pkgbuild/.${d}.done
    progress $d "'$name' $(color 32 ok)"
  done
}

run_style() {
  local style=$1
  local func=$2

  . $_LIB/style/${style}.sh

  if [ "$(command -v pre_$func)" ]; then
    pre_$func
  fi

  if [ "$(command -v do_$func)" ]; then
    do_$func
  else
    ${style}_default_$func
  fi

  if [ "$(command -v post_$func)" ]; then
    post_$func
  fi
}
