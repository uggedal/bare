ver 2.27.1
epoc 1
dist $URI_LINUX/utils/util-linux/v2.27/util-linux-2.27.1.tar.xz

bdep libcurses-bld kernel-headers

configure \
	--disable-nls \
	--disable-silent-rules \
	--disable-bash-completion \
	--disable-colors-default \
	--disable-makeinstall-chown \
	--enable-all-programs=no \
	--enable-libblkid \
	--enable-libfdisk \
	--enable-libmount \
	--enable-libsmartcols \
	--enable-libuuid \
	--enable-fsck \
	--enable-losetup \
	--enable-partx \
	--enable-pivot_root \
	--with-ncurses

sub libuuid type custom
sub libuuid mv lib/libuuid.so.'*'

sub libuuid-bld type custom
sub libuuid-bld mv \
	usr/include/uuid \
	usr/lib/libuuid.a \
	usr/lib/libuuid.so \
	usr/lib/pkgconfig/uuid.pc \
	usr/share/man/man3/uuid'*'

sub libblkid type custom
sub libblkid mv lib/libblkid.so.'*'

sub libblkid-bld type custom
sub libblkid-bld mv \
	usr/include/blkid \
	usr/lib/libblkid.a \
	usr/lib/libblkid.so \
	usr/lib/pkgconfig/blkid.pc \
	usr/share/man/man3/libblkid.3

sub libfdisk type custom
sub libfdisk mv lib/libfdisk.so.'*'

sub libfdisk-bld type custom
sub libfdisk-bld mv \
	usr/include/libfdisk \
	usr/lib/libfdisk.a \
	usr/lib/libfdisk.so \
	usr/lib/pkgconfig/fdisk.pc

sub libmount type custom
sub libmount mv lib/libmount.so.'*'

sub libmount-bld type custom
sub libmount-bld mv \
	usr/include/libmount \
	usr/lib/libmount.a \
	usr/lib/libmount.so \
	usr/lib/pkgconfig/mount.pc

sub libsmartcols type custom
sub libsmartcols mv lib/libsmartcols.so.'*'

sub libsmartcols-bld type custom
sub libsmartcols-bld mv \
	usr/include/libsmartcols \
	usr/lib/libsmartcols.a \
	usr/lib/libsmartcols.so \
	usr/lib/pkgconfig/smartcols.pc

pre_configure() {
	ed configure <<-EOF
	,s|\(enable_blkid=\)\$ul_default_estate|\1yes
	,s|\(build_blkid=\)no\$|\1yes
	,s|\(enable_fdisk=\)\$ul_default_estate|\1yes
	,s|\(build_fdisk=\)no\$|\1yes
	,s|\(enable_lsblk=\)\$ul_default_estate|\1yes
	,s|\(build_lsblk=\)no\$|\1yes
	,s|\(enable_mkfs=\)\$ul_default_estate|\1yes
	,s|\(build_mkfs=\)no\$|\1yes
	w
	q
	EOF
}
