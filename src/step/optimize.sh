step_optimize() {
  progress optmimize "'$name'"

  # Remove libtool archives
  find $_DEST/$fullname -type f -name \*.la -delete
}
