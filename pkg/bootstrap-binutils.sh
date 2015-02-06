inherit binutils

configure="
  $configure
  --disable-shared
  "

post_configure() {
  make configure-host
}
