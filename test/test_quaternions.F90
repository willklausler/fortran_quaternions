! SPDX-License-Identifier: MIT
! ======================================================================
! GENERATED FILE - DO NOT EDIT.  Edit the templates in tmpl/ and run `make generate`.
! API summary for tools and agents: llms.txt
! ======================================================================
! Quadruple precision (quat_qp) is compiled unless QUATERNIONS_QP=0.
! It is switched off by default where real128 is unavailable.
#ifndef QUATERNIONS_QP
#if defined(__NVCOMPILER) || defined(__PGI) || defined(__flang__)
#define QUATERNIONS_QP 0
#else
#define QUATERNIONS_QP 1
#endif
#endif
program test_quaternions
  !! Unit tests for every public procedure, for each kind.
  !! Avoids NaN/Inf arithmetic so it runs under floating-point trapping.
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128, int8, int16, int32, int64
  use, intrinsic :: ieee_arithmetic, only: ieee_is_nan
  use quaternions
  implicit none
  integer :: ncheck = 0, nfail = 0

  call check(quaternions_has_qp .eqv. (QUATERNIONS_QP == 1), 'quaternions_has_qp')

  call test_sp()


  call test_dp()

#if QUATERNIONS_QP
  call test_qp()
#endif
  print '(i0, a, i0, a)', ncheck - nfail, ' of ', ncheck, ' checks passed'
  if (nfail > 0) error stop 1

contains

subroutine check(cond, name)
  logical, intent(in) :: cond
  character(*), intent(in) :: name
  ncheck = ncheck + 1
  if (.not. cond) then
    nfail = nfail + 1
    print '(a)', 'FAIL: ' // name
  end if
end subroutine check


! Explicit-shape dummies: nvfortran 26.1 passes bad descriptors for
! array-valued expressions given to assumed-shape dummies.
logical function vclose_sp(a, b, tol) result(c)
  !! 3-vectors equal within tol, relative to max(1, |b|)
  real(real32), intent(in) :: a(3), b(3), tol
  c = all(abs(a - b) <= tol*max(1._real32, maxval(abs(b))))
end function vclose_sp

logical function mclose_sp(a, b, tol) result(c)
  !! 3x3 matrices equal within tol, relative to max(1, |b|)
  real(real32), intent(in) :: a(3,3), b(3,3), tol
  c = all(abs(a - b) <= tol*max(1._real32, maxval(abs(b))))
end function mclose_sp

logical function all_nan_sp(q) result(c)
  type(quat_sp), intent(in) :: q
  c = ieee_is_nan(q%w) .and. ieee_is_nan(q%x) .and. ieee_is_nan(q%y) .and. ieee_is_nan(q%z)
end function all_nan_sp

subroutine test_sp()
  real(real32), parameter :: pi = acos(-1._real32), eps = epsilon(1._real32)
  real(real32), parameter :: tol = 64*eps, ltol = sqrt(eps)
  type(quat_sp), parameter :: one = quat_sp(1), i = quat_sp(0, 1), j = quat_sp(0, 0, 1), k = quat_sp(0, 0, 0, 1)
  type(quat_sp) :: p, q, r, qs(1000)
  real(real32) :: v(3), axis(3), angle, m(3,3), yaw, pitch, roll, big, t
  complex(real32) :: z
  character(200) :: buf
  integer :: n, u, ios
  character(*), parameter :: pre = 'sp: '

  ! Construction ------------------------------------------------------
  p = quat_sp(1, 2, 3, 4)
  call check(p%w == 1 .and. p%x == 2 .and. p%y == 3 .and. p%z == 4, pre // 'structure constructor')
  call check(quat_sp([1._real32, 2._real32, 3._real32, 4._real32]) == p, pre // 'array constructor')
  call check(quat_sp(2.5_real32) == quat_sp(2.5_real32, 0, 0, 0), pre // 'omitted parts are zero')
  call check(quat_sp('1 + 2i + 3j + 4k') == p, pre // 'parse spaced')
  call check(quat_sp('1+2i+3j+4k') == p, pre // 'parse compact')
  call check(quat_sp('4k + 3j + 1 + 2i') == p, pre // 'parse any order')
  call check(quat_sp('-1.5e+2 - 2.5E-1i + j - k') == quat_sp(-150, -0.25_real32, 1, -1), pre // 'parse exponents, implicit 1')
  call check(quat_sp('  -3  ') == quat_sp(-3), pre // 'parse real only')
  call check(quat_sp('.5i') == quat_sp(0, 0.5_real32), pre // 'parse leading dot')
  call check(quat_sp('1d2 + 2I') == quat_sp(100, 2), pre // 'parse d exponent, capital unit')
  call check(all_nan_sp(quat_sp('1 2')), pre // 'parse rejects missing sign')
  call check(all_nan_sp(quat_sp('2 i')), pre // 'parse rejects blank before unit')
  call check(all_nan_sp(quat_sp('1 +')), pre // 'parse rejects dangling sign')
  call check(all_nan_sp(quat_sp('x')), pre // 'parse rejects garbage')
  call check(all_nan_sp(quat_sp('')), pre // 'parse rejects empty')

  call check(quat_sp(quat_dp(1.5_real64, -2, 0.25_real64, 8)) == quat_sp(1.5_real32, -2, 0.25_real32, 8), &
    & pre // 'convert from dp')

#if QUATERNIONS_QP
  call check(quat_sp(quat_qp(1.5_real128, -2, 0.25_real128, 8)) == quat_sp(1.5_real32, -2, 0.25_real32, 8), &
    & pre // 'convert from qp')
#endif

  ! Assignment ----------------------------------------------------------
  q = 3_int8
  call check(q == quat_sp(3), pre // 'assign int8')
  q = 3_int16
  call check(q == quat_sp(3), pre // 'assign int16')
  q = 3_int32
  call check(q == quat_sp(3), pre // 'assign int32')
  q = 3_int64
  call check(q == quat_sp(3), pre // 'assign int64')
  q = 2.5_real32
  call check(q == quat_sp(2.5_real32), pre // 'assign real')

  ! Arithmetic ----------------------------------------------------------
  call check(i*j == k .and. j*k == i .and. k*i == j, pre // 'ij = k, jk = i, ki = j')
  call check(i*i == -one .and. j*j == -one .and. k*k == -one .and. i*j*k == -one, pre // 'i^2 = j^2 = k^2 = ijk = -1')
  call check(j*i == -k, pre // 'ji = -k')
  q = quat_sp(5, -6, 7, 8)
  call check(p + q == quat_sp(6, -4, 10, 12) .and. p - q == quat_sp(-4, 8, -4, -4), pre // 'add, subtract')
  call check(-p == quat_sp(-1, -2, -3, -4) .and. +p == p, pre // 'unary minus, plus')
  call check(p*q == quat_sp(-36, 0, -18, 60), pre // 'Hamilton product')
  call check(p + 2_int8 == quat_sp(3, 2, 3, 4) .and. 2_int8 + p == quat_sp(3, 2, 3, 4), pre // 'add int8')
  call check(p - 2_int8 == quat_sp(-1, 2, 3, 4) .and. 2_int8 - p == quat_sp(1, -2, -3, -4), pre // 'subtract int8')
  call check(p*2_int8 == quat_sp(2, 4, 6, 8) .and. 2_int8*p == quat_sp(2, 4, 6, 8), pre // 'multiply int8')
  call check(p/2_int8 == quat_sp(0.5_real32, 1, 1.5_real32, 2) .and. 2_int8/quat_sp(4) == quat_sp(0.5_real32), pre // 'divide int8')
  call check(quat_sp(2) == 2_int8 .and. 2_int8 == quat_sp(2) .and. .not. (p == 2_int8), pre // 'equal int8')
  call check(p /= 2_int8 .and. 2_int8 /= p .and. .not. (quat_sp(2) /= 2_int8), pre // 'not equal int8')
  call check(p**2_int8 == p*p, pre // 'power int8')
  call check(is_close(2_int8**q, exp(log(2_int8*one)*q), tol), pre // 'int8 ** quaternion')
  call check(p + 2_int16 == quat_sp(3, 2, 3, 4) .and. 2_int16 + p == quat_sp(3, 2, 3, 4), pre // 'add int16')
  call check(p - 2_int16 == quat_sp(-1, 2, 3, 4) .and. 2_int16 - p == quat_sp(1, -2, -3, -4), pre // 'subtract int16')
  call check(p*2_int16 == quat_sp(2, 4, 6, 8) .and. 2_int16*p == quat_sp(2, 4, 6, 8), pre // 'multiply int16')
  call check(p/2_int16 == quat_sp(0.5_real32, 1, 1.5_real32, 2) .and. 2_int16/quat_sp(4) == quat_sp(0.5_real32), pre // 'divide&
      & int16')
  call check(quat_sp(2) == 2_int16 .and. 2_int16 == quat_sp(2) .and. .not. (p == 2_int16), pre // 'equal int16')
  call check(p /= 2_int16 .and. 2_int16 /= p .and. .not. (quat_sp(2) /= 2_int16), pre // 'not equal int16')
  call check(p**2_int16 == p*p, pre // 'power int16')
  call check(is_close(2_int16**q, exp(log(2_int16*one)*q), tol), pre // 'int16 ** quaternion')
  call check(p + 2_int32 == quat_sp(3, 2, 3, 4) .and. 2_int32 + p == quat_sp(3, 2, 3, 4), pre // 'add int32')
  call check(p - 2_int32 == quat_sp(-1, 2, 3, 4) .and. 2_int32 - p == quat_sp(1, -2, -3, -4), pre // 'subtract int32')
  call check(p*2_int32 == quat_sp(2, 4, 6, 8) .and. 2_int32*p == quat_sp(2, 4, 6, 8), pre // 'multiply int32')
  call check(p/2_int32 == quat_sp(0.5_real32, 1, 1.5_real32, 2) .and. 2_int32/quat_sp(4) == quat_sp(0.5_real32), pre // 'divide&
      & int32')
  call check(quat_sp(2) == 2_int32 .and. 2_int32 == quat_sp(2) .and. .not. (p == 2_int32), pre // 'equal int32')
  call check(p /= 2_int32 .and. 2_int32 /= p .and. .not. (quat_sp(2) /= 2_int32), pre // 'not equal int32')
  call check(p**2_int32 == p*p, pre // 'power int32')
  call check(is_close(2_int32**q, exp(log(2_int32*one)*q), tol), pre // 'int32 ** quaternion')
  call check(p + 2_int64 == quat_sp(3, 2, 3, 4) .and. 2_int64 + p == quat_sp(3, 2, 3, 4), pre // 'add int64')
  call check(p - 2_int64 == quat_sp(-1, 2, 3, 4) .and. 2_int64 - p == quat_sp(1, -2, -3, -4), pre // 'subtract int64')
  call check(p*2_int64 == quat_sp(2, 4, 6, 8) .and. 2_int64*p == quat_sp(2, 4, 6, 8), pre // 'multiply int64')
  call check(p/2_int64 == quat_sp(0.5_real32, 1, 1.5_real32, 2) .and. 2_int64/quat_sp(4) == quat_sp(0.5_real32), pre // 'divide&
      & int64')
  call check(quat_sp(2) == 2_int64 .and. 2_int64 == quat_sp(2) .and. .not. (p == 2_int64), pre // 'equal int64')
  call check(p /= 2_int64 .and. 2_int64 /= p .and. .not. (quat_sp(2) /= 2_int64), pre // 'not equal int64')
  call check(p**2_int64 == p*p, pre // 'power int64')
  call check(is_close(2_int64**q, exp(log(2_int64*one)*q), tol), pre // 'int64 ** quaternion')
  call check(p + 2._real32 == quat_sp(3, 2, 3, 4) .and. 2._real32 + p == quat_sp(3, 2, 3, 4), pre // 'add real32')
  call check(p - 2._real32 == quat_sp(-1, 2, 3, 4) .and. 2._real32 - p == quat_sp(1, -2, -3, -4), pre // 'subtract real32')
  call check(p*2._real32 == quat_sp(2, 4, 6, 8) .and. 2._real32*p == quat_sp(2, 4, 6, 8), pre // 'multiply real32')
  call check(p/2._real32 == quat_sp(0.5_real32, 1, 1.5_real32, 2) .and. 2._real32/quat_sp(4) == quat_sp(0.5_real32), pre //&
      & 'divide real32')
  call check(quat_sp(2) == 2._real32 .and. 2._real32 == quat_sp(2) .and. .not. (p == 2._real32), pre // 'equal real32')
  call check(p /= 2._real32 .and. 2._real32 /= p .and. .not. (quat_sp(2) /= 2._real32), pre // 'not equal real32')
  call check(is_close(p**2._real32, p*p, tol), pre // 'power real32')
  call check(is_close(2._real32**q, exp(log(2._real32*one)*q), tol), pre // 'real32 ** quaternion')

  call random_number(qs(1:3))
  qs(1:3) = 2*qs(1:3) - 1
  p = qs(1); q = qs(2); r = qs(3)
  call check(is_close((p*q)*r, p*(q*r), tol), pre // 'associative')
  call check(is_close(p*inv(p), one, tol) .and. is_close(inv(p)*p, one, tol), pre // 'inverse')
  call check(is_close(p/q*q, p, tol) .and. is_close(p/q, p*inv(q), tol), pre // 'right division')
  call check(is_close(conjg(p*q), conjg(q)*conjg(p), tol), pre // 'conjugate of product')
  call check(abs(abs(p*q) - abs(p)*abs(q)) <= tol*abs(p)*abs(q), pre // 'norm is multiplicative')
  call check(abs(dot_product(p, p) - abs(p)**2) <= tol*abs(p)**2, pre // 'dot_product')
  call check(quat_sp(1, 1)**2 == 2*i, pre // '(1+i)**2 exact')
  call check(p**0 == one .and. is_close(p**3, p*p*p, tol), pre // 'power 0, 3')
  call check(is_close(p**(-1), inv(p), tol) .and. is_close(p**(-2_int64), inv(p*p), tol), pre // 'negative power')
  call check(is_close((p**0.5_real32)**2, p, tol) .and. is_close(p**1._real32, p, tol), pre // 'real power')
  call check(is_close(p**quat_sp(2), p*p, 4*tol), pre // 'quaternion power')
  big = 4*sqrt(huge(1._real32))
  call check(is_close(inv(quat_sp(big, big)), quat_sp(1/(2*big), -1/(2*big)), tol), pre // 'inverse without overflow')

  ! Comparison --------------------------------------------------------
  call check(quat_sp(1 + eps) /= one .and. .not. (quat_sp(1 + eps) == one), pre // '== is exact')
  call check(is_close(quat_sp(1 + eps), one), pre // 'is_close default')
  call check(.not. is_close(one, quat_sp(1.1_real32)), pre // 'is_close rejects')
  call check(is_close(quat_sp(0), quat_sp(1e-3_real32), abs_tol=1e-2_real32), pre // 'is_close abs_tol')
  call check(.not. is_close(quat_sp(0), quat_sp(1e-3_real32), rel_tol=0.5_real32), pre // 'is_close rel_tol near 0')

  ! Basic functions ---------------------------------------------------
  p = quat_sp(1, 2, 3, 4)
  call check(abs(abs(quat_sp(1, 2, 2, 4)) - 5) <= tol, pre // 'abs')
  call check(real(p) == 1 .and. all(aimag(p) == [2, 3, 4]), pre // 'real, aimag')
  call check(conjg(p) == quat_sp(1, -2, -3, -4), pre // 'conjg')
  call check(abs(abs(normalize(p)) - 1) <= tol, pre // 'normalize')
  call check(inv(quat_sp(2)) == quat_sp(0.5_real32), pre // 'inv')

  ! Elementary functions ----------------------------------------------
  ! On a complex plane through the real axis they match intrinsic complex.
  z = cmplx(0.3_real32, -0.7_real32, real32)
  q = quat_sp(0.3_real32, -0.7_real32)
  r = sqrt(q)
  call check(is_close(r, quat_sp(real(sqrt(z)), aimag(sqrt(z))), tol, tol), pre // 'sqrt matches complex')
  r = exp(q)
  call check(is_close(r, quat_sp(real(exp(z)), aimag(exp(z))), tol, tol), pre // 'exp matches complex')
  r = log(q)
  call check(is_close(r, quat_sp(real(log(z)), aimag(log(z))), tol, tol), pre // 'log matches complex')
  r = sin(q)
  call check(is_close(r, quat_sp(real(sin(z)), aimag(sin(z))), tol, tol), pre // 'sin matches complex')
  r = cos(q)
  call check(is_close(r, quat_sp(real(cos(z)), aimag(cos(z))), tol, tol), pre // 'cos matches complex')
  r = tan(q)
  call check(is_close(r, quat_sp(real(tan(z)), aimag(tan(z))), tol, tol), pre // 'tan matches complex')
  r = asin(q)
  call check(is_close(r, quat_sp(real(asin(z)), aimag(asin(z))), tol, tol), pre // 'asin matches complex')
  r = acos(q)
  call check(is_close(r, quat_sp(real(acos(z)), aimag(acos(z))), tol, tol), pre // 'acos matches complex')
  r = atan(q)
  call check(is_close(r, quat_sp(real(atan(z)), aimag(atan(z))), tol, tol), pre // 'atan matches complex')
  r = sinh(q)
  call check(is_close(r, quat_sp(real(sinh(z)), aimag(sinh(z))), tol, tol), pre // 'sinh matches complex')
  r = cosh(q)
  call check(is_close(r, quat_sp(real(cosh(z)), aimag(cosh(z))), tol, tol), pre // 'cosh matches complex')
  r = tanh(q)
  call check(is_close(r, quat_sp(real(tanh(z)), aimag(tanh(z))), tol, tol), pre // 'tanh matches complex')
  q = quat_sp(0.3_real32, 0.2_real32, -0.4_real32, 0.5_real32)
  call check(is_close(exp(log(q)), q, tol) .and. is_close(sqrt(q)*sqrt(q), q, tol), pre // 'exp(log), sqrt')
  call check(is_close(sin(q)**2 + cos(q)**2, one, tol), pre // 'sin^2 + cos^2 = 1')
  call check(is_close(cosh(q)**2 - sinh(q)**2, one, tol), pre // 'cosh^2 - sinh^2 = 1')
  call check(is_close(tan(q), sin(q)/cos(q), tol) .and. is_close(tanh(q), sinh(q)/cosh(q), tol), pre // 'tan, tanh')
  call check(is_close(asin(sin(q)), q, tol) .and. is_close(acos(cos(q)), q, tol) .and. is_close(atan(tan(q)), q, tol), &
    & pre // 'inverse trigonometric')
  call check(is_close(sinh(asinh(q)), q, tol) .and. is_close(cosh(acosh(q)), q, tol) .and. is_close(tanh(atanh(q)), q, tol), &
    & pre // 'inverse hyperbolic')
  call check(is_close(log10(quat_sp(100)), quat_sp(2), tol), pre // 'log10')
  call check(is_close(sqrt(quat_sp(-4)), 2*i, tol), pre // 'sqrt(-4) = 2i')
  call check(is_close(log(-one), pi*i, tol), pre // 'log(-1) = pi i')
  call check(is_close(exp(pi*k), -one, abs_tol=tol), pre // 'exp(pi k) = -1')
  t = 1e-10_real32
  r = exp(quat_sp(0, t))
  call check(abs(r%x - sin(t)) <= tol*t, pre // 'exp keeps tiny vector part')
  r = log(quat_sp(1, 0, t))
  call check(abs(r%y - atan(t)) <= tol*t, pre // 'log keeps tiny vector part')

  ! Rotations ---------------------------------------------------------
  q = from_axis_angle([0._real32, 0._real32, 2._real32], pi/2)
  call check(vclose_sp(rotate(q, [1._real32, 0._real32, 0._real32]), [0._real32, 1._real32, 0._real32], tol), &
    & pre // 'rotate x about z to y')
  call check(vclose_sp(rotate(2*q, [0._real32, 1._real32, 0._real32]), [-1._real32, 0._real32, 0._real32], tol), &
    & pre // 'rotate with non-unit quaternion')
  call check(is_close(from_euler_zyx(pi/2, 0._real32, 0._real32), q, tol), pre // 'yaw is about z')
  call check(vclose_sp(rotate(from_euler_zyx(0._real32, pi/2, 0._real32), [1._real32, 0._real32, 0._real32]), &
    & [0._real32, 0._real32, -1._real32], tol), pre // 'pitch is about y')
  call check(vclose_sp(rotate(from_euler_zyx(0._real32, 0._real32, pi/2), [0._real32, 1._real32, 0._real32]), &
    & [0._real32, 0._real32, 1._real32], tol), pre // 'roll is about x')
  p = from_axis_angle([0._real32, 0._real32, 1._real32], 0.3_real32) * from_axis_angle([0._real32, 1._real32, 0._real32],&
      & -0.2_real32) &
    & * from_axis_angle([1._real32, 0._real32, 0._real32], 0.1_real32)
  call check(is_close(from_euler_zyx(0.3_real32, -0.2_real32, 0.1_real32), p, tol), pre // 'euler order z y x')
  call to_axis_angle(from_axis_angle([1._real32, -2._real32, 2._real32], 2.5_real32), axis, angle)
  call check(vclose_sp(axis, [1._real32, -2._real32, 2._real32]/3, tol) .and. abs(angle - 2.5_real32) <= tol, &
    & pre // 'axis-angle round trip')
  call to_axis_angle(one, axis, angle)
  call check(all(axis == [1, 0, 0]) .and. angle == 0, pre // 'identity axis-angle')

  call random_rotation(qs)
  v = [0.5_real32, -1._real32, 2._real32]
  do n = 1, 100
    q = qs(n)
    r = q*quat_sp(0, v(1), v(2), v(3))*conjg(q)
    call check(vclose_sp(rotate(q, v), [r%x, r%y, r%z], tol), pre // 'rotate = q v q*')
    m = to_matrix(q)
    call check(vclose_sp(matmul(m, v), rotate(q, v), tol), pre // 'to_matrix matches rotate')
    call check(mclose_sp(matmul(transpose(m), m), to_matrix(one), tol), &
      & pre // 'to_matrix orthogonal')
    if (q%w < 0) q = -q
    call check(is_close(from_matrix(m), q, tol), pre // 'from_matrix round trip')
    call to_euler_zyx(q, yaw, pitch, roll)
    call check(is_close(from_euler_zyx(yaw, pitch, roll), q, tol) .or. is_close(from_euler_zyx(yaw, pitch, roll), -q, tol), &
      & pre // 'euler round trip')
  end do
  ! Half turns exercise every branch of Shepperd's method
  do n = 1, 4
    axis = [real(real32) :: merge(1, 0, n == 1 .or. n == 4), merge(1, 0, n == 2 .or. n == 4), merge(1, 0, n >= 3)]
    m = to_matrix(from_axis_angle(axis, pi))
    call check(mclose_sp(to_matrix(from_matrix(m)), m, tol), pre // 'from_matrix half turn')
  end do
  ! Gimbal lock: the rotation survives even though yaw and roll are not unique
  q = from_euler_zyx(0.3_real32, pi/2, 0.2_real32)
  call to_euler_zyx(q, yaw, pitch, roll)
  call check(abs(pitch - pi/2) <= ltol, pre // 'gimbal pitch')
  call check(mclose_sp(to_matrix(from_euler_zyx(yaw, pitch, roll)), to_matrix(q), ltol), &
    & pre // 'gimbal rotation')

  p = one
  q = from_axis_angle([0._real32, 0._real32, 1._real32], 1._real32)
  call check(is_close(slerp(p, q, 0._real32), p, tol) .and. is_close(slerp(p, q, 1._real32), q, tol), pre // 'slerp ends')
  r = from_axis_angle([0._real32, 0._real32, 1._real32], 0.3_real32)
  call check(is_close(slerp(p, q, 0.3_real32), r, tol), pre // 'slerp constant speed')
  call check(is_close(slerp(p, -q, 0.3_real32), r, tol), pre // 'slerp shorter arc')
  call check(slerp(q, q, 0.3_real32) == q, pre // 'slerp equal ends')

  ! Random numbers ----------------------------------------------------
  call check(all(abs(abs(qs) - 1) <= tol), pre // 'random_rotation unit')
  call check(any(qs%w < 0) .and. any(qs%w > 0) .and. any(qs%z < 0) .and. any(qs%z > 0), pre // 'random_rotation signs')
  call check(abs(sum(qs%x)/size(qs)) < 0.1_real32, pre // 'random_rotation mean')
  call random_number(qs)
  call check(all(qs%w >= 0 .and. qs%w < 1 .and. qs%x >= 0 .and. qs%x < 1 .and. qs%y >= 0 .and. qs%y < 1 &
    & .and. qs%z >= 0 .and. qs%z < 1), pre // 'random_number in [0,1)')

  ! Text ----------------------------------------------------------------
  p = quat_sp(1, -2, 3, -4)
  call check(to_string(p, '(f0.1)') == '1.0 - 2.0i + 3.0j - 4.0k', pre // 'to_string fmt')
  call check(is_close(quat_sp(to_string(p*pi)), p*pi, tol), pre // 'to_string default round trip')
#ifndef __NVCOMPILER
  ! nvfortran does not support derived-type I/O on character variables
  write(buf, '(dt"f"(6,2))') p
  call check(buf == '1.00 - 2.00i + 3.00j - 4.00k', pre // 'DT"F"(6,2)')
  write(buf, '(dt"es10.2")') p*pi
  call check(is_close(quat_sp(buf), p*pi, 1e-2_real32), pre // 'DT"ES10.2"')
  write(buf, '(dt)') p
  call check(quat_sp(buf) == p, pre // 'DT g0')
#endif
  ! One read statement per file: ifx 2026 fails on a read that follows a
  ! derived-type read of a record starting with blanks.
  q = p*pi
  open(newunit=u, status='scratch')
  write(u, *) p, q
  rewind(u)
  read(u, *) r, q
  close(u)
  call check(r == p .and. is_close(q, p*pi, tol), pre // 'list-directed round trip')
  open(newunit=u, status='scratch')
  write(u, '(a)') '7+1k, 8 + 2i + 0j - 1K'
  rewind(u)
  read(u, *) r, q
  close(u)
  call check(r == quat_sp(7, 0, 0, 1) .and. q == quat_sp(8, 2, 0, -1), pre // 'read compact, comma')
#ifndef __GFORTRAN__
  ! libgfortran leaks the format of a child read that ends at end of record,
  ! which fails the LeakSanitizer in the gfortran debug profile.
  open(newunit=u, status='scratch')
  write(u, '(a)') '1 + 2i'
  rewind(u)
  read(u, *, iostat=ios) r
  close(u)
  call check(ios > 0, pre // 'read without k part is an error')
#endif
  open(newunit=u, status='scratch')
  write(u, '(a)') 'quark'
  rewind(u)
  read(u, *, iostat=ios) r
  close(u)
  call check(ios > 0, pre // 'read garbage is an error')
end subroutine test_sp



! Explicit-shape dummies: nvfortran 26.1 passes bad descriptors for
! array-valued expressions given to assumed-shape dummies.
logical function vclose_dp(a, b, tol) result(c)
  !! 3-vectors equal within tol, relative to max(1, |b|)
  real(real64), intent(in) :: a(3), b(3), tol
  c = all(abs(a - b) <= tol*max(1._real64, maxval(abs(b))))
end function vclose_dp

logical function mclose_dp(a, b, tol) result(c)
  !! 3x3 matrices equal within tol, relative to max(1, |b|)
  real(real64), intent(in) :: a(3,3), b(3,3), tol
  c = all(abs(a - b) <= tol*max(1._real64, maxval(abs(b))))
end function mclose_dp

logical function all_nan_dp(q) result(c)
  type(quat_dp), intent(in) :: q
  c = ieee_is_nan(q%w) .and. ieee_is_nan(q%x) .and. ieee_is_nan(q%y) .and. ieee_is_nan(q%z)
end function all_nan_dp

subroutine test_dp()
  real(real64), parameter :: pi = acos(-1._real64), eps = epsilon(1._real64)
  real(real64), parameter :: tol = 64*eps, ltol = sqrt(eps)
  type(quat_dp), parameter :: one = quat_dp(1), i = quat_dp(0, 1), j = quat_dp(0, 0, 1), k = quat_dp(0, 0, 0, 1)
  type(quat_dp) :: p, q, r, qs(1000)
  real(real64) :: v(3), axis(3), angle, m(3,3), yaw, pitch, roll, big, t
  complex(real64) :: z
  character(200) :: buf
  integer :: n, u, ios
  character(*), parameter :: pre = 'dp: '

  ! Construction ------------------------------------------------------
  p = quat_dp(1, 2, 3, 4)
  call check(p%w == 1 .and. p%x == 2 .and. p%y == 3 .and. p%z == 4, pre // 'structure constructor')
  call check(quat_dp([1._real64, 2._real64, 3._real64, 4._real64]) == p, pre // 'array constructor')
  call check(quat_dp(2.5_real64) == quat_dp(2.5_real64, 0, 0, 0), pre // 'omitted parts are zero')
  call check(quat_dp('1 + 2i + 3j + 4k') == p, pre // 'parse spaced')
  call check(quat_dp('1+2i+3j+4k') == p, pre // 'parse compact')
  call check(quat_dp('4k + 3j + 1 + 2i') == p, pre // 'parse any order')
  call check(quat_dp('-1.5e+2 - 2.5E-1i + j - k') == quat_dp(-150, -0.25_real64, 1, -1), pre // 'parse exponents, implicit 1')
  call check(quat_dp('  -3  ') == quat_dp(-3), pre // 'parse real only')
  call check(quat_dp('.5i') == quat_dp(0, 0.5_real64), pre // 'parse leading dot')
  call check(quat_dp('1d2 + 2I') == quat_dp(100, 2), pre // 'parse d exponent, capital unit')
  call check(all_nan_dp(quat_dp('1 2')), pre // 'parse rejects missing sign')
  call check(all_nan_dp(quat_dp('2 i')), pre // 'parse rejects blank before unit')
  call check(all_nan_dp(quat_dp('1 +')), pre // 'parse rejects dangling sign')
  call check(all_nan_dp(quat_dp('x')), pre // 'parse rejects garbage')
  call check(all_nan_dp(quat_dp('')), pre // 'parse rejects empty')

  call check(quat_dp(quat_sp(1.5_real32, -2, 0.25_real32, 8)) == quat_dp(1.5_real64, -2, 0.25_real64, 8), &
    & pre // 'convert from sp')

#if QUATERNIONS_QP
  call check(quat_dp(quat_qp(1.5_real128, -2, 0.25_real128, 8)) == quat_dp(1.5_real64, -2, 0.25_real64, 8), &
    & pre // 'convert from qp')
#endif

  ! Assignment ----------------------------------------------------------
  q = 3_int8
  call check(q == quat_dp(3), pre // 'assign int8')
  q = 3_int16
  call check(q == quat_dp(3), pre // 'assign int16')
  q = 3_int32
  call check(q == quat_dp(3), pre // 'assign int32')
  q = 3_int64
  call check(q == quat_dp(3), pre // 'assign int64')
  q = 2.5_real64
  call check(q == quat_dp(2.5_real64), pre // 'assign real')

  ! Arithmetic ----------------------------------------------------------
  call check(i*j == k .and. j*k == i .and. k*i == j, pre // 'ij = k, jk = i, ki = j')
  call check(i*i == -one .and. j*j == -one .and. k*k == -one .and. i*j*k == -one, pre // 'i^2 = j^2 = k^2 = ijk = -1')
  call check(j*i == -k, pre // 'ji = -k')
  q = quat_dp(5, -6, 7, 8)
  call check(p + q == quat_dp(6, -4, 10, 12) .and. p - q == quat_dp(-4, 8, -4, -4), pre // 'add, subtract')
  call check(-p == quat_dp(-1, -2, -3, -4) .and. +p == p, pre // 'unary minus, plus')
  call check(p*q == quat_dp(-36, 0, -18, 60), pre // 'Hamilton product')
  call check(p + 2_int8 == quat_dp(3, 2, 3, 4) .and. 2_int8 + p == quat_dp(3, 2, 3, 4), pre // 'add int8')
  call check(p - 2_int8 == quat_dp(-1, 2, 3, 4) .and. 2_int8 - p == quat_dp(1, -2, -3, -4), pre // 'subtract int8')
  call check(p*2_int8 == quat_dp(2, 4, 6, 8) .and. 2_int8*p == quat_dp(2, 4, 6, 8), pre // 'multiply int8')
  call check(p/2_int8 == quat_dp(0.5_real64, 1, 1.5_real64, 2) .and. 2_int8/quat_dp(4) == quat_dp(0.5_real64), pre // 'divide int8')
  call check(quat_dp(2) == 2_int8 .and. 2_int8 == quat_dp(2) .and. .not. (p == 2_int8), pre // 'equal int8')
  call check(p /= 2_int8 .and. 2_int8 /= p .and. .not. (quat_dp(2) /= 2_int8), pre // 'not equal int8')
  call check(p**2_int8 == p*p, pre // 'power int8')
  call check(is_close(2_int8**q, exp(log(2_int8*one)*q), tol), pre // 'int8 ** quaternion')
  call check(p + 2_int16 == quat_dp(3, 2, 3, 4) .and. 2_int16 + p == quat_dp(3, 2, 3, 4), pre // 'add int16')
  call check(p - 2_int16 == quat_dp(-1, 2, 3, 4) .and. 2_int16 - p == quat_dp(1, -2, -3, -4), pre // 'subtract int16')
  call check(p*2_int16 == quat_dp(2, 4, 6, 8) .and. 2_int16*p == quat_dp(2, 4, 6, 8), pre // 'multiply int16')
  call check(p/2_int16 == quat_dp(0.5_real64, 1, 1.5_real64, 2) .and. 2_int16/quat_dp(4) == quat_dp(0.5_real64), pre // 'divide&
      & int16')
  call check(quat_dp(2) == 2_int16 .and. 2_int16 == quat_dp(2) .and. .not. (p == 2_int16), pre // 'equal int16')
  call check(p /= 2_int16 .and. 2_int16 /= p .and. .not. (quat_dp(2) /= 2_int16), pre // 'not equal int16')
  call check(p**2_int16 == p*p, pre // 'power int16')
  call check(is_close(2_int16**q, exp(log(2_int16*one)*q), tol), pre // 'int16 ** quaternion')
  call check(p + 2_int32 == quat_dp(3, 2, 3, 4) .and. 2_int32 + p == quat_dp(3, 2, 3, 4), pre // 'add int32')
  call check(p - 2_int32 == quat_dp(-1, 2, 3, 4) .and. 2_int32 - p == quat_dp(1, -2, -3, -4), pre // 'subtract int32')
  call check(p*2_int32 == quat_dp(2, 4, 6, 8) .and. 2_int32*p == quat_dp(2, 4, 6, 8), pre // 'multiply int32')
  call check(p/2_int32 == quat_dp(0.5_real64, 1, 1.5_real64, 2) .and. 2_int32/quat_dp(4) == quat_dp(0.5_real64), pre // 'divide&
      & int32')
  call check(quat_dp(2) == 2_int32 .and. 2_int32 == quat_dp(2) .and. .not. (p == 2_int32), pre // 'equal int32')
  call check(p /= 2_int32 .and. 2_int32 /= p .and. .not. (quat_dp(2) /= 2_int32), pre // 'not equal int32')
  call check(p**2_int32 == p*p, pre // 'power int32')
  call check(is_close(2_int32**q, exp(log(2_int32*one)*q), tol), pre // 'int32 ** quaternion')
  call check(p + 2_int64 == quat_dp(3, 2, 3, 4) .and. 2_int64 + p == quat_dp(3, 2, 3, 4), pre // 'add int64')
  call check(p - 2_int64 == quat_dp(-1, 2, 3, 4) .and. 2_int64 - p == quat_dp(1, -2, -3, -4), pre // 'subtract int64')
  call check(p*2_int64 == quat_dp(2, 4, 6, 8) .and. 2_int64*p == quat_dp(2, 4, 6, 8), pre // 'multiply int64')
  call check(p/2_int64 == quat_dp(0.5_real64, 1, 1.5_real64, 2) .and. 2_int64/quat_dp(4) == quat_dp(0.5_real64), pre // 'divide&
      & int64')
  call check(quat_dp(2) == 2_int64 .and. 2_int64 == quat_dp(2) .and. .not. (p == 2_int64), pre // 'equal int64')
  call check(p /= 2_int64 .and. 2_int64 /= p .and. .not. (quat_dp(2) /= 2_int64), pre // 'not equal int64')
  call check(p**2_int64 == p*p, pre // 'power int64')
  call check(is_close(2_int64**q, exp(log(2_int64*one)*q), tol), pre // 'int64 ** quaternion')
  call check(p + 2._real64 == quat_dp(3, 2, 3, 4) .and. 2._real64 + p == quat_dp(3, 2, 3, 4), pre // 'add real64')
  call check(p - 2._real64 == quat_dp(-1, 2, 3, 4) .and. 2._real64 - p == quat_dp(1, -2, -3, -4), pre // 'subtract real64')
  call check(p*2._real64 == quat_dp(2, 4, 6, 8) .and. 2._real64*p == quat_dp(2, 4, 6, 8), pre // 'multiply real64')
  call check(p/2._real64 == quat_dp(0.5_real64, 1, 1.5_real64, 2) .and. 2._real64/quat_dp(4) == quat_dp(0.5_real64), pre //&
      & 'divide real64')
  call check(quat_dp(2) == 2._real64 .and. 2._real64 == quat_dp(2) .and. .not. (p == 2._real64), pre // 'equal real64')
  call check(p /= 2._real64 .and. 2._real64 /= p .and. .not. (quat_dp(2) /= 2._real64), pre // 'not equal real64')
  call check(is_close(p**2._real64, p*p, tol), pre // 'power real64')
  call check(is_close(2._real64**q, exp(log(2._real64*one)*q), tol), pre // 'real64 ** quaternion')

  call random_number(qs(1:3))
  qs(1:3) = 2*qs(1:3) - 1
  p = qs(1); q = qs(2); r = qs(3)
  call check(is_close((p*q)*r, p*(q*r), tol), pre // 'associative')
  call check(is_close(p*inv(p), one, tol) .and. is_close(inv(p)*p, one, tol), pre // 'inverse')
  call check(is_close(p/q*q, p, tol) .and. is_close(p/q, p*inv(q), tol), pre // 'right division')
  call check(is_close(conjg(p*q), conjg(q)*conjg(p), tol), pre // 'conjugate of product')
  call check(abs(abs(p*q) - abs(p)*abs(q)) <= tol*abs(p)*abs(q), pre // 'norm is multiplicative')
  call check(abs(dot_product(p, p) - abs(p)**2) <= tol*abs(p)**2, pre // 'dot_product')
  call check(quat_dp(1, 1)**2 == 2*i, pre // '(1+i)**2 exact')
  call check(p**0 == one .and. is_close(p**3, p*p*p, tol), pre // 'power 0, 3')
  call check(is_close(p**(-1), inv(p), tol) .and. is_close(p**(-2_int64), inv(p*p), tol), pre // 'negative power')
  call check(is_close((p**0.5_real64)**2, p, tol) .and. is_close(p**1._real64, p, tol), pre // 'real power')
  call check(is_close(p**quat_dp(2), p*p, 4*tol), pre // 'quaternion power')
  big = 4*sqrt(huge(1._real64))
  call check(is_close(inv(quat_dp(big, big)), quat_dp(1/(2*big), -1/(2*big)), tol), pre // 'inverse without overflow')

  ! Comparison --------------------------------------------------------
  call check(quat_dp(1 + eps) /= one .and. .not. (quat_dp(1 + eps) == one), pre // '== is exact')
  call check(is_close(quat_dp(1 + eps), one), pre // 'is_close default')
  call check(.not. is_close(one, quat_dp(1.1_real64)), pre // 'is_close rejects')
  call check(is_close(quat_dp(0), quat_dp(1e-3_real64), abs_tol=1e-2_real64), pre // 'is_close abs_tol')
  call check(.not. is_close(quat_dp(0), quat_dp(1e-3_real64), rel_tol=0.5_real64), pre // 'is_close rel_tol near 0')

  ! Basic functions ---------------------------------------------------
  p = quat_dp(1, 2, 3, 4)
  call check(abs(abs(quat_dp(1, 2, 2, 4)) - 5) <= tol, pre // 'abs')
  call check(real(p) == 1 .and. all(aimag(p) == [2, 3, 4]), pre // 'real, aimag')
  call check(conjg(p) == quat_dp(1, -2, -3, -4), pre // 'conjg')
  call check(abs(abs(normalize(p)) - 1) <= tol, pre // 'normalize')
  call check(inv(quat_dp(2)) == quat_dp(0.5_real64), pre // 'inv')

  ! Elementary functions ----------------------------------------------
  ! On a complex plane through the real axis they match intrinsic complex.
  z = cmplx(0.3_real64, -0.7_real64, real64)
  q = quat_dp(0.3_real64, -0.7_real64)
  r = sqrt(q)
  call check(is_close(r, quat_dp(real(sqrt(z)), aimag(sqrt(z))), tol, tol), pre // 'sqrt matches complex')
  r = exp(q)
  call check(is_close(r, quat_dp(real(exp(z)), aimag(exp(z))), tol, tol), pre // 'exp matches complex')
  r = log(q)
  call check(is_close(r, quat_dp(real(log(z)), aimag(log(z))), tol, tol), pre // 'log matches complex')
  r = sin(q)
  call check(is_close(r, quat_dp(real(sin(z)), aimag(sin(z))), tol, tol), pre // 'sin matches complex')
  r = cos(q)
  call check(is_close(r, quat_dp(real(cos(z)), aimag(cos(z))), tol, tol), pre // 'cos matches complex')
  r = tan(q)
  call check(is_close(r, quat_dp(real(tan(z)), aimag(tan(z))), tol, tol), pre // 'tan matches complex')
  r = asin(q)
  call check(is_close(r, quat_dp(real(asin(z)), aimag(asin(z))), tol, tol), pre // 'asin matches complex')
  r = acos(q)
  call check(is_close(r, quat_dp(real(acos(z)), aimag(acos(z))), tol, tol), pre // 'acos matches complex')
  r = atan(q)
  call check(is_close(r, quat_dp(real(atan(z)), aimag(atan(z))), tol, tol), pre // 'atan matches complex')
  r = sinh(q)
  call check(is_close(r, quat_dp(real(sinh(z)), aimag(sinh(z))), tol, tol), pre // 'sinh matches complex')
  r = cosh(q)
  call check(is_close(r, quat_dp(real(cosh(z)), aimag(cosh(z))), tol, tol), pre // 'cosh matches complex')
  r = tanh(q)
  call check(is_close(r, quat_dp(real(tanh(z)), aimag(tanh(z))), tol, tol), pre // 'tanh matches complex')
  q = quat_dp(0.3_real64, 0.2_real64, -0.4_real64, 0.5_real64)
  call check(is_close(exp(log(q)), q, tol) .and. is_close(sqrt(q)*sqrt(q), q, tol), pre // 'exp(log), sqrt')
  call check(is_close(sin(q)**2 + cos(q)**2, one, tol), pre // 'sin^2 + cos^2 = 1')
  call check(is_close(cosh(q)**2 - sinh(q)**2, one, tol), pre // 'cosh^2 - sinh^2 = 1')
  call check(is_close(tan(q), sin(q)/cos(q), tol) .and. is_close(tanh(q), sinh(q)/cosh(q), tol), pre // 'tan, tanh')
  call check(is_close(asin(sin(q)), q, tol) .and. is_close(acos(cos(q)), q, tol) .and. is_close(atan(tan(q)), q, tol), &
    & pre // 'inverse trigonometric')
  call check(is_close(sinh(asinh(q)), q, tol) .and. is_close(cosh(acosh(q)), q, tol) .and. is_close(tanh(atanh(q)), q, tol), &
    & pre // 'inverse hyperbolic')
  call check(is_close(log10(quat_dp(100)), quat_dp(2), tol), pre // 'log10')
  call check(is_close(sqrt(quat_dp(-4)), 2*i, tol), pre // 'sqrt(-4) = 2i')
  call check(is_close(log(-one), pi*i, tol), pre // 'log(-1) = pi i')
  call check(is_close(exp(pi*k), -one, abs_tol=tol), pre // 'exp(pi k) = -1')
  t = 1e-10_real64
  r = exp(quat_dp(0, t))
  call check(abs(r%x - sin(t)) <= tol*t, pre // 'exp keeps tiny vector part')
  r = log(quat_dp(1, 0, t))
  call check(abs(r%y - atan(t)) <= tol*t, pre // 'log keeps tiny vector part')

  ! Rotations ---------------------------------------------------------
  q = from_axis_angle([0._real64, 0._real64, 2._real64], pi/2)
  call check(vclose_dp(rotate(q, [1._real64, 0._real64, 0._real64]), [0._real64, 1._real64, 0._real64], tol), &
    & pre // 'rotate x about z to y')
  call check(vclose_dp(rotate(2*q, [0._real64, 1._real64, 0._real64]), [-1._real64, 0._real64, 0._real64], tol), &
    & pre // 'rotate with non-unit quaternion')
  call check(is_close(from_euler_zyx(pi/2, 0._real64, 0._real64), q, tol), pre // 'yaw is about z')
  call check(vclose_dp(rotate(from_euler_zyx(0._real64, pi/2, 0._real64), [1._real64, 0._real64, 0._real64]), &
    & [0._real64, 0._real64, -1._real64], tol), pre // 'pitch is about y')
  call check(vclose_dp(rotate(from_euler_zyx(0._real64, 0._real64, pi/2), [0._real64, 1._real64, 0._real64]), &
    & [0._real64, 0._real64, 1._real64], tol), pre // 'roll is about x')
  p = from_axis_angle([0._real64, 0._real64, 1._real64], 0.3_real64) * from_axis_angle([0._real64, 1._real64, 0._real64],&
      & -0.2_real64) &
    & * from_axis_angle([1._real64, 0._real64, 0._real64], 0.1_real64)
  call check(is_close(from_euler_zyx(0.3_real64, -0.2_real64, 0.1_real64), p, tol), pre // 'euler order z y x')
  call to_axis_angle(from_axis_angle([1._real64, -2._real64, 2._real64], 2.5_real64), axis, angle)
  call check(vclose_dp(axis, [1._real64, -2._real64, 2._real64]/3, tol) .and. abs(angle - 2.5_real64) <= tol, &
    & pre // 'axis-angle round trip')
  call to_axis_angle(one, axis, angle)
  call check(all(axis == [1, 0, 0]) .and. angle == 0, pre // 'identity axis-angle')

  call random_rotation(qs)
  v = [0.5_real64, -1._real64, 2._real64]
  do n = 1, 100
    q = qs(n)
    r = q*quat_dp(0, v(1), v(2), v(3))*conjg(q)
    call check(vclose_dp(rotate(q, v), [r%x, r%y, r%z], tol), pre // 'rotate = q v q*')
    m = to_matrix(q)
    call check(vclose_dp(matmul(m, v), rotate(q, v), tol), pre // 'to_matrix matches rotate')
    call check(mclose_dp(matmul(transpose(m), m), to_matrix(one), tol), &
      & pre // 'to_matrix orthogonal')
    if (q%w < 0) q = -q
    call check(is_close(from_matrix(m), q, tol), pre // 'from_matrix round trip')
    call to_euler_zyx(q, yaw, pitch, roll)
    call check(is_close(from_euler_zyx(yaw, pitch, roll), q, tol) .or. is_close(from_euler_zyx(yaw, pitch, roll), -q, tol), &
      & pre // 'euler round trip')
  end do
  ! Half turns exercise every branch of Shepperd's method
  do n = 1, 4
    axis = [real(real64) :: merge(1, 0, n == 1 .or. n == 4), merge(1, 0, n == 2 .or. n == 4), merge(1, 0, n >= 3)]
    m = to_matrix(from_axis_angle(axis, pi))
    call check(mclose_dp(to_matrix(from_matrix(m)), m, tol), pre // 'from_matrix half turn')
  end do
  ! Gimbal lock: the rotation survives even though yaw and roll are not unique
  q = from_euler_zyx(0.3_real64, pi/2, 0.2_real64)
  call to_euler_zyx(q, yaw, pitch, roll)
  call check(abs(pitch - pi/2) <= ltol, pre // 'gimbal pitch')
  call check(mclose_dp(to_matrix(from_euler_zyx(yaw, pitch, roll)), to_matrix(q), ltol), &
    & pre // 'gimbal rotation')

  p = one
  q = from_axis_angle([0._real64, 0._real64, 1._real64], 1._real64)
  call check(is_close(slerp(p, q, 0._real64), p, tol) .and. is_close(slerp(p, q, 1._real64), q, tol), pre // 'slerp ends')
  r = from_axis_angle([0._real64, 0._real64, 1._real64], 0.3_real64)
  call check(is_close(slerp(p, q, 0.3_real64), r, tol), pre // 'slerp constant speed')
  call check(is_close(slerp(p, -q, 0.3_real64), r, tol), pre // 'slerp shorter arc')
  call check(slerp(q, q, 0.3_real64) == q, pre // 'slerp equal ends')

  ! Random numbers ----------------------------------------------------
  call check(all(abs(abs(qs) - 1) <= tol), pre // 'random_rotation unit')
  call check(any(qs%w < 0) .and. any(qs%w > 0) .and. any(qs%z < 0) .and. any(qs%z > 0), pre // 'random_rotation signs')
  call check(abs(sum(qs%x)/size(qs)) < 0.1_real64, pre // 'random_rotation mean')
  call random_number(qs)
  call check(all(qs%w >= 0 .and. qs%w < 1 .and. qs%x >= 0 .and. qs%x < 1 .and. qs%y >= 0 .and. qs%y < 1 &
    & .and. qs%z >= 0 .and. qs%z < 1), pre // 'random_number in [0,1)')

  ! Text ----------------------------------------------------------------
  p = quat_dp(1, -2, 3, -4)
  call check(to_string(p, '(f0.1)') == '1.0 - 2.0i + 3.0j - 4.0k', pre // 'to_string fmt')
  call check(is_close(quat_dp(to_string(p*pi)), p*pi, tol), pre // 'to_string default round trip')
#ifndef __NVCOMPILER
  ! nvfortran does not support derived-type I/O on character variables
  write(buf, '(dt"f"(6,2))') p
  call check(buf == '1.00 - 2.00i + 3.00j - 4.00k', pre // 'DT"F"(6,2)')
  write(buf, '(dt"es10.2")') p*pi
  call check(is_close(quat_dp(buf), p*pi, 1e-2_real64), pre // 'DT"ES10.2"')
  write(buf, '(dt)') p
  call check(quat_dp(buf) == p, pre // 'DT g0')
#endif
  ! One read statement per file: ifx 2026 fails on a read that follows a
  ! derived-type read of a record starting with blanks.
  q = p*pi
  open(newunit=u, status='scratch')
  write(u, *) p, q
  rewind(u)
  read(u, *) r, q
  close(u)
  call check(r == p .and. is_close(q, p*pi, tol), pre // 'list-directed round trip')
  open(newunit=u, status='scratch')
  write(u, '(a)') '7+1k, 8 + 2i + 0j - 1K'
  rewind(u)
  read(u, *) r, q
  close(u)
  call check(r == quat_dp(7, 0, 0, 1) .and. q == quat_dp(8, 2, 0, -1), pre // 'read compact, comma')
#ifndef __GFORTRAN__
  ! libgfortran leaks the format of a child read that ends at end of record,
  ! which fails the LeakSanitizer in the gfortran debug profile.
  open(newunit=u, status='scratch')
  write(u, '(a)') '1 + 2i'
  rewind(u)
  read(u, *, iostat=ios) r
  close(u)
  call check(ios > 0, pre // 'read without k part is an error')
#endif
  open(newunit=u, status='scratch')
  write(u, '(a)') 'quark'
  rewind(u)
  read(u, *, iostat=ios) r
  close(u)
  call check(ios > 0, pre // 'read garbage is an error')
end subroutine test_dp


#if QUATERNIONS_QP
! Explicit-shape dummies: nvfortran 26.1 passes bad descriptors for
! array-valued expressions given to assumed-shape dummies.
logical function vclose_qp(a, b, tol) result(c)
  !! 3-vectors equal within tol, relative to max(1, |b|)
  real(real128), intent(in) :: a(3), b(3), tol
  c = all(abs(a - b) <= tol*max(1._real128, maxval(abs(b))))
end function vclose_qp

logical function mclose_qp(a, b, tol) result(c)
  !! 3x3 matrices equal within tol, relative to max(1, |b|)
  real(real128), intent(in) :: a(3,3), b(3,3), tol
  c = all(abs(a - b) <= tol*max(1._real128, maxval(abs(b))))
end function mclose_qp

logical function all_nan_qp(q) result(c)
  type(quat_qp), intent(in) :: q
  c = ieee_is_nan(q%w) .and. ieee_is_nan(q%x) .and. ieee_is_nan(q%y) .and. ieee_is_nan(q%z)
end function all_nan_qp

subroutine test_qp()
  real(real128), parameter :: pi = acos(-1._real128), eps = epsilon(1._real128)
  real(real128), parameter :: tol = 64*eps, ltol = sqrt(eps)
  type(quat_qp), parameter :: one = quat_qp(1), i = quat_qp(0, 1), j = quat_qp(0, 0, 1), k = quat_qp(0, 0, 0, 1)
  type(quat_qp) :: p, q, r, qs(1000)
  real(real128) :: v(3), axis(3), angle, m(3,3), yaw, pitch, roll, big, t
  complex(real128) :: z
  character(200) :: buf
  integer :: n, u, ios
  character(*), parameter :: pre = 'qp: '

  ! Construction ------------------------------------------------------
  p = quat_qp(1, 2, 3, 4)
  call check(p%w == 1 .and. p%x == 2 .and. p%y == 3 .and. p%z == 4, pre // 'structure constructor')
  call check(quat_qp([1._real128, 2._real128, 3._real128, 4._real128]) == p, pre // 'array constructor')
  call check(quat_qp(2.5_real128) == quat_qp(2.5_real128, 0, 0, 0), pre // 'omitted parts are zero')
  call check(quat_qp('1 + 2i + 3j + 4k') == p, pre // 'parse spaced')
  call check(quat_qp('1+2i+3j+4k') == p, pre // 'parse compact')
  call check(quat_qp('4k + 3j + 1 + 2i') == p, pre // 'parse any order')
  call check(quat_qp('-1.5e+2 - 2.5E-1i + j - k') == quat_qp(-150, -0.25_real128, 1, -1), pre // 'parse exponents, implicit 1')
  call check(quat_qp('  -3  ') == quat_qp(-3), pre // 'parse real only')
  call check(quat_qp('.5i') == quat_qp(0, 0.5_real128), pre // 'parse leading dot')
  call check(quat_qp('1d2 + 2I') == quat_qp(100, 2), pre // 'parse d exponent, capital unit')
  call check(all_nan_qp(quat_qp('1 2')), pre // 'parse rejects missing sign')
  call check(all_nan_qp(quat_qp('2 i')), pre // 'parse rejects blank before unit')
  call check(all_nan_qp(quat_qp('1 +')), pre // 'parse rejects dangling sign')
  call check(all_nan_qp(quat_qp('x')), pre // 'parse rejects garbage')
  call check(all_nan_qp(quat_qp('')), pre // 'parse rejects empty')

  call check(quat_qp(quat_sp(1.5_real32, -2, 0.25_real32, 8)) == quat_qp(1.5_real128, -2, 0.25_real128, 8), &
    & pre // 'convert from sp')


  call check(quat_qp(quat_dp(1.5_real64, -2, 0.25_real64, 8)) == quat_qp(1.5_real128, -2, 0.25_real128, 8), &
    & pre // 'convert from dp')


  ! Assignment ----------------------------------------------------------
  q = 3_int8
  call check(q == quat_qp(3), pre // 'assign int8')
  q = 3_int16
  call check(q == quat_qp(3), pre // 'assign int16')
  q = 3_int32
  call check(q == quat_qp(3), pre // 'assign int32')
  q = 3_int64
  call check(q == quat_qp(3), pre // 'assign int64')
  q = 2.5_real128
  call check(q == quat_qp(2.5_real128), pre // 'assign real')

  ! Arithmetic ----------------------------------------------------------
  call check(i*j == k .and. j*k == i .and. k*i == j, pre // 'ij = k, jk = i, ki = j')
  call check(i*i == -one .and. j*j == -one .and. k*k == -one .and. i*j*k == -one, pre // 'i^2 = j^2 = k^2 = ijk = -1')
  call check(j*i == -k, pre // 'ji = -k')
  q = quat_qp(5, -6, 7, 8)
  call check(p + q == quat_qp(6, -4, 10, 12) .and. p - q == quat_qp(-4, 8, -4, -4), pre // 'add, subtract')
  call check(-p == quat_qp(-1, -2, -3, -4) .and. +p == p, pre // 'unary minus, plus')
  call check(p*q == quat_qp(-36, 0, -18, 60), pre // 'Hamilton product')
  call check(p + 2_int8 == quat_qp(3, 2, 3, 4) .and. 2_int8 + p == quat_qp(3, 2, 3, 4), pre // 'add int8')
  call check(p - 2_int8 == quat_qp(-1, 2, 3, 4) .and. 2_int8 - p == quat_qp(1, -2, -3, -4), pre // 'subtract int8')
  call check(p*2_int8 == quat_qp(2, 4, 6, 8) .and. 2_int8*p == quat_qp(2, 4, 6, 8), pre // 'multiply int8')
  call check(p/2_int8 == quat_qp(0.5_real128, 1, 1.5_real128, 2) .and. 2_int8/quat_qp(4) == quat_qp(0.5_real128), pre // 'divide&
      & int8')
  call check(quat_qp(2) == 2_int8 .and. 2_int8 == quat_qp(2) .and. .not. (p == 2_int8), pre // 'equal int8')
  call check(p /= 2_int8 .and. 2_int8 /= p .and. .not. (quat_qp(2) /= 2_int8), pre // 'not equal int8')
  call check(p**2_int8 == p*p, pre // 'power int8')
  call check(is_close(2_int8**q, exp(log(2_int8*one)*q), tol), pre // 'int8 ** quaternion')
  call check(p + 2_int16 == quat_qp(3, 2, 3, 4) .and. 2_int16 + p == quat_qp(3, 2, 3, 4), pre // 'add int16')
  call check(p - 2_int16 == quat_qp(-1, 2, 3, 4) .and. 2_int16 - p == quat_qp(1, -2, -3, -4), pre // 'subtract int16')
  call check(p*2_int16 == quat_qp(2, 4, 6, 8) .and. 2_int16*p == quat_qp(2, 4, 6, 8), pre // 'multiply int16')
  call check(p/2_int16 == quat_qp(0.5_real128, 1, 1.5_real128, 2) .and. 2_int16/quat_qp(4) == quat_qp(0.5_real128), pre // 'divide&
      & int16')
  call check(quat_qp(2) == 2_int16 .and. 2_int16 == quat_qp(2) .and. .not. (p == 2_int16), pre // 'equal int16')
  call check(p /= 2_int16 .and. 2_int16 /= p .and. .not. (quat_qp(2) /= 2_int16), pre // 'not equal int16')
  call check(p**2_int16 == p*p, pre // 'power int16')
  call check(is_close(2_int16**q, exp(log(2_int16*one)*q), tol), pre // 'int16 ** quaternion')
  call check(p + 2_int32 == quat_qp(3, 2, 3, 4) .and. 2_int32 + p == quat_qp(3, 2, 3, 4), pre // 'add int32')
  call check(p - 2_int32 == quat_qp(-1, 2, 3, 4) .and. 2_int32 - p == quat_qp(1, -2, -3, -4), pre // 'subtract int32')
  call check(p*2_int32 == quat_qp(2, 4, 6, 8) .and. 2_int32*p == quat_qp(2, 4, 6, 8), pre // 'multiply int32')
  call check(p/2_int32 == quat_qp(0.5_real128, 1, 1.5_real128, 2) .and. 2_int32/quat_qp(4) == quat_qp(0.5_real128), pre // 'divide&
      & int32')
  call check(quat_qp(2) == 2_int32 .and. 2_int32 == quat_qp(2) .and. .not. (p == 2_int32), pre // 'equal int32')
  call check(p /= 2_int32 .and. 2_int32 /= p .and. .not. (quat_qp(2) /= 2_int32), pre // 'not equal int32')
  call check(p**2_int32 == p*p, pre // 'power int32')
  call check(is_close(2_int32**q, exp(log(2_int32*one)*q), tol), pre // 'int32 ** quaternion')
  call check(p + 2_int64 == quat_qp(3, 2, 3, 4) .and. 2_int64 + p == quat_qp(3, 2, 3, 4), pre // 'add int64')
  call check(p - 2_int64 == quat_qp(-1, 2, 3, 4) .and. 2_int64 - p == quat_qp(1, -2, -3, -4), pre // 'subtract int64')
  call check(p*2_int64 == quat_qp(2, 4, 6, 8) .and. 2_int64*p == quat_qp(2, 4, 6, 8), pre // 'multiply int64')
  call check(p/2_int64 == quat_qp(0.5_real128, 1, 1.5_real128, 2) .and. 2_int64/quat_qp(4) == quat_qp(0.5_real128), pre // 'divide&
      & int64')
  call check(quat_qp(2) == 2_int64 .and. 2_int64 == quat_qp(2) .and. .not. (p == 2_int64), pre // 'equal int64')
  call check(p /= 2_int64 .and. 2_int64 /= p .and. .not. (quat_qp(2) /= 2_int64), pre // 'not equal int64')
  call check(p**2_int64 == p*p, pre // 'power int64')
  call check(is_close(2_int64**q, exp(log(2_int64*one)*q), tol), pre // 'int64 ** quaternion')
  call check(p + 2._real128 == quat_qp(3, 2, 3, 4) .and. 2._real128 + p == quat_qp(3, 2, 3, 4), pre // 'add real128')
  call check(p - 2._real128 == quat_qp(-1, 2, 3, 4) .and. 2._real128 - p == quat_qp(1, -2, -3, -4), pre // 'subtract real128')
  call check(p*2._real128 == quat_qp(2, 4, 6, 8) .and. 2._real128*p == quat_qp(2, 4, 6, 8), pre // 'multiply real128')
  call check(p/2._real128 == quat_qp(0.5_real128, 1, 1.5_real128, 2) .and. 2._real128/quat_qp(4) == quat_qp(0.5_real128), pre //&
      & 'divide real128')
  call check(quat_qp(2) == 2._real128 .and. 2._real128 == quat_qp(2) .and. .not. (p == 2._real128), pre // 'equal real128')
  call check(p /= 2._real128 .and. 2._real128 /= p .and. .not. (quat_qp(2) /= 2._real128), pre // 'not equal real128')
  call check(is_close(p**2._real128, p*p, tol), pre // 'power real128')
  call check(is_close(2._real128**q, exp(log(2._real128*one)*q), tol), pre // 'real128 ** quaternion')

  call random_number(qs(1:3))
  qs(1:3) = 2*qs(1:3) - 1
  p = qs(1); q = qs(2); r = qs(3)
  call check(is_close((p*q)*r, p*(q*r), tol), pre // 'associative')
  call check(is_close(p*inv(p), one, tol) .and. is_close(inv(p)*p, one, tol), pre // 'inverse')
  call check(is_close(p/q*q, p, tol) .and. is_close(p/q, p*inv(q), tol), pre // 'right division')
  call check(is_close(conjg(p*q), conjg(q)*conjg(p), tol), pre // 'conjugate of product')
  call check(abs(abs(p*q) - abs(p)*abs(q)) <= tol*abs(p)*abs(q), pre // 'norm is multiplicative')
  call check(abs(dot_product(p, p) - abs(p)**2) <= tol*abs(p)**2, pre // 'dot_product')
  call check(quat_qp(1, 1)**2 == 2*i, pre // '(1+i)**2 exact')
  call check(p**0 == one .and. is_close(p**3, p*p*p, tol), pre // 'power 0, 3')
  call check(is_close(p**(-1), inv(p), tol) .and. is_close(p**(-2_int64), inv(p*p), tol), pre // 'negative power')
  call check(is_close((p**0.5_real128)**2, p, tol) .and. is_close(p**1._real128, p, tol), pre // 'real power')
  call check(is_close(p**quat_qp(2), p*p, 4*tol), pre // 'quaternion power')
  big = 4*sqrt(huge(1._real128))
  call check(is_close(inv(quat_qp(big, big)), quat_qp(1/(2*big), -1/(2*big)), tol), pre // 'inverse without overflow')

  ! Comparison --------------------------------------------------------
  call check(quat_qp(1 + eps) /= one .and. .not. (quat_qp(1 + eps) == one), pre // '== is exact')
  call check(is_close(quat_qp(1 + eps), one), pre // 'is_close default')
  call check(.not. is_close(one, quat_qp(1.1_real128)), pre // 'is_close rejects')
  call check(is_close(quat_qp(0), quat_qp(1e-3_real128), abs_tol=1e-2_real128), pre // 'is_close abs_tol')
  call check(.not. is_close(quat_qp(0), quat_qp(1e-3_real128), rel_tol=0.5_real128), pre // 'is_close rel_tol near 0')

  ! Basic functions ---------------------------------------------------
  p = quat_qp(1, 2, 3, 4)
  call check(abs(abs(quat_qp(1, 2, 2, 4)) - 5) <= tol, pre // 'abs')
  call check(real(p) == 1 .and. all(aimag(p) == [2, 3, 4]), pre // 'real, aimag')
  call check(conjg(p) == quat_qp(1, -2, -3, -4), pre // 'conjg')
  call check(abs(abs(normalize(p)) - 1) <= tol, pre // 'normalize')
  call check(inv(quat_qp(2)) == quat_qp(0.5_real128), pre // 'inv')

  ! Elementary functions ----------------------------------------------
  ! On a complex plane through the real axis they match intrinsic complex.
  z = cmplx(0.3_real128, -0.7_real128, real128)
  q = quat_qp(0.3_real128, -0.7_real128)
  r = sqrt(q)
  call check(is_close(r, quat_qp(real(sqrt(z)), aimag(sqrt(z))), tol, tol), pre // 'sqrt matches complex')
  r = exp(q)
  call check(is_close(r, quat_qp(real(exp(z)), aimag(exp(z))), tol, tol), pre // 'exp matches complex')
  r = log(q)
  call check(is_close(r, quat_qp(real(log(z)), aimag(log(z))), tol, tol), pre // 'log matches complex')
  r = sin(q)
  call check(is_close(r, quat_qp(real(sin(z)), aimag(sin(z))), tol, tol), pre // 'sin matches complex')
  r = cos(q)
  call check(is_close(r, quat_qp(real(cos(z)), aimag(cos(z))), tol, tol), pre // 'cos matches complex')
  r = tan(q)
  call check(is_close(r, quat_qp(real(tan(z)), aimag(tan(z))), tol, tol), pre // 'tan matches complex')
  r = asin(q)
  call check(is_close(r, quat_qp(real(asin(z)), aimag(asin(z))), tol, tol), pre // 'asin matches complex')
  r = acos(q)
  call check(is_close(r, quat_qp(real(acos(z)), aimag(acos(z))), tol, tol), pre // 'acos matches complex')
  r = atan(q)
  call check(is_close(r, quat_qp(real(atan(z)), aimag(atan(z))), tol, tol), pre // 'atan matches complex')
  r = sinh(q)
  call check(is_close(r, quat_qp(real(sinh(z)), aimag(sinh(z))), tol, tol), pre // 'sinh matches complex')
  r = cosh(q)
  call check(is_close(r, quat_qp(real(cosh(z)), aimag(cosh(z))), tol, tol), pre // 'cosh matches complex')
  r = tanh(q)
  call check(is_close(r, quat_qp(real(tanh(z)), aimag(tanh(z))), tol, tol), pre // 'tanh matches complex')
  q = quat_qp(0.3_real128, 0.2_real128, -0.4_real128, 0.5_real128)
  call check(is_close(exp(log(q)), q, tol) .and. is_close(sqrt(q)*sqrt(q), q, tol), pre // 'exp(log), sqrt')
  call check(is_close(sin(q)**2 + cos(q)**2, one, tol), pre // 'sin^2 + cos^2 = 1')
  call check(is_close(cosh(q)**2 - sinh(q)**2, one, tol), pre // 'cosh^2 - sinh^2 = 1')
  call check(is_close(tan(q), sin(q)/cos(q), tol) .and. is_close(tanh(q), sinh(q)/cosh(q), tol), pre // 'tan, tanh')
  call check(is_close(asin(sin(q)), q, tol) .and. is_close(acos(cos(q)), q, tol) .and. is_close(atan(tan(q)), q, tol), &
    & pre // 'inverse trigonometric')
  call check(is_close(sinh(asinh(q)), q, tol) .and. is_close(cosh(acosh(q)), q, tol) .and. is_close(tanh(atanh(q)), q, tol), &
    & pre // 'inverse hyperbolic')
  call check(is_close(log10(quat_qp(100)), quat_qp(2), tol), pre // 'log10')
  call check(is_close(sqrt(quat_qp(-4)), 2*i, tol), pre // 'sqrt(-4) = 2i')
  call check(is_close(log(-one), pi*i, tol), pre // 'log(-1) = pi i')
  call check(is_close(exp(pi*k), -one, abs_tol=tol), pre // 'exp(pi k) = -1')
  t = 1e-10_real128
  r = exp(quat_qp(0, t))
  call check(abs(r%x - sin(t)) <= tol*t, pre // 'exp keeps tiny vector part')
  r = log(quat_qp(1, 0, t))
  call check(abs(r%y - atan(t)) <= tol*t, pre // 'log keeps tiny vector part')

  ! Rotations ---------------------------------------------------------
  q = from_axis_angle([0._real128, 0._real128, 2._real128], pi/2)
  call check(vclose_qp(rotate(q, [1._real128, 0._real128, 0._real128]), [0._real128, 1._real128, 0._real128], tol), &
    & pre // 'rotate x about z to y')
  call check(vclose_qp(rotate(2*q, [0._real128, 1._real128, 0._real128]), [-1._real128, 0._real128, 0._real128], tol), &
    & pre // 'rotate with non-unit quaternion')
  call check(is_close(from_euler_zyx(pi/2, 0._real128, 0._real128), q, tol), pre // 'yaw is about z')
  call check(vclose_qp(rotate(from_euler_zyx(0._real128, pi/2, 0._real128), [1._real128, 0._real128, 0._real128]), &
    & [0._real128, 0._real128, -1._real128], tol), pre // 'pitch is about y')
  call check(vclose_qp(rotate(from_euler_zyx(0._real128, 0._real128, pi/2), [0._real128, 1._real128, 0._real128]), &
    & [0._real128, 0._real128, 1._real128], tol), pre // 'roll is about x')
  p = from_axis_angle([0._real128, 0._real128, 1._real128], 0.3_real128) * from_axis_angle([0._real128, 1._real128, 0._real128],&
      & -0.2_real128) &
    & * from_axis_angle([1._real128, 0._real128, 0._real128], 0.1_real128)
  call check(is_close(from_euler_zyx(0.3_real128, -0.2_real128, 0.1_real128), p, tol), pre // 'euler order z y x')
  call to_axis_angle(from_axis_angle([1._real128, -2._real128, 2._real128], 2.5_real128), axis, angle)
  call check(vclose_qp(axis, [1._real128, -2._real128, 2._real128]/3, tol) .and. abs(angle - 2.5_real128) <= tol, &
    & pre // 'axis-angle round trip')
  call to_axis_angle(one, axis, angle)
  call check(all(axis == [1, 0, 0]) .and. angle == 0, pre // 'identity axis-angle')

  call random_rotation(qs)
  v = [0.5_real128, -1._real128, 2._real128]
  do n = 1, 100
    q = qs(n)
    r = q*quat_qp(0, v(1), v(2), v(3))*conjg(q)
    call check(vclose_qp(rotate(q, v), [r%x, r%y, r%z], tol), pre // 'rotate = q v q*')
    m = to_matrix(q)
    call check(vclose_qp(matmul(m, v), rotate(q, v), tol), pre // 'to_matrix matches rotate')
    call check(mclose_qp(matmul(transpose(m), m), to_matrix(one), tol), &
      & pre // 'to_matrix orthogonal')
    if (q%w < 0) q = -q
    call check(is_close(from_matrix(m), q, tol), pre // 'from_matrix round trip')
    call to_euler_zyx(q, yaw, pitch, roll)
    call check(is_close(from_euler_zyx(yaw, pitch, roll), q, tol) .or. is_close(from_euler_zyx(yaw, pitch, roll), -q, tol), &
      & pre // 'euler round trip')
  end do
  ! Half turns exercise every branch of Shepperd's method
  do n = 1, 4
    axis = [real(real128) :: merge(1, 0, n == 1 .or. n == 4), merge(1, 0, n == 2 .or. n == 4), merge(1, 0, n >= 3)]
    m = to_matrix(from_axis_angle(axis, pi))
    call check(mclose_qp(to_matrix(from_matrix(m)), m, tol), pre // 'from_matrix half turn')
  end do
  ! Gimbal lock: the rotation survives even though yaw and roll are not unique
  q = from_euler_zyx(0.3_real128, pi/2, 0.2_real128)
  call to_euler_zyx(q, yaw, pitch, roll)
  call check(abs(pitch - pi/2) <= ltol, pre // 'gimbal pitch')
  call check(mclose_qp(to_matrix(from_euler_zyx(yaw, pitch, roll)), to_matrix(q), ltol), &
    & pre // 'gimbal rotation')

  p = one
  q = from_axis_angle([0._real128, 0._real128, 1._real128], 1._real128)
  call check(is_close(slerp(p, q, 0._real128), p, tol) .and. is_close(slerp(p, q, 1._real128), q, tol), pre // 'slerp ends')
  r = from_axis_angle([0._real128, 0._real128, 1._real128], 0.3_real128)
  call check(is_close(slerp(p, q, 0.3_real128), r, tol), pre // 'slerp constant speed')
  call check(is_close(slerp(p, -q, 0.3_real128), r, tol), pre // 'slerp shorter arc')
  call check(slerp(q, q, 0.3_real128) == q, pre // 'slerp equal ends')

  ! Random numbers ----------------------------------------------------
  call check(all(abs(abs(qs) - 1) <= tol), pre // 'random_rotation unit')
  call check(any(qs%w < 0) .and. any(qs%w > 0) .and. any(qs%z < 0) .and. any(qs%z > 0), pre // 'random_rotation signs')
  call check(abs(sum(qs%x)/size(qs)) < 0.1_real128, pre // 'random_rotation mean')
  call random_number(qs)
  call check(all(qs%w >= 0 .and. qs%w < 1 .and. qs%x >= 0 .and. qs%x < 1 .and. qs%y >= 0 .and. qs%y < 1 &
    & .and. qs%z >= 0 .and. qs%z < 1), pre // 'random_number in [0,1)')

  ! Text ----------------------------------------------------------------
  p = quat_qp(1, -2, 3, -4)
  call check(to_string(p, '(f0.1)') == '1.0 - 2.0i + 3.0j - 4.0k', pre // 'to_string fmt')
  call check(is_close(quat_qp(to_string(p*pi)), p*pi, tol), pre // 'to_string default round trip')
#ifndef __NVCOMPILER
  ! nvfortran does not support derived-type I/O on character variables
  write(buf, '(dt"f"(6,2))') p
  call check(buf == '1.00 - 2.00i + 3.00j - 4.00k', pre // 'DT"F"(6,2)')
  write(buf, '(dt"es10.2")') p*pi
  call check(is_close(quat_qp(buf), p*pi, 1e-2_real128), pre // 'DT"ES10.2"')
  write(buf, '(dt)') p
  call check(quat_qp(buf) == p, pre // 'DT g0')
#endif
  ! One read statement per file: ifx 2026 fails on a read that follows a
  ! derived-type read of a record starting with blanks.
  q = p*pi
  open(newunit=u, status='scratch')
  write(u, *) p, q
  rewind(u)
  read(u, *) r, q
  close(u)
  call check(r == p .and. is_close(q, p*pi, tol), pre // 'list-directed round trip')
  open(newunit=u, status='scratch')
  write(u, '(a)') '7+1k, 8 + 2i + 0j - 1K'
  rewind(u)
  read(u, *) r, q
  close(u)
  call check(r == quat_qp(7, 0, 0, 1) .and. q == quat_qp(8, 2, 0, -1), pre // 'read compact, comma')
#ifndef __GFORTRAN__
  ! libgfortran leaks the format of a child read that ends at end of record,
  ! which fails the LeakSanitizer in the gfortran debug profile.
  open(newunit=u, status='scratch')
  write(u, '(a)') '1 + 2i'
  rewind(u)
  read(u, *, iostat=ios) r
  close(u)
  call check(ios > 0, pre // 'read without k part is an error')
#endif
  open(newunit=u, status='scratch')
  write(u, '(a)') 'quark'
  rewind(u)
  read(u, *, iostat=ios) r
  close(u)
  call check(ios > 0, pre // 'read garbage is an error')
end subroutine test_qp
#endif

end program test_quaternions
