snix
====

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

* Alpine Linux
* CRUX
* Dragora
* Morpheus
* Sabotage Linux
* Slackware
* Void Linux

Usage
-----

## Bootstrap

The following packages are required to bootstrap a self hosting snix
system:

    binutils gcc gcc-c++ make patch tar xz curl perl
    gmp-devel mpfr-devel libmpc-devel zlib-devel

## Configuration

The following environment variables can be overwritten from the defaults:

* `MK_NPROC`: number of parallel processes to build with.
