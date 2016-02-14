#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
ED=src/bin/ed

if ! [ -d $ED ]; then
	cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $ED
else
	cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $ED
fi

mkdir -p dist

cp -a $ED/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
