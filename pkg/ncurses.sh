ver 5.9
rev 1
dist ftp://invisible-island.net/$PKG_NAME/$PKG_NAME-5.9.tar.gz

configure \
  --disable-termcap \
  --enable-ext-colors \
  --enable-pc-files \
  --enable-widec \
  --with-manpage-symlinks \
  --with-shared \
  --without-ada \
  --without-cxx-binding

sub libncurses type lib
sub libncurses rdep terminfo

sub libncurses-bld type bld
sub libncurses-bld rdep libncurses
sub libncurses-bld mv \
  usr/bin/ncursesw6-config \
  usr/share/man/man1/ncursesw6-config.1

sub terminfo type custom
sub terminfo mv usr/share/terminfo

post_install() {
  local conflicts='
    clear
  '

  local f
  for f in $conflicts; do
    rm $MK_DESTDIR$MK_PREFIX/bin/$f
    rm -f $MK_DESTDIR$MK_MANDIR/man1/${f}.1
  done

  rm -f $MK_DESTDIR$MK_PREFIX/lib/terminfo
  rm -r $MK_DESTDIR$MK_PREFIX/share/tabset

  local terminfo_files='
    ansi
    dumb
    linux
    rxvt
    rxvt-256color
    screen
    screen-256color
    sun
    vt100
    vt102
    vt220
    xterm
    '

  local t keep
  find $MK_DESTDIR$MK_PREFIX/share/terminfo -type f | while read f; do
    keep=
    for t in $terminfo_files; do
      [ "$(basename $f)" != "$t" ] || keep=yes
    done

    [ "$keep" ] || rm $f
  done

}
