cmd_gencksum() {
  sha256sum $(relative $(fetch $src $fullname)) > $_CKSUM/${name}.sha256sum
}
