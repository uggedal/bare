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

    ./mk <command>

## Configuration

The following environment variables can be overridden from the defaults:

* `MK_NPROC`: number of parallel processes to build with (defaults to the
  number of CPUs).

Bootstrap
---------

    ./bootstrap

[Public Domain][]
-----------------

The following does not apply to the packaged software and patches not
written by Eivind Uggedal.

To the extent possible under law, Eivind Uggedal has waived
all copyright and related or neighboring rights to this work.

[Alpine Linux]: https://www.alpinelinux.org/
[CRUX]: https://crux.nu/
[Dragora]: http://www.dragora.org/
[Morpheus]: http://morpheus.2f30.org/
[Sabotage Linux]: https://github.com/sabotage-linux/sabotage
[Slackware]: http://www.slackware.com/
[Void Linux]: http://www.voidlinux.eu/
[Public Domain]: http://creativecommons.org/publicdomain/zero/1.0/
