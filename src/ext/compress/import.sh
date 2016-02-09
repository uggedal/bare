#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
COMPRESS=src/usr.bin/compress

if ! [ -d $COMPRESS ]; then
	cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $COMPRESS
else
	cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $COMPRESS
fi

mkdir -p dist

cp -a $COMPRESS/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
