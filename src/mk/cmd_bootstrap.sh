_bootstrap_reqs() {
  local b
  local missing

  for b in cc c++ make patch tar xz curl file m4 ed; do
    which $b >/dev/null 2>&1 || missing="$missing $b"
  done

  if [ "$missing" ]; then
    printf "need '%s'\n" $missing
    exit 1
  fi
}

_bootstrap_fetch() {
  local deps='
    binutils
    gmp
    mpfr
    mpc
    gcc
    linux-headers
    musl
    busybox
    make
    xz
    file
    sbase
    ubase
    ksh
    ed
    awk
    pax
    bzip2
  '
  local d

  for d in $deps; do
    ./mk fetch $d
  done
}

_manual_install() {
  local prefix=$1
  local name=$2

  tar -C $prefix -xJf repo/$(./mk query $name qualified_name).tar.xz
}

_prefix_install() {
  local name="$1"
  local prefix=$2
  REPO=repo pkg-install -p $prefix "$name"
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
  MK_CONFIGURE="--prefix=$prefix" \
  MK_DESTDIR=no \
    ./mk install $name
}

_bootstrap_cross() {
  local prefix=$_BOOTSTRAP_CROSS

  mkdir -p $prefix/$TRIPLE

  if ! [ -x $prefix/bin/pkg-contain ]; then
    MK_PREFIX=$prefix \
    MK_DESTDIR=no \
      ./mk install bootstrap-pkg
  fi

  ./mk pkg linux-headers
  if ! [ -e $prefix/$TRIPLE/include/linux/inotify.h ]; then
    _manual_install $prefix/$TRIPLE linux-headers
    mv $prefix/$TRIPLE/usr/include $prefix/$TRIPLE
    rmdir $prefix/$TRIPLE/usr
  fi

  if ! [ -x $prefix/bin/$TRIPLE-ar ]; then
    MK_PREFIX=$prefix \
    MK_CONFIGURE="--prefix=$prefix" \
    MK_DESTDIR=no \
      ./mk install bootstrap-binutils
  fi

  if ! [ -x $prefix/bin/$TRIPLE-gcc ]; then
    _build_gcc bootstrap-gcc-1 $prefix
  fi


  if ! [ -e $prefix/$TRIPLE/include/stdio.h ]; then
    MK_PREFIX=$prefix/$TRIPLE \
    CROSS_COMPILE=$TRIPLE- \
    CC=$TRIPLE-gcc \
    MK_CONFIGURE="--prefix=$prefix/$TRIPLE" \
    MK_DESTDIR=no \
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

  _contain_pkg linux-headers
  _prefix_install linux-headers $_BOOTSTRAP_NATIVE

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

  local bin
  for bin in make xz file; do
    MK_CONFIGURE="
      --host=$TRIPLE
      --prefix=/usr" \
      ./mk pkg $bin
  done

  CROSS_COMPILE=$TRIPLE- \
    ./mk pkg busybox

  _contain_pkg \
    sbase \
    ubase \
    ksh \
    ed \
    awk \
    pax \
    bzip2 \
    hier \
    pkg \
    base \
    base-bld
}

cmd_bootstrap() {
  TRIPLE=$(./mk query gcc MK_TARGET_TRIPLE)
  PATH=$_BOOTSTRAP_CROSS/bin:$PATH

  export MK_BOOTSTRAP=yes

  _bootstrap_reqs
  _bootstrap_fetch
  _bootstrap_cross
  _bootstrap_contain
}
