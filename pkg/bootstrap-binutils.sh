inherit binutils

configure='
  --disable-multilib
  --disable-nls
  --disable-shared
  '

post_configure() {
  make configure-host
}
