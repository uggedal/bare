uppercase() {
  printf -- '%s' "$@" | tr 'a-z' 'A-Z'
}
