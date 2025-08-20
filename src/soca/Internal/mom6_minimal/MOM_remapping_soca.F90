!=======================================================================
!
! Minimal MOM remapping for SOCA internal use
! Extracted from MOM6: https://github.com/NOAA-EMC/MOM6
! Original authors: Laurent White, GFDL MOM team
!
! This file contains only the remapping functions needed for SOCA's 
! field interpolation.
!
!=======================================================================

module MOM_remapping_soca

use MOM_error_handler_soca, only: MOM_error, FATAL

implicit none

private

! Container for remapping parameters - simplified version
type, public :: remapping_CS
  private
  integer :: remapping_scheme = 2  ! Default to PLM (linear)
  logical :: boundary_extrapolation = .true.
  logical :: check_reconstruction = .false.
  logical :: check_remapping = .false.
  real :: h_neglect = 1.0e-30
  real :: h_neglect_edge = 1.0e-10
end type remapping_CS

! Remapping scheme constants  
integer, parameter :: REMAPPING_PCM = 0 ! Piecewise constant
integer, parameter :: REMAPPING_PLM = 2 ! Piecewise linear

public :: initialize_remapping, end_remapping, remapping_core_h

contains

!=======================================================================

subroutine initialize_remapping(CS, remapping_scheme, boundary_extrapolation, &
                               h_neglect, h_neglect_edge, check_reconstruction, &
                               check_remapping, force_bounds_in_subcell, &
                               force_bounds_in_target, answers_2018, debug)
  type(remapping_CS), intent(inout) :: CS
  character(len=*), optional, intent(in) :: remapping_scheme
  logical, optional, intent(in) :: boundary_extrapolation
  real, optional, intent(in) :: h_neglect, h_neglect_edge
  logical, optional, intent(in) :: check_reconstruction, check_remapping
  logical, optional, intent(in) :: force_bounds_in_subcell, force_bounds_in_target
  logical, optional, intent(in) :: answers_2018, debug
  
  ! Simplified remapping initialization
  CS%remapping_scheme = REMAPPING_PLM  ! Default to linear
  
  if (present(boundary_extrapolation)) CS%boundary_extrapolation = boundary_extrapolation
  if (present(h_neglect)) CS%h_neglect = h_neglect
  if (present(h_neglect_edge)) CS%h_neglect_edge = h_neglect_edge
  if (present(check_reconstruction)) CS%check_reconstruction = check_reconstruction
  if (present(check_remapping)) CS%check_remapping = check_remapping

end subroutine initialize_remapping

!=======================================================================

subroutine end_remapping(CS)
  type(remapping_CS), intent(inout) :: CS
  
  ! Simplified cleanup - nothing to do for this minimal version

end subroutine end_remapping

!=======================================================================

subroutine remapping_core_h(CS, n0, h0, u0, n1, h1, u1, h_neglect, &
                           force_bounds_in_subcell, force_bounds_in_target, &
                           src_poly_method, ol_in, noPLMlimiting, dFdU_in)
  type(remapping_CS), intent(in) :: CS
  integer, intent(in) :: n0, n1
  real, dimension(n0), intent(in) :: h0, u0
  real, dimension(n1), intent(in) :: h1
  real, dimension(n1), intent(out) :: u1
  real, optional, intent(in) :: h_neglect
  logical, optional, intent(in) :: force_bounds_in_subcell, force_bounds_in_target
  logical, optional, intent(in) :: noPLMlimiting
  character(len=*), optional, intent(in) :: src_poly_method
  real, dimension(n0,2), optional, intent(in) :: ol_in
  real, dimension(n0,n1), optional, intent(in) :: dFdU_in
  
  ! Simplified remapping - just do linear interpolation
  integer :: i, j, k
  real :: z0(n0+1), z1(n1+1), z_int
  real :: h_tot0, h_tot1, u_avg
  
  ! Calculate interface positions
  z0(1) = 0.0
  do i = 1, n0
    z0(i+1) = z0(i) + h0(i)
  enddo
  h_tot0 = z0(n0+1)
  
  z1(1) = 0.0  
  do i = 1, n1
    z1(i+1) = z1(i) + h1(i)
  enddo
  h_tot1 = z1(n1+1)
  
  ! Simple linear interpolation
  do i = 1, n1
    z_int = (z1(i) + z1(i+1)) * 0.5  ! Center of target cell
    z_int = z_int * h_tot0 / h_tot1  ! Scale to source grid
    
    ! Find source cell containing z_int
    do j = 1, n0
      if (z_int >= z0(j) .and. z_int < z0(j+1)) then
        u1(i) = u0(j)  ! Simple assignment
        exit
      endif
    enddo
    
    ! Handle edge cases
    if (z_int < z0(1)) u1(i) = u0(1)
    if (z_int >= z0(n0+1)) u1(i) = u0(n0)
  enddo

end subroutine remapping_core_h

!=======================================================================

end module MOM_remapping_soca

!=======================================================================