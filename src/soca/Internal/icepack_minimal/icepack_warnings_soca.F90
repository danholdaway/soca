!=======================================================================
!
! Minimal icepack_warnings module for SOCA internal use
! Extracted from Icepack: https://github.com/CICE-Consortium/Icepack.git
! 
! This file contains only the warning functions needed for SOCA's 
! sea ice analysis postprocessing functionality.
!
!=======================================================================

module icepack_warnings_soca

use icepack_kinds_soca
implicit none

private

! warning messages
character(len=char_len_long), dimension(:), allocatable :: warnings
integer :: nWarnings = 0
integer :: nWarningsBuffer = 10

! abort flag
logical :: warning_abort = .false.

! public string for all subroutines to use
character(len=char_len_long), public :: warnstr

public :: &
  icepack_warnings_clear,    &
  icepack_warnings_print,    &
  icepack_warnings_flush,    &
  icepack_warnings_aborted,  &
  icepack_warnings_add,      &
  icepack_warnings_setabort

!=======================================================================

contains

!=======================================================================

subroutine icepack_warnings_clear()
  nWarnings = 0
  warning_abort = .false.
  if (allocated(warnings)) deallocate(warnings)
end subroutine icepack_warnings_clear

!=======================================================================

subroutine icepack_warnings_print(iounit)
  integer, intent(in) :: iounit
  integer :: iWarning

  do iWarning = 1, nWarnings
    write(iounit,*) trim(warnings(iWarning))
  enddo
end subroutine icepack_warnings_print

!=======================================================================

subroutine icepack_warnings_flush(iounit)
  integer, intent(in) :: iounit
  
  if (nWarnings > 0) then
    call icepack_warnings_print(iounit)
    call icepack_warnings_clear()
  endif
end subroutine icepack_warnings_flush

!=======================================================================

logical function icepack_warnings_aborted()
  icepack_warnings_aborted = warning_abort
end function icepack_warnings_aborted

!=======================================================================

subroutine icepack_warnings_add(warning)
  character(len=*), intent(in) :: warning
  character(len=char_len_long), dimension(:), allocatable :: warningsTemp
  
  if (.not. allocated(warnings)) then
    allocate(warnings(nWarningsBuffer))
  elseif (nWarnings >= size(warnings)) then
    allocate(warningsTemp(nWarnings + nWarningsBuffer))
    warningsTemp(1:nWarnings) = warnings(1:nWarnings)
    deallocate(warnings)
    allocate(warnings(nWarnings + nWarningsBuffer))
    warnings = warningsTemp
    deallocate(warningsTemp)
  endif
  
  nWarnings = nWarnings + 1
  warnings(nWarnings) = warning
end subroutine icepack_warnings_add

!=======================================================================

subroutine icepack_warnings_setabort(abortflag)
  logical, intent(in) :: abortflag
  warning_abort = abortflag
end subroutine icepack_warnings_setabort

!=======================================================================

end module icepack_warnings_soca

!=======================================================================