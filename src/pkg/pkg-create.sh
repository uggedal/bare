#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='-n name -r root -p pkg'

while getopts "n:r:p" opt; do
  case $opt in
    n)
      NAME=$OPTARG
      ;;
    r)
      ROOT=$OPTARG
      ;;
    p)
      PKG=$OPTARG
      ;;
  esac
done
unset opt

[ "$NAME" ] || usage
[ "$ROOT" ] || usage
[ "$PKG" ] || usage

TMP=$(mktemp)
trap "rm -f $TMP" INT TERM EXIT

(
  cd $ROOT

  set -- *
  [ "$1" != \* ] || die "no files in '$ROOT'"

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
  tar -cJvf $PKG "$@"
)
