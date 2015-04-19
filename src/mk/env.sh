pre_env() {
  : ${CC:=gcc}

  MK_ARCH=$(uname -m)
  MK_KERNEL_ARCH=$(printf -- '%s' $MK_ARCH | sed 's/-.*//')

  : ${MK_BUILD_TRIPLE:=$($CC -dumpmachine)}
  : ${MK_HOST_TRIPLE:=$($CC -dumpmachine)}
  : ${MK_TARGET_TRIPLE:=$MK_ARCH-bare-linux-musl}
}

post_env() {
  umask 022
  export LC_ALL=C

  : ${CFLAGS:='-Os -pipe'}
  : ${CXXFLAGS:=$CFLAGS}
  export CFLAGS CXXFLAGS CC

  : ${MK_PREFIX:=/usr}

  if [ "$MK_DESTDIR" = no ]; then
    unset MK_DESTDIR
  else
    : ${MK_DESTDIR:=$_DEST/$PKG_FULLNAME}
  fi

  MK_FILE=$_FILE/$PKG_PARENTNAME
  MK_PATCH=$_PATCH/$PKG_PARENTNAME

  MK_BUILD_ROOT=$_BUILD/$PKG_FULLNAME

  if [ "$PKG_DISTDIR" ]; then
    MK_DIST=$MK_BUILD_ROOT/$PKG_DISTDIR
  else
    MK_DIST=$MK_BUILD_ROOT/$PKG_PARENTNAME-$PKG_VER
  fi

  MK_BUILD=$MK_DIST

  mkdir -p $MK_BUILD_ROOT

  if [ "$PKG_BUILDDIR" ]; then
    MK_BUILD=$MK_BUILD_ROOT/$PKG_BUILDDIR
    mkdir -p $MK_BUILD
  fi

  : ${MK_CONFIGURE:="
    --prefix=$MK_PREFIX
    --sysconfdir=/etc
    --localstatedir=/var
    --mandir=/usr/share/man
    "}
}
