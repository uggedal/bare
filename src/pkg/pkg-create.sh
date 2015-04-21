#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='-n name -r root -p pkg
[-l libs] [-d deps]'

while getopts "n:r:p:l:d:" opt; do
  case $opt in
    n)
      FULLNAME=$OPTARG
      ;;
    r)
      ROOT=$OPTARG
      ;;
    p)
      PKG=$OPTARG
      ;;
    l)
      LIBS="$OPTARG"
      ;;
    d)
      DEPS="$OPTARG"
      ;;
  esac
done
unset opt

[ "$FULLNAME" ] || usage
[ "$ROOT" ] || usage
[ "$PKG" ] || usage

NAME=$(pkg_to_name $FULLNAME)
VERSION=$(pkg_to_version $FULLNAME)

TMP=$(mktemp)
trap "rm -f $TMP" INT TERM EXIT

(
  cd $ROOT

  set -- *
  [ "$1" != \* ] || die "no files in '$ROOT'"

  printf -- 'v|%s\n' $VERSION > $TMP

  for lib in $LIBS; do
    printf -- 'l|%s\n' $lib
  done >> $TMP

  for dep in $DEPS; do
    printf -- 'd|%s\n' $dep
  done >> $TMP

  find * -type f | sort | while read f; do
    printf -- 'f|%s|%s\n' $f $(file_sum $f)
  done >> $TMP

  find * -type l | sort | while read l; do
    printf -- '@|%s|%s\n' $l $(readlink $l)
  done >> $TMP

  find * -type d | sort | while read d; do
    printf -- '/|%s\n' $d
  done >> $TMP

  mkdir -p $PKG_DB
  mv $TMP $PKG_DB/$NAME

  set -- *
  tar -c "$@" | xz > $PKG
)
