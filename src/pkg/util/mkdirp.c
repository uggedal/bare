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
#include <sys/stat.h>

#include <errno.h>
#include <limits.h>

#include "../util.h"

int
mkdirp(const char *path)
{
	char tmp[PATH_MAX], *p;

	estrlcpy(tmp, path, sizeof(tmp));
	for (p = tmp + (tmp[0] == '/'); *p; p++) {
		if (*p != '/')
			continue;
		*p = '\0';
		if (mkdir(tmp, S_IRWXU | S_IRWXG | S_IRWXO) < 0 && errno != EEXIST) {
			weprintf("mkdir %s:", tmp);
			return -1;
		}
		*p = '/';
	}
	if (mkdir(tmp, S_IRWXU | S_IRWXG | S_IRWXO) < 0 && errno != EEXIST) {
		weprintf("mkdir %s:", tmp);
		return -1;
	}
	return 0;
}
