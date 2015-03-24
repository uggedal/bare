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

  if [ $step = pkg ] && [ -s $_REPO/${fullname}$PKG_EXT ]; then
    progress pkg "'$name' $(color 34 complete)"
    return
  fi

  for d in $deps; do
    if [ -f $MK_BUILD_ROOT/.${d}.done ]; then
      progress $d "'$name' $(color 34 cached)"
      continue
    fi

    step_$d "$@"
    touch $MK_BUILD_ROOT/.${d}.done
    progress $d "'$name' $(color 32 ok)"
  done
}
