#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='name root pkg'

NAME=$1
ROOT=$2
PKG=$3

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

  mkdir -p $PKG_DB
  mv $TMP $PKG_DB/$NAME

  set -- *
  tar -cJvf $PKG "$@"
)
