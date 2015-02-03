bootstrap_install() {
  local p=$1

  read_pkg $p
  t=$_REPO/${fullname}.tar.xz

  [ -f $t ] || $_ROOT/mk pkg $p

  tar -C $_BOOTSTRAP -xJf $t
}

step_bootstrap() {
  local p t d b p
  local toolchain=opt/toolchain

  for p in toybox busybox binutils; do
    bootstrap_install $p
  done

  local OPATH=$PATH
  PATH=
  for d in sbin bin usr/sbin usr/bin $toolchain; do
    PATH=${PATH:+$PATH:}$_BOOTSTRAP/$d
  done

  mkdir -p $_BOOTSTRAP/$toolchain

  for b in ar as nm cc make ld gcc g++ objdump; do
    p=$(PATH=$OPATH which $b)
    [ -e $p ] || die "bootsrrap needs '$b' in host"
    ln -sf $p $_BOOTSTRAP/$toolchain/$b
  done

  for p in gcc; do
    bootstrap_install $p
  done

  PATH=$OPATH
}
