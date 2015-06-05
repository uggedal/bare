MK_STEPS='
  prep
  fetch
  deppkg
  contain
  bdepinstall
  fetch
  checksum
  extract
  patch
  configure
  build
  install
  sub
  optimize
  db
  validate
  pkg
'

MK_HOST_STEPS='
  prep
  fetch
  deppkg
  contain
  bdepinstall
  '

PKG_REQUIRED_VARS='
  name
  ver
  rev
  '

PKG_OPTIONAL_VARS='
  dist
  bdep
  rdep
  lib
  configure
  distdir
  builddir
  emptydirs
  patchflag
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

PKG_SUB_VARS='
  type
  mv
  rdep
  lib
  '

URI_GNU=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu
URI_SF=http://downloads.sourceforge.net/sourceforge
URI_BB=https://bitbucket.org
