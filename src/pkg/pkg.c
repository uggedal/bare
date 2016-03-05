#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <archive.h>
#include <archive_entry.h>

#include "util/queue.h"
#include "util.h"

#define EXTRACT_FLAGS	ARCHIVE_EXTRACT_PERM | \
			ARCHIVE_EXTRACT_TIME | \
			ARCHIVE_EXTRACT_SECURE_NODOTDOT

enum { NONE, INSTALL };
enum { I_FILE, I_LIB, I_DEP, I_SUM };
enum { I_FILE_NAME, I_FILE_VER, I_FILE_EPOC };

struct pkg {
	char path[PATH_MAX];
	char *name;
	char *ver;
	char *epoc;
	char *sum;
	char *raw_fname;
	char *raw_lib;
	char *raw_dep;
	LIST_ENTRY(pkg) dep_entries;
	LIST_HEAD(dep_listhead, pkg) dep_head;
};

static char *prefix = "/";
static char *repopath = NULL;
static char tmpdir[PATH_MAX];
static char dbdir[PATH_MAX];
static int vflag = 0;

/* parses file format: name_1.0.0_24.txz */
static int
parse_file_field(struct pkg *pkg, char *field)
{
	char *p;
	int i;

	pkg->raw_fname = estrdup(field);

	estrlcpy(pkg->path, repopath, PATH_MAX);
	estrlcat(pkg->path, "/", PATH_MAX);
	estrlcat(pkg->path, field, PATH_MAX);

	p = strrchr(field, '.');
	if (p)
		*p = '\0';
	for (i = 0; (p = strsep(&field, "_")); i++) {
		switch (i) {
		case I_FILE_NAME:
			pkg->name = estrdup(p);
			break;
		case I_FILE_VER:
			pkg->ver = estrdup(p);
			break;
		case I_FILE_EPOC:
			pkg->epoc = estrdup(p);
			break;
		}
	}

	if (i != I_FILE_EPOC + 1 || *pkg->name == '\0' ||
	    *pkg->ver == '\0' || pkg->epoc == '\0')
		return -1;
	return 0;
}

static struct pkg *pkg_load(FILE *, char *);

/* parses dep format: pkga,pkgb:libb.so.2 */
static void
parse_dep_field(struct pkg *pkg, FILE *fp, char *field)
{
	char *p, *tmp;
	struct pkg *dep;

	pkg->raw_dep = estrdup(field);

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
			switch (i) {
			case I_LIB:
				pkg->raw_lib = estrdup("");
				continue;
			case I_DEP:
				pkg->raw_dep = estrdup("");
				continue;
			case I_FILE:
			case I_SUM:
			default:
				eprintf("invalid INDEX for '%s'\n", name);
			}

		tmp = estrdup(p);

		switch (i) {
		case I_FILE:
			if (parse_file_field(pkg, tmp))
				eprintf("invalid file field in INDEX for"
				    " '%s'\n", name);
			break;
		case I_LIB:
			pkg->raw_lib = estrdup(tmp);
			break;
		case I_DEP:
			parse_dep_field(pkg, fp, tmp);
			break;
		case I_SUM:
			if (tmp[strlen(tmp) - 1] == '\n')
				tmp[strlen(tmp) - 1] = '\0';
			pkg->sum = estrdup(tmp);
			break;
		}
		free(tmp);
	}

	free(line);

	if (i != I_SUM + 1)
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
	free(pkg->sum);
	free(pkg->raw_fname);
	free(pkg->raw_lib);
	free(pkg->raw_dep);
	free(pkg);
}

static void
usage(void)
{
	eprintf("usage: %s [-i] [-p prefix] [name ...]\n", argv0);
}

static int
record_entry(FILE *fp, struct archive_entry *entry)
{
	int n;
	char t = 'U';

	switch (archive_entry_filetype(entry)) {
	case AE_IFREG:
		t = 'F';
		break;
	case AE_IFDIR:
		t = 'D';
		break;
	case AE_IFLNK:
		if (archive_entry_hardlink(entry) != NULL)
			t = 'H';
		if (archive_entry_symlink(entry) != NULL)
			t = 'L';
		break;
	}

	if (t == 'U') {
		weprintf("unknown file type '%d': %s\n",
		    archive_entry_filetype(entry),
		    archive_entry_pathname(entry));
		return -1;
	}

	n = fprintf(fp, "%s|%c|TODO_SUM\n", archive_entry_pathname(entry), t);
	return n < 0 ? n : 0;
}

static int
record_meta(struct pkg *pkg, FILE *infp, char *inpath, int explicit)
{
	char path[PATH_MAX], buf[BUFSIZ];
	FILE *fp;
	size_t n;

	if (mkdirp(dbdir)) {
		weprintf("mkdirp %s:", path);
		return -1;
	}

	estrlcpy(path, dbdir, PATH_MAX);
	estrlcat(path, "/", PATH_MAX);
	estrlcat(path, pkg->name, PATH_MAX);

	if (!(fp = fopen(path, "w"))) {
		weprintf("fopen %s:", path);
		return -1;
	}

	if (fprintf(fp, "%s|%s|%s|%s|%c\n", pkg->raw_fname,
	    pkg->raw_lib, pkg->raw_dep, pkg->sum,
	    explicit ? 'E' : 'D') < 0) {
		weprintf("fprintf %s:", path);
		return -1;
	}

	rewind(infp);
	while ((n = fread(buf, 1, sizeof(buf), infp))) {
		if (ferror(infp)) {
			weprintf("fread %s:", inpath);
			return -1;
		}

		if (fwrite(buf, 1, n, fp) != n) {
			weprintf("fwrite %s:", path);
			return -1;
		}

		if (feof(infp))
			break;
	}
	fclose(fp);

	return 0;
}

static int
extract(struct pkg *pkg, FILE *fp)
{
	struct archive *ar;
	struct archive_entry *entry;
	char cwd[PATH_MAX];
	int ret;

	if (!getcwd(cwd, sizeof(cwd))) {
		weprintf("getcwd:");
		return -1;
	}

	if (chdir(prefix) < 0) {
		weprintf("chdir %s:", prefix);
		return -1;
	}

	ar = archive_read_new();
	archive_read_support_filter_xz(ar);
	archive_read_support_format_tar(ar);

	if (archive_read_open_filename(ar, pkg->path, BUFSIZ) < 0) {
		weprintf("unable to open %s: %s\n", pkg->path,
		    archive_error_string(ar));
		ret = 1;
		goto cleanup;
	}

	while ((ret = archive_read_next_header(ar, &entry)) != ARCHIVE_EOF) {
		if (ret != ARCHIVE_OK) {
			weprintf("unable to read header %s: %s\n",
			    archive_entry_pathname(entry),
			    archive_error_string(ar));
			goto cleanup;
		}

		ret = archive_read_extract(ar, entry, EXTRACT_FLAGS);

		if (ret != ARCHIVE_OK) {
			weprintf("unable to extract %s: %s\n",
			    archive_entry_pathname(entry),
			    archive_error_string(ar));
			goto cleanup;
		}

		if (record_entry(fp, entry)) {
			weprintf("unable to record entry: %s\n",
			    archive_entry_pathname(entry));
			ret = -1;
			goto cleanup;
		}

		if (vflag > 1)
			printf("  %s\n", archive_entry_pathname(entry));
	}

cleanup:
	archive_read_free(ar);

	if (chdir(cwd) < 0) {
		weprintf("chdir %s:", cwd);
		ret = -1;
	}

	return ret == ARCHIVE_EOF ? 0 : ret;
}

static int
install(struct pkg *pkg, const char *parent)
{
	struct pkg *dep;
	int ret;
	FILE *fp = NULL;
	char path[PATH_MAX];

	LIST_FOREACH(dep, &pkg->dep_head, dep_entries) {
		install(dep, pkg->name);
	}

	if (vflag) {
		printf("install: %s", pkg->name);
		if (parent)
			printf(" <- %s", parent);
		printf("\n");
	}

	estrlcpy(path, tmpdir, PATH_MAX);
	estrlcat(path, "/", PATH_MAX);
	estrlcat(path, pkg->name, PATH_MAX);

	if (mkdirp(tmpdir)) {
		weprintf("mkdirp %s:", path);
		return -1;
	}

	if (!(fp = fopen(path, "w+"))) {
		weprintf("fopen %s:", path);
		return -1;
	}

	if (!(ret = extract(pkg, fp)))
		ret |= record_meta(pkg, fp, path, parent == NULL);

	fclose(fp);
	unlink(path);

	return ret;
}

static void
prefixify(char *path, const char *suffix)
{
	estrlcpy(path, prefix, PATH_MAX);
	if (path[strlen(path) - 1] != '/')
		estrlcat(path, "/", PATH_MAX);
	estrlcat(path, suffix, PATH_MAX);
}

int
main(int argc, char **argv)
{
	int ret = 0;
	int mode = NONE;
	char path[PATH_MAX];
	FILE *fp = NULL;
	struct pkg *pkg = NULL;

	ARGBEGIN{
	case 'i':
		mode = INSTALL;
		break;
	case 'p':
		prefix = EARGF(usage());
		break;
	case 'v':
		vflag++;
		break;
	default:
		usage();
	}ARGEND;

	prefixify(tmpdir, "tmp/pkg");
	prefixify(dbdir, "var/pkg/db");

	switch (mode) {
	case INSTALL:
		if (!(repopath = getenv("REPO")))
			eprintf("REPO env variable not set\n");
		estrlcpy(path, repopath, PATH_MAX);
		estrlcat(path, "/INDEX", PATH_MAX);

		if (!(fp = fopen(path, "r")))
			eprintf("fopen %s:", path);

		if (!argc)
			usage();
		while (*argv)
			if ((pkg = pkg_load(fp, *(argv++)))) {
				ret |= install(pkg, NULL);
				pkg_free(pkg);
			}
		fclose(fp);
		break;
	default:
		usage();
	}
	return ret;
}
