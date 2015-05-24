step_prep() {
  progress prep "'$PKG_NAME'"

  mkdir -p $MK_BUILD_ROOT

  if [ "$PKG_BUILDDIR" ]; then
    mkdir -p $MK_BUILD
  fi
}
