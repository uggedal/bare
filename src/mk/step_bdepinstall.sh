step_bdepinstall() {
  progress bdepinstall "'$PKG_NAME'"

  [ -z "$MK_NO_DEP" ] || return 0

  [ -z "$PKG_BDEP" ] || contain pkg-install $PKG_BDEP
}
