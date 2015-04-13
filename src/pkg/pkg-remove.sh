#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v[v] [-p root_prefix] name ...'

VERBOSE=0

while getopts "p:v" opt; do
  case $opt in
    p)
      PREFIX=$OPTARG
      ;;
    v)
      VERBOSE=$(($VERBOSE + 1))
      ;;
  esac
done
unset opt
shift $(( $OPTIND - 1 ))

: ${PREFIX:=/}

case $PREFIX in
  /*)
    :
    ;;
  *)
    usage
    ;;
esac

_changed_err() {
  local f=$1

  err "'$f' local changes, skipping removal"
}

_rm_empty_dirs() {
  local f=$1
  local d

  d=${f%/*}
  while [ "$d" ]; do
    rmdir $d 2>/dev/null
    d=${d%/*}
  done
}

handle_pkg() {
  local name=$1
  local db=$(pkg_db $PREFIX $name)

  [ -f $db ] || die "'$name' not installed"

  local f p t m
  while IFS='|' read -r f t m; do
    p=$PREFIX$f
    case $t in
      f)
        if check_sum $p $m; then
          rm $p
        else
          _changed_err $p
        fi
        ;;
      l)
        if [ "$(readlink $p)" = $m ]; then
          rm $p
        else
          _changed_err $p
        fi
        ;;
    esac

    _rm_empty_dirs $p
  done < $db

  rm $db
}

for p; do
  handle_pkg $p
done
unset p
