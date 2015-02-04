umask 022
export LC_ALL=C

[ "$MK_NPROC" ] ||
  MK_NPROC=$(printf -- '%s\n' /sys/devices/system/cpu/cpu[0-9]* | wc -l)

CC=cc

export CFLAGS='-Os -pipe'
export CXXFLAGS="$CFLAGS"

MK_PREFIX=/usr
MK_DESTDIR=$_DEST/$fullname

MK_FILE=$_FILE/$parentname
MK_PATCH=$_PATCH/$parentname

MK_BUILD_ROOT=$_BUILD/$fullname
MK_SRC=$MK_BUILD_ROOT/$parentname-$ver
MK_BUILD=$MK_SRC

mkdir -p $MK_BUILD_ROOT

if [ "$builddir" ]; then
  MK_BUILD=$MK_BUILD_ROOT/$builddir
  mkdir -p $MK_BUILD
fi

MK_CONFIGURE="
  --prefix=$MK_PREFIX
  --sysconfdir=/etc
  --localstatedir=/var
  --mandir=/usr/share/man
  "

case $name in
  bootstrap-*)
    MK_ARCH=$(uname -m)
    MK_KERNEL_ARCH=$(printf -- '%s' $MK_ARCH | sed 's/-.*//')
    MK_TARGET=$MK_ARCH-linux-musl
    MK_HOST="$($CC -dumpmachine | sed 's/-[^-]*/-cross/')"

    MK_CONFIGURE="
      $MK_CONFIGURE
      --target=$MK_TARGET
      --with-sysroot=$MK_PREFIX/$MK_TARGET
      "
    ;;
esac
