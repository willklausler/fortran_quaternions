program slerp_demo
  !! Rotate a rigid body smoothly from its reference orientation to a
  !! 120-degree rotation about (1,1,1), which cycles the axes x -> y -> z -> x.
  !! Each row prints the body axes, i.e. the columns of the rotation matrix.
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use quaternions, only: quat_dp, slerp, from_axis_angle, to_matrix
  implicit none

  integer, parameter :: nsteps = 5
  real(dp), parameter :: pi = acos(-1._dp)
  type(quat_dp) :: q_start, q_end
  integer :: i

  q_start = quat_dp(1._dp)
  q_end = from_axis_angle([1._dp, 1._dp, 1._dp], 2*pi/3)

  write(*, '(a)') 'SLERP of a rigid body: 120 degrees about (1,1,1)'
  write(*, '(a4, 3a24)') 'step', 'x-axis', 'y-axis', 'z-axis'
  do i = 0, nsteps
    write(*, '(i4, 3(2x, 3f7.3, 1x))') i, to_matrix(slerp(q_start, q_end, real(i, dp)/nsteps))
  end do
end program slerp_demo
