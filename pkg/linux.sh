ver=3.14.31
rev=1
src=https://www.kernel.org/pub/$parentname/kernel/v3.x/$parentname-${ver}.tar.xz

if [ -z "$MK_BOOTSTRAP" ]; then
  bdep='perl'
fi

style=make
