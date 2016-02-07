#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
PAX=src/bin/pax
INCLUDE=src/include
GEN=src/lib/libc/gen

for d in $PAX $INCLUDE $GEN; do
	if ! [ -d $d ]; then
		cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $d
	else
		cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $d
	fi
done

mkdir -p dist

cp $INCLUDE/fts.h dist/
cp $GEN/fts.c dist/

cp -a $PAX/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
