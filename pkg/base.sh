ver 0.0.1

rdep \
	hier \
	sbase \
	ubase \
	busybox \
	ksh \
	ed \
	awk \
	pax \
	xz \
	pkg

builddir .

do_install() {
	mkdir -p $MK_DESTDIR
}
