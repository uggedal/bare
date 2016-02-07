#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
KSH=src/bin/ksh
GEN=src/lib/libc/gen

for d in $KSH $GEN; do
	if ! [ -d $d ]; then
		cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $d
	else
		cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $d
	fi
done

mkdir -p dist

cp $GEN/charclass.h dist/

cp -a $KSH/* dist/
find dist -name CVS -type d | xargs rm -r

rm -r src
