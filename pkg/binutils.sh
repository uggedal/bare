ver=2.25
rev=1
src=$URI_GNU/$name/$name-${ver}.tar.bz2

style=configure
configure='
  --disable-multilib
  --disable-nls
  --disable-shared
  '

post_configure() {
  make configure-host
}
