ver 20121220
rev 1
dist http://www.cs.princeton.edu/~bwk/btl.mirror/awk.tar.gz

distdir .

pre_configure() {
  ed makefile <<EOF
g/mv y\.tab\./d
w
q
EOF
}

do_build() {
	make \
    YACC=: \
    CC=$CC \
    CFLAGS="$CFLAGS" \
    CPPFLAGS="$CPPFLAGS -DHAS_ISBLANK"
}

do_install() {
  install -Dm755 a.out $MK_DESTDIR$MK_PREFIX/bin/awk
  install -Dm644 awk.1 $MK_DESTDIR$MK_MANDIR/man1/awk.1
}
