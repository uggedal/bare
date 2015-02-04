ver=3.14.31
rev=1
src=https://www.kernel.org/pub/$name/kernel/v3.x/$name-${ver}.tar.xz

if [ -z "$MK_BOOTSTRAP" ]; then
  bdep='perl'
fi

style=make

do_build() {
  make ARCH=$MK_KERNEL_ARCH headers_check
}

do_install() {
  make \
    ARCH=$MK_KERNEL_ARCH \
    INSTALL_HDR_PATH=$MK_DESTDIR/$MK_PREFIX/$MK_TRIPLET \
    headers_install
}

post_install() {
  find $MK_DESTDIR -name .install -o -name ..install.cmd | xargs rm -f
}
