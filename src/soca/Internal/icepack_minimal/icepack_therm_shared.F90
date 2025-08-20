!=======================================================================
!
! Minimal icepack_therm_shared module for SOCA internal use
! Extracted from Icepack: https://github.com/CICE-Consortium/Icepack.git
! Original authors: Elizabeth C. Hunke, LANL
!
! This file contains only the thermal functions needed for SOCA's 
! sea ice analysis postprocessing functionality.
!
!=======================================================================

module icepack_therm_shared

use icepack_kinds
use icepack_parameters, only: c0, c1, c2, c4, p5, pi, puny
use icepack_parameters, only: cp_ocn, cp_ice, rhoi, rhos, Lfresh
use icepack_parameters, only: tfrz_option, depressT, Tocnfrz
use icepack_warnings, only: warnstr, icepack_warnings_add
use icepack_warnings, only: icepack_warnings_setabort, icepack_warnings_aborted

implicit none

private
public :: icepack_sea_freezing_temperature
public :: icepack_liquidus_temperature

real (kind=dbl_kind), parameter, public :: &
   ferrmax = 1.0e-3_dbl_kind    ! max allowed energy flux error (W m-2)

real (kind=dbl_kind), parameter, public :: &
   Tmin = -100.0_dbl_kind ! min allowed internal temperature (deg C)

logical (kind=log_kind), public :: &
   l_brine = .false.         ! if true, treat brine pocket effects

!-----------------------------------------------------------------
! Constants for Liquidus relation from Assur (1958)
!-----------------------------------------------------------------

! liquidus relation - higher temperature region
real(kind=dbl_kind), parameter :: &
     az1_liq = -18.48_dbl_kind, &
     bz1_liq =    0.0_dbl_kind

! liquidus relation - lower temperature region
real(kind=dbl_kind), parameter :: &
     az2_liq = -10.3085_dbl_kind, &
     bz2_liq =     62.4_dbl_kind

! liquidus break
real(kind=dbl_kind), parameter :: &
     Tb_liq = -7.6362968855167352_dbl_kind, & ! temperature of liquidus break
     Sb_liq =  123.66702800276086_dbl_kind    ! salinity of liquidus break

!=======================================================================

contains

!=======================================================================

! Simple liquidus temperature function for mushy physics
function icepack_liquidus_temperature(Sin) result(Tmlt)

  real(dbl_kind), intent(in) :: Sin
  real(dbl_kind) :: Tmlt

  ! local variables
  real(dbl_kind) :: t_high

  character(len=*),parameter :: subname='(icepack_liquidus_temperature)'

  ! Simplified liquidus calculation based on Assur (1958)
  ! High temperature liquidus relation
  if (Sin >= Sb_liq) then
    Tmlt = Sin / az1_liq
  else
    Tmlt = (Sin - bz2_liq) / az2_liq
  endif

  ! Ensure we don't get unrealistic temperatures
  Tmlt = max(Tmlt, Tmin)

end function icepack_liquidus_temperature

!=======================================================================

! Compute ocean freezing temperature
function icepack_sea_freezing_temperature(sss) result(Tf)

  real(dbl_kind), intent(in) :: sss
  real(dbl_kind) :: Tf

  character(len=*),parameter :: subname='(icepack_sea_freezing_temperature)'

  if (trim(tfrz_option) == 'mushy') then

     Tf = icepack_liquidus_temperature(sss) ! deg C

  elseif (trim(tfrz_option) == 'linear_salt') then

     Tf = -depressT * sss ! deg C

  elseif (trim(tfrz_option) == 'constant') then

     Tf = Tocnfrz

  elseif (trim(tfrz_option) == 'minus1p8') then

     Tf = -1.8_dbl_kind

  else

     call icepack_warnings_add(subname//' tfrz_option unsupported: '//trim(tfrz_option))
     call icepack_warnings_setabort(.true.)
     return

  endif

end function icepack_sea_freezing_temperature

!=======================================================================

end module icepack_therm_shared

!=======================================================================