#!/bin/sh -e

RELEASE=5_7

CVS=anoncvs@anoncvs.eu.openbsd.org
KSH=src/bin/ksh
GEN=src/lib/libc/gen
SYS=src/sys/sys

for d in $KSH $GEN $SYS; do
	if ! [ -d $d ]; then
		cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $d
	else
		cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $d
	fi
done

mkdir -p dist

cp $GEN/charclass.h dist/
mkdir -p sys
cp $SYS/queue.h dist/sys

cp $KSH/* dist/
