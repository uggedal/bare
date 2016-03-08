ver 5.22.1
epoc 1
dist http://www.cpan.org/src/5.0/$PKG_NAME-$PKG_VER.tar.gz

do_configure() {
	./Configure \
	    -des \
	    -Dprefix=$MK_PREFIX \
	    -Dvendorprefix=$MK_PREFIX\
	    -Dprivlib=$MK_PREFIX/share/perl5/core_perl \
	    -Darchlib=$MK_PREFIX/lib/perl5/core_perl \
	    -Dsitelib=$MK_PREFIX/local/share/perl5/site_perl \
	    -Dsitearch=$MK_PREFIX/local/lib/perl5/site_perl \
	    -Dvendorlib=$MK_PREFIX/share/perl5/vendor_perl \
	    -Dvendorarch=$MK_PREFIX/lib/perl5/vendor_perl \
	    -Dscriptdir=$MK_PREFIX/bin \
	    -Dsitescript=$MK_PREFIX/bin \
	    -Dvendorscript=$MK_PREFIX/bin \
	    -Dinc_version_list=none \
	    -Dman1dir=$MK_MANDIR/man1 \
	    -Dman1ext=1 \
	    -Dman3dir=$MK_MANDIR/man3 \
	    -Dman3ext=3p
}

post_install() {
	# Symlink in stead of hardlink
	ln -sf perl$PKG_VER $MK_DESTDIR$MK_PREFIX/bin/perl

	rm $MK_DESTDIR$MK_PREFIX/lib/perl5/core_perl/.packlist

	find $MK_DESTDIR$MK_PREFIX -name \*.pod | xargs rm
	rm -r $MK_DESTDIR$MK_MANDIR/man3

	local f
	for f in $(find $MK_DESTDIR$MK_MANDIR/man1 -type f); do
		[ -x $MK_DESTDIR$MK_PREFIX/bin/$(basename $f .1) ] ||
			rm $f
	done
}

stale ignore '[13579]\.[0-9][0-9]*$'
