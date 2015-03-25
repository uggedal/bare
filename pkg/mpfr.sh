ver=3.1.2
rev=1
dist=http://www.${name}.org/$name-current/$name-${ver}.tar.xz
bdep='gmp-dev'

style=configure

configure='
  --with-pic
  '

pre_configure() {
  cp -f $MK_FILE/config.sub .
}
