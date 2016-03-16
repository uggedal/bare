ver 1.42.13
epoc 1
dist $URI_LINUX/kernel/people/tytso/$PKG_NAME/v$PKG_VER/${PKG_NAME}-${PKG_VER}.tar.xz

bdep pkgconf kernel-headers libblkid-bld libuuid-bld

configure \
	--disable-nls \
	--disable-fsck \
	--disable-libblkid \
	--disable-libuuid \
	--disable-uuidd \
	--enable-symlink-install

sub e2fsprogs-extra type custom
sub e2fsprogs-extra mv \
	etc/mke2fs.conf \
	usr/bin/'*' \
	usr/lib/e2initrd_helper \
	usr/sbin/badblocks \
	usr/sbin/debugfs \
	usr/sbin/dumpe2fs \
	usr/sbin/e2freefrag \
	usr/sbin/e2image \
	usr/sbin/e2label \
	usr/sbin/e2undo \
	usr/sbin/e4defrag \
	usr/sbin/filefrag \
	usr/sbin/logsave \
	usr/sbin/mklost+found \
	usr/sbin/resize2fs \
	usr/sbin/tune2fs \
	usr/share/man/man1/'*' \
	usr/share/man/man5/'*' \
	usr/share/man/man8/badblocks.8 \
	usr/share/man/man8/debugfs.8 \
	usr/share/man/man8/dumpe2fs.8 \
	usr/share/man/man8/e2freefrag.8 \
	usr/share/man/man8/e2image.8 \
	usr/share/man/man8/e2label.8 \
	usr/share/man/man8/e2undo.8 \
	usr/share/man/man8/e4defrag.8 \
	usr/share/man/man8/filefrag.8 \
	usr/share/man/man8/logsave.8 \
	usr/share/man/man8/mklost+found.8 \
	usr/share/man/man8/resize2fs.8 \
	usr/share/man/man8/tune2fs.8
