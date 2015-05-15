#!/bin/sh

[ -r @@SYSCONFDIR@@/pkg.conf ] && . @@SYSCONFDIR@@/pkg.conf
. @@LIBDIR@@/pkg/def.sh
. @@LIBDIR@@/pkg/pkg.sh
. @@LIBDIR@@/pkg/msg.sh

_USAGE='[-v[v]] [-f] [-d] [-p root_prefix]
name ...'

VERBOSE=0

DB_TYPE=explicit

while getopts "p:vfd" opt; do
  case $opt in
    p)
      PREFIX=$OPTARG
      ;;
    v)
      VERBOSE=$(($VERBOSE + 1))
      ;;
    f)
      FORCE=yes
      ;;
    d)
      DEPENDENCY=yes
      DB_TYPE=dependency
      ;;
  esac
done
unset opt
shift $(( $OPTIND - 1 ))

handle_deps() {
  local t=$1
  local f1=$2

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

  # TODO: pass same flags as calle (except pkg(s) and don't add second
  # -d on recursion
  # TODO: collect all deps and fork off once?
  PREFIX=$PREFIX $0 -d $name || exit $?
}

handle_pkg() {
  local name=$1
  local ver=$2
  local qualified_name=$3
  local f=$4

  [ "$PKG" = "$name" ] || return 0

  local installedmsg="'$PKG' already installed"
  [ -z "$DEPENDENCY" ] || installedmsg="$installedmsg (dependency)"
  local installmsg="installing '$PKG'"
  [ -z "$DEPENDENCY" ] || installmsg="$installmsg (dependency)"

  if pkg_installed $PREFIX $PKG; then
    if [ "$DEPENDENCY" ]; then
      msg "$installedmsg"
      INSTALLED=yes
      return 0
    fi

    [ "$FORCE" ] || die "$installedmsg"
  fi

  [ "$VERBOSE" -le 0 ] || msg "$installmsg"

  [ "$VERBOSE" -le 1 ] || tar -tJf $REPO/$f

  local tmp=$PREFIX$PKG_TMP/$qualified_name

  rm -rf $tmp
  mkdir -p $tmp

  tar -C $tmp -xJf $REPO/$f

  read_db $tmp $name handle_deps

  dir_merge $tmp $PREFIX

  rm -rf $tmp

  local record=$(pkg_db $PREFIX $name $DB_TYPE)
  mkdir -p $(dirname $record)
  ln -s ../$name $record

  INSTALLED=yes
}

[ "$REPO" ] || usage

: ${PREFIX:=/}

for PKG; do
  unset INSTALLED
  read_repo $REPO handle_pkg
  [ "$INSTALLED" ] || die "no package named '$PKG'"
done
unset PKG
