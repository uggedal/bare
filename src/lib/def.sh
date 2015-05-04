PKG_REQUIRED_VARS='
  name
  ver
  rev
  '

PKG_OPTIONAL_VARS='
  dist
  bdep
  rdep
  configure
  distdir
  builddir
  emptydirs
  '

PKG_VARS="
  $PKG_REQUIRED_VARS
  $PKG_OPTIONAL_VARS
  "

PKG_COMPUTED_VARS='
  qualified_name
  parent_name
  qualified_parent_name
  '

PKG_EXT=.tar.xz

PKG_NAME_MAX=20

PKG_DB=var/db/pkg
PKG_TMP=var/tmp/pkg
