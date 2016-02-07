#!/bin/sh -e

RELEASE=5_7

CVS=anoncvs@anoncvs.eu.openbsd.org
PAX=src/bin/pax
STDLIB=src/lib/libc/stdlib
STRING=src/lib/libc/string
INCLUDE=src/include
GEN=src/lib/libc/gen

for d in $PAX $STDLIB $STRING $INCLUDE $GEN; do
	if ! [ -d $d ]; then
		cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $d
	else
		cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $d
	fi
done

mkdir -p dist

cp $STDLIB/reallocarray.c dist/
cp $STRING/strmode.c dist/

for f in fts.h tzfile.h vis.h; do
	cp $INCLUDE/$f dist/
done

for f in fts.c vis.c; do
	cp $GEN/$f dist/
done

cp -a $PAX/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
