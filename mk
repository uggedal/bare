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

for _dir in \
  bootstrap/cross \
  bootstrap/native \
  bootstrap/support \
  build \
  cache \
  contain \
  db \
  dest \
  dist \
  repo; do
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
  link <pkg>
  query <pkg> <field>
  bootstrap [-k]
  enter

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

if is_step $action && use_contain; then
  run_step_contained $action $pkg "$@"
  exit $?
fi

case "$action" in
  bootstrap|enter)
    :
    ;;
  clean)
    [ -z "$pkg" ] || read_pkg $pkg
    ;;
  *)
    [ "$pkg" ] || _usage
    read_pkg $pkg
    ;;
esac

[ "$action" != link ] || MK_NO_SUB_VALIDATION=yes

case $action in
  pkg|bootstrap)
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
    ;;
esac

if is_step $action; then
  run_step $action "$@"
elif is_cmd $action; then
  run_cmd $action "$@"
else
  _usage
fi
