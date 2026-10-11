# Changelog

All notable changes are listed here. The project follows [Semantic Versioning](https://semver.org).

## [0.1.0] - 2026-10-11

First public release.

- Types `quat_sp`, `quat_dp`, `quat_qp` with public components `w, x, y, z`, generated from one fypp template.
- Operators with quaternions, same-kind reals and integers of any kind; exact `==` and `is_close`.
- `abs`, `conjg`, `real`, `aimag`, `dot_product`, `inv`, `normalize`, and all elementary functions of `complex`, with matching branches.
- Rotations: `from_axis_angle`, `to_axis_angle`, `rotate`, `to_matrix`, `from_matrix`, `from_euler_zyx`, `to_euler_zyx`, `slerp`, `random_rotation`.
- Derived-type I/O, `to_string`, and parsing from strings.
- fpm and make builds, FORD documentation, man page, `llms.txt` API reference for coding agents.
- CI with gfortran, ifx, LLVM flang and nvfortran on Linux, macOS and Windows.
