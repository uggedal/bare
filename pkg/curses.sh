ver 0.0.1
epoc 1
_name=netbsd-curses-v${PKG_VER}
dist http://ftp.barfooze.de/pub/sabotage/tarballs/${_name}.tar.xz

distdir $_name

sub libcurses type custom
sub libcurses mv usr/lib/'*'.so

sub libcurses-bld type bld
sub libcurses-bld rdep libcurses

post_install() {
	rm $MK_DESTDIR$MK_PREFIX/bin/clear
}
