ver=2.25
rev=1
dist=$URI_GNU/$name/$name-${ver}.tar.bz2

style=configure

configure='
  --disable-multilib
  --disable-nls
  --disable-werror
  '

pre_configure() {
  sed -i -e 's#MAKEINFO="$MISSING makeinfo"#MAKEINFO=true#g' configure
}
