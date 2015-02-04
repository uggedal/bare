umask 022
export LC_ALL=C

CC=cc

MK_ARCH=$(uname -m)
# TODO: only for bootstrap?:
MK_TARGET=$MK_ARCH-linux-musl
# TODO: only for bootstrap:
MK_HOST="$($CC -dumpmachine | sed 's/-[^-]*/-cross/')"

[ "$MK_NPROC" ] ||
  MK_NPROC=$(printf -- '%s\n' /sys/devices/system/cpu/cpu[0-9]* | wc -l)

export CFLAGS='-Os -pipe'

MK_PREFIX=/usr
MK_DESTDIR=$_DEST/$fullname

MK_FILE=$_FILE/$name
MK_PATCH=$_PATCH/$name

MK_BUILD_ROOT=$_BUILD/$fullname
MK_SRC=$MK_BUILD_ROOT/$name-$ver
MK_BUILD=$MK_SRC

mkdir -p $MK_BUILD_ROOT

if [ "$builddir" ]; then
  MK_BUILD=$MK_BUILD_ROOT/$builddir
  mkdir -p $MK_BUILD
fi

# TOOD: --host/--build/--target is only for bootstrap
MK_CONFIGURE="
  --prefix=$MK_PREFIX
  --sysconfdir=/etc
  --localstatedir=/var
  --mandir=/usr/share/man
  --host=$MK_HOST
  --build=$MK_HOST
  --target=$MK_TARGET
  --with-sysroot=$MK_PREFIX/$MK_TRIPLET
  "
