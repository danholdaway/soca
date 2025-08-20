!=======================================================================
!
! Minimal MOM error handler for SOCA internal use
! Extracted from MOM6: https://github.com/NOAA-EMC/MOM6
! Original authors: GFDL MOM team
!
! This file contains only the error handling functions needed for SOCA's 
! geometry initialization.
!
!=======================================================================

module MOM_error_handler

implicit none

private

! Error level constants
integer, parameter, public :: NOTE = 0
integer, parameter, public :: WARNING = 1  
integer, parameter, public :: FATAL = 2

public :: MOM_error, MOM_mesg, is_root_pe

contains

!=======================================================================

subroutine MOM_error(level, message, all_print)
  integer,          intent(in) :: level
  character(len=*), intent(in) :: message
  logical, optional, intent(in) :: all_print
  
  logical :: print_msg
  
  print_msg = .true.
  if (present(all_print)) print_msg = all_print .or. is_root_pe()
  
  if (print_msg) then
    if (level == NOTE) then
      write(*,*) 'NOTE: ', trim(message)
    elseif (level == WARNING) then  
      write(*,*) 'WARNING: ', trim(message)
    elseif (level == FATAL) then
      write(*,*) 'FATAL: ', trim(message)
      stop 'MOM_error: FATAL error'
    endif
  endif

end subroutine MOM_error

!=======================================================================

subroutine MOM_mesg(message, verb_level)
  character(len=*), intent(in) :: message
  integer, optional, intent(in) :: verb_level
  
  if (is_root_pe()) then
    write(*,*) trim(message)
  endif

end subroutine MOM_mesg

!=======================================================================

logical function is_root_pe()
  ! Simplified - assume we're always on root PE for now
  ! In a real implementation, this would check MPI rank
  is_root_pe = .true.
end function is_root_pe

!=======================================================================

end module MOM_error_handler

!=======================================================================