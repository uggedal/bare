#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <sched.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/wait.h>

#include <archive.h>
#include <archive_entry.h>

#include "util/queue.h"
#include "util/sha256.h"
#include "util.h"

#define EXTRACT_FLAGS	ARCHIVE_EXTRACT_PERM | \
			ARCHIVE_EXTRACT_TIME | \
			ARCHIVE_EXTRACT_SECURE_NODOTDOT
#define ENT_FILE	'F'
#define ENT_DIR		'D'
#define ENT_HARDLINK	'H'
#define ENT_SYMLINK	'L'
#define ENT_UNKNOWN	'U'
#define CLONE_FLAGS	SIGCHLD | \
			CLONE_NEWUSER | \
			CLONE_NEWNS | \
			CLONE_NEWPID | \
			CLONE_NEWNET | \
			CLONE_NEWUTS | \
			CLONE_NEWIPC
#define SETGRP_FILE	"/proc/self/setgroups"

enum { NONE, INSTALL, ENTER };
enum { I_FILE, I_LIB, I_DEP, I_SUM };
enum { I_FILE_NAME, I_FILE_VER, I_FILE_EPOC };

struct pkg {
	char path[PATH_MAX];
	char dbpath[PATH_MAX];
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
static char *repodir = NULL;
static char tmpdir[PATH_MAX];
static char dbdir[PATH_MAX];
static int vflag = 0;

static void
usage(void)
{
	eprintf("usage: %s [-i | -e] [-p prefix] [arg ...]\n", argv0);
}

/* parses file format: name_1.0.0_24.txz */
static int
parse_file_field(struct pkg *pkg, char *field)
{
	char *p;
	int i;

	pkg->raw_fname = estrdup(field);

	estrlcpy(pkg->path, repodir, PATH_MAX);
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

	estrlcpy(pkg->dbpath, dbdir, PATH_MAX);
	estrlcat(pkg->dbpath, "/", PATH_MAX);
	estrlcat(pkg->dbpath, pkg->name, PATH_MAX);

	return 0;
}

static struct pkg *pkg_load(FILE *, char *);

/* parses dep format: pkga,pkgb:libb.so.2 */
static void
parse_dep_field(struct pkg *pkg, FILE *fp, char *field)
{
	char *p, *tmp;
	struct pkg *dep;
	int i;

	pkg->raw_dep = estrdup(field);

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

static int
pkg_installed(struct pkg *pkg)
{
	struct stat st;
	return ! (stat(pkg->dbpath, &st) < 0 && errno == ENOENT);
}

int
cksum(FILE *fp, const char *path, uint8_t *md)
{
	struct sha256 ctx;
	uint8_t buf[BUFSIZ];
	size_t n;

	sha256_init(&ctx);
	while ((n = fread(buf, 1, sizeof(buf), fp)) > 0)
		sha256_update(&ctx, buf, n);
	if (ferror(fp)) {
		weprintf("unable to read %s:", path);
		return -1;
	}
	sha256_sum(&ctx, md);
	return 0;
}

static char
entry_to_type(struct archive_entry *ent)
{
	char t = ENT_UNKNOWN;

	switch (archive_entry_filetype(ent)) {
	case AE_IFREG:
		t = ENT_FILE;
		break;
	case AE_IFDIR:
		t = ENT_DIR;
		break;
	case AE_IFLNK:
		if (archive_entry_hardlink(ent) != NULL)
			t = ENT_HARDLINK;
		if (archive_entry_symlink(ent) != NULL)
			t = ENT_SYMLINK;
		break;
	}

	return t;
}

static int
write_cksum(const char *path, FILE *out)
{
	FILE *in;
	uint8_t md[SHA256_DIGEST_LENGTH];
	size_t i;
	int n;

	if (!(in = fopen(path, "r"))) {
		weprintf("fopen %s:", path);
		return -1;
	}

	if (cksum(in, path, md)) {
		fclose(in);
		return -1;
	}

	for (i = 0; i < sizeof(md); i++)
		if ((n = fprintf(out, "%02x", md[i])) < 0) {
			fclose(in);
			return n;
		}

	fclose(in);
	return 0;
}

static int
record_entry(FILE *fp, struct archive_entry *ent)
{
	int n;
	char t;
	const char *path;

	path = archive_entry_pathname(ent);
	t = entry_to_type(ent);

	if (t == ENT_UNKNOWN) {
		weprintf("unknown file type '%d': %s\n",
		    archive_entry_filetype(ent), path);
		return -1;
	}

	if (vflag > 1) {
		if (t == ENT_FILE)
			printf("  %s\n", path);
		if (t == ENT_SYMLINK)
			printf("  %s -> %s\n", path,
			    archive_entry_symlink(ent));
	}

	if ((n = fprintf(fp, "%s|%c|", path, t)) < 0)
		return n;
	if (t == ENT_FILE || t == ENT_HARDLINK)
		if (write_cksum(path, fp))
			return -1;
	if ((n = fprintf(fp, "\n")) < 0)
		return n;

	return 0;
}

static int
record_meta(struct pkg *pkg, FILE *infp, char *inpath, int explicit)
{
	char buf[BUFSIZ];
	FILE *fp;
	size_t n;

	if (mkdirp(dbdir)) {
		weprintf("mkdirp %s:", dbdir);
		return -1;
	}

	if (!(fp = fopen(pkg->dbpath, "w"))) {
		weprintf("fopen %s:", pkg->dbpath);
		return -1;
	}

	if (fprintf(fp, "%s|%s|%s|%s|%c\n", pkg->raw_fname,
	    pkg->raw_lib, pkg->raw_dep, pkg->sum,
	    explicit ? 'E' : 'D') < 0) {
		weprintf("fprintf %s:", pkg->dbpath);
		return -1;
	}

	rewind(infp);
	while ((n = fread(buf, 1, sizeof(buf), infp))) {
		if (ferror(infp)) {
			weprintf("fread %s:", inpath);
			return -1;
		}

		if (fwrite(buf, 1, n, fp) != n) {
			weprintf("fwrite %s:", pkg->dbpath);
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
	struct archive_entry *ent;
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

	while ((ret = archive_read_next_header(ar, &ent)) != ARCHIVE_EOF) {
		if (ret != ARCHIVE_OK) {
			weprintf("unable to read header %s: %s\n",
			    archive_entry_pathname(ent),
			    archive_error_string(ar));
			goto cleanup;
		}

		ret = archive_read_extract(ar, ent, EXTRACT_FLAGS);

		if (ret != ARCHIVE_OK) {
			weprintf("unable to extract %s: %s\n",
			    archive_entry_pathname(ent),
			    archive_error_string(ar));
			goto cleanup;
		}

		if (record_entry(fp, ent)) {
			weprintf("unable to record entry: %s\n",
			    archive_entry_pathname(ent));
			ret = -1;
			goto cleanup;
		}
	}

cleanup:
	archive_read_close(ar);
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

	if (pkg_installed(pkg)) {
		if (vflag > 1) {
			printf("skip: %s", pkg->name);
			if (parent)
				printf(" <- %s", parent);
			printf(" (installed)\n");
		}
		return 0;
	}


	LIST_FOREACH(dep, &pkg->dep_head, dep_entries) {
		if ((ret = install(dep, pkg->name)))
			return ret;
	}

	if (vflag) {
		printf("install: %s %s_%s", pkg->name, pkg->ver, pkg->epoc);
		if (parent)
			printf(" <- %s", parent);
		printf("\n");
	}

	estrlcpy(path, tmpdir, PATH_MAX);
	estrlcat(path, "/", PATH_MAX);
	estrlcat(path, pkg->name, PATH_MAX);

	if (mkdirp(tmpdir)) {
		weprintf("mkdirp %s:", tmpdir);
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
idmap(const char *path, const uid_t id) {
	int fd;
	char buf[32];

	if ((fd = open(path, O_WRONLY)) < 0)
		eprintf("unable to open %s:", path);
	if (write(fd, buf, snprintf(buf, sizeof buf, "0 %u 1\n", id)) < 0)
		eprintf("unable to write %s:", path);
	if (close(fd))
		eprintf("unable to close %s:", path);
}

static void
mnt(const char *s, const char *d, const char *t, const int f) {
	if (mount(s, d, t, f, 0))
		eprintf("unable to mount '%s' to '%s'", s, d);
}

static int
enter(const char *dir, char **argv)
{
	pid_t pid;
	siginfo_t si;
	int fd;
	uid_t uid;
	uid_t gid;
	char cwd[PATH_MAX];

	uid = getuid();
	gid = getgid();

	if (!getcwd(cwd, sizeof(cwd)))
		eprintf("getcwd:");

	if ((pid = syscall(__NR_clone, CLONE_FLAGS, NULL)) < 0)
		eprintf("clone:");

	if (pid == 0) {
		if ((fd = open(SETGRP_FILE, O_WRONLY)) < 0)
			eprintf("unable to open %s:", SETGRP_FILE);
		if (write(fd, "deny", 4) < 0)
			eprintf("unable to write %s:", SETGRP_FILE);
		if (close(fd))
			eprintf("unable to close %s:", SETGRP_FILE);
		idmap("/proc/self/uid_map", uid);
		idmap("/proc/self/gid_map", gid);

		if (chdir(dir))
			eprintf("chdir %s:", dir);

		mnt("/dev", "./dev", 0, MS_BIND|MS_REC);
		mnt("proc", "./proc", "proc", 0);
		mnt("/sys", "./sys", 0, MS_BIND|MS_REC);

		if (mkdirp("./host"))
			eprintf("mkdirp %s:", "./host");
		mnt(cwd, "./host", 0, MS_BIND);

		if (chroot("."))
			eprintf("chroot %s:", dir);

		if (execv(argv[0], argv))
			eprintf("unable to exec %s:", argv[0]);
	}

	if (waitid(P_PID, pid, &si, WEXITED))
		eprintf("wait %u:", pid);

	return si.si_status;
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
		if (mode != NONE)
			usage();
		mode = INSTALL;
		break;
	case 'e':
		if (mode != NONE)
			usage();
		mode = ENTER;
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
	prefixify(dbdir, "var/db/pkg");

	switch (mode) {
	case INSTALL:
		if (!(repodir = getenv("REPO")))
			eprintf("REPO env variable not set\n");
		estrlcpy(path, repodir, PATH_MAX);
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
	case ENTER:
		if (argc < 2)
			usage();
		ret = enter(argv[0], argv+1);
		break;
	default:
		usage();
	}
	return ret;
}
