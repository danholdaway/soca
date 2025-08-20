!=======================================================================
!
! Minimal MOM get input for SOCA internal use
! Extracted from MOM6: https://github.com/NOAA-EMC/MOM6
! Original authors: GFDL MOM team
!
! This file contains only the input functions needed for SOCA's 
! geometry initialization.
!
!=======================================================================

module MOM_get_input

use MOM_file_parser, only: param_file_type

implicit none

private

! Directory type for MOM6 paths
type, public :: directories
  character(len=:), allocatable :: input_filename
  character(len=:), allocatable :: output_directory
  character(len=:), allocatable :: restart_input_dir
  character(len=:), allocatable :: restart_output_dir
end type directories

public :: Get_MOM_Input

contains

!=======================================================================

subroutine Get_MOM_Input(param_file, dirs)
  type(param_file_type), intent(out) :: param_file
  type(directories), intent(out) :: dirs
  
  ! Simplified MOM input initialization
  ! In a real implementation, this would read the MOM_input file
  ! and parse the parameter file
  
  ! Set up default directories
  dirs%input_filename = "MOM_input" 
  dirs%output_directory = "./"
  dirs%restart_input_dir = "INPUT/"
  dirs%restart_output_dir = "RESTART/"
  
  ! Initialize param_file (simplified)
  param_file%is_open = .true.

end subroutine Get_MOM_Input

!=======================================================================

end module MOM_get_input

!=======================================================================