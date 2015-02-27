ver=1.0.2
rev=1
src=$URI_GNU/$name/$name-${ver}.tar.gz
bdep='gmp-dev mpfr-dev'

style=configure

configure='
  --with-pic
  '

pre_configure() {
  cp -f $MK_FILE/config.sub .
}
