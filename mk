#!/bin/sh

set -e

export _ROOT=$(realpath $(dirname $0))

export _LIB=$_ROOT/lib
export _PKG=$_ROOT/pkg
export _CKSUM=$_ROOT/cksum
export _FILE=$_ROOT/file

. $_LIB/def.sh
. $_LIB/common.sh

for _dir in cache build dest repo; do
  eval export _$(uppercase $_dir)=$_ROOT/$_dir
  mkdir -p $_ROOT/$_dir
done
unset _dir

_usage() {
  cat <<EOF
mk <command> [<args>]

Commands:
  gencksum <pkg>
  verify <pkg>
  extract <pkg>
  configure <pkg>
  build <pkg>
  install <pkg>
  pkg <pkg>
  clean [pkg]
EOF
  exit 64
}

[ "$1" ] || _usage

for _f in $_LIB/step/*.sh; do
  . $_f
done
unset _f

[ "$(command -v step_$1)" ] || _usage

case "$1" in
  clean)
    [ "$2" ] && read_pkg $2
    ;;
  *)
    [ "$2" ] || _usage
    read_pkg $2
    ;;
esac

. $_LIB/env.sh
run_step $1
