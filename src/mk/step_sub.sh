_mvp() {
  local dest=$1
  local files="$2"
  local maindest=$_DEST/$PKG_QUALIFIED_NAME

  (
    cd $maindest

    local f dir
    for f in $files; do
      case $f in
        *\**)
          continue
          ;;
      esac

      dir=$(dirname $(relative $f $maindest))
      mkdir -p $dest/$dir
      mv $f $dest/$dir
    done
  )
}

_split_lib() {
  local dest=$1

  _mvp $dest 'usr/lib/*.so.*'
}

_split_bld() {
  local dest=$1

  _mvp $dest 'usr/lib/*.a'
  _mvp $dest 'usr/lib/*.so'
  _mvp $dest usr/include
  _mvp $dest usr/lib/pkgconfig
}

_create_sub() {
  local name=$1
  local qualified_name=$name-${PKG_VER}_$PKG_REV
  local type=$(get_sub_var $name type)
  local dest=$_DEST/$qualified_name

  mkdir -p $dest

  _split_$type $dest
}

step_sub() {
  msglist 'Sub:' $PKG_SUB
  foreach _create_sub $PKG_SUB
}
