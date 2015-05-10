cmd_contain() {
  local conf=$_CONTAIN/etc/pkg.conf

  printf 'REPO=%s\n' /host/repo > $conf

  env -i \
    PATH="/usr/bin:/usr/sbin:/bin:/sbin" \
    PS1='[contain] \w \$ ' \
    VISUAL=vi \
    HOME=/root \
    HOSTDIR=$(pwd) \
    $_CROSS/bin/pkg-contain $_CONTAIN /bin/ksh

  rm -f $conf
}
