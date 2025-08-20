!=======================================================================
!
! Minimal MOM time manager for SOCA internal use
! Extracted from MOM6: https://github.com/NOAA-EMC/MOM6
! Original authors: GFDL MOM team
!
! This file contains only the time management functions needed for SOCA's 
! geometry initialization.
!
!=======================================================================

module MOM_time_manager_soca

use, intrinsic :: iso_fortran_env, only: real64

implicit none

private

! Time type - simplified version
type, public :: time_type
  private
  real(real64) :: seconds = 0.0_real64
end type time_type

! Calendar type constants
integer, parameter, public :: JULIAN = 2

public :: real_to_time, set_calendar_type

contains

!=======================================================================

function real_to_time(time_in_seconds) result(time_out)
  real(real64), intent(in) :: time_in_seconds
  type(time_type) :: time_out
  
  time_out%seconds = time_in_seconds
end function real_to_time

!=======================================================================

subroutine set_calendar_type(calendar_type)
  integer, intent(in) :: calendar_type
  
  ! Simplified - just accept the calendar type
  ! In a real implementation, this would configure the calendar
end subroutine set_calendar_type

!=======================================================================

end module MOM_time_manager_soca

!=======================================================================