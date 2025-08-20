!=======================================================================
!
! Minimal icepack_tracers module for SOCA internal use
! Extracted from Icepack: https://github.com/CICE-Consortium/Icepack.git
! Original authors: Elizabeth C. Hunke, LANL
!
! This file contains only the tracer infrastructure needed for SOCA's 
! sea ice analysis postprocessing functionality.
!
!=======================================================================

module icepack_tracers_soca

use icepack_kinds_soca
use icepack_parameters_soca, only: c0, c1, puny
use icepack_warnings_soca, only: warnstr, icepack_warnings_add
use icepack_warnings_soca, only: icepack_warnings_setabort, icepack_warnings_aborted

implicit none

private
public :: icepack_init_tracer_sizes
public :: icepack_init_tracer_indices

!-----------------------------------------------------------------
! dimensions
!-----------------------------------------------------------------

integer (kind=int_kind), public :: &
   ntrcr        = 0, & ! number of tracers in use
   ncat         = 0, & ! number of ice categories in use
   nilyr        = 0, & ! number of ice layers per category
   nslyr        = 0, & ! number of snow layers per category
   nblyr        = 0, & ! number of bio/brine layers per category
   n_aero       = 0    ! number of aerosols in use

integer (kind=int_kind), public :: &
   nt_Tsfc      = 0, & ! ice/snow temperature
   nt_qice      = 0, & ! volume-weighted ice enthalpy (in layers)
   nt_qsno      = 0, & ! volume-weighted snow enthalpy (in layers)
   nt_sice      = 0, & ! volume-weighted ice bulk salinity (CICE grid layers)
   nt_fbri      = 0, & ! volume fraction of ice with dynamic salt
   nt_iage      = 0, & ! volume-weighted ice age
   nt_FY        = 0, & ! area-weighted first-year ice area
   nt_alvl      = 0, & ! level ice area fraction
   nt_vlvl      = 0, & ! level ice volume fraction
   nt_apnd      = 0, & ! melt pond area fraction
   nt_hpnd      = 0, & ! melt pond depth
   nt_ipnd      = 0, & ! melt pond refrozen lid thickness
   nt_smice     = 0, & ! mass of ice in snow
   nt_smliq     = 0, & ! mass of liquid water in snow
   nt_rhos      = 0, & ! snow density
   nt_rsnw      = 0, & ! snow grain radius
   nt_isosno    = 0, & ! starting index for isotopes in snow
   nt_isoice    = 0, & ! starting index for isotopes in ice
   nt_aero      = 0    ! starting index for aerosols in ice

logical (kind=log_kind), public :: &
   tr_iage      = .false., & ! if .true., use age tracer
   tr_FY        = .false., & ! if .true., use first-year area tracer
   tr_lvl       = .false., & ! if .true., use level ice tracer
   tr_pond      = .false., & ! if .true., use melt pond tracer
   tr_pond_lvl  = .false., & ! if .true., use level-ice pond tracer
   tr_pond_topo = .false., & ! if .true., use explicit topography-based ponds
   tr_snow      = .false., & ! if .true., use snow redistribution or metamorphosis tracers
   tr_iso       = .false., & ! if .true., use isotope tracers
   tr_aero      = .false., & ! if .true., use aerosol tracers
   tr_brine     = .false., & ! if .true., brine height differs from ice thickness
   tr_fsd       = .false.    ! if .true., use floe size distribution

!=======================================================================

contains

!=======================================================================

subroutine icepack_init_tracer_sizes(ncat_in, nilyr_in, nslyr_in, &
                                     nblyr_in, nfsd_in, n_aero_in, &
                                     n_iso_in, n_algae_in, n_doc_in, &
                                     n_dic_in, n_don_in, n_fed_in, &
                                     n_fep_in, ntrcr_in)

integer (kind=int_kind), intent(in), optional :: &
   ncat_in     , & ! number of ice categories
   nilyr_in    , & ! number of ice layers per category  
   nslyr_in    , & ! number of snow layers per category
   nblyr_in    , & ! number of bio/brine layers per category
   nfsd_in     , & ! number of floe size distribution layers
   n_aero_in   , & ! number of aerosol tracers
   n_iso_in    , & ! number of isotope tracers  
   n_algae_in  , & ! number of algae tracers
   n_doc_in    , & ! number of DOC tracers
   n_dic_in    , & ! number of DIC tracers
   n_don_in    , & ! number of DON tracers
   n_fed_in    , & ! number of dissolved iron tracers
   n_fep_in    , & ! number of particulate iron tracers
   ntrcr_in        ! number of tracers

character(len=*), parameter :: subname='(icepack_init_tracer_sizes)'

if (present(ncat_in))   ncat   = ncat_in
if (present(nilyr_in))  nilyr  = nilyr_in  
if (present(nslyr_in))  nslyr  = nslyr_in
if (present(nblyr_in))  nblyr  = nblyr_in
if (present(n_aero_in)) n_aero = n_aero_in
if (present(ntrcr_in))  ntrcr  = ntrcr_in

end subroutine icepack_init_tracer_sizes

!=======================================================================

subroutine icepack_init_tracer_indices(nt_Tsfc_in, nt_qice_in, &
                                       nt_qsno_in, nt_sice_in, &
                                       nt_fbri_in, nt_iage_in, &
                                       nt_FY_in, nt_alvl_in, &
                                       nt_vlvl_in, nt_apnd_in, &
                                       nt_hpnd_in, nt_ipnd_in, &
                                       nt_smice_in, nt_smliq_in, &
                                       nt_rhos_in, nt_rsnw_in, &
                                       nt_fsd_in, nt_isosno_in, &
                                       nt_isoice_in, nt_aero_in)

integer (kind=int_kind), intent(in), optional :: &
   nt_Tsfc_in  , & ! ice/snow temperature
   nt_qice_in  , & ! volume-weighted ice enthalpy (in layers)
   nt_qsno_in  , & ! volume-weighted snow enthalpy (in layers) 
   nt_sice_in  , & ! volume-weighted ice bulk salinity
   nt_fbri_in  , & ! volume fraction of ice with dynamic salt
   nt_iage_in  , & ! volume-weighted ice age
   nt_FY_in    , & ! area-weighted first-year ice area
   nt_alvl_in  , & ! level ice area fraction
   nt_vlvl_in  , & ! level ice volume fraction
   nt_apnd_in  , & ! melt pond area fraction
   nt_hpnd_in  , & ! melt pond depth
   nt_ipnd_in  , & ! melt pond refrozen lid thickness
   nt_smice_in , & ! mass of ice in snow
   nt_smliq_in , & ! mass of liquid water in snow
   nt_rhos_in  , & ! snow density
   nt_rsnw_in  , & ! snow grain radius
   nt_fsd_in   , & ! floe size distribution
   nt_isosno_in, & ! starting index for isotopes in snow
   nt_isoice_in, & ! starting index for isotopes in ice
   nt_aero_in      ! starting index for aerosols in ice

character(len=*), parameter :: subname='(icepack_init_tracer_indices)'

if (present(nt_Tsfc_in))   nt_Tsfc   = nt_Tsfc_in
if (present(nt_qice_in))   nt_qice   = nt_qice_in
if (present(nt_qsno_in))   nt_qsno   = nt_qsno_in
if (present(nt_sice_in))   nt_sice   = nt_sice_in
if (present(nt_fbri_in))   nt_fbri   = nt_fbri_in
if (present(nt_iage_in))   nt_iage   = nt_iage_in
if (present(nt_FY_in))     nt_FY     = nt_FY_in
if (present(nt_alvl_in))   nt_alvl   = nt_alvl_in
if (present(nt_vlvl_in))   nt_vlvl   = nt_vlvl_in
if (present(nt_apnd_in))   nt_apnd   = nt_apnd_in
if (present(nt_hpnd_in))   nt_hpnd   = nt_hpnd_in
if (present(nt_ipnd_in))   nt_ipnd   = nt_ipnd_in
if (present(nt_smice_in))  nt_smice  = nt_smice_in
if (present(nt_smliq_in))  nt_smliq  = nt_smliq_in
if (present(nt_rhos_in))   nt_rhos   = nt_rhos_in
if (present(nt_rsnw_in))   nt_rsnw   = nt_rsnw_in
if (present(nt_isosno_in)) nt_isosno = nt_isosno_in
if (present(nt_isoice_in)) nt_isoice = nt_isoice_in
if (present(nt_aero_in))   nt_aero   = nt_aero_in

end subroutine icepack_init_tracer_indices

!=======================================================================

end module icepack_tracers_soca

!=======================================================================