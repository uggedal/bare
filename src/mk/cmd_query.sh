cmd_query() {
  local field=$3
  local v ok

  if ! printf -- '%s' $field | grep -q ^MK_; then
    for v in $PKG_VARS; do
      [ "$v" != "$field" ] || ok=yes
    done

    [ "$ok" ] || die "unsupported pkg field '$field'"
  fi

  eval local v="\$$field"

  [ "$v" ] || die "undefined pkg field '$field'"

  printf -- '%s\n' "$v"
}
