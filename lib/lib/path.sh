relative() {
  printf -- '%s' ${1#$(pwd)/*}
}
