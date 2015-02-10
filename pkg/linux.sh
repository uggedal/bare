ver=3.14.31
rev=1
src=https://www.kernel.org/pub/$name/kernel/v3.x/$name-${ver}.tar.xz

if [ -z "$MK_BOOTSTRAP" ]; then
  bdep='perl'
fi

style=make
