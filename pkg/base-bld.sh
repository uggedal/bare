ver 0.0.1
epoc 1

rdep \
	base \
	musl-bld \
	bzip2 \
	binutils \
	gcc \
	make \
	patch \
	file

builddir .

do_install() {
	mkdir -p $MK_DESTDIR
}
