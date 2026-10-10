! SPDX-License-Identifier: MIT
! ======================================================================
! GENERATED FILE - DO NOT EDIT.  Edit the templates in tmpl/ and run `make generate`.
! API summary for tools and agents: llms.txt
! ======================================================================
! Quadruple precision (quat_qp) is compiled unless QUATERNIONS_QP=0.
! It is switched off by default where real128 is unavailable.
#ifndef QUATERNIONS_QP
#if defined(__NVCOMPILER) || defined(__PGI) || defined(__flang__) || (defined(__APPLE__) && defined(__aarch64__))
#define QUATERNIONS_QP 0
#else
#define QUATERNIONS_QP 1
#endif
#endif
module quaternions_impl
!! Implementation of module quaternions; use that instead.
!!
!! Quaternions that behave like Fortran's intrinsic `complex` type.
!!
!! A quaternion is q = w + xi + yj + zk, stored scalar first as the public
!! components `w, x, y, z`.  Types `quat_sp`, `quat_dp` and `quat_qp` hold
!! real32, real64 and real128 components.  Arithmetic mixes a quaternion with
!! reals of the same kind and with integers of any kind.
!!
!! Conventions: Hamilton product (ij = k), active rotation v' = q v q*,
!! `a/b = a*inv(b)`, exact `==`, Euler angles ZYX (yaw, pitch, roll).
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128, int8, int16, int32, int64
  use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_quiet_nan
  implicit none
  private


  public :: quat_sp


  public :: quat_dp

#if QUATERNIONS_QP
  public :: quat_qp
#endif
  public :: quaternions_has_qp
#ifdef __NVCOMPILER

  public :: write_sp, read_sp


  public :: write_dp, read_dp

#if QUATERNIONS_QP
  public :: write_qp, read_qp
#endif
#endif
  public :: assignment(=)
  public :: operator(+), operator(-), operator(*), operator(/), operator(**)
  public :: operator(==), operator(/=)
  public :: abs, conjg, real, aimag, dot_product, inv, normalize, is_close, to_string
  public :: sqrt
  public :: exp
  public :: log
  public :: sin
  public :: cos
  public :: tan
  public :: asin
  public :: acos
  public :: atan
  public :: sinh
  public :: cosh
  public :: tanh
  public :: asinh
  public :: acosh
  public :: atanh
  public :: log10
  public :: random_number, random_rotation
  public :: from_axis_angle, to_axis_angle, rotate, to_matrix, from_matrix
  public :: from_euler_zyx, to_euler_zyx, slerp

  logical, parameter :: quaternions_has_qp = QUATERNIONS_QP == 1
  !! True if `quat_qp` was compiled in


  type :: quat_sp
    !! Quaternion w + xi + yj + zk with real(real32) components
    real(real32) :: w = 0, x = 0, y = 0, z = 0
#ifndef __NVCOMPILER
  contains
    procedure, private :: write_sp
    procedure, private :: read_sp
    generic :: write(formatted) => write_sp
    generic :: read(formatted) => read_sp
#endif
  end type quat_sp

  interface quat_sp
    !! Construct from a real(real32) array [w, x, y, z], a string such as
    !! "1 + 2i - 3j + 4k", or a quaternion of another kind.  The structure
    !! constructor quat_sp(w, x, y, z) also works; omitted parts are 0.
    module procedure :: sp_from_array, sp_from_string

    module procedure :: sp_from_dp

#if QUATERNIONS_QP
    module procedure :: sp_from_qp
#endif
  end interface quat_sp



  type :: quat_dp
    !! Quaternion w + xi + yj + zk with real(real64) components
    real(real64) :: w = 0, x = 0, y = 0, z = 0
#ifndef __NVCOMPILER
  contains
    procedure, private :: write_dp
    procedure, private :: read_dp
    generic :: write(formatted) => write_dp
    generic :: read(formatted) => read_dp
#endif
  end type quat_dp

  interface quat_dp
    !! Construct from a real(real64) array [w, x, y, z], a string such as
    !! "1 + 2i - 3j + 4k", or a quaternion of another kind.  The structure
    !! constructor quat_dp(w, x, y, z) also works; omitted parts are 0.
    module procedure :: dp_from_array, dp_from_string

    module procedure :: dp_from_sp

#if QUATERNIONS_QP
    module procedure :: dp_from_qp
#endif
  end interface quat_dp


#if QUATERNIONS_QP
  type :: quat_qp
    !! Quaternion w + xi + yj + zk with real(real128) components
    real(real128) :: w = 0, x = 0, y = 0, z = 0
#ifndef __NVCOMPILER
  contains
    procedure, private :: write_qp
    procedure, private :: read_qp
    generic :: write(formatted) => write_qp
    generic :: read(formatted) => read_qp
#endif
  end type quat_qp

  interface quat_qp
    !! Construct from a real(real128) array [w, x, y, z], a string such as
    !! "1 + 2i - 3j + 4k", or a quaternion of another kind.  The structure
    !! constructor quat_qp(w, x, y, z) also works; omitted parts are 0.
    module procedure :: qp_from_array, qp_from_string

    module procedure :: qp_from_sp


    module procedure :: qp_from_dp

  end interface quat_qp
#endif

  interface assignment(=)
    !! Assign a real of the same kind or an integer of any kind

    module procedure :: sp_assign_r
    module procedure :: sp_assign_i8
    module procedure :: sp_assign_i16
    module procedure :: sp_assign_i32
    module procedure :: sp_assign_i64


    module procedure :: dp_assign_r
    module procedure :: dp_assign_i8
    module procedure :: dp_assign_i16
    module procedure :: dp_assign_i32
    module procedure :: dp_assign_i64

#if QUATERNIONS_QP
    module procedure :: qp_assign_r
    module procedure :: qp_assign_i8
    module procedure :: qp_assign_i16
    module procedure :: qp_assign_i32
    module procedure :: qp_assign_i64
#endif
  end interface assignment(=)

  interface operator(+)

    module procedure :: sp_add_sp
    module procedure :: sp_add_r, r_add_sp
    module procedure :: sp_add_i8, i8_add_sp
    module procedure :: sp_add_i16, i16_add_sp
    module procedure :: sp_add_i32, i32_add_sp
    module procedure :: sp_add_i64, i64_add_sp
    module procedure :: sp_pos


    module procedure :: dp_add_dp
    module procedure :: dp_add_r, r_add_dp
    module procedure :: dp_add_i8, i8_add_dp
    module procedure :: dp_add_i16, i16_add_dp
    module procedure :: dp_add_i32, i32_add_dp
    module procedure :: dp_add_i64, i64_add_dp
    module procedure :: dp_pos

#if QUATERNIONS_QP
    module procedure :: qp_add_qp
    module procedure :: qp_add_r, r_add_qp
    module procedure :: qp_add_i8, i8_add_qp
    module procedure :: qp_add_i16, i16_add_qp
    module procedure :: qp_add_i32, i32_add_qp
    module procedure :: qp_add_i64, i64_add_qp
    module procedure :: qp_pos
#endif
  end interface operator(+)

  interface operator(-)

    module procedure :: sp_sub_sp
    module procedure :: sp_sub_r, r_sub_sp
    module procedure :: sp_sub_i8, i8_sub_sp
    module procedure :: sp_sub_i16, i16_sub_sp
    module procedure :: sp_sub_i32, i32_sub_sp
    module procedure :: sp_sub_i64, i64_sub_sp
    module procedure :: sp_neg


    module procedure :: dp_sub_dp
    module procedure :: dp_sub_r, r_sub_dp
    module procedure :: dp_sub_i8, i8_sub_dp
    module procedure :: dp_sub_i16, i16_sub_dp
    module procedure :: dp_sub_i32, i32_sub_dp
    module procedure :: dp_sub_i64, i64_sub_dp
    module procedure :: dp_neg

#if QUATERNIONS_QP
    module procedure :: qp_sub_qp
    module procedure :: qp_sub_r, r_sub_qp
    module procedure :: qp_sub_i8, i8_sub_qp
    module procedure :: qp_sub_i16, i16_sub_qp
    module procedure :: qp_sub_i32, i32_sub_qp
    module procedure :: qp_sub_i64, i64_sub_qp
    module procedure :: qp_neg
#endif
  end interface operator(-)

  interface operator(*)

    module procedure :: sp_mul_sp
    module procedure :: sp_mul_r, r_mul_sp
    module procedure :: sp_mul_i8, i8_mul_sp
    module procedure :: sp_mul_i16, i16_mul_sp
    module procedure :: sp_mul_i32, i32_mul_sp
    module procedure :: sp_mul_i64, i64_mul_sp


    module procedure :: dp_mul_dp
    module procedure :: dp_mul_r, r_mul_dp
    module procedure :: dp_mul_i8, i8_mul_dp
    module procedure :: dp_mul_i16, i16_mul_dp
    module procedure :: dp_mul_i32, i32_mul_dp
    module procedure :: dp_mul_i64, i64_mul_dp

#if QUATERNIONS_QP
    module procedure :: qp_mul_qp
    module procedure :: qp_mul_r, r_mul_qp
    module procedure :: qp_mul_i8, i8_mul_qp
    module procedure :: qp_mul_i16, i16_mul_qp
    module procedure :: qp_mul_i32, i32_mul_qp
    module procedure :: qp_mul_i64, i64_mul_qp
#endif
  end interface operator(*)

  interface operator(/)

    module procedure :: sp_div_sp
    module procedure :: sp_div_r, r_div_sp
    module procedure :: sp_div_i8, i8_div_sp
    module procedure :: sp_div_i16, i16_div_sp
    module procedure :: sp_div_i32, i32_div_sp
    module procedure :: sp_div_i64, i64_div_sp


    module procedure :: dp_div_dp
    module procedure :: dp_div_r, r_div_dp
    module procedure :: dp_div_i8, i8_div_dp
    module procedure :: dp_div_i16, i16_div_dp
    module procedure :: dp_div_i32, i32_div_dp
    module procedure :: dp_div_i64, i64_div_dp

#if QUATERNIONS_QP
    module procedure :: qp_div_qp
    module procedure :: qp_div_r, r_div_qp
    module procedure :: qp_div_i8, i8_div_qp
    module procedure :: qp_div_i16, i16_div_qp
    module procedure :: qp_div_i32, i32_div_qp
    module procedure :: qp_div_i64, i64_div_qp
#endif
  end interface operator(/)

  interface operator(==)

    module procedure :: sp_eq_sp
    module procedure :: sp_eq_r, r_eq_sp
    module procedure :: sp_eq_i8, i8_eq_sp
    module procedure :: sp_eq_i16, i16_eq_sp
    module procedure :: sp_eq_i32, i32_eq_sp
    module procedure :: sp_eq_i64, i64_eq_sp


    module procedure :: dp_eq_dp
    module procedure :: dp_eq_r, r_eq_dp
    module procedure :: dp_eq_i8, i8_eq_dp
    module procedure :: dp_eq_i16, i16_eq_dp
    module procedure :: dp_eq_i32, i32_eq_dp
    module procedure :: dp_eq_i64, i64_eq_dp

#if QUATERNIONS_QP
    module procedure :: qp_eq_qp
    module procedure :: qp_eq_r, r_eq_qp
    module procedure :: qp_eq_i8, i8_eq_qp
    module procedure :: qp_eq_i16, i16_eq_qp
    module procedure :: qp_eq_i32, i32_eq_qp
    module procedure :: qp_eq_i64, i64_eq_qp
#endif
  end interface operator(==)

  interface operator(/=)

    module procedure :: sp_ne_sp
    module procedure :: sp_ne_r, r_ne_sp
    module procedure :: sp_ne_i8, i8_ne_sp
    module procedure :: sp_ne_i16, i16_ne_sp
    module procedure :: sp_ne_i32, i32_ne_sp
    module procedure :: sp_ne_i64, i64_ne_sp


    module procedure :: dp_ne_dp
    module procedure :: dp_ne_r, r_ne_dp
    module procedure :: dp_ne_i8, i8_ne_dp
    module procedure :: dp_ne_i16, i16_ne_dp
    module procedure :: dp_ne_i32, i32_ne_dp
    module procedure :: dp_ne_i64, i64_ne_dp

#if QUATERNIONS_QP
    module procedure :: qp_ne_qp
    module procedure :: qp_ne_r, r_ne_qp
    module procedure :: qp_ne_i8, i8_ne_qp
    module procedure :: qp_ne_i16, i16_ne_qp
    module procedure :: qp_ne_i32, i32_ne_qp
    module procedure :: qp_ne_i64, i64_ne_qp
#endif
  end interface operator(/=)

  interface operator(**)
    !! Integer powers by repeated squaring; other powers via exp and log

    module procedure :: sp_pow_sp
    module procedure :: sp_pow_r, r_pow_sp
    module procedure :: sp_pow_i8, i8_pow_sp
    module procedure :: sp_pow_i16, i16_pow_sp
    module procedure :: sp_pow_i32, i32_pow_sp
    module procedure :: sp_pow_i64, i64_pow_sp


    module procedure :: dp_pow_dp
    module procedure :: dp_pow_r, r_pow_dp
    module procedure :: dp_pow_i8, i8_pow_dp
    module procedure :: dp_pow_i16, i16_pow_dp
    module procedure :: dp_pow_i32, i32_pow_dp
    module procedure :: dp_pow_i64, i64_pow_dp

#if QUATERNIONS_QP
    module procedure :: qp_pow_qp
    module procedure :: qp_pow_r, r_pow_qp
    module procedure :: qp_pow_i8, i8_pow_qp
    module procedure :: qp_pow_i16, i16_pow_qp
    module procedure :: qp_pow_i32, i32_pow_qp
    module procedure :: qp_pow_i64, i64_pow_qp
#endif
  end interface operator(**)

  interface abs
    !! Norm |q|

    module procedure :: sp_abs


    module procedure :: dp_abs

#if QUATERNIONS_QP
    module procedure :: qp_abs
#endif
  end interface abs

  interface conjg
    !! Conjugate w - xi - yj - zk

    module procedure :: sp_conjg


    module procedure :: dp_conjg

#if QUATERNIONS_QP
    module procedure :: qp_conjg
#endif
  end interface conjg

  interface real
    !! Scalar part w

    module procedure :: sp_real


    module procedure :: dp_real

#if QUATERNIONS_QP
    module procedure :: qp_real
#endif
  end interface real

  interface aimag
    !! Vector part [x, y, z]

    module procedure :: sp_aimag


    module procedure :: dp_aimag

#if QUATERNIONS_QP
    module procedure :: qp_aimag
#endif
  end interface aimag

  interface dot_product
    !! Four-dimensional dot product

    module procedure :: sp_dot


    module procedure :: dp_dot

#if QUATERNIONS_QP
    module procedure :: qp_dot
#endif
  end interface dot_product

  interface inv
    !! Inverse conjg(q)/|q|**2

    module procedure :: sp_inv


    module procedure :: dp_inv

#if QUATERNIONS_QP
    module procedure :: qp_inv
#endif
  end interface inv

  interface normalize
    !! Unit quaternion q/|q|

    module procedure :: sp_normalize


    module procedure :: dp_normalize

#if QUATERNIONS_QP
    module procedure :: qp_normalize
#endif
  end interface normalize

  interface is_close
    !! True if |a-b| <= max(rel_tol*max(|a|,|b|), abs_tol)

    module procedure :: sp_is_close


    module procedure :: dp_is_close

#if QUATERNIONS_QP
    module procedure :: qp_is_close
#endif
  end interface is_close

  interface to_string
    !! Text "w + xi + yj + zk", each part written with fmt (default "(g0)")

    module procedure :: sp_to_string


    module procedure :: dp_to_string

#if QUATERNIONS_QP
    module procedure :: qp_to_string
#endif
  end interface to_string

  interface log10
    !! Base-10 logarithm

    module procedure :: sp_log10


    module procedure :: dp_log10

#if QUATERNIONS_QP
    module procedure :: qp_log10
#endif
  end interface log10

  interface random_number
    !! Each component uniform in [0, 1), like the intrinsic

    module procedure :: sp_random_number


    module procedure :: dp_random_number

#if QUATERNIONS_QP
    module procedure :: qp_random_number
#endif
  end interface random_number

  interface random_rotation
    !! Unit quaternion uniformly distributed over all rotations

    module procedure :: sp_random_rotation


    module procedure :: dp_random_rotation

#if QUATERNIONS_QP
    module procedure :: qp_random_rotation
#endif
  end interface random_rotation

  interface from_axis_angle
    !! Rotation by angle (radians) about axis (need not be unit)

    module procedure :: sp_from_axis_angle


    module procedure :: dp_from_axis_angle

#if QUATERNIONS_QP
    module procedure :: qp_from_axis_angle
#endif
  end interface from_axis_angle

  interface to_axis_angle
    !! Unit axis and angle in [0, pi] of the rotation q

    module procedure :: sp_to_axis_angle


    module procedure :: dp_to_axis_angle

#if QUATERNIONS_QP
    module procedure :: qp_to_axis_angle
#endif
  end interface to_axis_angle

  interface rotate
    !! Rotate vector v: q v inv(q)

    module procedure :: sp_rotate


    module procedure :: dp_rotate

#if QUATERNIONS_QP
    module procedure :: qp_rotate
#endif
  end interface rotate

  interface to_matrix
    !! Rotation matrix R with matmul(R, v) == rotate(q, v)

    module procedure :: sp_to_matrix


    module procedure :: dp_to_matrix

#if QUATERNIONS_QP
    module procedure :: qp_to_matrix
#endif
  end interface to_matrix

  interface from_matrix
    !! Unit quaternion (w >= 0) from a rotation matrix

    module procedure :: sp_from_matrix


    module procedure :: dp_from_matrix

#if QUATERNIONS_QP
    module procedure :: qp_from_matrix
#endif
  end interface from_matrix

  interface from_euler_zyx
    !! Rotation Rz(yaw) Ry(pitch) Rx(roll)

    module procedure :: sp_from_euler_zyx


    module procedure :: dp_from_euler_zyx

#if QUATERNIONS_QP
    module procedure :: qp_from_euler_zyx
#endif
  end interface from_euler_zyx

  interface to_euler_zyx
    !! Yaw, pitch, roll of q; roll = 0 at gimbal lock

    module procedure :: sp_to_euler_zyx


    module procedure :: dp_to_euler_zyx

#if QUATERNIONS_QP
    module procedure :: qp_to_euler_zyx
#endif
  end interface to_euler_zyx

  interface slerp
    !! Spherical linear interpolation along the shorter arc

    module procedure :: sp_slerp


    module procedure :: dp_slerp

#if QUATERNIONS_QP
    module procedure :: qp_slerp
#endif
  end interface slerp

  interface sqrt
    !! Elementary function, consistent with complex sqrt

    module procedure :: sp_sqrt


    module procedure :: dp_sqrt

#if QUATERNIONS_QP
    module procedure :: qp_sqrt
#endif
  end interface sqrt

  interface exp
    !! Elementary function, consistent with complex exp

    module procedure :: sp_exp


    module procedure :: dp_exp

#if QUATERNIONS_QP
    module procedure :: qp_exp
#endif
  end interface exp

  interface log
    !! Elementary function, consistent with complex log

    module procedure :: sp_log


    module procedure :: dp_log

#if QUATERNIONS_QP
    module procedure :: qp_log
#endif
  end interface log

  interface sin
    !! Elementary function, consistent with complex sin

    module procedure :: sp_sin


    module procedure :: dp_sin

#if QUATERNIONS_QP
    module procedure :: qp_sin
#endif
  end interface sin

  interface cos
    !! Elementary function, consistent with complex cos

    module procedure :: sp_cos


    module procedure :: dp_cos

#if QUATERNIONS_QP
    module procedure :: qp_cos
#endif
  end interface cos

  interface tan
    !! Elementary function, consistent with complex tan

    module procedure :: sp_tan


    module procedure :: dp_tan

#if QUATERNIONS_QP
    module procedure :: qp_tan
#endif
  end interface tan

  interface asin
    !! Elementary function, consistent with complex asin

    module procedure :: sp_asin


    module procedure :: dp_asin

#if QUATERNIONS_QP
    module procedure :: qp_asin
#endif
  end interface asin

  interface acos
    !! Elementary function, consistent with complex acos

    module procedure :: sp_acos


    module procedure :: dp_acos

#if QUATERNIONS_QP
    module procedure :: qp_acos
#endif
  end interface acos

  interface atan
    !! Elementary function, consistent with complex atan

    module procedure :: sp_atan


    module procedure :: dp_atan

#if QUATERNIONS_QP
    module procedure :: qp_atan
#endif
  end interface atan

  interface sinh
    !! Elementary function, consistent with complex sinh

    module procedure :: sp_sinh


    module procedure :: dp_sinh

#if QUATERNIONS_QP
    module procedure :: qp_sinh
#endif
  end interface sinh

  interface cosh
    !! Elementary function, consistent with complex cosh

    module procedure :: sp_cosh


    module procedure :: dp_cosh

#if QUATERNIONS_QP
    module procedure :: qp_cosh
#endif
  end interface cosh

  interface tanh
    !! Elementary function, consistent with complex tanh

    module procedure :: sp_tanh


    module procedure :: dp_tanh

#if QUATERNIONS_QP
    module procedure :: qp_tanh
#endif
  end interface tanh

  interface asinh
    !! Elementary function, consistent with complex asinh

    module procedure :: sp_asinh


    module procedure :: dp_asinh

#if QUATERNIONS_QP
    module procedure :: qp_asinh
#endif
  end interface asinh

  interface acosh
    !! Elementary function, consistent with complex acosh

    module procedure :: sp_acosh


    module procedure :: dp_acosh

#if QUATERNIONS_QP
    module procedure :: qp_acosh
#endif
  end interface acosh

  interface atanh
    !! Elementary function, consistent with complex atanh

    module procedure :: sp_atanh


    module procedure :: dp_atanh

#if QUATERNIONS_QP
    module procedure :: qp_atanh
#endif
  end interface atanh

contains

pure function lower(s) result(r)
  !! Lowercase ASCII letters
  character(*), intent(in) :: s
  character(len(s)) :: r
  integer :: i
  r = s
  do i = 1, len(s)
    if (s(i:i) >= 'A' .and. s(i:i) <= 'Z') r(i:i) = achar(iachar(s(i:i)) + 32)
  end do
end function lower

pure function itoa(i) result(s)
  integer, intent(in) :: i
  character(:), allocatable :: s
  character(24) :: buf
  write(buf, '(i0)') i
  s = trim(buf)
end function itoa


!=======================================================================
! quat_sp
!=======================================================================

pure function sp_from_array(a) result(q)
  real(real32), intent(in) :: a(4)
  type(quat_sp) :: q
  q = quat_sp(a(1), a(2), a(3), a(4))
end function sp_from_array

elemental function sp_from_string(str) result(q)
  !! Parse a string; all components are NaN if it is not a quaternion
  character(*), intent(in) :: str
  type(quat_sp) :: q
  integer :: ios
  real(real32) :: nan
  call sp_parse(str, q, ios)
  if (ios /= 0) then
    nan = ieee_value(0._real32, ieee_quiet_nan)
    q = quat_sp(nan, nan, nan, nan)
  end if
end function sp_from_string


elemental function sp_from_dp(a) result(q)
  type(quat_dp), intent(in) :: a
  type(quat_sp) :: q
  q = quat_sp(real(a%w, real32), real(a%x, real32), real(a%y, real32), real(a%z, real32))
end function sp_from_dp


#if QUATERNIONS_QP
elemental function sp_from_qp(a) result(q)
  type(quat_qp), intent(in) :: a
  type(quat_sp) :: q
  q = quat_sp(real(a%w, real32), real(a%x, real32), real(a%y, real32), real(a%z, real32))
end function sp_from_qp
#endif

pure subroutine sp_parse(str, q, ios)
  !! Parse terms like "1.5", "-2i", "+ 3.0e-2j", "k" in any order and spacing.
  !! No blank is allowed between a number and its unit.  ios /= 0 on error.
  character(*), intent(in) :: str
  type(quat_sp), intent(out) :: q
  integer, intent(out) :: ios
  real(real32) :: c(4), val
  integer :: p, n, start, nterms, part, e
  logical :: neg

  c = 0; ios = 0; p = 1; n = len_trim(str); nterms = 0
  do
    do while (p <= n)
      if (str(p:p) /= ' ') exit
      p = p + 1
    end do
    if (p > n) exit
    neg = .false.
    if (str(p:p) == '+' .or. str(p:p) == '-') then
      neg = str(p:p) == '-'
      p = p + 1
      do while (p <= n)
        if (str(p:p) /= ' ') exit
        p = p + 1
      end do
    else if (nterms > 0) then
      ios = 1; return
    end if
    start = p
    if (lower(str(p:min(p+7, n))) == 'infinity') then
      p = p + 8
    else if (lower(str(p:min(p+2, n))) == 'inf' .or. lower(str(p:min(p+2, n))) == 'nan') then
      p = p + 3
    else
      do while (p <= n)
        if (index('0123456789.', str(p:p)) > 0) then
          p = p + 1
        else if (index('eEdD', str(p:p)) > 0 .and. p > start) then
          e = p + 1
          if (e <= n) then
            if (str(e:e) == '+' .or. str(e:e) == '-') e = e + 1
          end if
          if (e > n) exit
          if (index('0123456789', str(e:e)) == 0) exit
          p = e + 1
        else
          exit
        end if
      end do
    end if
    if (p > start) then
      read(str(start:p-1), *, iostat=ios) val
      if (ios /= 0) return
    else
      val = 1
    end if
    part = 1
    if (p <= n) part = index('iIjJkK', str(p:p))
    if (part > 0 .and. p <= n) then
      part = (part + 3)/2
      p = p + 1
    else
      part = 1
    end if
    if (p == start) then
      ios = 1; return
    end if
    if (neg) val = -val
    c(part) = c(part) + val
    nterms = nterms + 1
  end do
  if (nterms == 0) ios = 1
  q = quat_sp(c(1), c(2), c(3), c(4))
end subroutine sp_parse

elemental subroutine sp_assign_r(q, a)
  type(quat_sp), intent(out) :: q
  real(real32), intent(in) :: a
  q = quat_sp(real(a, real32))
end subroutine sp_assign_r

elemental subroutine sp_assign_i8(q, a)
  type(quat_sp), intent(out) :: q
  integer(int8), intent(in) :: a
  q = quat_sp(real(a, real32))
end subroutine sp_assign_i8

elemental subroutine sp_assign_i16(q, a)
  type(quat_sp), intent(out) :: q
  integer(int16), intent(in) :: a
  q = quat_sp(real(a, real32))
end subroutine sp_assign_i16

elemental subroutine sp_assign_i32(q, a)
  type(quat_sp), intent(out) :: q
  integer(int32), intent(in) :: a
  q = quat_sp(real(a, real32))
end subroutine sp_assign_i32

elemental subroutine sp_assign_i64(q, a)
  type(quat_sp), intent(out) :: q
  integer(int64), intent(in) :: a
  q = quat_sp(real(a, real32))
end subroutine sp_assign_i64

!-----------------------------------------------------------------------
! Arithmetic and comparison
!-----------------------------------------------------------------------

elemental function sp_pos(a) result(c)
  type(quat_sp), intent(in) :: a
  type(quat_sp) :: c
  c = a
end function sp_pos

elemental function sp_neg(a) result(c)
  type(quat_sp), intent(in) :: a
  type(quat_sp) :: c
  c = quat_sp(-a%w, -a%x, -a%y, -a%z)
end function sp_neg

elemental function sp_add_sp(a, b) result(c)
  type(quat_sp), intent(in) :: a, b
  type(quat_sp) :: c
  c = quat_sp(a%w + b%w, a%x + b%x, a%y + b%y, a%z + b%z)
end function sp_add_sp

elemental function sp_sub_sp(a, b) result(c)
  type(quat_sp), intent(in) :: a, b
  type(quat_sp) :: c
  c = quat_sp(a%w - b%w, a%x - b%x, a%y - b%y, a%z - b%z)
end function sp_sub_sp

elemental function sp_mul_sp(a, b) result(c)
  !! Hamilton product
  type(quat_sp), intent(in) :: a, b
  type(quat_sp) :: c
  c = quat_sp(a%w*b%w - a%x*b%x - a%y*b%y - a%z*b%z, &
               & a%w*b%x + a%x*b%w + a%y*b%z - a%z*b%y, &
               & a%w*b%y - a%x*b%z + a%y*b%w + a%z*b%x, &
               & a%w*b%z + a%x*b%y - a%y*b%x + a%z*b%w)
end function sp_mul_sp

elemental function sp_div_sp(a, b) result(c)
  !! Right division a*inv(b)
  type(quat_sp), intent(in) :: a, b
  type(quat_sp) :: c
  c = a*sp_inv(b)
end function sp_div_sp

elemental logical function sp_eq_sp(a, b) result(c)
  type(quat_sp), intent(in) :: a, b
  c = a%w == b%w .and. a%x == b%x .and. a%y == b%y .and. a%z == b%z
end function sp_eq_sp

elemental logical function sp_ne_sp(a, b) result(c)
  type(quat_sp), intent(in) :: a, b
  c = .not. sp_eq_sp(a, b)
end function sp_ne_sp

elemental function sp_add_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w + b, a%x, a%y, a%z)
end function sp_add_r

elemental function r_add_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a + b%w, b%x, b%y, b%z)
end function r_add_sp

elemental function sp_sub_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w - b, a%x, a%y, a%z)
end function sp_sub_r

elemental function r_sub_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a - b%w, -b%x, -b%y, -b%z)
end function r_sub_sp

elemental function sp_mul_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w*b, a%x*b, a%y*b, a%z*b)
end function sp_mul_r

elemental function r_mul_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a*b%w, a*b%x, a*b%y, a*b%z)
end function r_mul_sp

elemental function sp_div_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w/b, a%x/b, a%y/b, a%z/b)
end function sp_div_r

elemental function r_div_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = a*sp_inv(b)
end function r_div_sp

elemental logical function sp_eq_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function sp_eq_r

elemental logical function r_eq_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = sp_eq_r(b, a)
end function r_eq_sp

elemental logical function sp_ne_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  c = .not. sp_eq_r(a, b)
end function sp_ne_r

elemental logical function r_ne_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = .not. sp_eq_r(b, a)
end function r_ne_sp

elemental function sp_add_i8(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w + b, a%x, a%y, a%z)
end function sp_add_i8

elemental function i8_add_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a + b%w, b%x, b%y, b%z)
end function i8_add_sp

elemental function sp_sub_i8(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w - b, a%x, a%y, a%z)
end function sp_sub_i8

elemental function i8_sub_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a - b%w, -b%x, -b%y, -b%z)
end function i8_sub_sp

elemental function sp_mul_i8(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w*b, a%x*b, a%y*b, a%z*b)
end function sp_mul_i8

elemental function i8_mul_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i8_mul_sp

elemental function sp_div_i8(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w/b, a%x/b, a%y/b, a%z/b)
end function sp_div_i8

elemental function i8_div_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = a*sp_inv(b)
end function i8_div_sp

elemental logical function sp_eq_i8(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function sp_eq_i8

elemental logical function i8_eq_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = sp_eq_i8(b, a)
end function i8_eq_sp

elemental logical function sp_ne_i8(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: b
  c = .not. sp_eq_i8(a, b)
end function sp_ne_i8

elemental logical function i8_ne_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = .not. sp_eq_i8(b, a)
end function i8_ne_sp

elemental function sp_add_i16(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w + b, a%x, a%y, a%z)
end function sp_add_i16

elemental function i16_add_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a + b%w, b%x, b%y, b%z)
end function i16_add_sp

elemental function sp_sub_i16(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w - b, a%x, a%y, a%z)
end function sp_sub_i16

elemental function i16_sub_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a - b%w, -b%x, -b%y, -b%z)
end function i16_sub_sp

elemental function sp_mul_i16(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w*b, a%x*b, a%y*b, a%z*b)
end function sp_mul_i16

elemental function i16_mul_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i16_mul_sp

elemental function sp_div_i16(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w/b, a%x/b, a%y/b, a%z/b)
end function sp_div_i16

elemental function i16_div_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = a*sp_inv(b)
end function i16_div_sp

elemental logical function sp_eq_i16(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function sp_eq_i16

elemental logical function i16_eq_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = sp_eq_i16(b, a)
end function i16_eq_sp

elemental logical function sp_ne_i16(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: b
  c = .not. sp_eq_i16(a, b)
end function sp_ne_i16

elemental logical function i16_ne_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = .not. sp_eq_i16(b, a)
end function i16_ne_sp

elemental function sp_add_i32(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w + b, a%x, a%y, a%z)
end function sp_add_i32

elemental function i32_add_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a + b%w, b%x, b%y, b%z)
end function i32_add_sp

elemental function sp_sub_i32(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w - b, a%x, a%y, a%z)
end function sp_sub_i32

elemental function i32_sub_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a - b%w, -b%x, -b%y, -b%z)
end function i32_sub_sp

elemental function sp_mul_i32(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w*b, a%x*b, a%y*b, a%z*b)
end function sp_mul_i32

elemental function i32_mul_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i32_mul_sp

elemental function sp_div_i32(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w/b, a%x/b, a%y/b, a%z/b)
end function sp_div_i32

elemental function i32_div_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = a*sp_inv(b)
end function i32_div_sp

elemental logical function sp_eq_i32(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function sp_eq_i32

elemental logical function i32_eq_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = sp_eq_i32(b, a)
end function i32_eq_sp

elemental logical function sp_ne_i32(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: b
  c = .not. sp_eq_i32(a, b)
end function sp_ne_i32

elemental logical function i32_ne_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = .not. sp_eq_i32(b, a)
end function i32_ne_sp

elemental function sp_add_i64(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w + b, a%x, a%y, a%z)
end function sp_add_i64

elemental function i64_add_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a + b%w, b%x, b%y, b%z)
end function i64_add_sp

elemental function sp_sub_i64(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w - b, a%x, a%y, a%z)
end function sp_sub_i64

elemental function i64_sub_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a - b%w, -b%x, -b%y, -b%z)
end function i64_sub_sp

elemental function sp_mul_i64(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w*b, a%x*b, a%y*b, a%z*b)
end function sp_mul_i64

elemental function i64_mul_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i64_mul_sp

elemental function sp_div_i64(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_sp) :: c
  c = quat_sp(a%w/b, a%x/b, a%y/b, a%z/b)
end function sp_div_i64

elemental function i64_div_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = a*sp_inv(b)
end function i64_div_sp

elemental logical function sp_eq_i64(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function sp_eq_i64

elemental logical function i64_eq_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = sp_eq_i64(b, a)
end function i64_eq_sp

elemental logical function sp_ne_i64(a, b) result(c)
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: b
  c = .not. sp_eq_i64(a, b)
end function sp_ne_i64

elemental logical function i64_ne_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  c = .not. sp_eq_i64(b, a)
end function i64_ne_sp

elemental function sp_pow_r(a, b) result(c)
  type(quat_sp), intent(in) :: a
  real(real32), intent(in) :: b
  type(quat_sp) :: c
  c = sp_from_c(sp_to_c(a)**b, a)
end function sp_pow_r

elemental function r_pow_sp(a, b) result(c)
  real(real32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = sp_exp(sp_log(quat_sp(real(a, real32)))*b)
end function r_pow_sp

elemental function sp_pow_i8(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_sp), intent(in) :: a
  integer(int8), intent(in) :: n
  type(quat_sp) :: c, b
  integer(int8) :: m
  c = quat_sp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = sp_inv(c)
end function sp_pow_i8

elemental function i8_pow_sp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = sp_exp(sp_log(quat_sp(real(a, real32)))*b)
end function i8_pow_sp

elemental function sp_pow_i16(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_sp), intent(in) :: a
  integer(int16), intent(in) :: n
  type(quat_sp) :: c, b
  integer(int16) :: m
  c = quat_sp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = sp_inv(c)
end function sp_pow_i16

elemental function i16_pow_sp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = sp_exp(sp_log(quat_sp(real(a, real32)))*b)
end function i16_pow_sp

elemental function sp_pow_i32(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_sp), intent(in) :: a
  integer(int32), intent(in) :: n
  type(quat_sp) :: c, b
  integer(int32) :: m
  c = quat_sp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = sp_inv(c)
end function sp_pow_i32

elemental function i32_pow_sp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = sp_exp(sp_log(quat_sp(real(a, real32)))*b)
end function i32_pow_sp

elemental function sp_pow_i64(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_sp), intent(in) :: a
  integer(int64), intent(in) :: n
  type(quat_sp) :: c, b
  integer(int64) :: m
  c = quat_sp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = sp_inv(c)
end function sp_pow_i64

elemental function i64_pow_sp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_sp), intent(in) :: b
  type(quat_sp) :: c
  c = sp_exp(sp_log(quat_sp(real(a, real32)))*b)
end function i64_pow_sp

elemental function sp_pow_sp(a, b) result(c)
  !! exp(log(a)*b)
  type(quat_sp), intent(in) :: a, b
  type(quat_sp) :: c
  c = sp_exp(sp_log(a)*b)
end function sp_pow_sp

!-----------------------------------------------------------------------
! Basic functions
!-----------------------------------------------------------------------

elemental real(real32) function sp_abs(q) result(r)
  type(quat_sp), intent(in) :: q
  r = norm2([q%w, q%x, q%y, q%z])
end function sp_abs

elemental function sp_conjg(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = quat_sp(q%w, -q%x, -q%y, -q%z)
end function sp_conjg

elemental real(real32) function sp_real(q) result(r)
  type(quat_sp), intent(in) :: q
  r = q%w
end function sp_real

pure function sp_aimag(q) result(v)
  type(quat_sp), intent(in) :: q
  real(real32) :: v(3)
  v = [q%x, q%y, q%z]
end function sp_aimag

elemental real(real32) function sp_dot(a, b) result(r)
  type(quat_sp), intent(in) :: a, b
  r = a%w*b%w + a%x*b%x + a%y*b%y + a%z*b%z
end function sp_dot

elemental function sp_inv(q) result(r)
  !! Scaled to avoid premature overflow and underflow
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r, p
  real(real32) :: sc
  sc = max(abs(q%w), abs(q%x), abs(q%y), abs(q%z))
  p = q/sc
  r = sp_conjg(p)/(sp_dot(p, p)*sc)
end function sp_inv

elemental function sp_normalize(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = q/sp_abs(q)
end function sp_normalize

elemental logical function sp_is_close(a, b, rel_tol, abs_tol) result(c)
  !! Defaults: rel_tol = sqrt(epsilon), abs_tol = 0
  type(quat_sp), intent(in) :: a, b
  real(real32), intent(in), optional :: rel_tol, abs_tol
  real(real32) :: rt, at
  rt = sqrt(epsilon(1._real32))
  if (present(rel_tol)) rt = rel_tol
  at = 0
  if (present(abs_tol)) at = abs_tol
  c = sp_abs(a - b) <= max(rt*max(sp_abs(a), sp_abs(b)), at)
end function sp_is_close

!-----------------------------------------------------------------------
! Elementary functions: f(w + u n) = Re f(w + in) + u Im f(w + in), with
! u = (x, y, z)/n, n = |(x, y, z)|, and u = i on the real axis.
!-----------------------------------------------------------------------

elemental complex(real32) function sp_to_c(q) result(c)
  type(quat_sp), intent(in) :: q
  c = cmplx(q%w, norm2([q%x, q%y, q%z]), kind=real32)
end function sp_to_c

elemental function sp_from_c(c, q) result(r)
  !! Map c = a + ib back onto the axis of q
  complex(real32), intent(in) :: c
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  real(real32) :: n, b
  n = norm2([q%x, q%y, q%z])
  b = aimag(c)
  if (n > 0) then
    r = quat_sp(real(c), b*(q%x/n), b*(q%y/n), b*(q%z/n))
  else
    r = quat_sp(real(c), b)
  end if
end function sp_from_c

elemental function sp_sqrt(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(sqrt(sp_to_c(q)), q)
end function sp_sqrt

elemental function sp_exp(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(exp(sp_to_c(q)), q)
end function sp_exp

elemental function sp_log(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(log(sp_to_c(q)), q)
end function sp_log

elemental function sp_sin(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(sin(sp_to_c(q)), q)
end function sp_sin

elemental function sp_cos(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(cos(sp_to_c(q)), q)
end function sp_cos

elemental function sp_tan(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(tan(sp_to_c(q)), q)
end function sp_tan

elemental function sp_asin(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(asin(sp_to_c(q)), q)
end function sp_asin

elemental function sp_acos(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(acos(sp_to_c(q)), q)
end function sp_acos

elemental function sp_atan(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(atan(sp_to_c(q)), q)
end function sp_atan

elemental function sp_sinh(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(sinh(sp_to_c(q)), q)
end function sp_sinh

elemental function sp_cosh(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(cosh(sp_to_c(q)), q)
end function sp_cosh

elemental function sp_tanh(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(tanh(sp_to_c(q)), q)
end function sp_tanh

elemental function sp_asinh(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(sp_casinh(sp_to_c(q)), q)
end function sp_asinh

elemental function sp_acosh(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(sp_cacosh(sp_to_c(q)), q)
end function sp_acosh

elemental function sp_atanh(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_from_c(sp_catanh(sp_to_c(q)), q)
end function sp_atanh

! Complex inverse hyperbolic functions via the C99 identities, because not
! every compiler provides them for complex arguments.

elemental complex(real32) function sp_casinh(c) result(r)
  complex(real32), intent(in) :: c
  complex(real32), parameter :: i = (0, 1)
  r = -i*asin(i*c)
end function sp_casinh

elemental complex(real32) function sp_cacosh(c) result(r)
  complex(real32), intent(in) :: c
  complex(real32), parameter :: i = (0, 1)
  r = i*acos(c)
  if (real(r) < 0) r = -r
end function sp_cacosh

elemental complex(real32) function sp_catanh(c) result(r)
  complex(real32), intent(in) :: c
  complex(real32), parameter :: i = (0, 1)
  r = -i*atan(i*c)
end function sp_catanh

elemental function sp_log10(q) result(r)
  type(quat_sp), intent(in) :: q
  type(quat_sp) :: r
  r = sp_log(q)/log(10._real32)
end function sp_log10

!-----------------------------------------------------------------------
! Random numbers
!-----------------------------------------------------------------------

impure elemental subroutine sp_random_number(q)
  type(quat_sp), intent(out) :: q
  real(real32) :: r(4)
  call random_number(r)
  q = sp_from_array(r)
end subroutine sp_random_number

impure elemental subroutine sp_random_rotation(q)
  !! Shoemake's method
  type(quat_sp), intent(out) :: q
  real(real32), parameter :: twopi = 2*acos(-1._real32)
  real(real32) :: r(3), a, b
  call random_number(r)
  a = sqrt(1 - r(1))
  b = sqrt(r(1))
  q = quat_sp(b*cos(twopi*r(3)), a*sin(twopi*r(2)), a*cos(twopi*r(2)), b*sin(twopi*r(3)))
end subroutine sp_random_rotation

!-----------------------------------------------------------------------
! Rotations
!-----------------------------------------------------------------------

pure function sp_cross(a, b) result(c)
  real(real32), intent(in) :: a(3), b(3)
  real(real32) :: c(3)
  c = [a(2)*b(3) - a(3)*b(2), a(3)*b(1) - a(1)*b(3), a(1)*b(2) - a(2)*b(1)]
end function sp_cross

pure function sp_from_axis_angle(axis, angle) result(q)
  real(real32), intent(in) :: axis(3), angle
  type(quat_sp) :: q
  real(real32) :: u(3)
  u = axis/norm2(axis)*sin(angle/2)
  q = quat_sp(cos(angle/2), u(1), u(2), u(3))
end function sp_from_axis_angle

pure subroutine sp_to_axis_angle(q, axis, angle)
  !! axis = [1, 0, 0] for the identity rotation
  type(quat_sp), intent(in) :: q
  real(real32), intent(out) :: axis(3), angle
  type(quat_sp) :: p
  real(real32) :: n
  p = sp_normalize(q)
  if (p%w < 0) p = -p
  n = norm2([p%x, p%y, p%z])
  angle = 2*atan2(n, p%w)
  if (n > 0) then
    axis = [p%x, p%y, p%z]/n
  else
    axis = [1, 0, 0]
  end if
end subroutine sp_to_axis_angle

pure function sp_rotate(q, v) result(r)
  !! v + 2(w t + u x t)/|q|**2 with t = u x v; q need not be a unit quaternion
  type(quat_sp), intent(in) :: q
  real(real32), intent(in) :: v(3)
  real(real32) :: r(3), u(3), t(3)
  u = [q%x, q%y, q%z]
  t = sp_cross(u, v)
  r = v + 2*(q%w*t + sp_cross(u, t))/sp_dot(q, q)
end function sp_rotate

pure function sp_to_matrix(q) result(m)
  type(quat_sp), intent(in) :: q
  real(real32) :: m(3,3), f
  f = 2/sp_dot(q, q)
  associate(w => q%w, x => q%x, y => q%y, z => q%z)
    m(1,:) = [1 - f*(y*y + z*z), f*(x*y - z*w), f*(x*z + y*w)]
    m(2,:) = [f*(x*y + z*w), 1 - f*(x*x + z*z), f*(y*z - x*w)]
    m(3,:) = [f*(x*z - y*w), f*(y*z + x*w), 1 - f*(x*x + y*y)]
  end associate
end function sp_to_matrix

pure function sp_from_matrix(m) result(q)
  !! Shepperd's method: divide by the largest of 4w**2, 4x**2, 4y**2, 4z**2
  real(real32), intent(in) :: m(3,3)
  type(quat_sp) :: q
  real(real32) :: d(4), f
  d = [m(1,1) + m(2,2) + m(3,3), m(1,1), m(2,2), m(3,3)]
  select case (maxloc(d, dim=1))
  case (1)
    f = sqrt(1 + d(1))*2
    q = quat_sp(f/4, (m(3,2) - m(2,3))/f, (m(1,3) - m(3,1))/f, (m(2,1) - m(1,2))/f)
  case (2)
    f = sqrt(1 + m(1,1) - m(2,2) - m(3,3))*2
    q = quat_sp((m(3,2) - m(2,3))/f, f/4, (m(1,2) + m(2,1))/f, (m(1,3) + m(3,1))/f)
  case (3)
    f = sqrt(1 - m(1,1) + m(2,2) - m(3,3))*2
    q = quat_sp((m(1,3) - m(3,1))/f, (m(1,2) + m(2,1))/f, f/4, (m(2,3) + m(3,2))/f)
  case default
    f = sqrt(1 - m(1,1) - m(2,2) + m(3,3))*2
    q = quat_sp((m(2,1) - m(1,2))/f, (m(1,3) + m(3,1))/f, (m(2,3) + m(3,2))/f, f/4)
  end select
  if (q%w < 0) q = -q
end function sp_from_matrix

elemental function sp_from_euler_zyx(yaw, pitch, roll) result(q)
  !! qz(yaw) qy(pitch) qx(roll): roll about x first, then pitch about y, then yaw about z
  real(real32), intent(in) :: yaw, pitch, roll
  type(quat_sp) :: q
  real(real32) :: cy, sy, cp, sp, cr, sr
  cy = cos(yaw/2); sy = sin(yaw/2)
  cp = cos(pitch/2); sp = sin(pitch/2)
  cr = cos(roll/2); sr = sin(roll/2)
  q = quat_sp(cr*cp*cy + sr*sp*sy, sr*cp*cy - cr*sp*sy, cr*sp*cy + sr*cp*sy, cr*cp*sy - sr*sp*cy)
end function sp_from_euler_zyx

elemental subroutine sp_to_euler_zyx(q, yaw, pitch, roll)
  !! yaw, roll in (-pi, pi], pitch in [-pi/2, pi/2]
  type(quat_sp), intent(in) :: q
  real(real32), intent(out) :: yaw, pitch, roll
  real(real32), parameter :: pi = acos(-1._real32)
  type(quat_sp) :: p
  real(real32) :: sp
  p = sp_normalize(q)
  sp = 2*(p%w*p%y - p%z*p%x)
  if (abs(sp) >= 1 - 4*epsilon(sp)) then
    pitch = sign(pi/2, sp)
    roll = 0
    yaw = 2*atan2(p%z, p%w)
    if (yaw > pi) yaw = yaw - 2*pi
    if (yaw <= -pi) yaw = yaw + 2*pi
  else
    pitch = asin(sp)
    roll = atan2(2*(p%w*p%x + p%y*p%z), 1 - 2*(p%x**2 + p%y**2))
    yaw = atan2(2*(p%w*p%z + p%x*p%y), 1 - 2*(p%y**2 + p%z**2))
  end if
end subroutine sp_to_euler_zyx

elemental function sp_slerp(a, b, t) result(r)
  !! a and b are unit quaternions; t = 0 gives a, t = 1 gives b or -b
  type(quat_sp), intent(in) :: a, b
  real(real32), intent(in) :: t
  type(quat_sp) :: r, c
  real(real32) :: th
  c = b
  if (sp_dot(a, b) < 0) c = -b
  th = 2*atan2(sp_abs(a - c), sp_abs(a + c))
  if (th == 0) then
    r = a
  else
    r = (sin((1 - t)*th)*a + sin(t*th)*c)/sin(th)
  end if
end function sp_slerp

!-----------------------------------------------------------------------
! Text
!-----------------------------------------------------------------------

pure function sp_to_string(q, fmt) result(str)
  type(quat_sp), intent(in) :: q
  character(*), intent(in), optional :: fmt
  character(:), allocatable :: str, f
  f = '(g0)'
  if (present(fmt)) f = fmt
  str = num(q%w) // sgn(q%x) // num(abs(q%x)) // 'i' // sgn(q%y) // num(abs(q%y)) // 'j' &
      & // sgn(q%z) // num(abs(q%z)) // 'k'
contains
  pure function num(v) result(s)
    real(real32), intent(in) :: v
    character(:), allocatable :: s
    character(128) :: buf
    write(buf, f) v
    s = trim(adjustl(buf))
  end function num
  pure function sgn(v) result(s)
    real(real32), intent(in) :: v
    character(3) :: s
    s = ' + '
    if (sign(1._real32, v) < 0) s = ' - '
  end function sgn
end function sp_to_string

subroutine write_sp(dtv, unit, iotype, v_list, iostat, iomsg)
  !! List-directed: a blank, then g0 parts.  DT"F8.4" or DT"F"(8,4): that edit descriptor for each part.
  class(quat_sp), intent(in) :: dtv
  integer, intent(in) :: unit
  character(*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(*), intent(inout) :: iomsg
  character(:), allocatable :: f, lead
  lead = ''
  if (iotype == 'LISTDIRECTED' .or. iotype == 'NAMELIST') then
    f = 'g0'
    lead = ' '
  else
    f = iotype(3:)
    if (size(v_list) > 0) then
      if (f == '') f = 'g'
      f = f // itoa(v_list(1))
      if (size(v_list) > 1) f = f // '.' // itoa(v_list(2))
    else if (f == '') then
      f = 'g0'
    end if
  end if
  ! Build the text before writing: nvfortran fails on I/O inside an output list
  f = lead // sp_to_string(dtv, '(' // f // ')')
  write(unit, '(a)', iostat=iostat, iomsg=iomsg) f
end subroutine write_sp

subroutine read_sp(dtv, unit, iotype, v_list, iostat, iomsg)
  !! Reads characters up to and including the k part, e.g. "1 + 2i + 3j + 4k"
  !! or "1+2i+3j+4k", within one record of an external file.  Edit descriptors
  !! are ignored.  Reading stops at the k so the record end is never reached.
  !! Character variables are not supported as files; use quat_sp(string).
  class(quat_sp), intent(inout) :: dtv
  integer, intent(in) :: unit
  character(*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(*), intent(inout) :: iomsg
  character :: ch
  character(:), allocatable :: text
  type(quat_sp) :: q
  associate(unused => iotype, unused2 => v_list); end associate
  text = ''
  do
    read(unit, '(a)', advance='no', iostat=iostat, iomsg=iomsg) ch
    if (is_iostat_eor(iostat)) then
      iostat = 1
      iomsg = 'quaternion text must end with its k part: ' // text
      return
    end if
    if (iostat /= 0) then
      if (len(text) == 0) iomsg = trim(iomsg) // ' (to parse a string, use quat_sp(string))'
      return
    end if
    if (len(text) == 0 .and. (ch == ' ' .or. ch == ',')) cycle
    text = text // ch
    if (ch == 'k' .or. ch == 'K') exit
  end do
  call sp_parse(text, q, iostat)
  if (iostat /= 0) then
    iomsg = 'not a quaternion: ' // text
    return
  end if
  dtv%w = q%w; dtv%x = q%x; dtv%y = q%y; dtv%z = q%z
end subroutine read_sp



!=======================================================================
! quat_dp
!=======================================================================

pure function dp_from_array(a) result(q)
  real(real64), intent(in) :: a(4)
  type(quat_dp) :: q
  q = quat_dp(a(1), a(2), a(3), a(4))
end function dp_from_array

elemental function dp_from_string(str) result(q)
  !! Parse a string; all components are NaN if it is not a quaternion
  character(*), intent(in) :: str
  type(quat_dp) :: q
  integer :: ios
  real(real64) :: nan
  call dp_parse(str, q, ios)
  if (ios /= 0) then
    nan = ieee_value(0._real64, ieee_quiet_nan)
    q = quat_dp(nan, nan, nan, nan)
  end if
end function dp_from_string


elemental function dp_from_sp(a) result(q)
  type(quat_sp), intent(in) :: a
  type(quat_dp) :: q
  q = quat_dp(real(a%w, real64), real(a%x, real64), real(a%y, real64), real(a%z, real64))
end function dp_from_sp


#if QUATERNIONS_QP
elemental function dp_from_qp(a) result(q)
  type(quat_qp), intent(in) :: a
  type(quat_dp) :: q
  q = quat_dp(real(a%w, real64), real(a%x, real64), real(a%y, real64), real(a%z, real64))
end function dp_from_qp
#endif

pure subroutine dp_parse(str, q, ios)
  !! Parse terms like "1.5", "-2i", "+ 3.0e-2j", "k" in any order and spacing.
  !! No blank is allowed between a number and its unit.  ios /= 0 on error.
  character(*), intent(in) :: str
  type(quat_dp), intent(out) :: q
  integer, intent(out) :: ios
  real(real64) :: c(4), val
  integer :: p, n, start, nterms, part, e
  logical :: neg

  c = 0; ios = 0; p = 1; n = len_trim(str); nterms = 0
  do
    do while (p <= n)
      if (str(p:p) /= ' ') exit
      p = p + 1
    end do
    if (p > n) exit
    neg = .false.
    if (str(p:p) == '+' .or. str(p:p) == '-') then
      neg = str(p:p) == '-'
      p = p + 1
      do while (p <= n)
        if (str(p:p) /= ' ') exit
        p = p + 1
      end do
    else if (nterms > 0) then
      ios = 1; return
    end if
    start = p
    if (lower(str(p:min(p+7, n))) == 'infinity') then
      p = p + 8
    else if (lower(str(p:min(p+2, n))) == 'inf' .or. lower(str(p:min(p+2, n))) == 'nan') then
      p = p + 3
    else
      do while (p <= n)
        if (index('0123456789.', str(p:p)) > 0) then
          p = p + 1
        else if (index('eEdD', str(p:p)) > 0 .and. p > start) then
          e = p + 1
          if (e <= n) then
            if (str(e:e) == '+' .or. str(e:e) == '-') e = e + 1
          end if
          if (e > n) exit
          if (index('0123456789', str(e:e)) == 0) exit
          p = e + 1
        else
          exit
        end if
      end do
    end if
    if (p > start) then
      read(str(start:p-1), *, iostat=ios) val
      if (ios /= 0) return
    else
      val = 1
    end if
    part = 1
    if (p <= n) part = index('iIjJkK', str(p:p))
    if (part > 0 .and. p <= n) then
      part = (part + 3)/2
      p = p + 1
    else
      part = 1
    end if
    if (p == start) then
      ios = 1; return
    end if
    if (neg) val = -val
    c(part) = c(part) + val
    nterms = nterms + 1
  end do
  if (nterms == 0) ios = 1
  q = quat_dp(c(1), c(2), c(3), c(4))
end subroutine dp_parse

elemental subroutine dp_assign_r(q, a)
  type(quat_dp), intent(out) :: q
  real(real64), intent(in) :: a
  q = quat_dp(real(a, real64))
end subroutine dp_assign_r

elemental subroutine dp_assign_i8(q, a)
  type(quat_dp), intent(out) :: q
  integer(int8), intent(in) :: a
  q = quat_dp(real(a, real64))
end subroutine dp_assign_i8

elemental subroutine dp_assign_i16(q, a)
  type(quat_dp), intent(out) :: q
  integer(int16), intent(in) :: a
  q = quat_dp(real(a, real64))
end subroutine dp_assign_i16

elemental subroutine dp_assign_i32(q, a)
  type(quat_dp), intent(out) :: q
  integer(int32), intent(in) :: a
  q = quat_dp(real(a, real64))
end subroutine dp_assign_i32

elemental subroutine dp_assign_i64(q, a)
  type(quat_dp), intent(out) :: q
  integer(int64), intent(in) :: a
  q = quat_dp(real(a, real64))
end subroutine dp_assign_i64

!-----------------------------------------------------------------------
! Arithmetic and comparison
!-----------------------------------------------------------------------

elemental function dp_pos(a) result(c)
  type(quat_dp), intent(in) :: a
  type(quat_dp) :: c
  c = a
end function dp_pos

elemental function dp_neg(a) result(c)
  type(quat_dp), intent(in) :: a
  type(quat_dp) :: c
  c = quat_dp(-a%w, -a%x, -a%y, -a%z)
end function dp_neg

elemental function dp_add_dp(a, b) result(c)
  type(quat_dp), intent(in) :: a, b
  type(quat_dp) :: c
  c = quat_dp(a%w + b%w, a%x + b%x, a%y + b%y, a%z + b%z)
end function dp_add_dp

elemental function dp_sub_dp(a, b) result(c)
  type(quat_dp), intent(in) :: a, b
  type(quat_dp) :: c
  c = quat_dp(a%w - b%w, a%x - b%x, a%y - b%y, a%z - b%z)
end function dp_sub_dp

elemental function dp_mul_dp(a, b) result(c)
  !! Hamilton product
  type(quat_dp), intent(in) :: a, b
  type(quat_dp) :: c
  c = quat_dp(a%w*b%w - a%x*b%x - a%y*b%y - a%z*b%z, &
               & a%w*b%x + a%x*b%w + a%y*b%z - a%z*b%y, &
               & a%w*b%y - a%x*b%z + a%y*b%w + a%z*b%x, &
               & a%w*b%z + a%x*b%y - a%y*b%x + a%z*b%w)
end function dp_mul_dp

elemental function dp_div_dp(a, b) result(c)
  !! Right division a*inv(b)
  type(quat_dp), intent(in) :: a, b
  type(quat_dp) :: c
  c = a*dp_inv(b)
end function dp_div_dp

elemental logical function dp_eq_dp(a, b) result(c)
  type(quat_dp), intent(in) :: a, b
  c = a%w == b%w .and. a%x == b%x .and. a%y == b%y .and. a%z == b%z
end function dp_eq_dp

elemental logical function dp_ne_dp(a, b) result(c)
  type(quat_dp), intent(in) :: a, b
  c = .not. dp_eq_dp(a, b)
end function dp_ne_dp

elemental function dp_add_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w + b, a%x, a%y, a%z)
end function dp_add_r

elemental function r_add_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a + b%w, b%x, b%y, b%z)
end function r_add_dp

elemental function dp_sub_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w - b, a%x, a%y, a%z)
end function dp_sub_r

elemental function r_sub_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a - b%w, -b%x, -b%y, -b%z)
end function r_sub_dp

elemental function dp_mul_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w*b, a%x*b, a%y*b, a%z*b)
end function dp_mul_r

elemental function r_mul_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a*b%w, a*b%x, a*b%y, a*b%z)
end function r_mul_dp

elemental function dp_div_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w/b, a%x/b, a%y/b, a%z/b)
end function dp_div_r

elemental function r_div_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = a*dp_inv(b)
end function r_div_dp

elemental logical function dp_eq_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function dp_eq_r

elemental logical function r_eq_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = dp_eq_r(b, a)
end function r_eq_dp

elemental logical function dp_ne_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  c = .not. dp_eq_r(a, b)
end function dp_ne_r

elemental logical function r_ne_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = .not. dp_eq_r(b, a)
end function r_ne_dp

elemental function dp_add_i8(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w + b, a%x, a%y, a%z)
end function dp_add_i8

elemental function i8_add_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a + b%w, b%x, b%y, b%z)
end function i8_add_dp

elemental function dp_sub_i8(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w - b, a%x, a%y, a%z)
end function dp_sub_i8

elemental function i8_sub_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a - b%w, -b%x, -b%y, -b%z)
end function i8_sub_dp

elemental function dp_mul_i8(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w*b, a%x*b, a%y*b, a%z*b)
end function dp_mul_i8

elemental function i8_mul_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i8_mul_dp

elemental function dp_div_i8(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w/b, a%x/b, a%y/b, a%z/b)
end function dp_div_i8

elemental function i8_div_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = a*dp_inv(b)
end function i8_div_dp

elemental logical function dp_eq_i8(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function dp_eq_i8

elemental logical function i8_eq_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = dp_eq_i8(b, a)
end function i8_eq_dp

elemental logical function dp_ne_i8(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: b
  c = .not. dp_eq_i8(a, b)
end function dp_ne_i8

elemental logical function i8_ne_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = .not. dp_eq_i8(b, a)
end function i8_ne_dp

elemental function dp_add_i16(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w + b, a%x, a%y, a%z)
end function dp_add_i16

elemental function i16_add_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a + b%w, b%x, b%y, b%z)
end function i16_add_dp

elemental function dp_sub_i16(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w - b, a%x, a%y, a%z)
end function dp_sub_i16

elemental function i16_sub_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a - b%w, -b%x, -b%y, -b%z)
end function i16_sub_dp

elemental function dp_mul_i16(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w*b, a%x*b, a%y*b, a%z*b)
end function dp_mul_i16

elemental function i16_mul_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i16_mul_dp

elemental function dp_div_i16(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w/b, a%x/b, a%y/b, a%z/b)
end function dp_div_i16

elemental function i16_div_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = a*dp_inv(b)
end function i16_div_dp

elemental logical function dp_eq_i16(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function dp_eq_i16

elemental logical function i16_eq_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = dp_eq_i16(b, a)
end function i16_eq_dp

elemental logical function dp_ne_i16(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: b
  c = .not. dp_eq_i16(a, b)
end function dp_ne_i16

elemental logical function i16_ne_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = .not. dp_eq_i16(b, a)
end function i16_ne_dp

elemental function dp_add_i32(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w + b, a%x, a%y, a%z)
end function dp_add_i32

elemental function i32_add_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a + b%w, b%x, b%y, b%z)
end function i32_add_dp

elemental function dp_sub_i32(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w - b, a%x, a%y, a%z)
end function dp_sub_i32

elemental function i32_sub_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a - b%w, -b%x, -b%y, -b%z)
end function i32_sub_dp

elemental function dp_mul_i32(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w*b, a%x*b, a%y*b, a%z*b)
end function dp_mul_i32

elemental function i32_mul_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i32_mul_dp

elemental function dp_div_i32(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w/b, a%x/b, a%y/b, a%z/b)
end function dp_div_i32

elemental function i32_div_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = a*dp_inv(b)
end function i32_div_dp

elemental logical function dp_eq_i32(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function dp_eq_i32

elemental logical function i32_eq_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = dp_eq_i32(b, a)
end function i32_eq_dp

elemental logical function dp_ne_i32(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: b
  c = .not. dp_eq_i32(a, b)
end function dp_ne_i32

elemental logical function i32_ne_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = .not. dp_eq_i32(b, a)
end function i32_ne_dp

elemental function dp_add_i64(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w + b, a%x, a%y, a%z)
end function dp_add_i64

elemental function i64_add_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a + b%w, b%x, b%y, b%z)
end function i64_add_dp

elemental function dp_sub_i64(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w - b, a%x, a%y, a%z)
end function dp_sub_i64

elemental function i64_sub_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a - b%w, -b%x, -b%y, -b%z)
end function i64_sub_dp

elemental function dp_mul_i64(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w*b, a%x*b, a%y*b, a%z*b)
end function dp_mul_i64

elemental function i64_mul_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i64_mul_dp

elemental function dp_div_i64(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_dp) :: c
  c = quat_dp(a%w/b, a%x/b, a%y/b, a%z/b)
end function dp_div_i64

elemental function i64_div_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = a*dp_inv(b)
end function i64_div_dp

elemental logical function dp_eq_i64(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function dp_eq_i64

elemental logical function i64_eq_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = dp_eq_i64(b, a)
end function i64_eq_dp

elemental logical function dp_ne_i64(a, b) result(c)
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: b
  c = .not. dp_eq_i64(a, b)
end function dp_ne_i64

elemental logical function i64_ne_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  c = .not. dp_eq_i64(b, a)
end function i64_ne_dp

elemental function dp_pow_r(a, b) result(c)
  type(quat_dp), intent(in) :: a
  real(real64), intent(in) :: b
  type(quat_dp) :: c
  c = dp_from_c(dp_to_c(a)**b, a)
end function dp_pow_r

elemental function r_pow_dp(a, b) result(c)
  real(real64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = dp_exp(dp_log(quat_dp(real(a, real64)))*b)
end function r_pow_dp

elemental function dp_pow_i8(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_dp), intent(in) :: a
  integer(int8), intent(in) :: n
  type(quat_dp) :: c, b
  integer(int8) :: m
  c = quat_dp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = dp_inv(c)
end function dp_pow_i8

elemental function i8_pow_dp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = dp_exp(dp_log(quat_dp(real(a, real64)))*b)
end function i8_pow_dp

elemental function dp_pow_i16(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_dp), intent(in) :: a
  integer(int16), intent(in) :: n
  type(quat_dp) :: c, b
  integer(int16) :: m
  c = quat_dp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = dp_inv(c)
end function dp_pow_i16

elemental function i16_pow_dp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = dp_exp(dp_log(quat_dp(real(a, real64)))*b)
end function i16_pow_dp

elemental function dp_pow_i32(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_dp), intent(in) :: a
  integer(int32), intent(in) :: n
  type(quat_dp) :: c, b
  integer(int32) :: m
  c = quat_dp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = dp_inv(c)
end function dp_pow_i32

elemental function i32_pow_dp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = dp_exp(dp_log(quat_dp(real(a, real64)))*b)
end function i32_pow_dp

elemental function dp_pow_i64(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_dp), intent(in) :: a
  integer(int64), intent(in) :: n
  type(quat_dp) :: c, b
  integer(int64) :: m
  c = quat_dp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = dp_inv(c)
end function dp_pow_i64

elemental function i64_pow_dp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_dp), intent(in) :: b
  type(quat_dp) :: c
  c = dp_exp(dp_log(quat_dp(real(a, real64)))*b)
end function i64_pow_dp

elemental function dp_pow_dp(a, b) result(c)
  !! exp(log(a)*b)
  type(quat_dp), intent(in) :: a, b
  type(quat_dp) :: c
  c = dp_exp(dp_log(a)*b)
end function dp_pow_dp

!-----------------------------------------------------------------------
! Basic functions
!-----------------------------------------------------------------------

elemental real(real64) function dp_abs(q) result(r)
  type(quat_dp), intent(in) :: q
  r = norm2([q%w, q%x, q%y, q%z])
end function dp_abs

elemental function dp_conjg(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = quat_dp(q%w, -q%x, -q%y, -q%z)
end function dp_conjg

elemental real(real64) function dp_real(q) result(r)
  type(quat_dp), intent(in) :: q
  r = q%w
end function dp_real

pure function dp_aimag(q) result(v)
  type(quat_dp), intent(in) :: q
  real(real64) :: v(3)
  v = [q%x, q%y, q%z]
end function dp_aimag

elemental real(real64) function dp_dot(a, b) result(r)
  type(quat_dp), intent(in) :: a, b
  r = a%w*b%w + a%x*b%x + a%y*b%y + a%z*b%z
end function dp_dot

elemental function dp_inv(q) result(r)
  !! Scaled to avoid premature overflow and underflow
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r, p
  real(real64) :: sc
  sc = max(abs(q%w), abs(q%x), abs(q%y), abs(q%z))
  p = q/sc
  r = dp_conjg(p)/(dp_dot(p, p)*sc)
end function dp_inv

elemental function dp_normalize(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = q/dp_abs(q)
end function dp_normalize

elemental logical function dp_is_close(a, b, rel_tol, abs_tol) result(c)
  !! Defaults: rel_tol = sqrt(epsilon), abs_tol = 0
  type(quat_dp), intent(in) :: a, b
  real(real64), intent(in), optional :: rel_tol, abs_tol
  real(real64) :: rt, at
  rt = sqrt(epsilon(1._real64))
  if (present(rel_tol)) rt = rel_tol
  at = 0
  if (present(abs_tol)) at = abs_tol
  c = dp_abs(a - b) <= max(rt*max(dp_abs(a), dp_abs(b)), at)
end function dp_is_close

!-----------------------------------------------------------------------
! Elementary functions: f(w + u n) = Re f(w + in) + u Im f(w + in), with
! u = (x, y, z)/n, n = |(x, y, z)|, and u = i on the real axis.
!-----------------------------------------------------------------------

elemental complex(real64) function dp_to_c(q) result(c)
  type(quat_dp), intent(in) :: q
  c = cmplx(q%w, norm2([q%x, q%y, q%z]), kind=real64)
end function dp_to_c

elemental function dp_from_c(c, q) result(r)
  !! Map c = a + ib back onto the axis of q
  complex(real64), intent(in) :: c
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  real(real64) :: n, b
  n = norm2([q%x, q%y, q%z])
  b = aimag(c)
  if (n > 0) then
    r = quat_dp(real(c), b*(q%x/n), b*(q%y/n), b*(q%z/n))
  else
    r = quat_dp(real(c), b)
  end if
end function dp_from_c

elemental function dp_sqrt(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(sqrt(dp_to_c(q)), q)
end function dp_sqrt

elemental function dp_exp(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(exp(dp_to_c(q)), q)
end function dp_exp

elemental function dp_log(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(log(dp_to_c(q)), q)
end function dp_log

elemental function dp_sin(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(sin(dp_to_c(q)), q)
end function dp_sin

elemental function dp_cos(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(cos(dp_to_c(q)), q)
end function dp_cos

elemental function dp_tan(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(tan(dp_to_c(q)), q)
end function dp_tan

elemental function dp_asin(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(asin(dp_to_c(q)), q)
end function dp_asin

elemental function dp_acos(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(acos(dp_to_c(q)), q)
end function dp_acos

elemental function dp_atan(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(atan(dp_to_c(q)), q)
end function dp_atan

elemental function dp_sinh(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(sinh(dp_to_c(q)), q)
end function dp_sinh

elemental function dp_cosh(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(cosh(dp_to_c(q)), q)
end function dp_cosh

elemental function dp_tanh(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(tanh(dp_to_c(q)), q)
end function dp_tanh

elemental function dp_asinh(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(dp_casinh(dp_to_c(q)), q)
end function dp_asinh

elemental function dp_acosh(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(dp_cacosh(dp_to_c(q)), q)
end function dp_acosh

elemental function dp_atanh(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_from_c(dp_catanh(dp_to_c(q)), q)
end function dp_atanh

! Complex inverse hyperbolic functions via the C99 identities, because not
! every compiler provides them for complex arguments.

elemental complex(real64) function dp_casinh(c) result(r)
  complex(real64), intent(in) :: c
  complex(real64), parameter :: i = (0, 1)
  r = -i*asin(i*c)
end function dp_casinh

elemental complex(real64) function dp_cacosh(c) result(r)
  complex(real64), intent(in) :: c
  complex(real64), parameter :: i = (0, 1)
  r = i*acos(c)
  if (real(r) < 0) r = -r
end function dp_cacosh

elemental complex(real64) function dp_catanh(c) result(r)
  complex(real64), intent(in) :: c
  complex(real64), parameter :: i = (0, 1)
  r = -i*atan(i*c)
end function dp_catanh

elemental function dp_log10(q) result(r)
  type(quat_dp), intent(in) :: q
  type(quat_dp) :: r
  r = dp_log(q)/log(10._real64)
end function dp_log10

!-----------------------------------------------------------------------
! Random numbers
!-----------------------------------------------------------------------

impure elemental subroutine dp_random_number(q)
  type(quat_dp), intent(out) :: q
  real(real64) :: r(4)
  call random_number(r)
  q = dp_from_array(r)
end subroutine dp_random_number

impure elemental subroutine dp_random_rotation(q)
  !! Shoemake's method
  type(quat_dp), intent(out) :: q
  real(real64), parameter :: twopi = 2*acos(-1._real64)
  real(real64) :: r(3), a, b
  call random_number(r)
  a = sqrt(1 - r(1))
  b = sqrt(r(1))
  q = quat_dp(b*cos(twopi*r(3)), a*sin(twopi*r(2)), a*cos(twopi*r(2)), b*sin(twopi*r(3)))
end subroutine dp_random_rotation

!-----------------------------------------------------------------------
! Rotations
!-----------------------------------------------------------------------

pure function dp_cross(a, b) result(c)
  real(real64), intent(in) :: a(3), b(3)
  real(real64) :: c(3)
  c = [a(2)*b(3) - a(3)*b(2), a(3)*b(1) - a(1)*b(3), a(1)*b(2) - a(2)*b(1)]
end function dp_cross

pure function dp_from_axis_angle(axis, angle) result(q)
  real(real64), intent(in) :: axis(3), angle
  type(quat_dp) :: q
  real(real64) :: u(3)
  u = axis/norm2(axis)*sin(angle/2)
  q = quat_dp(cos(angle/2), u(1), u(2), u(3))
end function dp_from_axis_angle

pure subroutine dp_to_axis_angle(q, axis, angle)
  !! axis = [1, 0, 0] for the identity rotation
  type(quat_dp), intent(in) :: q
  real(real64), intent(out) :: axis(3), angle
  type(quat_dp) :: p
  real(real64) :: n
  p = dp_normalize(q)
  if (p%w < 0) p = -p
  n = norm2([p%x, p%y, p%z])
  angle = 2*atan2(n, p%w)
  if (n > 0) then
    axis = [p%x, p%y, p%z]/n
  else
    axis = [1, 0, 0]
  end if
end subroutine dp_to_axis_angle

pure function dp_rotate(q, v) result(r)
  !! v + 2(w t + u x t)/|q|**2 with t = u x v; q need not be a unit quaternion
  type(quat_dp), intent(in) :: q
  real(real64), intent(in) :: v(3)
  real(real64) :: r(3), u(3), t(3)
  u = [q%x, q%y, q%z]
  t = dp_cross(u, v)
  r = v + 2*(q%w*t + dp_cross(u, t))/dp_dot(q, q)
end function dp_rotate

pure function dp_to_matrix(q) result(m)
  type(quat_dp), intent(in) :: q
  real(real64) :: m(3,3), f
  f = 2/dp_dot(q, q)
  associate(w => q%w, x => q%x, y => q%y, z => q%z)
    m(1,:) = [1 - f*(y*y + z*z), f*(x*y - z*w), f*(x*z + y*w)]
    m(2,:) = [f*(x*y + z*w), 1 - f*(x*x + z*z), f*(y*z - x*w)]
    m(3,:) = [f*(x*z - y*w), f*(y*z + x*w), 1 - f*(x*x + y*y)]
  end associate
end function dp_to_matrix

pure function dp_from_matrix(m) result(q)
  !! Shepperd's method: divide by the largest of 4w**2, 4x**2, 4y**2, 4z**2
  real(real64), intent(in) :: m(3,3)
  type(quat_dp) :: q
  real(real64) :: d(4), f
  d = [m(1,1) + m(2,2) + m(3,3), m(1,1), m(2,2), m(3,3)]
  select case (maxloc(d, dim=1))
  case (1)
    f = sqrt(1 + d(1))*2
    q = quat_dp(f/4, (m(3,2) - m(2,3))/f, (m(1,3) - m(3,1))/f, (m(2,1) - m(1,2))/f)
  case (2)
    f = sqrt(1 + m(1,1) - m(2,2) - m(3,3))*2
    q = quat_dp((m(3,2) - m(2,3))/f, f/4, (m(1,2) + m(2,1))/f, (m(1,3) + m(3,1))/f)
  case (3)
    f = sqrt(1 - m(1,1) + m(2,2) - m(3,3))*2
    q = quat_dp((m(1,3) - m(3,1))/f, (m(1,2) + m(2,1))/f, f/4, (m(2,3) + m(3,2))/f)
  case default
    f = sqrt(1 - m(1,1) - m(2,2) + m(3,3))*2
    q = quat_dp((m(2,1) - m(1,2))/f, (m(1,3) + m(3,1))/f, (m(2,3) + m(3,2))/f, f/4)
  end select
  if (q%w < 0) q = -q
end function dp_from_matrix

elemental function dp_from_euler_zyx(yaw, pitch, roll) result(q)
  !! qz(yaw) qy(pitch) qx(roll): roll about x first, then pitch about y, then yaw about z
  real(real64), intent(in) :: yaw, pitch, roll
  type(quat_dp) :: q
  real(real64) :: cy, sy, cp, sp, cr, sr
  cy = cos(yaw/2); sy = sin(yaw/2)
  cp = cos(pitch/2); sp = sin(pitch/2)
  cr = cos(roll/2); sr = sin(roll/2)
  q = quat_dp(cr*cp*cy + sr*sp*sy, sr*cp*cy - cr*sp*sy, cr*sp*cy + sr*cp*sy, cr*cp*sy - sr*sp*cy)
end function dp_from_euler_zyx

elemental subroutine dp_to_euler_zyx(q, yaw, pitch, roll)
  !! yaw, roll in (-pi, pi], pitch in [-pi/2, pi/2]
  type(quat_dp), intent(in) :: q
  real(real64), intent(out) :: yaw, pitch, roll
  real(real64), parameter :: pi = acos(-1._real64)
  type(quat_dp) :: p
  real(real64) :: sp
  p = dp_normalize(q)
  sp = 2*(p%w*p%y - p%z*p%x)
  if (abs(sp) >= 1 - 4*epsilon(sp)) then
    pitch = sign(pi/2, sp)
    roll = 0
    yaw = 2*atan2(p%z, p%w)
    if (yaw > pi) yaw = yaw - 2*pi
    if (yaw <= -pi) yaw = yaw + 2*pi
  else
    pitch = asin(sp)
    roll = atan2(2*(p%w*p%x + p%y*p%z), 1 - 2*(p%x**2 + p%y**2))
    yaw = atan2(2*(p%w*p%z + p%x*p%y), 1 - 2*(p%y**2 + p%z**2))
  end if
end subroutine dp_to_euler_zyx

elemental function dp_slerp(a, b, t) result(r)
  !! a and b are unit quaternions; t = 0 gives a, t = 1 gives b or -b
  type(quat_dp), intent(in) :: a, b
  real(real64), intent(in) :: t
  type(quat_dp) :: r, c
  real(real64) :: th
  c = b
  if (dp_dot(a, b) < 0) c = -b
  th = 2*atan2(dp_abs(a - c), dp_abs(a + c))
  if (th == 0) then
    r = a
  else
    r = (sin((1 - t)*th)*a + sin(t*th)*c)/sin(th)
  end if
end function dp_slerp

!-----------------------------------------------------------------------
! Text
!-----------------------------------------------------------------------

pure function dp_to_string(q, fmt) result(str)
  type(quat_dp), intent(in) :: q
  character(*), intent(in), optional :: fmt
  character(:), allocatable :: str, f
  f = '(g0)'
  if (present(fmt)) f = fmt
  str = num(q%w) // sgn(q%x) // num(abs(q%x)) // 'i' // sgn(q%y) // num(abs(q%y)) // 'j' &
      & // sgn(q%z) // num(abs(q%z)) // 'k'
contains
  pure function num(v) result(s)
    real(real64), intent(in) :: v
    character(:), allocatable :: s
    character(128) :: buf
    write(buf, f) v
    s = trim(adjustl(buf))
  end function num
  pure function sgn(v) result(s)
    real(real64), intent(in) :: v
    character(3) :: s
    s = ' + '
    if (sign(1._real64, v) < 0) s = ' - '
  end function sgn
end function dp_to_string

subroutine write_dp(dtv, unit, iotype, v_list, iostat, iomsg)
  !! List-directed: a blank, then g0 parts.  DT"F8.4" or DT"F"(8,4): that edit descriptor for each part.
  class(quat_dp), intent(in) :: dtv
  integer, intent(in) :: unit
  character(*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(*), intent(inout) :: iomsg
  character(:), allocatable :: f, lead
  lead = ''
  if (iotype == 'LISTDIRECTED' .or. iotype == 'NAMELIST') then
    f = 'g0'
    lead = ' '
  else
    f = iotype(3:)
    if (size(v_list) > 0) then
      if (f == '') f = 'g'
      f = f // itoa(v_list(1))
      if (size(v_list) > 1) f = f // '.' // itoa(v_list(2))
    else if (f == '') then
      f = 'g0'
    end if
  end if
  ! Build the text before writing: nvfortran fails on I/O inside an output list
  f = lead // dp_to_string(dtv, '(' // f // ')')
  write(unit, '(a)', iostat=iostat, iomsg=iomsg) f
end subroutine write_dp

subroutine read_dp(dtv, unit, iotype, v_list, iostat, iomsg)
  !! Reads characters up to and including the k part, e.g. "1 + 2i + 3j + 4k"
  !! or "1+2i+3j+4k", within one record of an external file.  Edit descriptors
  !! are ignored.  Reading stops at the k so the record end is never reached.
  !! Character variables are not supported as files; use quat_dp(string).
  class(quat_dp), intent(inout) :: dtv
  integer, intent(in) :: unit
  character(*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(*), intent(inout) :: iomsg
  character :: ch
  character(:), allocatable :: text
  type(quat_dp) :: q
  associate(unused => iotype, unused2 => v_list); end associate
  text = ''
  do
    read(unit, '(a)', advance='no', iostat=iostat, iomsg=iomsg) ch
    if (is_iostat_eor(iostat)) then
      iostat = 1
      iomsg = 'quaternion text must end with its k part: ' // text
      return
    end if
    if (iostat /= 0) then
      if (len(text) == 0) iomsg = trim(iomsg) // ' (to parse a string, use quat_dp(string))'
      return
    end if
    if (len(text) == 0 .and. (ch == ' ' .or. ch == ',')) cycle
    text = text // ch
    if (ch == 'k' .or. ch == 'K') exit
  end do
  call dp_parse(text, q, iostat)
  if (iostat /= 0) then
    iomsg = 'not a quaternion: ' // text
    return
  end if
  dtv%w = q%w; dtv%x = q%x; dtv%y = q%y; dtv%z = q%z
end subroutine read_dp


#if QUATERNIONS_QP
!=======================================================================
! quat_qp
!=======================================================================

pure function qp_from_array(a) result(q)
  real(real128), intent(in) :: a(4)
  type(quat_qp) :: q
  q = quat_qp(a(1), a(2), a(3), a(4))
end function qp_from_array

elemental function qp_from_string(str) result(q)
  !! Parse a string; all components are NaN if it is not a quaternion
  character(*), intent(in) :: str
  type(quat_qp) :: q
  integer :: ios
  real(real128) :: nan
  call qp_parse(str, q, ios)
  if (ios /= 0) then
    nan = ieee_value(0._real128, ieee_quiet_nan)
    q = quat_qp(nan, nan, nan, nan)
  end if
end function qp_from_string


elemental function qp_from_sp(a) result(q)
  type(quat_sp), intent(in) :: a
  type(quat_qp) :: q
  q = quat_qp(real(a%w, real128), real(a%x, real128), real(a%y, real128), real(a%z, real128))
end function qp_from_sp



elemental function qp_from_dp(a) result(q)
  type(quat_dp), intent(in) :: a
  type(quat_qp) :: q
  q = quat_qp(real(a%w, real128), real(a%x, real128), real(a%y, real128), real(a%z, real128))
end function qp_from_dp


pure subroutine qp_parse(str, q, ios)
  !! Parse terms like "1.5", "-2i", "+ 3.0e-2j", "k" in any order and spacing.
  !! No blank is allowed between a number and its unit.  ios /= 0 on error.
  character(*), intent(in) :: str
  type(quat_qp), intent(out) :: q
  integer, intent(out) :: ios
  real(real128) :: c(4), val
  integer :: p, n, start, nterms, part, e
  logical :: neg

  c = 0; ios = 0; p = 1; n = len_trim(str); nterms = 0
  do
    do while (p <= n)
      if (str(p:p) /= ' ') exit
      p = p + 1
    end do
    if (p > n) exit
    neg = .false.
    if (str(p:p) == '+' .or. str(p:p) == '-') then
      neg = str(p:p) == '-'
      p = p + 1
      do while (p <= n)
        if (str(p:p) /= ' ') exit
        p = p + 1
      end do
    else if (nterms > 0) then
      ios = 1; return
    end if
    start = p
    if (lower(str(p:min(p+7, n))) == 'infinity') then
      p = p + 8
    else if (lower(str(p:min(p+2, n))) == 'inf' .or. lower(str(p:min(p+2, n))) == 'nan') then
      p = p + 3
    else
      do while (p <= n)
        if (index('0123456789.', str(p:p)) > 0) then
          p = p + 1
        else if (index('eEdD', str(p:p)) > 0 .and. p > start) then
          e = p + 1
          if (e <= n) then
            if (str(e:e) == '+' .or. str(e:e) == '-') e = e + 1
          end if
          if (e > n) exit
          if (index('0123456789', str(e:e)) == 0) exit
          p = e + 1
        else
          exit
        end if
      end do
    end if
    if (p > start) then
      read(str(start:p-1), *, iostat=ios) val
      if (ios /= 0) return
    else
      val = 1
    end if
    part = 1
    if (p <= n) part = index('iIjJkK', str(p:p))
    if (part > 0 .and. p <= n) then
      part = (part + 3)/2
      p = p + 1
    else
      part = 1
    end if
    if (p == start) then
      ios = 1; return
    end if
    if (neg) val = -val
    c(part) = c(part) + val
    nterms = nterms + 1
  end do
  if (nterms == 0) ios = 1
  q = quat_qp(c(1), c(2), c(3), c(4))
end subroutine qp_parse

elemental subroutine qp_assign_r(q, a)
  type(quat_qp), intent(out) :: q
  real(real128), intent(in) :: a
  q = quat_qp(real(a, real128))
end subroutine qp_assign_r

elemental subroutine qp_assign_i8(q, a)
  type(quat_qp), intent(out) :: q
  integer(int8), intent(in) :: a
  q = quat_qp(real(a, real128))
end subroutine qp_assign_i8

elemental subroutine qp_assign_i16(q, a)
  type(quat_qp), intent(out) :: q
  integer(int16), intent(in) :: a
  q = quat_qp(real(a, real128))
end subroutine qp_assign_i16

elemental subroutine qp_assign_i32(q, a)
  type(quat_qp), intent(out) :: q
  integer(int32), intent(in) :: a
  q = quat_qp(real(a, real128))
end subroutine qp_assign_i32

elemental subroutine qp_assign_i64(q, a)
  type(quat_qp), intent(out) :: q
  integer(int64), intent(in) :: a
  q = quat_qp(real(a, real128))
end subroutine qp_assign_i64

!-----------------------------------------------------------------------
! Arithmetic and comparison
!-----------------------------------------------------------------------

elemental function qp_pos(a) result(c)
  type(quat_qp), intent(in) :: a
  type(quat_qp) :: c
  c = a
end function qp_pos

elemental function qp_neg(a) result(c)
  type(quat_qp), intent(in) :: a
  type(quat_qp) :: c
  c = quat_qp(-a%w, -a%x, -a%y, -a%z)
end function qp_neg

elemental function qp_add_qp(a, b) result(c)
  type(quat_qp), intent(in) :: a, b
  type(quat_qp) :: c
  c = quat_qp(a%w + b%w, a%x + b%x, a%y + b%y, a%z + b%z)
end function qp_add_qp

elemental function qp_sub_qp(a, b) result(c)
  type(quat_qp), intent(in) :: a, b
  type(quat_qp) :: c
  c = quat_qp(a%w - b%w, a%x - b%x, a%y - b%y, a%z - b%z)
end function qp_sub_qp

elemental function qp_mul_qp(a, b) result(c)
  !! Hamilton product
  type(quat_qp), intent(in) :: a, b
  type(quat_qp) :: c
  c = quat_qp(a%w*b%w - a%x*b%x - a%y*b%y - a%z*b%z, &
               & a%w*b%x + a%x*b%w + a%y*b%z - a%z*b%y, &
               & a%w*b%y - a%x*b%z + a%y*b%w + a%z*b%x, &
               & a%w*b%z + a%x*b%y - a%y*b%x + a%z*b%w)
end function qp_mul_qp

elemental function qp_div_qp(a, b) result(c)
  !! Right division a*inv(b)
  type(quat_qp), intent(in) :: a, b
  type(quat_qp) :: c
  c = a*qp_inv(b)
end function qp_div_qp

elemental logical function qp_eq_qp(a, b) result(c)
  type(quat_qp), intent(in) :: a, b
  c = a%w == b%w .and. a%x == b%x .and. a%y == b%y .and. a%z == b%z
end function qp_eq_qp

elemental logical function qp_ne_qp(a, b) result(c)
  type(quat_qp), intent(in) :: a, b
  c = .not. qp_eq_qp(a, b)
end function qp_ne_qp

elemental function qp_add_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w + b, a%x, a%y, a%z)
end function qp_add_r

elemental function r_add_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a + b%w, b%x, b%y, b%z)
end function r_add_qp

elemental function qp_sub_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w - b, a%x, a%y, a%z)
end function qp_sub_r

elemental function r_sub_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a - b%w, -b%x, -b%y, -b%z)
end function r_sub_qp

elemental function qp_mul_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w*b, a%x*b, a%y*b, a%z*b)
end function qp_mul_r

elemental function r_mul_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a*b%w, a*b%x, a*b%y, a*b%z)
end function r_mul_qp

elemental function qp_div_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w/b, a%x/b, a%y/b, a%z/b)
end function qp_div_r

elemental function r_div_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = a*qp_inv(b)
end function r_div_qp

elemental logical function qp_eq_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function qp_eq_r

elemental logical function r_eq_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = qp_eq_r(b, a)
end function r_eq_qp

elemental logical function qp_ne_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  c = .not. qp_eq_r(a, b)
end function qp_ne_r

elemental logical function r_ne_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = .not. qp_eq_r(b, a)
end function r_ne_qp

elemental function qp_add_i8(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w + b, a%x, a%y, a%z)
end function qp_add_i8

elemental function i8_add_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a + b%w, b%x, b%y, b%z)
end function i8_add_qp

elemental function qp_sub_i8(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w - b, a%x, a%y, a%z)
end function qp_sub_i8

elemental function i8_sub_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a - b%w, -b%x, -b%y, -b%z)
end function i8_sub_qp

elemental function qp_mul_i8(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w*b, a%x*b, a%y*b, a%z*b)
end function qp_mul_i8

elemental function i8_mul_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i8_mul_qp

elemental function qp_div_i8(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w/b, a%x/b, a%y/b, a%z/b)
end function qp_div_i8

elemental function i8_div_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = a*qp_inv(b)
end function i8_div_qp

elemental logical function qp_eq_i8(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function qp_eq_i8

elemental logical function i8_eq_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = qp_eq_i8(b, a)
end function i8_eq_qp

elemental logical function qp_ne_i8(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: b
  c = .not. qp_eq_i8(a, b)
end function qp_ne_i8

elemental logical function i8_ne_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = .not. qp_eq_i8(b, a)
end function i8_ne_qp

elemental function qp_add_i16(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w + b, a%x, a%y, a%z)
end function qp_add_i16

elemental function i16_add_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a + b%w, b%x, b%y, b%z)
end function i16_add_qp

elemental function qp_sub_i16(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w - b, a%x, a%y, a%z)
end function qp_sub_i16

elemental function i16_sub_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a - b%w, -b%x, -b%y, -b%z)
end function i16_sub_qp

elemental function qp_mul_i16(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w*b, a%x*b, a%y*b, a%z*b)
end function qp_mul_i16

elemental function i16_mul_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i16_mul_qp

elemental function qp_div_i16(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w/b, a%x/b, a%y/b, a%z/b)
end function qp_div_i16

elemental function i16_div_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = a*qp_inv(b)
end function i16_div_qp

elemental logical function qp_eq_i16(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function qp_eq_i16

elemental logical function i16_eq_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = qp_eq_i16(b, a)
end function i16_eq_qp

elemental logical function qp_ne_i16(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: b
  c = .not. qp_eq_i16(a, b)
end function qp_ne_i16

elemental logical function i16_ne_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = .not. qp_eq_i16(b, a)
end function i16_ne_qp

elemental function qp_add_i32(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w + b, a%x, a%y, a%z)
end function qp_add_i32

elemental function i32_add_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a + b%w, b%x, b%y, b%z)
end function i32_add_qp

elemental function qp_sub_i32(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w - b, a%x, a%y, a%z)
end function qp_sub_i32

elemental function i32_sub_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a - b%w, -b%x, -b%y, -b%z)
end function i32_sub_qp

elemental function qp_mul_i32(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w*b, a%x*b, a%y*b, a%z*b)
end function qp_mul_i32

elemental function i32_mul_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i32_mul_qp

elemental function qp_div_i32(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w/b, a%x/b, a%y/b, a%z/b)
end function qp_div_i32

elemental function i32_div_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = a*qp_inv(b)
end function i32_div_qp

elemental logical function qp_eq_i32(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function qp_eq_i32

elemental logical function i32_eq_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = qp_eq_i32(b, a)
end function i32_eq_qp

elemental logical function qp_ne_i32(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: b
  c = .not. qp_eq_i32(a, b)
end function qp_ne_i32

elemental logical function i32_ne_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = .not. qp_eq_i32(b, a)
end function i32_ne_qp

elemental function qp_add_i64(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w + b, a%x, a%y, a%z)
end function qp_add_i64

elemental function i64_add_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a + b%w, b%x, b%y, b%z)
end function i64_add_qp

elemental function qp_sub_i64(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w - b, a%x, a%y, a%z)
end function qp_sub_i64

elemental function i64_sub_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a - b%w, -b%x, -b%y, -b%z)
end function i64_sub_qp

elemental function qp_mul_i64(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w*b, a%x*b, a%y*b, a%z*b)
end function qp_mul_i64

elemental function i64_mul_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a*b%w, a*b%x, a*b%y, a*b%z)
end function i64_mul_qp

elemental function qp_div_i64(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: b
  type(quat_qp) :: c
  c = quat_qp(a%w/b, a%x/b, a%y/b, a%z/b)
end function qp_div_i64

elemental function i64_div_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = a*qp_inv(b)
end function i64_div_qp

elemental logical function qp_eq_i64(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: b
  c = a%w == b .and. a%x == 0 .and. a%y == 0 .and. a%z == 0
end function qp_eq_i64

elemental logical function i64_eq_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = qp_eq_i64(b, a)
end function i64_eq_qp

elemental logical function qp_ne_i64(a, b) result(c)
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: b
  c = .not. qp_eq_i64(a, b)
end function qp_ne_i64

elemental logical function i64_ne_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  c = .not. qp_eq_i64(b, a)
end function i64_ne_qp

elemental function qp_pow_r(a, b) result(c)
  type(quat_qp), intent(in) :: a
  real(real128), intent(in) :: b
  type(quat_qp) :: c
  c = qp_from_c(qp_to_c(a)**b, a)
end function qp_pow_r

elemental function r_pow_qp(a, b) result(c)
  real(real128), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = qp_exp(qp_log(quat_qp(real(a, real128)))*b)
end function r_pow_qp

elemental function qp_pow_i8(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_qp), intent(in) :: a
  integer(int8), intent(in) :: n
  type(quat_qp) :: c, b
  integer(int8) :: m
  c = quat_qp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = qp_inv(c)
end function qp_pow_i8

elemental function i8_pow_qp(a, b) result(c)
  integer(int8), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = qp_exp(qp_log(quat_qp(real(a, real128)))*b)
end function i8_pow_qp

elemental function qp_pow_i16(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_qp), intent(in) :: a
  integer(int16), intent(in) :: n
  type(quat_qp) :: c, b
  integer(int16) :: m
  c = quat_qp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = qp_inv(c)
end function qp_pow_i16

elemental function i16_pow_qp(a, b) result(c)
  integer(int16), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = qp_exp(qp_log(quat_qp(real(a, real128)))*b)
end function i16_pow_qp

elemental function qp_pow_i32(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_qp), intent(in) :: a
  integer(int32), intent(in) :: n
  type(quat_qp) :: c, b
  integer(int32) :: m
  c = quat_qp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = qp_inv(c)
end function qp_pow_i32

elemental function i32_pow_qp(a, b) result(c)
  integer(int32), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = qp_exp(qp_log(quat_qp(real(a, real128)))*b)
end function i32_pow_qp

elemental function qp_pow_i64(a, n) result(c)
  !! Repeated squaring; exact where the products are exact
  type(quat_qp), intent(in) :: a
  integer(int64), intent(in) :: n
  type(quat_qp) :: c, b
  integer(int64) :: m
  c = quat_qp(1)
  b = a
  m = n
  do while (m /= 0)
    if (mod(m, int(2, kind(m))) /= 0) c = c*b
    m = m/2
    if (m /= 0) b = b*b
  end do
  if (n < 0) c = qp_inv(c)
end function qp_pow_i64

elemental function i64_pow_qp(a, b) result(c)
  integer(int64), intent(in) :: a
  type(quat_qp), intent(in) :: b
  type(quat_qp) :: c
  c = qp_exp(qp_log(quat_qp(real(a, real128)))*b)
end function i64_pow_qp

elemental function qp_pow_qp(a, b) result(c)
  !! exp(log(a)*b)
  type(quat_qp), intent(in) :: a, b
  type(quat_qp) :: c
  c = qp_exp(qp_log(a)*b)
end function qp_pow_qp

!-----------------------------------------------------------------------
! Basic functions
!-----------------------------------------------------------------------

elemental real(real128) function qp_abs(q) result(r)
  type(quat_qp), intent(in) :: q
  r = norm2([q%w, q%x, q%y, q%z])
end function qp_abs

elemental function qp_conjg(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = quat_qp(q%w, -q%x, -q%y, -q%z)
end function qp_conjg

elemental real(real128) function qp_real(q) result(r)
  type(quat_qp), intent(in) :: q
  r = q%w
end function qp_real

pure function qp_aimag(q) result(v)
  type(quat_qp), intent(in) :: q
  real(real128) :: v(3)
  v = [q%x, q%y, q%z]
end function qp_aimag

elemental real(real128) function qp_dot(a, b) result(r)
  type(quat_qp), intent(in) :: a, b
  r = a%w*b%w + a%x*b%x + a%y*b%y + a%z*b%z
end function qp_dot

elemental function qp_inv(q) result(r)
  !! Scaled to avoid premature overflow and underflow
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r, p
  real(real128) :: sc
  sc = max(abs(q%w), abs(q%x), abs(q%y), abs(q%z))
  p = q/sc
  r = qp_conjg(p)/(qp_dot(p, p)*sc)
end function qp_inv

elemental function qp_normalize(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = q/qp_abs(q)
end function qp_normalize

elemental logical function qp_is_close(a, b, rel_tol, abs_tol) result(c)
  !! Defaults: rel_tol = sqrt(epsilon), abs_tol = 0
  type(quat_qp), intent(in) :: a, b
  real(real128), intent(in), optional :: rel_tol, abs_tol
  real(real128) :: rt, at
  rt = sqrt(epsilon(1._real128))
  if (present(rel_tol)) rt = rel_tol
  at = 0
  if (present(abs_tol)) at = abs_tol
  c = qp_abs(a - b) <= max(rt*max(qp_abs(a), qp_abs(b)), at)
end function qp_is_close

!-----------------------------------------------------------------------
! Elementary functions: f(w + u n) = Re f(w + in) + u Im f(w + in), with
! u = (x, y, z)/n, n = |(x, y, z)|, and u = i on the real axis.
!-----------------------------------------------------------------------

elemental complex(real128) function qp_to_c(q) result(c)
  type(quat_qp), intent(in) :: q
  c = cmplx(q%w, norm2([q%x, q%y, q%z]), kind=real128)
end function qp_to_c

elemental function qp_from_c(c, q) result(r)
  !! Map c = a + ib back onto the axis of q
  complex(real128), intent(in) :: c
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  real(real128) :: n, b
  n = norm2([q%x, q%y, q%z])
  b = aimag(c)
  if (n > 0) then
    r = quat_qp(real(c), b*(q%x/n), b*(q%y/n), b*(q%z/n))
  else
    r = quat_qp(real(c), b)
  end if
end function qp_from_c

elemental function qp_sqrt(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(sqrt(qp_to_c(q)), q)
end function qp_sqrt

elemental function qp_exp(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(exp(qp_to_c(q)), q)
end function qp_exp

elemental function qp_log(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(log(qp_to_c(q)), q)
end function qp_log

elemental function qp_sin(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(sin(qp_to_c(q)), q)
end function qp_sin

elemental function qp_cos(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(cos(qp_to_c(q)), q)
end function qp_cos

elemental function qp_tan(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(tan(qp_to_c(q)), q)
end function qp_tan

elemental function qp_asin(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(asin(qp_to_c(q)), q)
end function qp_asin

elemental function qp_acos(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(acos(qp_to_c(q)), q)
end function qp_acos

elemental function qp_atan(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(atan(qp_to_c(q)), q)
end function qp_atan

elemental function qp_sinh(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(sinh(qp_to_c(q)), q)
end function qp_sinh

elemental function qp_cosh(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(cosh(qp_to_c(q)), q)
end function qp_cosh

elemental function qp_tanh(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(tanh(qp_to_c(q)), q)
end function qp_tanh

elemental function qp_asinh(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(qp_casinh(qp_to_c(q)), q)
end function qp_asinh

elemental function qp_acosh(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(qp_cacosh(qp_to_c(q)), q)
end function qp_acosh

elemental function qp_atanh(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_from_c(qp_catanh(qp_to_c(q)), q)
end function qp_atanh

! Complex inverse hyperbolic functions via the C99 identities, because not
! every compiler provides them for complex arguments.

elemental complex(real128) function qp_casinh(c) result(r)
  complex(real128), intent(in) :: c
  complex(real128), parameter :: i = (0, 1)
  r = -i*asin(i*c)
end function qp_casinh

elemental complex(real128) function qp_cacosh(c) result(r)
  complex(real128), intent(in) :: c
  complex(real128), parameter :: i = (0, 1)
  r = i*acos(c)
  if (real(r) < 0) r = -r
end function qp_cacosh

elemental complex(real128) function qp_catanh(c) result(r)
  complex(real128), intent(in) :: c
  complex(real128), parameter :: i = (0, 1)
  r = -i*atan(i*c)
end function qp_catanh

elemental function qp_log10(q) result(r)
  type(quat_qp), intent(in) :: q
  type(quat_qp) :: r
  r = qp_log(q)/log(10._real128)
end function qp_log10

!-----------------------------------------------------------------------
! Random numbers
!-----------------------------------------------------------------------

impure elemental subroutine qp_random_number(q)
  type(quat_qp), intent(out) :: q
  real(real128) :: r(4)
  call random_number(r)
  q = qp_from_array(r)
end subroutine qp_random_number

impure elemental subroutine qp_random_rotation(q)
  !! Shoemake's method
  type(quat_qp), intent(out) :: q
  real(real128), parameter :: twopi = 2*acos(-1._real128)
  real(real128) :: r(3), a, b
  call random_number(r)
  a = sqrt(1 - r(1))
  b = sqrt(r(1))
  q = quat_qp(b*cos(twopi*r(3)), a*sin(twopi*r(2)), a*cos(twopi*r(2)), b*sin(twopi*r(3)))
end subroutine qp_random_rotation

!-----------------------------------------------------------------------
! Rotations
!-----------------------------------------------------------------------

pure function qp_cross(a, b) result(c)
  real(real128), intent(in) :: a(3), b(3)
  real(real128) :: c(3)
  c = [a(2)*b(3) - a(3)*b(2), a(3)*b(1) - a(1)*b(3), a(1)*b(2) - a(2)*b(1)]
end function qp_cross

pure function qp_from_axis_angle(axis, angle) result(q)
  real(real128), intent(in) :: axis(3), angle
  type(quat_qp) :: q
  real(real128) :: u(3)
  u = axis/norm2(axis)*sin(angle/2)
  q = quat_qp(cos(angle/2), u(1), u(2), u(3))
end function qp_from_axis_angle

pure subroutine qp_to_axis_angle(q, axis, angle)
  !! axis = [1, 0, 0] for the identity rotation
  type(quat_qp), intent(in) :: q
  real(real128), intent(out) :: axis(3), angle
  type(quat_qp) :: p
  real(real128) :: n
  p = qp_normalize(q)
  if (p%w < 0) p = -p
  n = norm2([p%x, p%y, p%z])
  angle = 2*atan2(n, p%w)
  if (n > 0) then
    axis = [p%x, p%y, p%z]/n
  else
    axis = [1, 0, 0]
  end if
end subroutine qp_to_axis_angle

pure function qp_rotate(q, v) result(r)
  !! v + 2(w t + u x t)/|q|**2 with t = u x v; q need not be a unit quaternion
  type(quat_qp), intent(in) :: q
  real(real128), intent(in) :: v(3)
  real(real128) :: r(3), u(3), t(3)
  u = [q%x, q%y, q%z]
  t = qp_cross(u, v)
  r = v + 2*(q%w*t + qp_cross(u, t))/qp_dot(q, q)
end function qp_rotate

pure function qp_to_matrix(q) result(m)
  type(quat_qp), intent(in) :: q
  real(real128) :: m(3,3), f
  f = 2/qp_dot(q, q)
  associate(w => q%w, x => q%x, y => q%y, z => q%z)
    m(1,:) = [1 - f*(y*y + z*z), f*(x*y - z*w), f*(x*z + y*w)]
    m(2,:) = [f*(x*y + z*w), 1 - f*(x*x + z*z), f*(y*z - x*w)]
    m(3,:) = [f*(x*z - y*w), f*(y*z + x*w), 1 - f*(x*x + y*y)]
  end associate
end function qp_to_matrix

pure function qp_from_matrix(m) result(q)
  !! Shepperd's method: divide by the largest of 4w**2, 4x**2, 4y**2, 4z**2
  real(real128), intent(in) :: m(3,3)
  type(quat_qp) :: q
  real(real128) :: d(4), f
  d = [m(1,1) + m(2,2) + m(3,3), m(1,1), m(2,2), m(3,3)]
  select case (maxloc(d, dim=1))
  case (1)
    f = sqrt(1 + d(1))*2
    q = quat_qp(f/4, (m(3,2) - m(2,3))/f, (m(1,3) - m(3,1))/f, (m(2,1) - m(1,2))/f)
  case (2)
    f = sqrt(1 + m(1,1) - m(2,2) - m(3,3))*2
    q = quat_qp((m(3,2) - m(2,3))/f, f/4, (m(1,2) + m(2,1))/f, (m(1,3) + m(3,1))/f)
  case (3)
    f = sqrt(1 - m(1,1) + m(2,2) - m(3,3))*2
    q = quat_qp((m(1,3) - m(3,1))/f, (m(1,2) + m(2,1))/f, f/4, (m(2,3) + m(3,2))/f)
  case default
    f = sqrt(1 - m(1,1) - m(2,2) + m(3,3))*2
    q = quat_qp((m(2,1) - m(1,2))/f, (m(1,3) + m(3,1))/f, (m(2,3) + m(3,2))/f, f/4)
  end select
  if (q%w < 0) q = -q
end function qp_from_matrix

elemental function qp_from_euler_zyx(yaw, pitch, roll) result(q)
  !! qz(yaw) qy(pitch) qx(roll): roll about x first, then pitch about y, then yaw about z
  real(real128), intent(in) :: yaw, pitch, roll
  type(quat_qp) :: q
  real(real128) :: cy, sy, cp, sp, cr, sr
  cy = cos(yaw/2); sy = sin(yaw/2)
  cp = cos(pitch/2); sp = sin(pitch/2)
  cr = cos(roll/2); sr = sin(roll/2)
  q = quat_qp(cr*cp*cy + sr*sp*sy, sr*cp*cy - cr*sp*sy, cr*sp*cy + sr*cp*sy, cr*cp*sy - sr*sp*cy)
end function qp_from_euler_zyx

elemental subroutine qp_to_euler_zyx(q, yaw, pitch, roll)
  !! yaw, roll in (-pi, pi], pitch in [-pi/2, pi/2]
  type(quat_qp), intent(in) :: q
  real(real128), intent(out) :: yaw, pitch, roll
  real(real128), parameter :: pi = acos(-1._real128)
  type(quat_qp) :: p
  real(real128) :: sp
  p = qp_normalize(q)
  sp = 2*(p%w*p%y - p%z*p%x)
  if (abs(sp) >= 1 - 4*epsilon(sp)) then
    pitch = sign(pi/2, sp)
    roll = 0
    yaw = 2*atan2(p%z, p%w)
    if (yaw > pi) yaw = yaw - 2*pi
    if (yaw <= -pi) yaw = yaw + 2*pi
  else
    pitch = asin(sp)
    roll = atan2(2*(p%w*p%x + p%y*p%z), 1 - 2*(p%x**2 + p%y**2))
    yaw = atan2(2*(p%w*p%z + p%x*p%y), 1 - 2*(p%y**2 + p%z**2))
  end if
end subroutine qp_to_euler_zyx

elemental function qp_slerp(a, b, t) result(r)
  !! a and b are unit quaternions; t = 0 gives a, t = 1 gives b or -b
  type(quat_qp), intent(in) :: a, b
  real(real128), intent(in) :: t
  type(quat_qp) :: r, c
  real(real128) :: th
  c = b
  if (qp_dot(a, b) < 0) c = -b
  th = 2*atan2(qp_abs(a - c), qp_abs(a + c))
  if (th == 0) then
    r = a
  else
    r = (sin((1 - t)*th)*a + sin(t*th)*c)/sin(th)
  end if
end function qp_slerp

!-----------------------------------------------------------------------
! Text
!-----------------------------------------------------------------------

pure function qp_to_string(q, fmt) result(str)
  type(quat_qp), intent(in) :: q
  character(*), intent(in), optional :: fmt
  character(:), allocatable :: str, f
  f = '(g0)'
  if (present(fmt)) f = fmt
  str = num(q%w) // sgn(q%x) // num(abs(q%x)) // 'i' // sgn(q%y) // num(abs(q%y)) // 'j' &
      & // sgn(q%z) // num(abs(q%z)) // 'k'
contains
  pure function num(v) result(s)
    real(real128), intent(in) :: v
    character(:), allocatable :: s
    character(128) :: buf
    write(buf, f) v
    s = trim(adjustl(buf))
  end function num
  pure function sgn(v) result(s)
    real(real128), intent(in) :: v
    character(3) :: s
    s = ' + '
    if (sign(1._real128, v) < 0) s = ' - '
  end function sgn
end function qp_to_string

subroutine write_qp(dtv, unit, iotype, v_list, iostat, iomsg)
  !! List-directed: a blank, then g0 parts.  DT"F8.4" or DT"F"(8,4): that edit descriptor for each part.
  class(quat_qp), intent(in) :: dtv
  integer, intent(in) :: unit
  character(*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(*), intent(inout) :: iomsg
  character(:), allocatable :: f, lead
  lead = ''
  if (iotype == 'LISTDIRECTED' .or. iotype == 'NAMELIST') then
    f = 'g0'
    lead = ' '
  else
    f = iotype(3:)
    if (size(v_list) > 0) then
      if (f == '') f = 'g'
      f = f // itoa(v_list(1))
      if (size(v_list) > 1) f = f // '.' // itoa(v_list(2))
    else if (f == '') then
      f = 'g0'
    end if
  end if
  ! Build the text before writing: nvfortran fails on I/O inside an output list
  f = lead // qp_to_string(dtv, '(' // f // ')')
  write(unit, '(a)', iostat=iostat, iomsg=iomsg) f
end subroutine write_qp

subroutine read_qp(dtv, unit, iotype, v_list, iostat, iomsg)
  !! Reads characters up to and including the k part, e.g. "1 + 2i + 3j + 4k"
  !! or "1+2i+3j+4k", within one record of an external file.  Edit descriptors
  !! are ignored.  Reading stops at the k so the record end is never reached.
  !! Character variables are not supported as files; use quat_qp(string).
  class(quat_qp), intent(inout) :: dtv
  integer, intent(in) :: unit
  character(*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(*), intent(inout) :: iomsg
  character :: ch
  character(:), allocatable :: text
  type(quat_qp) :: q
  associate(unused => iotype, unused2 => v_list); end associate
  text = ''
  do
    read(unit, '(a)', advance='no', iostat=iostat, iomsg=iomsg) ch
    if (is_iostat_eor(iostat)) then
      iostat = 1
      iomsg = 'quaternion text must end with its k part: ' // text
      return
    end if
    if (iostat /= 0) then
      if (len(text) == 0) iomsg = trim(iomsg) // ' (to parse a string, use quat_qp(string))'
      return
    end if
    if (len(text) == 0 .and. (ch == ' ' .or. ch == ',')) cycle
    text = text // ch
    if (ch == 'k' .or. ch == 'K') exit
  end do
  call qp_parse(text, q, iostat)
  if (iostat /= 0) then
    iomsg = 'not a quaternion: ' // text
    return
  end if
  dtv%w = q%w; dtv%x = q%x; dtv%y = q%y; dtv%z = q%z
end subroutine read_qp
#endif

end module quaternions_impl


module quaternions
!! Quaternions that behave like Fortran's intrinsic `complex` type.
!! See llms.txt or the online documentation for the API.
  use quaternions_impl
  implicit none
  ! Everything public in quaternions_impl is re-exported.
#ifdef __NVCOMPILER
  ! nvfortran resolves type-bound derived-type I/O for only one type per
  ! scope, and cannot name write(formatted) in a PUBLIC statement, so the
  ! I/O generics are declared here, in a module that is public by default.

  private :: write_sp, read_sp
  interface write(formatted)
    module procedure :: write_sp
  end interface
  interface read(formatted)
    module procedure :: read_sp
  end interface


  private :: write_dp, read_dp
  interface write(formatted)
    module procedure :: write_dp
  end interface
  interface read(formatted)
    module procedure :: read_dp
  end interface

#if QUATERNIONS_QP
  private :: write_qp, read_qp
  interface write(formatted)
    module procedure :: write_qp
  end interface
  interface read(formatted)
    module procedure :: read_qp
  end interface
#endif
#endif
end module quaternions
