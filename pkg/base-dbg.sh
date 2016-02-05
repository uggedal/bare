ver 0.0.1
rev 1

rdep \
	base \
	strace

builddir .

do_install() {
	mkdir -p $MK_DESTDIR
}
