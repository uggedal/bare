#!/bin/sh

[ -r @@SYSCONFDIR@@/pkg.conf ] && . @@SYSCONFDIR@@/pkg.conf
. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v[v]] [-f] [-p root_prefix]
name ...'

VERBOSE=0

while getopts "p:vf" opt; do
  case $opt in
    p)
      PREFIX=$OPTARG
      ;;
    v)
      VERBOSE=$(($VERBOSE + 1))
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

  [ "$VERBOSE" -le 0 ] || msg "installing '$PKG'"

  [ "$VERBOSE" -le 1 ] || xzdec -c $REPO/$f | tar -t

  xzdec -c $REPO/$f | tar -C $PREFIX -x
  INSTALLED=yes
}

[ "$REPO" ] || usage

: ${PREFIX:=/}

for PKG; do
  unset INSTALLED
  read_repo $REPO handle_pkg
  [ "$INSTALLED" ] || die "no package named '$PKG'"
done
unset PKG
