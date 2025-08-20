!=======================================================================
!
! Minimal icepack_parameters module for SOCA internal use
! Extracted from Icepack: https://github.com/CICE-Consortium/Icepack.git
! Original authors: Elizabeth C. Hunke, LANL
!
! This file contains only the parameters and initialization functions
! needed for SOCA's sea ice analysis postprocessing functionality.
!
!=======================================================================

module icepack_parameters

use icepack_kinds
use icepack_warnings, only: icepack_warnings_aborted, &
    icepack_warnings_add, icepack_warnings_setabort

implicit none
private

public :: icepack_init_parameters
public :: icepack_recompute_constants

!-----------------------------------------------------------------
! parameter constants
!-----------------------------------------------------------------

real (kind=dbl_kind), parameter, public :: &
   c0   = 0.0_dbl_kind, &
   c1   = 1.0_dbl_kind, &
   c1p5 = 1.5_dbl_kind, &
   c2   = 2.0_dbl_kind, &
   c3   = 3.0_dbl_kind, &
   c4   = 4.0_dbl_kind, &
   c5   = 5.0_dbl_kind, &
   c6   = 6.0_dbl_kind, &
   c8   = 8.0_dbl_kind, &
   c10  = 10.0_dbl_kind, &
   c15  = 15.0_dbl_kind, &
   c16  = 16.0_dbl_kind, &
   c20  = 20.0_dbl_kind, &
   c25  = 25.0_dbl_kind, &
   c100 = 100.0_dbl_kind, &
   c180 = 180.0_dbl_kind, &
   c1000= 1000.0_dbl_kind, &
   p001 = 0.001_dbl_kind, &
   p01  = 0.01_dbl_kind, &
   p1   = 0.1_dbl_kind, &
   p2   = 0.2_dbl_kind, &
   p4   = 0.4_dbl_kind, &
   p5   = 0.5_dbl_kind, &
   p6   = 0.6_dbl_kind, &
   p05  = 0.05_dbl_kind, &
   p15  = 0.15_dbl_kind, &
   p25  = 0.25_dbl_kind, &
   p75  = 0.75_dbl_kind, &
   p333 = c1/c3, &
   p666 = c2/c3, &
   spval_const= -1.0e36_dbl_kind

real (kind=dbl_kind), public :: &
   secday = 86400.0_dbl_kind ,&! seconds in calendar day
   puny   = 1.0e-11_dbl_kind, &
   bignum = 1.0e+30_dbl_kind, &
   pi     = 3.14159265358979323846_dbl_kind

!-----------------------------------------------------------------
! derived physical constants
!-----------------------------------------------------------------

real (kind=dbl_kind), public :: &
   pih        = spval_const     ,&! 0.5 * pi
   piq        = spval_const     ,&! 0.25 * pi
   pi2        = spval_const     ,&! 2 * pi
   rad_to_deg = spval_const     ,&! conversion factor, radians to degrees
   cprho      = spval_const     ,&! for ocean mixed layer (J kg / K m^3)
   Cp         = spval_const       ! proport const for PE

!-----------------------------------------------------------------
! Densities
!-----------------------------------------------------------------

real (kind=dbl_kind), public :: &
   rhos      = 330.0_dbl_kind   ,&! density of snow (kg/m^3)
   rhoi      = 917.0_dbl_kind   ,&! density of ice (kg/m^3)
   rhosi     = 940.0_dbl_kind   ,&! average sea ice density
   rhow      = 1026.0_dbl_kind  ,&! density of seawater (kg/m^3)
   rhofresh  = 1000.0_dbl_kind    ! density of fresh water (kg/m^3)

!-----------------------------------------------------------------
! Thermal properties
!-----------------------------------------------------------------

real (kind=dbl_kind), public :: &
   cp_air    = 1005.0_dbl_kind  ,&! specific heat of air (J/kg/K)
   cp_ice    = 2106._dbl_kind   ,&! specific heat of fresh ice (J/kg/K)
   cp_ocn    = 4218._dbl_kind   ,&! specific heat of ocn    (J/kg/K)
   Lvap      = 2.501e6_dbl_kind ,&! Latent heat of evaporation of water (J/kg)
   Lsub      = 2.8345e6_dbl_kind,&! Latent heat of sublimation of fresh ice (J/kg)
   ice_ref_salinity = 4._dbl_kind, &  ! (ppt)
   hs_min    = 1.e-4_dbl_kind   ,&! min snow thickness (m)
   hi_min    = 0.01_dbl_kind   ,&! minimum ice thickness (m)
   depressT  = 0.054_dbl_kind  ,&! Tf:brine salinity ratio (C/ppt)
   Tocnfrz   = -1.8_dbl_kind      ! freezing temp of seawater (C)

real (kind=dbl_kind), public :: &
   Lfresh    = 3.34e5_dbl_kind     ! Latent heat of melting of fresh ice (J/kg)

!-----------------------------------------------------------------
! Thermodynamics options
!-----------------------------------------------------------------

character (char_len), public :: &
   tfrz_option = 'mushy'  ! freezing temperature option

integer (kind=int_kind), public :: &
   ktherm = 2             ! thermodynamic model

logical (kind=log_kind), public :: &
   l_brine = .false.      ! brine pocket effects

!=======================================================================

contains

!=======================================================================

subroutine icepack_init_parameters(ktherm_in, tfrz_option_in)

integer (kind=int_kind), intent(in), optional :: ktherm_in
character(len=*), intent(in), optional :: tfrz_option_in

character(len=*), parameter :: subname='(icepack_init_parameters)'

if (present(ktherm_in)) ktherm = ktherm_in
if (present(tfrz_option_in)) tfrz_option = trim(tfrz_option_in)

end subroutine icepack_init_parameters

!=======================================================================

subroutine icepack_recompute_constants()

character(len=*), parameter :: subname='(icepack_recompute_constants)'

! derived constants
pih = 0.5_dbl_kind * pi
piq = 0.25_dbl_kind * pi  
pi2 = 2.0_dbl_kind * pi
rad_to_deg = 180.0_dbl_kind/pi

! thermal properties - update derived values
Lsub = Lvap + Lfresh
cprho = cp_ocn * rhow
Cp = 0.5_dbl_kind * rhoi / rhow

end subroutine icepack_recompute_constants

!=======================================================================

end module icepack_parameters

!=======================================================================