ver 5.2.1
rev 1
dist http://tukaani.org/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.xz

configure \
  --disable-nls \
  --disable-doc

sub liblzma type lib

sub liblzma-bld type bld
sub liblzma-bld rdep liblzma

stale ignore 'b$'
