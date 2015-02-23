color() {
  local n=$1
  shift

  if tput colors >/dev/null 2>&1; then
    printf -- '\033[%dm%s\033[39;49m' $n "$@"
  else
    printf -- '%s' "$@"
  fi
}

msg() {
  printf -- '\033[1m%s\033[0m\n' "$@" 1>&2
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
  printf -- '%s' "$@" | tr 'a-z' 'A-Z'
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

  . $_LIB/env.sh
}

get_archive() {
  local archive=${src##*/}

  printf -- '%s' $_CACHE/$fullparentname/$archive
}

fetch() {
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

run_step() {
  local step=$1
  local deps=
  local hasdeps=
  local s d
  local steps='
    verify
    extract
    patch
    configure
    build
    install
    validate
    pkg
    '
  for s in $steps; do
    deps="$deps $s"

    if [ "$step" = "$s" ]; then
      hasdeps=yes
      break
    fi
  done

  if [ "$hasdeps" ]; then
    if [ $step = pkg ] && [ -s $_REPO/${fullname}.tar.xz ]; then
      progress pkg "'$name' $(color 34 complete)"
      return
    fi
  else
    deps=$step
  fi

  for d in $deps; do
    if [ -f $MK_BUILD_ROOT/.${d}.done ]; then
      progress $d "'$name' $(color 34 cached)"
      continue
    fi

    step_$d "$@"
    if [ "$hasdeps" ]; then
      touch $MK_BUILD_ROOT/.${d}.done
      progress $d "'$name' $(color 32 ok)"
    fi
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

inherit() {
  parentname=$1
  local oname=$name
  name=$parentname
  . $_PKG/${1}.sh
  name=$oname
}
