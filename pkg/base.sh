ver 0.0.1
epoc 1

rdep \
	hier \
	sbase \
	ubase \
	ksh \
	awk \
	diff \
	ed \
	bsdtar \
	compress \
	xz \
	pkg

builddir .

do_install() {
	mkdir -p $MK_DESTDIR
}
