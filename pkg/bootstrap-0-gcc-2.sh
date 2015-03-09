inherit gcc

configure="
  $configure
  --disable-libsanitizer
  --target=$MK_TARGET
  "
