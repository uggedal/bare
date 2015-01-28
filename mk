#!/bin/sh

set -e

export _ROOT=$(realpath $(dirname $0))

export _LIB=$_ROOT/lib
export _PKG=$_ROOT/pkg
export _CKSUM=$_ROOT/cksum

. $_LIB/common.sh

for _dir in cache build dest; do
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
  build <pkg>
  install <pkg>
EOF
  exit 64
}

[ "$1" ] || _usage
[ "$2" ] || _usage

for _cmdf in $_LIB/cmd/*.sh; do
  . $_cmdf
done

[ "$(command -v cmd_$1)" ] || _usage

read_pkg $2
cmd_$1 $2
