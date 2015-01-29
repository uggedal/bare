snix
====

Simple linux distro.

Philosophy
----------

* Keep patching of upstream to a minimum.
* Vanilla kernel without initramfs and module support. Different kernel
  config and package per target system.
* No translations.
* Only one package for per use-case.
* Favor non-GPL licensed software (no {A,L,}GPL3 if possible).

Inspiration
-----------

* Alpine Linux
* Dragora
* Morpheus
* Sabotage Linux
* Slackware
* Void Linux

Components
----------

### libc

musl.

### init

Supervision based init system based on either runit or s6. Potentially
patched with cgroup support.

### sh

ash or potentially mksh (with patches for better vi mode support and simple
completion system).

### coreutils

Toybox (with missing peaces from busybox). Potentially parts from
openbsd/netbsd.

### pkg

Package manager initially written in POSIX shell with parts rewritten in C
if needed.

Package format should be a simple tarball with essential metadata.

The database should be a simple text file with a list of key value pairs.

Options:

* pkg sync
* pkg add
* pkg rm (automatically recursive)
* pkg find

If too much work xbps could be used in stead.

### mk

Package builder based on POSIX shell recipes. Extract commonalities out
to library functions.

Metadata should be minimal:

* name
* v (version)
* src (url)
* cksum
* bdep (build dependencies)
* rdep (runtime dependencies)
* style (build system)

Create -dev subpackages (headers etc) automatically.

Handle shared library dependencies automatically.

The only valid source of documentation is man pages.

Build in chroot

    clone(CLONE_NEWNS|CLONE_NEWIPC|CLONE_NEWUTS|CLONE_NEWPID|CLONE_NEWNET).

### mk check

Check for upstream updates. Ability to override in `update/<name>.sh`

Bootstrap
---------

Bootstrap from simple shell script based on:

* https://github.com/sabotage-linux/sabotage/blob/master/build-stage
* https://github.com/pikhq/bootstrap-linux
* https://github.com/jhuntwork/lightcube-bootstrap-musl
* https://github.com/mwcampbell/docker-muslbase
* http://landley.net/hg/aboriginal

## Required packages

    binutils gcc make tar xz
