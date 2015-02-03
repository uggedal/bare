umask 022
export LC_ALL=C

CC=cc

MK_ARCH=$(uname -m)
MK_TARGET=$MK_ARCH-linux-musl
MK_HOST="$($CC -dumpmachine | sed 's/-[^-]*/-cross/')"

[ "$MK_NPROC" ] ||
  MK_NPROC=$(printf -- '%s\n' /sys/devices/system/cpu/cpu[0-9]* | wc -l)

export CFLAGS='-Os -pipe'

MK_PREFIX=/usr
MK_DESTDIR=$_DEST/$fullname

MK_FILE=$_FILE/$name

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
