ver=5.22
rev=1
dist=ftp://ftp.astron.com/pub/$name/$name-${ver}.tar.gz

style=configure

pre_configure() {
  cp -f $MK_FILE/config.sub .
}
