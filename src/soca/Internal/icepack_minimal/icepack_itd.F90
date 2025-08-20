!=======================================================================
!
! Minimal icepack_itd module for SOCA internal use
! Extracted from Icepack: https://github.com/CICE-Consortium/Icepack.git
! Original authors: C. M. Bitz, UW; William H. Lipscomb and Elizabeth C. Hunke, LANL
!
! This file contains only the ice thickness distribution functions
! needed for SOCA's sea ice analysis postprocessing functionality.
!
!=======================================================================

module icepack_itd

use icepack_kinds
use icepack_parameters, only: c0, c1, c2, c3, c15, c25, c100, p1, p01, p001, p5, puny
use icepack_parameters, only: Lfresh, rhos, ice_ref_salinity, hs_min, cp_ice, rhoi
use icepack_tracers,    only: ncat, nilyr, nslyr, nblyr, ntrcr
use icepack_tracers,    only: nt_Tsfc, nt_qice, nt_qsno, nt_sice
use icepack_parameters, only: hi_min
use icepack_warnings,   only: warnstr, icepack_warnings_add
use icepack_warnings,   only: icepack_warnings_setabort, icepack_warnings_aborted

implicit none

private
public :: aggregate_area, &
          cleanup_itd, &
          icepack_init_itd

!=======================================================================

contains

!=======================================================================

! Aggregate ice area over thickness categories.
subroutine aggregate_area(aicen, aice, aice0)

real (kind=dbl_kind), dimension(:), intent(in) :: &
   aicen     ! concentration of ice

real (kind=dbl_kind), intent(inout) :: &
   aice, &   ! concentration of ice
   aice0     ! concentration of open water

! local variables
integer (kind=int_kind) :: n

character(len=*),parameter :: subname='(aggregate_area)'

!-----------------------------------------------------------------
! Aggregate
!-----------------------------------------------------------------

aice = c0
do n = 1, ncat
   aice = aice + aicen(n)
enddo

! open water fraction
aice0 = max (c1 - aice, c0)

end subroutine aggregate_area

!=======================================================================

! Initialize thickness boundaries for ice thickness distribution
subroutine icepack_init_itd(hin_max)

real (kind=dbl_kind), intent(out) :: &
     hin_max(0:ncat)  ! category limits (m)

! local variables
integer (kind=int_kind) :: n    ! thickness category index
real (kind=dbl_kind) :: rncat   ! real(ncat)

character(len=*),parameter :: subname='(icepack_init_itd)'

! Default WMO standard ice thickness boundaries
! simplified version - assume kcatbound = 2 (WMO standard)

hin_max(0) = c0
if (ncat == 1) then
   hin_max(1) = c100
elseif (ncat == 5) then
   hin_max(1) = p1
   hin_max(2) = 0.3_dbl_kind  ! 0.3m
   hin_max(3) = 0.7_dbl_kind  ! 0.7m  
   hin_max(4) = c2
   hin_max(5) = c100
else
   ! Linearly spaced boundaries for other ncat values
   rncat = real(ncat, kind=dbl_kind)
   do n = 1, ncat-1
      hin_max(n) = real(n, kind=dbl_kind) / rncat * c4
   enddo
   hin_max(ncat) = c100
endif

end subroutine icepack_init_itd

!=======================================================================

! Simplified cleanup_itd that removes very thin ice
subroutine cleanup_itd(dt, hin_max, aicen, trcrn, vicen, vsnon, &
                      aice0, aice, tr_aero, tr_pond_topo, &
                      first_ice, trcr_depend, trcr_base, &
                      n_trcr_strata, nt_strata, fpond, fresh, &
                      fsalt, fhocn, faero_ocn, fiso_ocn, &
                      flux_bio, Tf, limit_aice, dorebin)

real (kind=dbl_kind), intent(in) :: &
   dt        ! time step

real (kind=dbl_kind), intent(in) :: &
   Tf        ! Freezing temperature

real (kind=dbl_kind), dimension(0:ncat), intent(in) :: &
   hin_max   ! category boundaries (m)

real (kind=dbl_kind), dimension (:), intent(inout) :: &
   aicen , & ! concentration of ice
   vicen , & ! volume per unit area of ice (m)
   vsnon     ! volume per unit area of snow (m)

real (kind=dbl_kind), dimension (:,:), intent(inout) :: &
   trcrn     ! ice tracers

real (kind=dbl_kind), intent(inout) :: &
   aice0, &  ! concentration of open water
   aice      ! total ice concentration

logical (kind=log_kind), intent(in) :: &
   tr_aero, tr_pond_topo, first_ice, limit_aice, dorebin

integer (kind=int_kind), dimension (:), intent(in) :: &
   trcr_depend, n_trcr_strata

real (kind=dbl_kind), dimension (:,:), intent(in) :: &
   trcr_base

integer (kind=int_kind), dimension (:,:), intent(in) :: &
   nt_strata

real (kind=dbl_kind), intent(out) :: &
   fpond, fresh, fsalt, fhocn

real (kind=dbl_kind), dimension(:), intent(out) :: &
   faero_ocn, fiso_ocn, flux_bio

! local variables
integer (kind=int_kind) :: n, nt
real (kind=dbl_kind) :: hicen

character(len=*),parameter :: subname='(cleanup_itd)'

! Initialize outputs
fpond = c0
fresh = c0
fsalt = c0
fhocn = c0
faero_ocn(:) = c0
fiso_ocn(:) = c0
flux_bio(:) = c0

! Remove very small ice areas (zap small areas)
do n = 1, ncat
   if (aicen(n) <= puny) then
      aicen(n) = c0
      vicen(n) = c0
      vsnon(n) = c0
      if (ntrcr > 0) then
         do nt = 1, ntrcr
            trcrn(nt, n) = c0
         enddo
      endif
   endif
enddo

! Compute aggregate ice area
call aggregate_area(aicen, aice, aice0)

end subroutine cleanup_itd

!=======================================================================

end module icepack_itd

!=======================================================================