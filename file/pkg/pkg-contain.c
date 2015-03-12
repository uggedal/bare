#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>

#define USAGE_FMT "Usage: HOSTDIR=hostdir %s <dir> <command> [args]\n"

static const int clone_flags = SIGCHLD|
	CLONE_NEWUSER|
	CLONE_NEWNS|
	CLONE_NEWPID|
	CLONE_NEWNET|
	CLONE_NEWUTS|
	CLONE_NEWIPC;

static char *name = NULL;

static void die(const char *fmt, ...) {
	int oerrno = errno;
	va_list args;

	va_start(args, fmt);
	fprintf(stderr, "%s: ", name);
	vfprintf(stderr, fmt, args);
	va_end(args);

	if (oerrno) {
		fprintf(stderr, ": %s", strerror(oerrno));
	}

	fprintf(stderr, "\n");

	exit(EXIT_FAILURE);
}

static void denysetgroups(void) {
	int fd;
	if ((fd = open("/proc/self/setgroups", O_RDWR)) != -1 &&
			write(fd, "deny", 4) == -1) {
		die("Unable to deny setgroups");
	}
	close(fd);
}

static void idmap(const char *fname, const uid_t id) {
	int fd;
	char buf[32];

	if ((fd = open(fname, O_RDWR)) != -1 &&
			write(fd, buf, snprintf(buf, sizeof buf, "0 %u 1\n", id)) != -1) {
		close(fd);
		return;
	}

	die("Unable to change idmap of '%s'", fname);
}

static void mnt(const char *s, const char *d, const char *t, const int f) {
	if (mount(s, d, t, f, 0) == -1) {
		die("Unable to mount '%s' to '%s'", s, d);
	}
}

int main(int argc, char **argv) {
	uid_t uid = getuid();
	gid_t gid = getgid();

	name = argv[0];

	if (argc < 3) {
		die(USAGE_FMT, argv[0]);
	}

	char *hostdir = getenv("HOSTDIR");
	if (!hostdir) {
		die(USAGE_FMT, argv[0]);
	}

	pid_t pid;
	if ((pid = syscall(__NR_clone, clone_flags, NULL)) == -1) {
		die("Unable to clone");
	}

	if (pid == 0) {
		denysetgroups();
		idmap("/proc/self/uid_map", uid);
		idmap("/proc/self/gid_map", gid);

		if (chdir(argv[1]) == -1) {
			die("Unable to chdir to '%s'", argv[1]);
		}

		mnt("/dev", "./dev", 0, MS_BIND|MS_REC);
		mnt("proc", "./proc", "proc", 0);
		mnt("/sys", "./sys", 0, MS_BIND|MS_REC);

		char *hosttarget = "./host";
		if (mkdir(hosttarget, 0700) == -1 && errno != EEXIST) {
			die("Unable to mkdir %s", hosttarget);
		}
		mnt(hostdir, hosttarget, 0, MS_BIND);

		if (chroot(".") == -1) {
			die("Unable to chroot");
		}

		if (execv(argv[2], argv+2)) {
			die("Unable to exec '%s'", argv[2]);
		}
	}

	siginfo_t info;
	if (waitid(P_PID, pid, &info, WEXITED) == -1) {
		die("Unable to wait for '%u'", pid);
	}

	return info.si_status;
}
