cmd_image() {
	local support=$_ROOT/image/support
	local src=$support/src
	local dest=$_ROOT/image/bare-$(date +%Y%m%d).img
	local mnt=$_ROOT/image/mnt
	local mbr=$support/usr/lib/syslinux/mbr.bin
	local bytes_per_sector=512
	local part_start_sector=2048
	local part_start=$(($bytes_per_sector * $part_start_sector))
	local lodev

	mkdir -p $src $mnt

	REPO=$_ROOT/repo $(pkgpath) -ip $support \
		base util-linux e2fsprogs extlinux syslinux-bios

	REPO=$_ROOT/repo $(pkgpath) -ip $src base kernel-vm

	cat <<-EOF >$src/boot/extlinux.conf
	DEFAULT bare

	LABEL bare
		KERNEL vmlinuz
		APPEND root=/dev/sda1 rw init=/bin/sh
	EOF

	dd if=/dev/zero of=$dest bs=1 count=0 seek=$((1024*1024*1024*4))

	fdisk -b $bytes_per_sector $dest <<-EOF
	n
	p
	1
	$part_start_sector
	
	a
	w
	EOF

	dd conv=notrunc if=$mbr of=$dest

	lodev=$(losetup -f)
	sudo sh -c "
	losetup -o$part_start $lodev $dest
	mkfs.ext4 $lodev
	mount $lodev $mnt
	cp -a $src/* $mnt/
	extlinux -i $mnt/boot
	"
	sync
	sudo sh -c "
	umount $mnt
	losetup -d $lodev
	"
	(
		cd $_ROOT/image
		tar -cSf $(basename $dest).tar $(basename $dest)
	)
}
