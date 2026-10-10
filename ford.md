---
project: fortran_quaternions
summary: Quaternions that behave like Fortran's intrinsic `complex` type, with 3D rotations, in single, double and quadruple precision.
author: Will Klausler
github: https://github.com/willklausler
project_github: https://github.com/willklausler/fortran_quaternions
license: mit
src_dir: ./src
output_dir: ./build/doc
page_dir: ./build/pages
preprocess: true
display: public
source: true
search: true
graph: false
---

`use quaternions` gives the types `quat_sp`, `quat_dp` and `quat_qp`, arithmetic
operators, the elemental functions Fortran provides for `complex`, and rotation
utilities.  Start with the [user manual](page/index.html), which is also available
as plain text in [llms.txt](llms.txt).

The procedures are documented under module `quaternions_impl`, which
`quaternions` re-exports.  Their specific names, such as `dp_mul_dp`, are
private; call them through the generic names.

```fortran
use, intrinsic :: iso_fortran_env, only: dp => real64
use quaternions
type(quat_dp) :: q
q = from_axis_angle([0._dp, 0._dp, 1._dp], acos(-1._dp)/2)
print *, rotate(q, [1._dp, 0._dp, 0._dp])   ! [0, 1, 0]
```
