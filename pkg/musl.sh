ver=1.1.6
rev=1
src=http://www.$parentname-libc.org/releases/$parentname-${ver}.tar.gz

style=configure

configure='
  --disable-gcc-wrapper
  '

if [ "$MK_CROSS" ]; then
  export CROSS_COMPILE=${MK_TARGET}-
fi
