_mvp() {
  local dest=$1
  local files="$2"
  local maindest=$MK_DESTDIR

  (
    cd $maindest

    local f dir
    for f in $files; do
      case $f in
        *\**)
          continue
          ;;
      esac

      [ -e $f ] || continue

      dir=$(dirname $(relative $f $maindest))
      mkdir -p $dest/$dir
      mv $f $dest/$dir
    done
  )
}

_split_lib() {
  local name=$1
  local dest=$2
  local prefix=$(relative .$MK_PREFIX .)

  _mvp $dest $prefix/lib/\*.so.\*
}

_split_bld() {
  local name=$1
  local dest=$2
  local prefix=$(relative .$MK_PREFIX .)

  _mvp $dest $prefix/lib/\*.a
  _mvp $dest $prefix/lib/\*.so
  _mvp $dest $prefix/include
  _mvp $dest $(relative .$MK_MANDIR .)'/man[23]'
  _mvp $dest $prefix/lib/pkgconfig
}

_split_custom() {
  local name=$1
  local dest=$2

  _mvp $dest "$(get_sub_var $name mv)"
}

_create_sub() {
  local name=$1
  local qualified_name=$name-${PKG_VER}_$PKG_REV
  local type=$(get_sub_var $name type)
  local dest=$_DEST/$qualified_name

  mkdir -p $dest

  _split_$type $name $dest
}

step_sub() {
  msglist 'Sub:' $PKG_SUB
  foreach _create_sub $PKG_SUB
}
