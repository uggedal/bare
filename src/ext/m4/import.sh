#!/bin/sh -e

RELEASE=5_8

CVS=anoncvs@anoncvs.eu.openbsd.org
M4=src/usr.bin/m4
LIBUTIL=src/lib/libutil

for d in $M4 $LIBUTIL; do
	if ! [ -d $d ]; then
		cvs -qd $CVS:/cvs get -rOPENBSD_$RELEASE -P $d
	else
		cvs -qd $CVS:/cvs up -rOPENBSD_$RELEASE -P $d
	fi
done

mkdir -p dist

cp $LIBUTIL/ohash.h $LIBUTIL/ohash.c dist/

cp -a $M4/* dist/
find dist -name CVS -type d | xargs rm -r

(
	cd dist

	yacc -d parser.y
	mv y.tab.c parser.c
	mv y.tab.h parser.h

	lex  -t tokenizer.l > tokenizer.c
)

rm -r src
