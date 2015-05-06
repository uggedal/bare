cmd_contain() {
  local conf=$_CHROOT/etc/pkg.conf

  printf 'REPO=%s\n' /host/repo > $conf

  env -i \
    PATH="/usr/bin:/usr/sbin:/bin:/sbin" \
    PS1='[chroot] \w \$ ' \
    VISUAL=vi \
    HOME=/root \
    HOSTDIR=$(pwd) \
    $_CROSS/bin/pkg-contain $_CHROOT /bin/ksh

  rm -f $conf
}
