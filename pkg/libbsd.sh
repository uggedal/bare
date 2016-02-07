ver 0.8.2
dist http://libbsd.freedesktop.org/releases/$PKG_NAME-${PKG_VER}.tar.xz

bdep bsd-headers linux-headers

sub libbsd-bld type bld
sub libbsd-bld rdep bsd-headers

pre_configure() {
	ed src/funopen.c <<-EOF
	/^#error /d
	w
	q
	EOF

	ed src/nlist.c <<-EOF
	,s|<a.out.h>|<linux/a.out.h>
	w
	q
	EOF
}
