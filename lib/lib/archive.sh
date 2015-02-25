get_archive() {
  local archive=${src##*/}

  printf -- '%s' $_CACHE/$fullparentname/$archive
}
