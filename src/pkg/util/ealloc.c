/*
 * MIT/X Consortium License
 * 
 * © 2011 Connor Lane Smith <cls@lubutu.com>
 * © 2011-2016 Dimitris Papastamos <sin@2f30.org>
 * © 2014-2016 Laslo Hunhold <dev@frign.de>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
#include <stdlib.h>
#include <string.h>

#include "../util.h"

void *
ecalloc(size_t nmemb, size_t size)
{
	return encalloc(1, nmemb, size);
}

void *
emalloc(size_t size)
{
	return enmalloc(1, size);
}

void *
erealloc(void *p, size_t size)
{
	return enrealloc(1, p, size);
}

char *
estrdup(const char *s)
{
	return enstrdup(1, s);
}

char *
estrndup(const char *s, size_t n)
{
	return enstrndup(1, s, n);
}

void *
encalloc(int status, size_t nmemb, size_t size)
{
	void *p;

	p = calloc(nmemb, size);
	if (!p)
		enprintf(status, "calloc: out of memory\n");
	return p;
}

void *
enmalloc(int status, size_t size)
{
	void *p;

	p = malloc(size);
	if (!p)
		enprintf(status, "malloc: out of memory\n");
	return p;
}

void *
enrealloc(int status, void *p, size_t size)
{
	p = realloc(p, size);
	if (!p)
		enprintf(status, "realloc: out of memory\n");
	return p;
}

char *
enstrdup(int status, const char *s)
{
	char *p;

	p = strdup(s);
	if (!p)
		enprintf(status, "strdup: out of memory\n");
	return p;
}

char *
enstrndup(int status, const char *s, size_t n)
{
	char *p;

	p = strndup(s, n);
	if (!p)
		enprintf(status, "strndup: out of memory\n");
	return p;
}
