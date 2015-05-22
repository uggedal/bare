_is_last_step_without_keep() {
  [ $step = pkg ] && [ "$MK_KEEP" != yes ]
}

is_step() {
  [ "$(command -v step_$1)" ]
}

run_step() {
  local step=$1
  local s

  if [ $step = pkg ] &&
    [ "$MK_FORCE" != yes ] &&
    [ -s $_REPO/${PKG_QUALIFIED_NAME}$PKG_EXT ]; then
    progress pkg "'$PKG_NAME' $(color 34 complete)"
    return
  fi

  for s in $MK_STEPS; do
    if [ -f $MK_BUILD_ROOT/.${s}.done ]; then
      progress $s "'$PKG_NAME' $(color 34 cached)"
    else
      step_$s
      touch $MK_BUILD_ROOT/.${s}.done
      progress $s "'$PKG_NAME' $(color 32 ok)"
    fi

    if [ "$step" = "$s" ]; then
      break
    fi
  done

  ! _is_last_step_without_keep || run_cmd clean
}

exec_step_contained() {
  local args
  args="$@"

  REPO=$_ROOT/repo $_BOOTSTRAP_CROSS/bin/pkg-install -p $_CONTAIN base-bld

  exec env -i \
    HOSTDIR=$_ROOT \
    MK_CONTAINED=yes \
    $_BOOTSTRAP_CROSS/bin/pkg-contain \
      $_CONTAIN /bin/sh -lc "cd /host && ./mk $args"
}
