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

_contain_install() {
  local name=$1
  _manual_install $_CONTAIN $name
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
  local prefix=$_CROSS

  if ! [ -e $prefix/$TRIPLE/usr ]; then
    mkdir -p $prefix/$TRIPLE
    ln -s . $prefix/$TRIPLE/usr
  fi

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
  local name=$1
  local file=$2

  ./mk pkg $name
  if ! [ -e $file ]; then
    _contain_install $name
  fi
}

_bootstrap_contain() {
  local prefix=$_CONTAIN/usr

  export CC=$TRIPLE-gcc
  export CXX=$TRIPLE-g++
  export AR=$TRIPLE-ar
  export AS=$TRIPLE-as
  export LD=$TRIPLE-ld
  export RANLIB=$TRIPLE-ranlib
  export READELF=$TRIPLE-readelf
  export STRIP=$TRIPLE-strip

  _contain_pkg musl $prefix/include/stdio.h
  _contain_pkg linux-headers $prefix/include/linux/inotify.h

  CROSS_COMPILE=$TRIPLE- \
    ./mk pkg busybox
  if ! [ -x $_CONTAIN/bin/busybox ]; then
    _contain_install busybox
  fi

  _contain_pkg sbase $prefix/bin/cp
  _contain_pkg ubase $prefix/bin/passwd
  _contain_pkg ksh $_CONTAIN/bin/sh
  _contain_pkg ed $prefix/bin/ed
  _contain_pkg awk $prefix/bin/awk
  _contain_pkg pax $_CONTAIN/bin/tar
  _contain_pkg bzip2 $prefix/bin/bzip2

  MK_BUILD_TRIPLE=$(gcc -dumpmachine) \
  MK_CONFIGURE="--prefix=/usr" \
    ./mk pkg binutils
  if ! [ -x $prefix/bin/ar ]; then
    _contain_install binutils
  fi

  MK_CONFIGURE="
    --host=$TRIPLE
    --prefix=/usr" \
    ./mk pkg gmp
  if ! [ -e $prefix/lib/libgmp.so ]; then
    _contain_install gmp
  fi

  MK_CONFIGURE="
    --host=$TRIPLE
    --prefix=/usr
    --with-gmp=$prefix" \
    ./mk pkg mpfr
  if ! [ -e $prefix/lib/libmpfr.so ]; then
    _contain_install mpfr
  fi

  MK_CONFIGURE="
    --host=$TRIPLE
    --prefix=/usr
    --with-gmp=$prefix
    --with-mpfr=$prefix" \
    ./mk pkg mpc
  if ! [ -e $prefix/lib/libmpc.so ]; then
    _contain_install mpc
  fi

  MK_BUILD_TRIPLE=$(gcc -dumpmachine) \
  MK_CONFIGURE="
    --prefix=/usr
    --with-gmp=$prefix
    --with-mpfr=$prefix
    --with-mpc=$prefix" \
    ./mk pkg gcc
  if ! [ -x $prefix/bin/gcc ]; then
    _contain_install gcc
  fi

  local bin
  for bin in make xz file; do
    MK_CONFIGURE="
      --host=$TRIPLE
      --prefix=/usr" \
      ./mk pkg $bin
    if ! [ -x $prefix/bin/$bin ]; then
      _contain_install $bin
    fi
  done

  _contain_pkg hier $_CONTAIN/dev
  _contain_pkg pkg $prefix/usr/pkg-contain
}

cmd_bootstrap() {
  TRIPLE=$(./mk query gcc MK_TARGET_TRIPLE)
  PATH=$_CROSS/bin:$PATH

  _bootstrap_reqs
  _bootstrap_fetch
  _bootstrap_cross
  _bootstrap_contain
}
