ver 1.0.6
epoc 1
dist http://bzip.org/$PKG_VER/$PKG_NAME-${PKG_VER}.tar.gz

pre_configure() {
	ed Makefile <<-EOF
	,s/^\(CC\)=\(.*\)\$/\1\?=\2
	,s/^\(AR\)=\(.*\)\$/\1\?=\2
	,s/^\(RANLIB\)=\(.*\)\$/\1\?=\2
	w
	q
	EOF
}

do_build() {
	make -j $MK_NPROC bzip2
}

do_install() {
	install -Dm755 bzip2 $MK_DESTDIR$MK_PREFIX/bin/bzip2
	install -Dm644 bzip2.1 $MK_DESTDIR$MK_MANDIR/man1/bzip2.1

	local l
	for l in bunzip2 bzcat; do
		ln -s bzip2 $MK_DESTDIR$MK_PREFIX/bin/$l
		ln -s bzip2.1 $MK_DESTDIR$MK_MANDIR/man1/${l}.1
	done
}

stale url http://bzip.org/downloads.html
