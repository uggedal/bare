#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
PATCH=src/usr.bin/patch

if ! [ -d $PATCH ]; then
	cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $PATCH
else
	cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $PATCH
fi

mkdir -p dist

cp -a $PATCH/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
