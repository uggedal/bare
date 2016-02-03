cmd_bump() {
  local v=$1
  local f=$_PKG/$PKG_NAME.sh

  ed $f <<EOF
,s|^\(ver \).*\$|\1$v
w
q
EOF

  ./mk fetch $PKG_NAME
  ./mk sum $PKG_NAME
  ./mk pkg $PKG_NAME
  git ci -m "$PKG_NAME: update to $v" $f $_SUM/$PKG_NAME.sum
}
