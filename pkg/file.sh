ver 5.24
epoc 1
dist ftp://ftp.astron.com/pub/$PKG_NAME/$PKG_NAME-${PKG_VER}.tar.gz

sub libmagic type lib

sub libmagic-bld type bld
sub libmagic-bld rdep libmagic

pre_configure() {
	cp -f $MK_FILE/config.sub .
}
