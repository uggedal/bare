cmd_contain() {
  local conf=$_CONTAIN/etc/pkg.conf

  printf 'REPO=%s\n' /host/repo > $conf

  env -i \
    PS1='[contain] \w \$ ' \
    HOME=/root \
    HOSTDIR=$(pwd) \
    $_BOOTSTRAP_CROSS/bin/pkg-contain $_CONTAIN /bin/ksh -l

  rm -f $conf
}
