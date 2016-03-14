MK_HOST_STEPS='
	prep
	fetch
	deppkg
	contain
	bdepinstall
	'

MK_STEPS="
	$MK_HOST_STEPS
	checksum
	extract
	patch
	configure
	build
	install
	sub
	optimize
	validate
	pkg
"

PKG_REQUIRED_VARS='
	name
	ver
	epoc
	'

PKG_OPTIONAL_VARS='
	dist
	bdep
	rdep
	lib
	style
	configure
	distdir
	builddir
	emptydirs
	patchflag
	'

PKG_VARS="
	$PKG_REQUIRED_VARS
	$PKG_OPTIONAL_VARS
	"

PKG_COMPUTED_VARS='
	qualified_name
	parent_name
	qualified_parent_name
	'

PKG_SUB_VARS='
	type
	mv
	rdep
	lib
	pkgorder
	'

PKG_EXT=.txz
PKG_NAME_MAX=20

URI_GNU=http://ftp.hosteurope.de/mirror/ftp.gnu.org/gnu
URI_SF=http://downloads.sourceforge.net/sourceforge
URI_LINUX=https://www.kernel.org/pub/linux
