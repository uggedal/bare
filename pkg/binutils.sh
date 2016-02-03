ver 2.25.1
rev 1
dist $URI_GNU/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.bz2

sub binutils-bld type bld
sub binutils-bld rdep binutils

configure \
  --disable-multilib \
  --disable-nls \
  --disable-werror \
  --build=$MK_BUILD_TRIPLE \
  --host=$MK_HOST_TRIPLE \
  --target=$MK_TARGET_TRIPLE

pre_configure() {
  ed configure <<EOF
,s|MAKEINFO="\$MISSING makeinfo"|MAKEINFO=true|g
w
q
EOF
}
