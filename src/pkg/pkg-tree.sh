#!/bin/sh

[ -r @@SYSCONFDIR@@/pkg.conf ] && . @@SYSCONFDIR@@/pkg.conf
. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v] [-p root_prefix]
name'

while getopts p:v opt; do
  case $opt in
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

: ${PREFIX:=/}

PKG=$1
[ "$PKG" ] || usage

DEPTH=1

handle_deps() {
  local t=$1
  local f1=$2
  local indent=$(($DEPTH*2))

  [ "$t" = d ] || return 0

  local name lib
  case $f1 in
    *:*)
      name=${f1%:*}
      lib=${f1#*:}
      ;;
    *)
      name=$f1
      ;;
  esac

  printf "%${indent}s" ''
  if [ "$VERBOSE" ] && [ "$lib" ]; then
    printf "%-${PKG_NAME_MAX}s %s\n" $name $lib
  else
    printf '%s\n' $name
  fi

  DEPTH=$(($DEPTH+1))
  read_db $PREFIX $name handle_deps
  DEPTH=$(($DEPTH-1))
}

printf '%s\n' $PKG

read_db $PREFIX $PKG handle_deps
