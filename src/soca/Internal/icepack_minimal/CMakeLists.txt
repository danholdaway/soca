# CMakeLists.txt for minimal IcePack modules for SOCA
# This contains only the essential IcePack functionality needed by SOCA

list(APPEND icepack_minimal_src_files
  icepack_kinds.F90
  icepack_warnings.F90  
  icepack_parameters.F90
  icepack_tracers.F90
  icepack_therm_shared.F90
  icepack_itd.F90
)

add_library(icepack_minimal STATIC ${icepack_minimal_src_files})
set_target_properties(icepack_minimal PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)

target_include_directories(icepack_minimal PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
  $<INSTALL_INTERFACE:mod>)

# Install
install(TARGETS icepack_minimal
  EXPORT icepack_minimal-config
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/icepack_minimal)

install(EXPORT icepack_minimal-config
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake)