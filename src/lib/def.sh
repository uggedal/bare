PKG_REQUIRED_VARS='
  name
  ver
  rev
  style
  '

PKG_OPTIONAL_VARS='
  dist
  bdep
  rdep
  configure
  builddir
  emptydirs
  '

PKG_VARS="
  $PKG_REQUIRED_VARS
  $PKG_OPTIONAL_VARS
  "

PKG_COMPUTED_VARS='
  fullname
  parentname
  fullparentname
  '

PKG_EXT=.tar.xz

PKG_NAME_MAX=20
