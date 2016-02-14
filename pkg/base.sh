ver 0.0.1

rdep \
	hier \
	sbase \
	ubase \
	ksh \
	awk \
	diff \
	compress \
	xz \
	pkg

builddir .

do_install() {
	mkdir -p $MK_DESTDIR
}
