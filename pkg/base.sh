ver 0.0.1

rdep \
	hier \
	sbase \
	ubase \
	busybox \
	ksh \
	awk \
	pax \
	diff \
	xz \
	pkg

builddir .

do_install() {
	mkdir -p $MK_DESTDIR
}
