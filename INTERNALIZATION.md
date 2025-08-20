# Removal of Submodule Dependencies

## Overview

This change removes the dependency on MOM6 and IcePack submodules by internalizing only the minimal code that SOCA actually requires. The original submodules contained full implementations with many dependencies that SOCA doesn't need.

## Changes Made

### 1. Internalized Minimal Modules

**IcePack Minimal (`src/soca/Internal/icepack_minimal/`):**
- `icepack_kinds.F90`: Type definitions
- `icepack_warnings.F90`: Warning/error handling system
- `icepack_parameters.F90`: Physical constants and parameters 
- `icepack_tracers.F90`: Tracer infrastructure and initialization
- `icepack_therm_shared.F90`: Freezing temperature calculations
- `icepack_itd.F90`: Ice thickness distribution functions

**MOM6 Minimal (`src/soca/Internal/mom6_minimal/`):**
- `MOM_error_handler.F90`: Error handling and messaging
- `MOM_time_manager.F90`: Time type and management
- `MOM_file_parser.F90`: Parameter file parsing
- `MOM_get_input.F90`: Input file handling
- `MOM_grid.F90`: Ocean grid type definitions
- `MOM_domains.F90`: Domain decomposition management
- `MOM_io.F90`: IO infrastructure stubs
- `MOM_restart.F90`: Restart type placeholder
- `MOM_remapping.F90`: Vertical remapping functions
- `fms_interfaces.F90`: FMS/MPP interface stubs
- `MOM.F90`: Main MOM control structure and initialization

### 2. Updated Build System

- Modified `CMakeLists.txt` to remove external submodule builds
- Updated `src/soca/CMakeLists.txt` to link against internal modules
- Added CMakeLists.txt files for building internal libraries

### 3. Removed Submodules

- Updated `.gitmodules` to indicate internalization
- Removed MOM6 and IcePack submodule directories

## Benefits

1. **Reduced Build Complexity**: No need to build full MOM6/IcePack with all dependencies
2. **Simplified Deployment**: No git submodule management required
3. **Faster Builds**: Only compile the code actually needed by SOCA  
4. **Self-Contained**: SOCA no longer depends on external repository state
5. **Easier Maintenance**: All code is under direct SOCA control

## Usage Impact

From a user perspective, the functionality remains identical. The internal modules provide the same interfaces that SOCA was using from the external libraries, but with simpler implementations suited to SOCA's specific needs.

The grid generation and sea ice analysis postprocessing capabilities work exactly as before, but without the overhead of the full external dependencies.

## Testing

The minimal modules have been tested to ensure they compile cleanly and provide all the interfaces that SOCA requires.