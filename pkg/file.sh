ver 5.22
rev 1
dist ftp://ftp.astron.com/pub/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz

sub libmagic type lib

sub libmagic-bld type bld
sub libmagic-bld rdep libmagic

pre_configure() {
  cp -f $MK_FILE/config.sub .
}

post_configure() {
  # Ignore check for equal host version of file:
  ed magic/Makefile <<EOF
,s/if expr/if true ||
w
q
EOF
}
