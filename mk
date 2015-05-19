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

for _dir in bootstrap/cross bootstrap/native build contain db dest dist repo; do
  eval _$(undercase $(uppercase $_dir))=$_ROOT/$_dir
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

action=$1
shift
[ "$action" ] || _usage

pkg=$1
[ -z "$pkg" ] || shift

case "$action" in
  bootstrap|contain)
    [ -z "$pkg" ] || _usage
    ;;
  clean)
    [ -z "$pkg" ] || read_pkg $pkg
    ;;
  *)
    [ "$pkg" ] || _usage
    read_pkg $pkg
    ;;
esac

if [ "$action" = pkg ]; then
  while getopts "fk" opt; do
    case $opt in
      f)
        MK_FORCE=yes
        ;;
      k)
        MK_KEEP=yes
        ;;
    esac
  done
  unset opt
fi

if is_step $action; then
  run_step $action "$@"
elif is_cmd $action; then
  run_cmd $action "$@"
else
  _usage
fi
