ver 6.03
epoc 1
dist https://www.kernel.org/pub/linux/utils/boot/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.xz

bdep kernel-headers nasm perl

sub syslinux-bios type custom
sub syslinux-bios mv \
	usr/lib/syslinux/'*'.c32 \
	usr/lib/syslinux/*mbr.bin \
	usr/lib/syslinux/memdisk

sub syslinux-efi type custom
sub syslinux-efi mv usr/lib/syslinux/efi64

sub extlinux type custom
sub extlinux mv \
	sbin/extlinux \
	usr/share/man/man1/extlinux.1

sub isolinux type custom
sub isolinux mv usr/lib/syslinux/isolinux.bin \
	usr/lib/syslinux/isohd'*'x.bin

sub pxelinux type custom
sub pxelinux mv usr/lib/syslinux/'*'pxelinux.0

pre_configure() {
	ed Makefile <<-"EOF"
	,s|diag libinstaller dos win32 win64 dosutil txt$|libinstaller txt
	,s|win32/syslinux\.exe win64/syslinux64\.exe|
	,s|dosutil/\*\.com dosutil/\*\.sys|
	,s|dos/syslinux\.com|
	,s|^\(INSTALLSUBDIRS = com32 utils\) dosutil|\1
	g/INSTALL_AUX_OPT/d
	/install -m 644 -c $(INSTALL_DIAG)/d
	,s|\(install .*\)-c|\1|
	w
	q
	EOF
}

do_build() {
	env CFLAGS= LDFLAGS= make -j1 bios efi64 installer
}

do_install() {
	make -j1 \
		INSTALLROOT=$MK_DESTDIR \
		DATADIR=$MK_PREFIX/lib \
		MANDIR=$MK_MANDIR \
		bios efi64 install

	(
		cd $MK_DESTDIR$MK_PREFIX/lib/syslinux
		rm -r \
			com32 \
			*_c.bin \
			*_f.bin \
			isolinux-debug.bin \
			gpxelinuxk.0
	)
	rm $MK_DESTDIR$MK_MANDIR/man1/isohybrid.1
}
