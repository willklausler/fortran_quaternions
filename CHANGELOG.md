# Changelog

All notable changes are listed here. The project follows [Semantic Versioning](https://semver.org).

## [Unreleased]

### Fixed

- `atanh` and `asinh` returned the wrong side of the branch cut on the real axis: `atanh(quat_dp(2))` gave 0.549 - 1.571i instead of 0.549 + 1.571i, as `atanh((2, 0))` gives.
- `is_close` returned true for an infinity and any finite value, and false for two equal infinities.
- `inv` (and division) by a quaternion with an infinite component returned NaN instead of 0.

## [0.1.0] - 2026-10-10

First public release.

- Types `quat_sp`, `quat_dp`, `quat_qp` with public components `w, x, y, z`, generated from one fypp template.
- Operators with quaternions, same-kind reals and integers of any kind; exact `==` and `is_close`.
- `abs`, `conjg`, `real`, `aimag`, `dot_product`, `inv`, `normalize`, and all elementary functions of `complex`, with matching branches.
- Rotations: `from_axis_angle`, `to_axis_angle`, `rotate`, `to_matrix`, `from_matrix`, `from_euler_zyx`, `to_euler_zyx`, `slerp`, `random_rotation`.
- Derived-type I/O, `to_string`, and parsing from strings.
- fpm and make builds, FORD documentation, man page, `llms.txt` API reference for coding agents.
- CI with gfortran, ifx, LLVM flang and nvfortran on Linux, macOS and Windows.
