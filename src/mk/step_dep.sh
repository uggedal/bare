step_dep() {
  progress dep "'$PKG_NAME'"
  msglist 'Bdep:' $PKG_BDEP

  [ "$MK_CONTAINED" ] || return 0

  local bdep
  for bdep in $PKG_BDEP; do
    pkg_in_repo $_REPO $bdep ||
      MK_CONTAINED=$MK_CONTAINED ./mk pkg $(sub_to_main $bdep)
  done

  pkg-install $PKG_BDEP
}
