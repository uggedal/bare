step_optimize() {
  progress optmimize "'$name'"

  # Remove libtool archives
  find $_DEST/$fullname -type f -name \*.la -exec rm -v {} \+

  # Strip binaries
  local f
  find $_DEST/$fullname -type f | while read f; do
    case "$(file -bi "$f")" in
      application/x-executable*)
        ${STRIP:-strip} -v $f
        ;;
      application/x-sharedlib*)
        ${STRIP:-strip} -v --strip-unneeded $f
        ;;
      application/x-archive*)
        ${STRIP:-strip} -v --strip-debug $f
        ;;
    esac
  done
}
