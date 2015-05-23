_extract_db_file() {
  local name=$1
  local ver=$2
  local qualified_name=$3
  local pkg=$4

  tar -C $_DB -xJf $_REPO/$pkg $PKG_DB/$name
}

step_prep() {
  progress prep "'$PKG_NAME'"

  read_repo $_REPO _extract_db_file

  mkdir -p $MK_BUILD_ROOT

  if [ "$PKG_BUILDDIR" ]; then
    mkdir -p $MK_BUILD
  fi
}
