is_step() {
  [ "$(command -v step_$1)" ]
}

is_host_step() {
  local step=$1
  local s

  for s in $MK_HOST_STEPS; do
    if [ "$s" = "$step" ]; then
      return 0
    fi
  done

  return 1
}

_exec_step() {
  local step=$1

  if [ -f $MK_BUILD_ROOT/.${step}.done ]; then
    progress $step "'$PKG_NAME' $(color 34 cached)"
  else
    if is_host_step $step || ! use_contain; then
      step_$step
      touch $MK_BUILD_ROOT/.${step}.done
      progress $step "'$PKG_NAME' $(color 32 ok)"
    else
      contain_mk -n$MK_FLAGS $step $PKG_NAME
    fi
  fi
}

run_step() {
  local step=$1
  local pkg=$2
  local s

  read_pkg $pkg

  if [ $step = pkg ] &&
    [ "$MK_FORCE" != yes ] &&
    [ -s $_REPO/${PKG_QUALIFIED_NAME}$PKG_EXT ]; then
    progress pkg "'$PKG_NAME' $(color 34 complete)"
    return
  fi

  if [ "$MK_NO_STEP_DEP" ]; then
    _exec_step $step
  else
    for s in $MK_STEPS; do
      _exec_step $s

      if [ "$step" = "$s" ]; then
        break
      fi
    done

    if [ $step = pkg ] && [ "$MK_KEEP" != yes ]; then
      if use_contain; then
        contain_mk clean $PKG_NAME
        _clean_contain
      else
        run_cmd clean $PKG_NAME
      fi
    fi
  fi
}
