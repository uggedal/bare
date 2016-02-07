#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
DIFF=src/usr.bin/diff

if ! [ -d $DIFF ]; then
	cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $DIFF
else
	cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $DIFF
fi

mkdir -p dist

cp -a $DIFF/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
