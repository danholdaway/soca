!=======================================================================
!
! Minimal MOM grid types for SOCA internal use
! Extracted from MOM6: https://github.com/NOAA-EMC/MOM6
! Original authors: GFDL MOM team
!
! This file contains only the grid types needed for SOCA's 
! geometry initialization.
!
!=======================================================================

module MOM_grid

use, intrinsic :: iso_fortran_env, only: real64

implicit none

private

! Ocean grid type - simplified version with only fields used by SOCA
type, public :: ocean_grid_type
  ! Grid dimensions
  integer :: isc, iec, jsc, jec  ! Compute domain indices
  integer :: isd, ied, jsd, jed  ! Data domain indices  
  integer :: isg, ieg, jsg, jeg  ! Global domain indices
  integer :: nk                  ! Number of vertical levels
  
  ! Grid coordinates and metrics (only those used by SOCA)
  real(real64), dimension(:,:), allocatable :: &
    gridlont, &    ! Longitude of T cell centers
    gridlatt, &    ! Latitude of T cell centers  
    gridlonb, &    ! Longitude of cell corners
    gridlatb, &    ! Latitude of cell corners
    GeoLonT, &     ! Geographic longitude of T cell centers
    GeoLatT, &     ! Geographic latitude of T cell centers
    geoLonCu, &    ! Geographic longitude of U cell centers
    geoLatCu, &    ! Geographic latitude of U cell centers
    geoLonCv, &    ! Geographic longitude of V cell centers
    geoLatCv, &    ! Geographic latitude of V cell centers
    sin_rot, &     ! Sine of rotation angle  
    cos_rot, &     ! Cosine of rotation angle
    mask2dT, &     ! Ocean mask on T points
    mask2dCu, &    ! Ocean mask on U points  
    mask2dCv, &    ! Ocean mask on V points
    dxT, &         ! Grid spacing in x direction at T points
    dyT, &         ! Grid spacing in y direction at T points
    areaT          ! Area of T cells
end type ocean_grid_type

contains

! No public functions needed for this simplified version

end module MOM_grid

!=======================================================================