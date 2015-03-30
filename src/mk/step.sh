is_step() {
  [ "$(command -v step_$1)" ]
}

run_step() {
  local step=$1
  local deps=
  local s d

  for s in $MK_STEPS; do
    deps="$deps $s"

    if [ "$step" = "$s" ]; then
      break
    fi
  done

  if [ $step = pkg ] &&
    [ "$MK_FORCE" != yes ] &&
    [ -s $_REPO/${PKG_FULLNAME}$PKG_EXT ]; then
    progress pkg "'$PKG_NAME' $(color 34 complete)"
    return
  fi

  for d in $deps; do
    if [ -f $MK_BUILD_ROOT/.${d}.done ]; then
      progress $d "'$PKG_NAME' $(color 34 cached)"
      continue
    fi

    step_$d "$@"
    touch $MK_BUILD_ROOT/.${d}.done
    progress $d "'$PKG_NAME' $(color 32 ok)"
  done
}
