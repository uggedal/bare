_bootstrap_reqs() {
	local b h
	local missing

	for b in cc c++ make patch tar xz curl file m4 ed; do
		which $b >/dev/null 2>&1 || missing="$missing $b"
	done

	[ -f /usr/include/archive.h ] ||
		missing="$missing archive.h (libarchive)"

	if [ "$missing" ]; then
		printf "need '%s'\n" $missing
		exit 1
	fi
}

_manual_install() {
	local prefix=$1
	local name=$2

	tar -C $prefix -xJf $(name_to_repo_pkg $name)
}

_prefix_install() {
	local name="$1"
	local prefix=$2
	REPO=$_ROOT/repo pkg -ip $prefix "$name"
}

_build_gcc() {
	local name=$1
	local prefix=$2

	./mk extract $name

	local dep dest
	for dep in gmp mpfr mpc; do
		./mk extract $dep
		dest=$(./mk query $name MK_DIST)/$dep
		[ -h $dest ] || ln -s $(./mk query $dep MK_DIST) $dest
	done

	MK_PREFIX=$prefix \
	MK_CONFIGURE="--prefix=$prefix --with-sysroot=$prefix/$TRIPLE" \
	MK_DESTDIR=no \
		./mk install $name
}

_bootstrap_cross() {
	local prefix=$_BOOTSTRAP_CROSS

	mkdir -p $prefix/$TRIPLE

	if ! [ -x $_BOOTSTRAP_SUPPORT/bin/pkg ]; then
		MK_PREFIX=$_BOOTSTRAP_SUPPORT \
		MK_DESTDIR=no \
			./mk install bootstrap-pkg
	fi

	# file needs the same version on host to cross compile:
	if ! [ -x $_BOOTSTRAP_SUPPORT/bin/file ]; then
		MK_PREFIX=$_BOOTSTRAP_SUPPORT \
		MK_DESTDIR=no \
			./mk install bootstrap-file
	fi

	if ! [ -x $prefix/bin/$TRIPLE-ar ]; then
		MK_PREFIX=$prefix \
		MK_CONFIGURE="--prefix=$prefix --with-sysroot=$prefix/$TRIPLE" \
		MK_DESTDIR=no \
			./mk install bootstrap-binutils
	fi

	if ! [ -x $prefix/bin/$TRIPLE-gcc ]; then
		_build_gcc bootstrap-gcc-1 $prefix
	fi

	if ! [ -e $prefix/$TRIPLE/include/stdio.h ]; then
		CROSS_COMPILE=$TRIPLE- \
		CC=$TRIPLE-gcc \
		MK_CONFIGURE="--prefix=" \
		MK_DESTDIR=$prefix/$TRIPLE \
			./mk install bootstrap-musl
	fi

	if ! [ -x $prefix/bin/$TRIPLE-g++ ]; then
		_build_gcc bootstrap-gcc-2 $prefix
	fi
}

_contain_pkg() {
	local name

	for name; do
		./mk pkg $name
	done
}

_bootstrap_contain() {
	local prefix=$_BOOTSTRAP_NATIVE/usr
	local p

	export CC=$TRIPLE-gcc
	export CXX=$TRIPLE-g++
	export AR=$TRIPLE-ar
	export AS=$TRIPLE-as
	export LD=$TRIPLE-ld
	export RANLIB=$TRIPLE-ranlib
	export READELF=$TRIPLE-readelf
	export STRIP=$TRIPLE-strip

	_contain_pkg musl
	_prefix_install musl $_BOOTSTRAP_NATIVE

	MK_BUILD_TRIPLE=$(gcc -dumpmachine) \
	MK_CONFIGURE="--prefix=/usr" \
		./mk pkg binutils

	MK_CONFIGURE="
		--host=$TRIPLE
		--prefix=/usr" \
		./mk pkg gmp
	_prefix_install gmp-bld $_BOOTSTRAP_NATIVE

	MK_CONFIGURE="
		--host=$TRIPLE
		--prefix=/usr
		--with-gmp=$prefix" \
		./mk pkg mpfr
	_prefix_install mpfr-bld $_BOOTSTRAP_NATIVE

	MK_CONFIGURE="
		--host=$TRIPLE
		--prefix=/usr
		--with-gmp=$prefix
		--with-mpfr=$prefix" \
		./mk pkg mpc
	_prefix_install mpc-bld $_BOOTSTRAP_NATIVE

	MK_BUILD_TRIPLE=$(gcc -dumpmachine) \
	MK_CONFIGURE="
		--prefix=/usr
		--with-gmp=$prefix
		--with-mpfr=$prefix
		--with-mpc=$prefix" \
		./mk pkg gcc

	for p in bsd-headers kernel-headers; do
		_contain_pkg $p
		_prefix_install $p $_BOOTSTRAP_NATIVE
	done

	for p in libbsd libz libarchive; do
		CPPFLAGS="-isystem $prefix/include" \
		MK_CONFIGURE="
			--host=$TRIPLE
			--prefix=/usr" \
			./mk pkg $p
		_prefix_install $p-bld $_BOOTSTRAP_NATIVE
	done

	for p in make xz file; do
		MK_CONFIGURE="
			--host=$TRIPLE
			--prefix=/usr" \
			./mk pkg $p
	done
	_prefix_install liblzma-bld $_BOOTSTRAP_NATIVE

	export CPPFLAGS="$CPPFLAGS -isystem $prefix/include"
	export LDFLAGS="$LDFLAGS -L$prefix/lib"
	_contain_pkg pkg ksh patch diff compress ed sbase
	unset MK_NO_DEP
	_contain_pkg base-bld
}

_bootstrap_clean() {
	rm -r $_BOOTSTRAP_CROSS $_BOOTSTRAP_NATIVE
}

cmd_bootstrap() {
	TRIPLE=$(./mk query gcc MK_TARGET_TRIPLE)
	PATH=$_BOOTSTRAP_SUPPORT/bin:$_BOOTSTRAP_CROSS/bin:$PATH

	export MK_NO_DEP=yes
	export MK_NO_CONTAIN=yes

	# If host has GNU tar we use a sane format so that we
	# potentially can enable sbase tar in the future:
	export TAR_OPTIONS=--format=posix

	_bootstrap_reqs
	_bootstrap_cross
	_bootstrap_contain
	[ "$MK_KEEP" ] || _bootstrap_clean
}
