run_step() {
  local step=$1
  local deps=
  local hasdeps=
  local s d
  local steps='
    verify
    extract
    patch
    configure
    build
    install
    optimize
    validate
    pkg
    '
  for s in $steps; do
    deps="$deps $s"

    if [ "$step" = "$s" ]; then
      hasdeps=yes
      break
    fi
  done

  if [ "$hasdeps" ]; then
    if [ $step = pkg ] && [ -s $_REPO/${fullname}.tar.xz ]; then
      progress pkg "'$name' $(color 34 complete)"
      return
    fi
  else
    deps=$step
  fi

  for d in $deps; do
    if [ -f $MK_BUILD_ROOT/.${d}.done ]; then
      progress $d "'$name' $(color 34 cached)"
      continue
    fi

    step_$d "$@"
    if [ "$hasdeps" ]; then
      touch $MK_BUILD_ROOT/.${d}.done
      progress $d "'$name' $(color 32 ok)"
    fi
  done
}
