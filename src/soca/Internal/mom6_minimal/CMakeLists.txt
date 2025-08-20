# CMakeLists.txt for minimal MOM6 modules for SOCA
# This contains only the essential MOM6 functionality needed by SOCA

list(APPEND mom6_minimal_src_files
  MOM_error_handler.F90
  MOM_time_manager.F90
  MOM_file_parser.F90
  MOM_get_input.F90
  MOM_grid.F90
  MOM_domains.F90
  MOM_io.F90
  MOM_restart.F90
  MOM_remapping.F90
  MOM.F90
)

add_library(mom6_minimal STATIC ${mom6_minimal_src_files})
set_target_properties(mom6_minimal PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)

target_include_directories(mom6_minimal PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
  $<INSTALL_INTERFACE:mod>)

# Install
install(TARGETS mom6_minimal
  EXPORT mom6_minimal-config
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/mom6_minimal)

install(EXPORT mom6_minimal-config
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake)