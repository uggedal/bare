#!/bin/sh

set -e

export _ROOT=$(realpath $(dirname $0))
export _LIB=$_ROOT/lib
export _PKG=$_ROOT/pkg
export _CACHE=$_ROOT/cache
export _CKSUM=$_ROOT/cksum
export _BUILD=$_ROOT/build
export _DEST=$_ROOT/dest

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

. $_LIB/common.sh
for _cmdf in $_LIB/cmd/*.sh; do
  . $_cmdf
done

[ "$(command -v cmd_$1)" ] || _usage

read_pkg $2
cmd_$1 $2
