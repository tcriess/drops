# drops

An Atari ST intro in the 96kB category. Music by Dhor/MEC, code by tecer/hacKNology.

[![drops by tecer and Dhor](https://img.youtube.com/vi/8616Zllg2Zc/0.jpg)](https://www.youtube.com/watch?v=8616Zllg2Zc)

## BUILD

drops is pure 68000 assembly and thus can be "assembled" - in principle - by any Atari ST assembler.
More convenient is cross-assembling via [vasm](http://sun.hasenbraten.de/vasm/) on a host system.

The Makefile assumes that the vasm executable is called `vasmm68k_mot`, then the code can be assembled via
```
> make
```
or
```
> make debug
```
(the latter includes debug symbols).

The result is the executable (on an Atari ST, of course) `drops.tos`.
It should run on any vanilla Atari 520 ST, no blitter required, no RAM extension required; of course, it also runs on an Atari ST emulator, like [Hatari](https://hatari.tuxfamily.org/).
