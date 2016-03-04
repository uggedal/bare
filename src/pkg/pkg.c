#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <archive.h>
#include <archive_entry.h>

#include "queue.h"
#include "util.h"

enum { NONE, INSTALL };
enum { I_FILE, I_LIB, I_DEP, I_SUM };
enum { I_FILE_NAME, I_FILE_VER, I_FILE_EPOC };

struct pkg {
	char *path;
	char *name;
	char *ver;
	char *epoc;
	char *sum;
	LIST_ENTRY(pkg) dep_entries;
	LIST_HEAD(dep_listhead, pkg) dep_head;
};

static char *prefix = "/";

/* parses file format: name_1.0.0_24.txz */
static void
parse_file_field(struct pkg *pkg, char *field)
{
	char *p;
	int i;

	p = strrchr(field, '.');
	if (p)
		*p = '\0';
	for (i = 0; (p = strsep(&field, "_")); i++) {
		switch (i) {
		case I_FILE_NAME:
			pkg->name = strdup(p);
			break;
		case I_FILE_VER:
			pkg->ver = strdup(p);
			break;
		case I_FILE_EPOC:
			pkg->epoc = strdup(p);
			break;
		}
	}
}

static struct pkg *pkg_load(FILE *, char *);

/* parses dep format: pkga,pkgb:libb.so.2 */
static void
parse_dep_field(struct pkg *pkg, FILE *fp, char *field)
{
	char *p, *tmp;
	struct pkg *dep;

	int i;
	for (i = 0; (p = strsep(&field, ",")); i++) {
		tmp = estrdup(p);
		p = strrchr(tmp, ':');
		if (p)
			*p = '\0';
		dep = pkg_load(fp, tmp);
		LIST_INSERT_HEAD(&pkg->dep_head, dep, dep_entries);
		free(tmp);
	}
}

static struct pkg *
pkg_load(FILE *fp, char *name)
{
	char *line = NULL, *p, *tmp;
	size_t size = 0;
	ssize_t len;
	int i, match = 0;
	struct pkg *pkg;

	while ((len = getline(&line, &size, fp)) > 0)
		if (!strncmp(line, name, strlen(name)) &&
		    line[strlen(name)] == '_') {
				match = 1;
				break;
		}
	rewind(fp);

	if (!match)
		eprintf("no package named '%s'\n", name);

	pkg = emalloc(sizeof(*pkg));
	LIST_INIT(&pkg->dep_head);

	for (i = 0; (p = strsep(&line, "|")); i++) {
		if (*p == '\0')
			continue;

		tmp = estrdup(p);

		switch (i) {
		case I_FILE:
			parse_file_field(pkg, tmp);
			break;
		case I_LIB:
			break;
		case I_DEP:
			parse_dep_field(pkg, fp, tmp);
			break;
		case I_SUM:
			break;
		}
		free(tmp);
	}

	free(line);

	if (!pkg->name || !pkg->ver || !pkg->epoc)
		eprintf("invalid INDEX for '%s'\n", name);

	return pkg;
}

static void
pkg_free(struct pkg *pkg)
{
	struct pkg *dep;

	while (!LIST_EMPTY(&pkg->dep_head)) {
		dep = LIST_FIRST(&pkg->dep_head);
		LIST_REMOVE(dep, dep_entries);
		pkg_free(dep);
	}
	free(pkg->name);
	free(pkg->ver);
	free(pkg->epoc);
}

static void
usage(void)
{
	eprintf("usage: %s [-i] [-p prefix] [name ...]\n", argv0);
}

static int
install(struct pkg *p)
{
	(void) p;
	return 0;
}

int
main(int argc, char **argv)
{
	int ret = 0;
	int mode = NONE;
	char *repopath;
	char indexpath[PATH_MAX];
	FILE *indexfp = NULL;
	struct pkg *pkg = NULL;

	ARGBEGIN{
	case 'i':
		mode = INSTALL;
		break;
	case 'p':
		prefix = EARGF(usage());
		break;
	default:
		usage();
	}ARGEND;

	switch (mode) {
	case INSTALL:
		if (!(repopath = getenv("REPO")))
			eprintf("REPO env variable not set\n");
		estrlcpy(indexpath, repopath, PATH_MAX);
		estrlcat(indexpath, "/INDEX", PATH_MAX);

		if (!(indexfp = fopen(indexpath, "r")))
			eprintf("fopen %s:", indexpath);

		if (!argc)
			usage();
		while (*argv)
			if ((pkg = pkg_load(indexfp, *(argv++)))) {
				ret |= install(pkg);
				pkg_free(pkg);
			}
		fclose(indexfp);
		break;
	default:
		usage();
	}
	return ret;
}
