step_query() {
  local field=$2
  local v ok

  for v in $PKG_VARS; do
    [ "$v" != "$field" ] || ok=yes
  done

  [ "$ok" ] || die "unsupported pkg field '$field'"

  eval local v="\$$field"

  [ "$v" ] || die "undefined pkg field '$field'"

  printf -- '%s\n' "$v"
}
