bootstrap_install() {
  local p=$1

  read_pkg $p

  $_ROOT/mk pkg $p

  local t=$_REPO/${fullname}.tar.xz
  tar -C $_BOOTSTRAP -xJf $t
}

step_bootstrap() {
  local p d b p
  local toolchain=opt/toolchain
  local hosttools='ar as nm cc make ld gcc g++ objdump xz curl perl'

  for p in toybox busybox binutils; do
    bootstrap_install $p
  done

  local OPATH=$PATH
  PATH=
  for d in sbin bin usr/sbin usr/bin $toolchain; do
    PATH=${PATH:+$PATH:}$_BOOTSTRAP/$d
  done

  mkdir -p $_BOOTSTRAP/$toolchain

  for b in $hosttools; do
    p=$(PATH=$OPATH which $b)
    [ -e $p ] || die "bootstrap needs '$b' in host"
    ln -sf $p $_BOOTSTRAP/$toolchain/$b
  done

  for p in gcc linux; do
    bootstrap_install $p
  done

  PATH=$OPATH
}
