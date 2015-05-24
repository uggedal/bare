step_dep() {
  progress dep "'$PKG_NAME'"
  msglist 'Bdep:' $PKG_BDEP

  [ -z "$MK_NO_DEP" ] || return 0

  local dep
  for dep in $PKG_BDEP $PKG_RDEP; do
    pkg_in_repo $_REPO $bdep ||
      MK_CONTAINED=$MK_CONTAINED ./mk pkg $(sub_to_main $bdep)
  done

  pkg-install $PKG_BDEP
}
