umask 022
export LC_ALL=C

MK_ARCH=$(uname -m)
MK_TRIPLET=$MK_ARCH-linux-musl

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
  --host=$MK_TRIPLET
  --build=$MK_TRIPLET
  --target=$MK_TRIPLET
  --with-sysroot=$MK_PREFIX/$MK_TRIPLET
  "
