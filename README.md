xunil
=====

Simple linux distro.

Philosophy
----------

* Keep patching of upstream to a minimum.
* Vanilla kernel without initramfs and module support. Different kernel
  config and package per target system.
* Only one package for per use-case.
* Stable timed branches only containing security updates and bug fixes.
* No translations.
* Favor non-GPL licensed software (no {A,L,}GPL3 if possible).

Inspiration
-----------

* [Alpine Linux][]
* [CRUX][]
* [D-os][]
* [Dragora][]
* [Morpheus][]
* [Sabotage Linux][]
* [Slackware][]
* [Void Linux][]

Usage
-----

    ./mk <command>

## Configuration

The following environment variables can be overwritten from the defaults:

* `MK_NPROC`: number of parallel processes to build with (defaults to the
  number of CPUs).

[Alpine Linux]: https://www.alpinelinux.org/
[CRUX]: https://crux.nu/
[D-os]: https://github.com/D-os
[Dragora]: http://www.dragora.org/
[Morpheus]: http://morpheus.2f30.org/
[Sabotage Linux]: https://github.com/sabotage-linux/sabotage
[Slackware]: http://www.slackware.com/
[Void Linux]: http://www.voidlinux.eu/
