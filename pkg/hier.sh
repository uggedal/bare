ver 0.0.1
epoc 5

builddir .
emptydirs keep

do_install() {
	local d

	for d in dev etc proc root sys tmp; do
		mkdir -p $MK_DESTDIR/$d
	done

	cp -r $MK_FILE/etc $MK_DESTDIR
}
