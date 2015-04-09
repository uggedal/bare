#!/bin/sh

[ -r @@SYSCONFDIR@@/pkg.conf ] && . @@SYSCONFDIR@@/pkg.conf
. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v] [-f] [-p root_prefix]
name ...'

while getopts "r:p:vf" opt; do
  case $opt in
    p)
      PREFIX=$OPTARG
      ;;
    v)
      VERBOSE=yes
      ;;
    f)
      FORCE=yes
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

  if [ -z "$FORCE" ] && pkg_installed $PREFIX $PKG; then
    die "'$PKG' already installed"
  fi

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
