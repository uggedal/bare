step_dep() {
  progress dep "'$PKG_NAME'"
  msglist 'Bdep:' $PKG_BDEP

  [ -z "$MK_NO_DEP" ] || return 0

  local dep
  for dep in $PKG_BDEP $PKG_RDEP; do
    pkg_in_repo $_REPO $dep || ./mk pkg $(sub_to_main $dep)
  done

  [ -z "$PKG_BDEP" ] || contain pkg-install $PKG_BDEP
}
