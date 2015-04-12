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

  find * -type f | while read f; do
    printf -- '%s|f|%s\n' $f $(sha512sum $f | cut -d' ' -f1)
  done > $TMP

  find * -type l | while read f; do
    printf -- '%s|l|%s\n' $f $(readlink $f)
  done >> $TMP

  mkdir -p $PKG_DB
  sort $TMP > $PKG_DB/$NAME

  set -- *
  tar -cJvf $PKG "$@"
)
