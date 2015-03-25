ver=1.23.1
rev=1
dist="
  http://${name}.net/downloads/$name-${ver}.tar.bz2
  http://git.alpinelinux.org/cgit/aports/plain/main/busybox/0001-linedit-deluser-use-POSIX-getpwent-instead-of-getpwe.patch
  "

style=make

pre_build() {
  make allnoconfig KCONFIG_ALLCONFIG=$MK_FILE/config
}

do_install() {
  make CONFIG_PREFIX=$MK_DESTDIR install
}
