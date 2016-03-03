ver 6.03
dist https://www.kernel.org/pub/linux/utils/boot/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.xz

bdep kernel-headers nasm perl

sub syslinux-bios type custom
sub syslinux-bios mv usr/lib/syslinux/'*'.c32

sub syslinux-efi type custom
sub syslinux-efi mv usr/lib/syslinux/efi64

sub syslinux-mbr type custom
sub syslinux-mbr mv usr/lib/syslinux/*mbr.bin

sub extlinux type custom
sub extlinux mv \
	sbin/extlinux \
	usr/share/man/man1/extlinux.1

sub isolinux type custom
sub isolinux mv \
	usr/lib/syslinux/isolinux.bin \
	usr/lib/syslinux/isohd'*'x.bin

sub pxelinux type custom
sub pxelinux mv \
	usr/lib/syslinux/isolinux.bin \
	usr/lib/syslinux/'*'pxelinux.0

sub syslinux-utils type custom
sub syslinux-utils mv \
	usr/bin/gethostip \
	usr/bin/keytab-lilo \
	usr/bin/lss16toppm \
	usr/bin/md5pass \
	usr/bin/memdiskfind \
	usr/bin/mkdiskimage \
	usr/bin/ppmtolss16 \
	usr/bin/pxelinux-options \
	usr/bin/sha1pass \
	usr/bin/syslinux2ansi \
	usr/share/man/man1/gethostip.1 \
	usr/share/man/man1/keytab-lilo.1 \
	usr/share/man/man1/lss16toppm.1 \
	usr/share/man/man1/md5pass.1 \
	usr/share/man/man1/memdiskfind.1 \
	usr/share/man/man1/mkdiskimage.1 \
	usr/share/man/man1/ppmtolss16.1 \
	usr/share/man/man1/pxelinux-options.1 \
	usr/share/man/man1/sha1pass.1 \
	usr/share/man/man1/syslinux2ansi.1

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
