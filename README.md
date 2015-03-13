xunil
=====

Simple linux distro.

Philosophy
----------

* Favor minimal applications and libraries.
* Only one package for per use-case.
* No translations.
* Stable timed branches only containing security updates and bug fixes.
* Vanilla kernel without initramfs and module support. Different kernel
  config and package per target system.

Inspiration
-----------

* [Alpine Linux][]
* [CRUX][]
* [Dragora][]
* [Morpheus][]
* [Sabotage Linux][]
* [Slackware][]
* [Void Linux][]

Usage
-----

To build packages in a native xunil system:

    ./mk <command>

## Configuration

The following environment variables can be overridden from the defaults:

* `MK_NPROC`: number of parallel processes to build with (defaults to the
  number of CPUs).

Bootstrap
---------

To bootstrap from a linux system with the necessary toolchain and
a kernel with `user_namespaces(7)` support:

    ./bootstrap -x <cross-dir> -r <rootfs-dir>

Legal Information
-----------------

xunil consists of several packages, each with their own license. These
can be inspected under `/usr/share/licenses` on a live system.

Some patches under `patches/` are taken from other projects and thus
carry the license of their respective upstream.

The following applies to the rest of xunil which is released into
the [Public Domain][].

To the extent possible under law, Eivind Uggedal has waived
all copyright and related or neighboring rights to xunil.
This work is published from: Norway.

[Alpine Linux]: https://www.alpinelinux.org/
[CRUX]: https://crux.nu/
[Dragora]: http://www.dragora.org/
[Morpheus]: http://morpheus.2f30.org/
[Sabotage Linux]: https://github.com/sabotage-linux/sabotage
[Slackware]: http://www.slackware.com/
[Void Linux]: http://www.voidlinux.eu/
[Public Domain]: http://creativecommons.org/publicdomain/zero/1.0/
