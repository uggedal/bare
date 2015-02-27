ver=6.0.0
rev=1
src=https://gmplib.org/download/$name/${name}-${ver}a.tar.xz
bdep='m4'

style=configure

configure='
  --with-pic
  '
