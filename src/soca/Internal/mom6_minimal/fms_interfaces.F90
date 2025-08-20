!=======================================================================
!
! Minimal FMS interfaces for SOCA internal use
! This provides placeholder implementations of FMS functions needed by SOCA
!
!=======================================================================

module fms_mod

implicit none

private

public :: fms_init

contains

!=======================================================================

subroutine fms_init()
  ! Placeholder FMS initialization
  ! In a real implementation, this would initialize FMS infrastructure
end subroutine fms_init

!=======================================================================

end module fms_mod

!=======================================================================

module fms_io_mod

implicit none

private

! Restart file type
type, public :: restart_file_type
  character(len=:), allocatable :: filename
end type restart_file_type

public :: fms_io_init, register_restart_field, restore_state, free_restart_type
public :: save_restart, file_exist, field_exist

contains

!=======================================================================

subroutine fms_io_init()
  ! Placeholder FMS IO initialization
end subroutine fms_io_init

!=======================================================================

function register_restart_field(restart_file, filename, fieldname, field, domain) result(status)
  type(restart_file_type), intent(inout) :: restart_file
  character(len=*), intent(in) :: filename, fieldname
  real, dimension(:,:), intent(inout) :: field
  integer, intent(in) :: domain
  integer :: status
  
  ! Simplified - just return success
  status = 0
  if (.not. allocated(restart_file%filename)) restart_file%filename = filename
end function register_restart_field

!=======================================================================

subroutine restore_state(restart_file)
  type(restart_file_type), intent(in) :: restart_file
  ! Placeholder restore
end subroutine restore_state

!=======================================================================

subroutine free_restart_type(restart_file)
  type(restart_file_type), intent(inout) :: restart_file
  if (allocated(restart_file%filename)) deallocate(restart_file%filename)
end subroutine free_restart_type

!=======================================================================

subroutine save_restart(restart_file)
  type(restart_file_type), intent(in) :: restart_file
  ! Placeholder save
end subroutine save_restart

!=======================================================================

logical function file_exist(filename)
  character(len=*), intent(in) :: filename
  inquire(file=filename, exist=file_exist)
end function file_exist

!=======================================================================

logical function field_exist(restart_file, fieldname)
  type(restart_file_type), intent(in) :: restart_file
  character(len=*), intent(in) :: fieldname
  ! Simplified - assume field exists
  field_exist = .true.
end function field_exist

!=======================================================================

end module fms_io_mod

!=======================================================================

module mpp_mod

implicit none

private

public :: mpp_init

contains

!=======================================================================

subroutine mpp_init(localcomm)
  integer, optional, intent(in) :: localcomm
  ! Placeholder MPI/MPP initialization
end subroutine mpp_init

!=======================================================================

end module mpp_mod

!=======================================================================

module mpp_domains_mod

implicit none

private

public :: mpp_update_domains, mpp_get_compute_domain, mpp_get_data_domain
public :: mpp_get_global_domain
public :: CYCLIC_GLOBAL_DOMAIN, FOLD_NORTH_EDGE
public :: mpp_gather, mpp_root_pe, mpp_pe

! Domain boundary constants
integer, parameter :: CYCLIC_GLOBAL_DOMAIN = 1
integer, parameter :: FOLD_NORTH_EDGE = 2

contains

!=======================================================================

subroutine mpp_update_domains(field, domain)
  real, dimension(:,:), intent(inout) :: field
  integer, intent(in) :: domain
  ! Placeholder domain update
end subroutine mpp_update_domains

!=======================================================================

subroutine mpp_get_compute_domain(domain, isc, iec, jsc, jec)
  integer, intent(in) :: domain
  integer, intent(out) :: isc, iec, jsc, jec
  ! Simplified compute domain
  isc = 1; iec = 72
  jsc = 1; jec = 35
end subroutine mpp_get_compute_domain

!=======================================================================

subroutine mpp_get_data_domain(domain, isd, ied, jsd, jed)
  integer, intent(in) :: domain
  integer, intent(out) :: isd, ied, jsd, jed
  ! Simplified data domain
  isd = 1; ied = 72
  jsd = 1; jed = 35
end subroutine mpp_get_data_domain

!=======================================================================

subroutine mpp_get_global_domain(domain, isg, ieg, jsg, jeg)
  integer, intent(in) :: domain
  integer, intent(out) :: isg, ieg, jsg, jeg
  ! Simplified global domain
  isg = 1; ieg = 72
  jsg = 1; jeg = 35
end subroutine mpp_get_global_domain

!=======================================================================

subroutine mpp_gather(local_data, global_data, root_pe)
  real, dimension(:), intent(in) :: local_data
  real, dimension(:), intent(out) :: global_data
  integer, intent(in) :: root_pe
  ! Simplified gather - just copy for single PE
  global_data = local_data
end subroutine mpp_gather

!=======================================================================

integer function mpp_root_pe()
  mpp_root_pe = 0  ! Root PE is 0
end function mpp_root_pe

!=======================================================================

integer function mpp_pe()
  mpp_pe = 0  ! Current PE is 0 (single PE simulation)
end function mpp_pe

!=======================================================================

end module mpp_domains_mod

!=======================================================================

module time_interp_external_mod

implicit none

private

public :: time_interp_external_init

contains

!=======================================================================

subroutine time_interp_external_init()
  ! Placeholder time interpolation initialization
end subroutine time_interp_external_init

!=======================================================================

end module time_interp_external_mod