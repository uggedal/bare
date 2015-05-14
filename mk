#!/bin/sh

set -e

_ROOT=$(realpath $(dirname $0))

_FILE=$_ROOT/file
_PATCH=$_ROOT/patch
_PKG=$_ROOT/pkg
_SRC=$_ROOT/src
_SUM=$_ROOT/sum

_FANCY_MSG=yes

for _f in $_SRC/lib/*.sh $_SRC/mk/*.sh; do
  . $_f
done
unset _f

for _dir in build contain cross db dest dist repo; do
  eval _$(uppercase $_dir)=$_ROOT/$_dir
  mkdir -p $_ROOT/$_dir
done
unset _dir

_usage() {
  cat <<EOF
mk <command|step> [<args>]

Commands:
  fetch <pkg>
  sum <pkg>
  clean [pkg]
  query <pkg> <field>
  bootstrap
  contain

Ordered steps:
  prep <pkg>
  checksum <pkg>
  extract <pkg>
  patch <pkg>
  configure <pkg>
  build <pkg>
  install <pkg>
  optimize <pkg>
  validate <pkg>
  pkg <pkg> [-f] [-k]
EOF
  exit 64
}

[ "$1" ] || _usage

case "$1" in
  clean)
    if [ "$2" ]; then
      read_pkg $2
    fi
    ;;
  pkg)
    if [ "$3" = -f ]; then
      MK_FORCE=yes
    fi
    if [ "$3" = -k ]; then
      MK_KEEP=yes
    fi
    read_pkg $2
    ;;
  bootstrap|contain)
    [ -z "$2" ] || _usage
    ;;
  *)
    [ "$2" ] || _usage
    read_pkg $2
    ;;
esac

if is_step $1; then
  run_step "$@"
  exit 0
fi

if is_cmd $1; then
  run_cmd "$@"
  exit 0
fi

usage
