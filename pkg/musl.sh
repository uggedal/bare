ver=1.1.6
rev=1
src=http://www.$parentname-libc.org/releases/$parentname-${ver}.tar.gz

style=configure

configure='
  --disable-gcc-wrapper
  '
