run_style() {
  local style=$1
  local func=$2

  . $_SRC/mk/style_${style}.sh

  if [ "$(command -v pre_$func)" ]; then
    pre_$func
  fi

  if [ "$(command -v do_$func)" ]; then
    do_$func
  else
    ${style}_default_$func
  fi

  if [ "$(command -v post_$func)" ]; then
    post_$func
  fi
}
