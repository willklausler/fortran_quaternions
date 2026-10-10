program demo_rotations
  !! Rotations: Hamilton convention, active (rotates the vector)
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use quaternions
  implicit none
  real(dp), parameter :: pi = acos(-1._dp)
  type(quat_dp) :: q, p
  real(dp) :: axis(3), angle, m(3,3), yaw, pitch, roll

  q = from_axis_angle([0._dp, 0._dp, 1._dp], pi/2)  ! 90 degrees about z
  print *, rotate(q, [1._dp, 0._dp, 0._dp])         ! x -> y: [0, 1, 0]

  m = to_matrix(q)                                  ! matmul(m, v) == rotate(q, v)
  p = from_matrix(m)                                ! unit, w >= 0
  call to_axis_angle(p, axis, angle)
  print *, axis, angle

  q = from_euler_zyx(yaw=0.3_dp, pitch=-0.2_dp, roll=0.1_dp)
  call to_euler_zyx(q, yaw, pitch, roll)
  print *, yaw, pitch, roll

  call random_rotation(p)                           ! uniform over rotations
  print *, slerp(q, p, 0.5_dp)                      ! halfway, shorter arc
  print *, rotate(q*p, [1._dp, 2._dp, 3._dp])       ! apply p, then q
end program demo_rotations
