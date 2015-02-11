ver=1.1.6
rev=1
src=http://www.$name-libc.org/releases/$name-${ver}.tar.gz

style=configure

configure='
  --disable-gcc-wrapper
  '
