#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v] [-p root_prefix] -r repo_path
name ...'

while getopts "r:p:v" opt; do
  case $opt in
    r)
      REPO=$OPTARG
      ;;
    p)
      PREFIX=$OPTARG
      ;;
    v)
      VERBOSE=yes
      ;;
  esac
done
unset opt
shift $(( $OPTIND - 1 ))

handle_pkg() {
  local name=$1
  local ver=$2
  local fullname=$3
  local f=$4

  [ "$PKG" = "$name" ] || return 0

  [ -z "$VERBOSE" ] || msg "installing '$PKG'"
  tar -C $PREFIX -xJf $REPO/$f
  INSTALLED=yes
}

[ "$REPO" ] || usage

: ${PREFIX:=/}

for PKG in $@; do
  unset INSTALLED
  read_repo $REPO handle_pkg
  [ "$INSTALLED" ] || die "no package named '$PKG'"
done
unset PKG
