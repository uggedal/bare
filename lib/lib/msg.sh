if [ -t 2 ] && tput colors >/dev/null 2>&1; then
  _USE_COLOR=yes
fi

strong() {
  if [ "$_USE_COLOR" ]; then
    printf -- '\033[1m%s\033[0m\n' "$@"
  else
    printf -- '%s' "$@"
  fi
}

color() {
  local n=$1
  shift

  if [ "$_USE_COLOR" ]; then
    printf -- '\033[%dm%s\033[39;49m' $n "$@"
  else
    printf -- '%s' "$@"
  fi
}

msg() {
  printf -- '%s\n' "$(strong "$(color 37 '>>>') $@")" 1>&2
}

err() {
  msg "$(color 31 mk:) $@"
}

die() {
  err "$@"
  exit 1
}

progress() {
  local step="$(printf '%-10s' $1:)"
  shift

  msg "$(color 33 "$step") $@"
}
