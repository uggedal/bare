#!/bin/sh

set -e

export _ROOT=$(realpath $(dirname $0))

export _SRC=$_ROOT/src
export _PKG=$_ROOT/pkg
export _CKSUM=$_ROOT/cksum
export _FILE=$_ROOT/file
export _PATCH=$_ROOT/patch

. $_SRC/def.sh
. $_SRC/conf.sh

for _f in $_SRC/lib/*.sh; do
  . $_f
done
unset _f

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
  patch <pkg>
  configure <pkg>
  build <pkg>
  install <pkg>
  pkg <pkg>
  clean [pkg]
  query <pkg> <field>
EOF
  exit 64
}

[ "$1" ] || _usage

for _f in $_SRC/step/*.sh; do
  . $_f
done
unset _f

[ "$(command -v step_$1)" ] || _usage

case "$1" in
  clean)
    if [ "$2" ]; then
      read_pkg $2
    fi
    ;;
  *)
    [ "$2" ] || _usage
    read_pkg $2
    ;;
esac

run_step "$@"
