# fortran_quaternions

[![CI](https://github.com/willklausler/fortran_quaternions/actions/workflows/ci.yml/badge.svg)](https://github.com/willklausler/fortran_quaternions/actions/workflows/ci.yml)
[![Docs](https://github.com/willklausler/fortran_quaternions/actions/workflows/docs.yml/badge.svg)](https://willklausler.github.io/fortran_quaternions/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Quaternions for modern Fortran that behave like the intrinsic `complex` type,
with 3D rotations, in single, double and quadruple precision.

```fortran
use, intrinsic :: iso_fortran_env, only: dp => real64
use quaternions
type(quat_dp) :: p, q

p = quat_dp(1, 2, 3, 4)                    ! w + xi + yj + zk
q = sqrt(exp(p)) * conjg(p) / 2            ! like complex arithmetic
print *, abs(q), q%x, is_close(exp(log(p)), p)   ! T

q = from_axis_angle([0._dp, 0._dp, 1._dp], acos(-1._dp)/2)
print *, rotate(q, [1._dp, 0._dp, 0._dp])   ! 90 degrees about z: [0, 1, 0]
```

> Coding agents: the complete API reference is [llms.txt](llms.txt), and
> contributor instructions are in [AGENTS.md](AGENTS.md).

## Features

- Types `quat_sp`, `quat_dp`, `quat_qp` (real32, real64, real128) with public components `w, x, y, z`.
- Operators `+ - * / ** == /=` between quaternions, reals of the same kind and integers of any kind; exact `==`, plus `is_close`.
- The functions Fortran provides for `complex`: `abs`, `conjg`, `real`, `aimag`, `sqrt`, `exp`, `log`, `log10`, and all trigonometric and hyperbolic functions and their inverses, with the same principal branches.
- Rotations: axis-angle, rotation matrices, ZYX Euler angles, `rotate`, `slerp`, uniformly distributed `random_rotation`.
- Text I/O with `print *` and `read(u, *)`, edit descriptors such as `'(dt"f8.4")'`, `to_string`, and parsing from strings.
- Every function that can be is elemental; no procedure stops the program.

Conventions: Hamilton product (ij = k), scalar first, active rotations (`rotate(q, v)` is q v q⁻¹), right division `a/b = a*inv(b)`.

## Installation

With [fpm](https://fpm.fortran-lang.org) 0.13 or later, add to your `fpm.toml`:

```toml
[dependencies]
fortran_quaternions = { git = "https://github.com/willklausler/fortran_quaternions" }
```

With make, which builds `build/make/libfortran_quaternions.a` and the module files:

```sh
make FC=gfortran && make test
make install PREFIX=$HOME/.local    # library, .mod files and man page
```

Quadruple precision is switched off automatically where the compiler lacks it
(nvfortran, LLVM flang); force it with `-DQUATERNIONS_QP=0` or `1`.

## Documentation

- [User manual and API documentation](https://willklausler.github.io/fortran_quaternions/), generated with FORD (`make doc`)
- [llms.txt](llms.txt): the API reference as one plain-text file, also the manual's source
- `man 3 quaternions` after `make install` ([man/quaternions.3](man/quaternions.3))
- Example programs in [example/](example/) (`fpm run --example --all`) and a SLERP demo in [app/](app/) (`fpm run`)

## Compilers

CI tests every push on:

| Compiler | Linux | macOS | Windows |
| --- | --- | --- | --- |
| gfortran 13, 14 | yes | yes | yes |
| ifx 2026 | yes | | yes |
| LLVM flang 21 | yes | | |
| nvfortran 26 | yes | | |

Known compiler limitations are listed in [llms.txt](llms.txt#compiler-notes).

## Why another quaternion package?

Existing Fortran quaternion code on GitHub covers parts of this: plain
arrays with a few functions ([pdebuyl/fortran_quaternion](https://github.com/pdebuyl/fortran_quaternion)),
a type with operators but no rotations ([MarDiehl/quaternions](https://github.com/MarDiehl/quaternions), GPL),
rotation conversions without a quaternion type ([saridut/rotlib](https://github.com/saridut/rotlib)), or
several precisions through parameterized derived types, which several compilers handle poorly
([rivwgk/quatf](https://github.com/rivwgk/quatf)). This package combines a `complex`-like
type, rotations and three precisions, packaged for fpm and tested on five compilers.

## References

- W. R. Hamilton, "On quaternions", *Philosophical Magazine* 25 (1844) 489–495.
- K. Shoemake, "Animating rotation with quaternion curves", *SIGGRAPH '85*, 245–254 (slerp).
- K. Shoemake, "Uniform random rotations", *Graphics Gems III* (1992) 124–132.
- S. W. Shepperd, "Quaternion from rotation matrix", *J. Guidance and Control* 1 (1978) 223–224.
- J. Diebel, "Representing attitude: Euler angles, unit quaternions, and rotation vectors", Stanford University (2006).

## Status and support

Version 0.1.0, the first public release. The API may still change before 1.0;
changes are recorded in [CHANGELOG.md](CHANGELOG.md). Bug reports, questions and
pull requests are welcome on [GitHub](https://github.com/willklausler/fortran_quaternions/issues);
see [CONTRIBUTING.md](CONTRIBUTING.md). To cite this package, use [CITATION.cff](CITATION.cff).

## License

[MIT](LICENSE)
