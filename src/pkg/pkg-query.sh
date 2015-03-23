#!/bin/sh

. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

usage() {
  local bin=$(basename $0)
  cat <<EOF
Usage: $bin -r <repo> [-v]

Example:

    $bin -r /tmp/repo
EOF
  exit 1
}

query_line() {
  local p=$1

  if [ "$VERBOSE" ]; then
    printf -- "%-${PKG_NAME_MAX}s %s\n" $(pkg_to_name $p) $(pkg_to_version $p)
  else
    printf -- '%s\n' $(pkg_to_name $p)
  fi
}

query() {
  # TODO: tweak die to not print >>> (global var for mk)
  [ -d $REPO ] || die "unable to read repo: '$REPO'"

  local f

  for f in $REPO/*$PKG_EXT; do
    query_line $(basename $f)
  done
}

while getopts "r:vh" opt; do
  case $opt in
    r)
      REPO=$OPTARG
      ;;
    h)
      usage
      ;;
    v)
      VERBOSE=yes
      ;;
  esac
done
unset opt

[ "$REPO" ] || usage

query
