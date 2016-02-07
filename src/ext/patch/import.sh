#!/bin/sh -e

RELEASE=5_7

CVS=anoncvs@anoncvs.eu.openbsd.org
PATCH=src/usr.bin/patch

for d in $PATCH $STDLIB; do
	if ! [ -d $d ]; then
		cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $d
	else
		cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $d
	fi
done

mkdir -p dist

cp -a $PATCH/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
