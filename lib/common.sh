msg() {
  printf -- '%s\n' "$@" 1>&2
}

err() {
  printf -- 'mk: %s\n' "$@" 1>&2
}

die() {
  err "$@"
  exit 1
}

read_pkg() {
  # TODO: sanity check for variables
  # TODO: unsetting of variables before read

  name=$1
  pkgfile=$_PKG/${name}.sh

  [ -r "$pkgfile" ] || die "no file for '$name' ($pkgfile)"
  . $pkgfile

  fullname=$name-${ver}_$rev
}
