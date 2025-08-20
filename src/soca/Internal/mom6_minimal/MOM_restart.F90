!=======================================================================
!
! Minimal MOM restart for SOCA internal use
! Extracted from MOM6: https://github.com/NOAA-EMC/MOM6
! Original authors: GFDL MOM team
!
! This file contains only the restart types needed for SOCA's 
! geometry initialization.
!
!=======================================================================

module MOM_restart

implicit none

private

! MOM restart control structure - simplified placeholder
type, public :: MOM_restart_CS
  logical :: placeholder = .true.
end type MOM_restart_CS

! No public functions needed - this is just a placeholder for the type

end module MOM_restart

!=======================================================================