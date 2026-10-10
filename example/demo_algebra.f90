program demo_algebra
  !! Construction, arithmetic, functions, comparison and text I/O
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use quaternions
  implicit none
  type(quat_dp) :: p, q, r
  real(dp) :: v(3)
  integer :: u

  p = quat_dp(1, 2, 3, 4)               ! w + xi + yj + zk; structure constructor
  q = quat_dp("0.5 - 1.5i + k")          ! parse text; omitted parts are 0
  r = quat_dp([1._dp, 0._dp, 0._dp, 0._dp])
  r = 2                                 ! assign integer (any kind) or real(dp)

  print *, p*q                          ! Hamilton product, not commutative
  print *, p/q, p*inv(q)                ! right division: both equal
  print *, 2*p + 1._dp, p**2, p**0.5_dp ! same-kind reals, any integer kind
  print *, abs(p), real(p), conjg(p)    ! abs is the norm |p|
  v = aimag(p)                          ! vector part [x, y, z]
  print *, v, p%x                       ! components are public: w, x, y, z
  print *, exp(log(p)), sqrt(quat_dp(-4))

  print *, p == quat_dp(1, 2, 3, 4)     ! exact, like intrinsic ==
  print *, is_close(exp(log(p)), p)     ! tolerance, rel_tol = sqrt(epsilon)

  print '(a)', to_string(p, '(f0.2)')   ! 1.00 + 2.00i + 3.00j + 4.00k
  write(*, '(dt"f"(6,2))') p            ! same, via derived-type I/O
  open(newunit=u, status='scratch')
  write(u, *) p, q                      ! list-directed: w + xi + yj + zk
  rewind(u)
  read(u, *) r, q                       ! each ends at its k part
  close(u)
  print *, r, q
end program demo_algebra
